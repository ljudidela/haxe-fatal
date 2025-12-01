package scenes;

import h2d.Scene;
import h2d.Text;
import h2d.Graphics;
import hxd.Key;
import game.Entity;
import game.MapGen;
import Const;

class GameScene extends Scene {
    var mapData:Array<Array<Int>>;
    var player:Entity;
    var enemies:Array<Entity>;
    var stairs:{x:Int, y:Int};
    
    var mapLayer:h2d.Object;
    var entityLayer:h2d.Object;
    var uiLayer:h2d.Object;
    
    var hudText:Text;
    var logText:Text;
    var gameData:Dynamic;
    
    var turnLocked:Bool = false;

    public function new(data:Dynamic) {
        super();
        this.gameData = data;
        
        mapLayer = new h2d.Object(this);
        entityLayer = new h2d.Object(this);
        uiLayer = new h2d.Object(this);
        
        generateLevel();
        createUI();
        log("Welcome to Floor " + gameData.level);
    }

    function generateLevel() {
        mapLayer.removeChildren();
        entityLayer.removeChildren();
        enemies = [];

        mapData = MapGen.generate(Const.GRID_W, Const.GRID_H);
        
        // Draw Map
        var tileWall = h2d.Tile.fromColor(Const.COLOR_WALL, Const.TILE_SIZE, Const.TILE_SIZE);
        var tileFloor = h2d.Tile.fromColor(Const.COLOR_FLOOR, Const.TILE_SIZE, Const.TILE_SIZE);
        var tileStairs = h2d.Tile.fromColor(Const.COLOR_STAIRS, Const.TILE_SIZE, Const.TILE_SIZE);

        var emptySpots = [];

        for (y in 0...Const.GRID_H) {
            for (x in 0...Const.GRID_W) {
                var t = mapData[y][x] == 1 ? tileWall : tileFloor;
                var bmp = new h2d.Bitmap(t, mapLayer);
                bmp.x = x * Const.TILE_SIZE;
                bmp.y = y * Const.TILE_SIZE;
                if (mapData[y][x] == 0) emptySpots.push({x:x, y:y});
            }
        }

        // Place Player
        var pStart = emptySpots.shift();
        player = new Entity(pStart.x, pStart.y, Const.COLOR_PLAYER, entityLayer);
        player.hp = gameData.hp;
        player.maxHp = gameData.maxHp;
        player.name = "Hero";

        // Place Stairs
        var sPos = emptySpots.pop();
        stairs = sPos;
        var sBmp = new h2d.Bitmap(tileStairs, mapLayer);
        sBmp.x = sPos.x * Const.TILE_SIZE;
        sBmp.y = sPos.y * Const.TILE_SIZE;

        // Place Enemies
        var enemyCount = 3 + gameData.level;
        for (i in 0...enemyCount) {
            if (emptySpots.length == 0) break;
            var pos = emptySpots[Std.random(emptySpots.length)];
            var e = new Entity(pos.x, pos.y, Const.COLOR_ENEMY, entityLayer);
            e.hp = 10 + gameData.level * 5;
            e.name = "Slime Lvl" + gameData.level;
            enemies.push(e);
        }
    }

    function createUI() {
        var font = hxd.res.DefaultFont.get();
        
        // Sidebar background
        var bg = new h2d.Bitmap(h2d.Tile.fromColor(0xFF333333, 200, 600), uiLayer);
        bg.x = Const.GRID_W * Const.TILE_SIZE;
        
        hudText = new Text(font, uiLayer);
        hudText.x = bg.x + 10;
        hudText.y = 10;
        hudText.scale(1.5);

        logText = new Text(font, uiLayer);
        logText.x = 10;
        logText.y = Const.GRID_H * Const.TILE_SIZE + 10;
        logText.textColor = 0xFFAAAAAA;
        
        updateHUD();
    }

    function updateHUD() {
        hudText.text = 
            "FLOOR: " + gameData.level + "
" +
            "HP: " + player.hp + "/" + player.maxHp + "
" +
            "GOLD: " + gameData.gold + "
" +
            "XP: " + gameData.xp;
    }

    function log(msg:String) {
        logText.text = "> " + msg + "
" + logText.text;
        if (logText.text.length > 500) logText.text = logText.text.substr(0, 500);
    }

    override function update(dt:Float) {
        if (turnLocked) return;

        var dx = 0;
        var dy = 0;

        if (Key.isPressed(Key.UP)) dy = -1;
        else if (Key.isPressed(Key.DOWN)) dy = 1;
        else if (Key.isPressed(Key.LEFT)) dx = -1;
        else if (Key.isPressed(Key.RIGHT)) dx = 1;
        else if (Key.isPressed(Key.SPACE)) { /* Wait */ dx = 0; dy = 0; processTurn(); }
        else if (Key.isPressed(Key.ESCAPE)) Main.inst.setScene(new MenuScene());

        if (dx != 0 || dy != 0) {
            tryMove(player, dx, dy);
            processTurn();
        }
    }

    function tryMove(e:Entity, dx:Int, dy:Int):Bool {
        var tx = e.gx + dx;
        var ty = e.gy + dy;

        // Bounds
        if (tx < 0 || ty < 0 || tx >= Const.GRID_W || ty >= Const.GRID_H) return false;
        
        // Walls
        if (mapData[ty][tx] == 1) return false;

        // Combat
        if (e == player) {
            for (en in enemies) {
                if (en.gx == tx && en.gy == ty) {
                    attack(player, en);
                    return true;
                }
            }
        } else {
            if (tx == player.gx && ty == player.gy) {
                attack(e, player);
                return true;
            }
            // Enemies don't attack each other, just block
            for (other in enemies) if (other != e && other.gx == tx && other.gy == ty) return false;
        }

        e.gx = tx;
        e.gy = ty;
        e.updatePos();
        
        // Check Stairs
        if (e == player && tx == stairs.x && ty == stairs.y) {
            nextLevel();
        }
        
        return true;
    }

    function attack(att:Entity, def:Entity) {
        var dmg = Std.random(5) + 1;
        log(att.name + " hits " + def.name + " for " + dmg);
        if (def.takeDamage(dmg)) {
            log(def.name + " died!");
            if (def == player) {
                gameOver();
            } else {
                enemies.remove(def);
                def.remove();
                gameData.xp += 10;
                gameData.gold += Std.random(5);
                updateHUD();
            }
        }
        updateHUD();
    }

    function processTurn() {
        turnLocked = true;
        for (e in enemies) {
            // Simple AI: Move towards player
            var dx = 0;
            var dy = 0;
            if (e.gx < player.gx) dx = 1;
            else if (e.gx > player.gx) dx = -1;
            else if (e.gy < player.gy) dy = 1;
            else if (e.gy > player.gy) dy = -1;
            
            // Randomize slightly to avoid getting stuck
            if (Std.random(10) < 2) {
                dx = Std.random(3) - 1;
                dy = Std.random(3) - 1;
            }

            tryMove(e, dx, dy);
        }
        turnLocked = false;
        
        // Save state
        gameData.hp = player.hp;
        hxd.Save.save(gameData, "fatal_save");
    }

    function nextLevel() {
        gameData.level++;
        if (gameData.level > 10) {
            Main.inst.setScene(new StoryScene("VICTORY!
You defeated the tower.", () -> Main.inst.setScene(new MenuScene())));
        } else {
            Main.inst.setScene(new StoryScene("Floor " + gameData.level + " reached.", () -> Main.inst.setScene(new GameScene(gameData))));
        }
    }

    function gameOver() {
        hxd.Save.delete("fatal_save");
        Main.inst.setScene(new StoryScene("GAME OVER
You have perished.", () -> Main.inst.setScene(new MenuScene())));
    }
}