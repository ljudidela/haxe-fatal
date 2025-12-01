package;

import h2d.Object;
import h2d.Graphics;
import hxd.Event;
import hxd.Key;
import world.Level;
import ui.Hud;

class Game extends Object {
    var level:Level;
    var levelGraphics:Graphics;
    var player:Graphics;
    var stairs:Graphics;
    
    var px:Int;
    var py:Int;
    var currentFloor:Int = 1;
    var hp:Int = 100;
    var maxHp:Int = 100;
    var inventory:Array<String> = [];

    var hud:Hud;
    var onGameOver:() -> Void;

    public function new(parent:Object, hud:Hud, onGameOver:() -> Void) {
        super(parent);
        this.hud = hud;
        this.onGameOver = onGameOver;
        
        levelGraphics = new Graphics(this);
        stairs = new Graphics(this);
        player = new Graphics(this);
        
        // Draw Player
        player.beginFill(Const.COLOR_PLAYER);
        player.drawRect(0, 0, Const.TILE_SIZE, Const.TILE_SIZE);
        player.endFill();

        // Draw Stairs
        stairs.beginFill(Const.COLOR_STAIRS);
        stairs.drawRect(0, 0, Const.TILE_SIZE, Const.TILE_SIZE);
        stairs.endFill();

        startLevel(1);
    }

    public function startLevel(floor:Int) {
        currentFloor = floor;
        level = new Level(Const.GRID_W, Const.GRID_H);
        
        drawLevel();
        
        px = level.startX;
        py = level.startY;
        updatePlayerPos();

        stairs.x = level.exitX * Const.TILE_SIZE;
        stairs.y = level.exitY * Const.TILE_SIZE;

        hud.updateStats(hp, maxHp, currentFloor, inventory);
        hud.showMessage("Floor " + currentFloor + " started.");
    }

    function drawLevel() {
        levelGraphics.clear();
        for (y in 0...level.height) {
            for (x in 0...level.width) {
                var color = level.data[y][x] == 1 ? Const.COLOR_FLOOR : Const.COLOR_WALL;
                levelGraphics.beginFill(color);
                levelGraphics.drawRect(x * Const.TILE_SIZE, y * Const.TILE_SIZE, Const.TILE_SIZE, Const.TILE_SIZE);
            }
        }
        levelGraphics.endFill();
    }

    function updatePlayerPos() {
        player.x = px * Const.TILE_SIZE;
        player.y = py * Const.TILE_SIZE;
    }

    public function handleInput(e:Event) {
        if (e.kind == EKeyDown) {
            var dx = 0;
            var dy = 0;

            switch(e.keyCode) {
                case Key.UP: dy = -1;
                case Key.DOWN: dy = 1;
                case Key.LEFT: dx = -1;
                case Key.RIGHT: dx = 1;
                case Key.ENTER:
                    if (px == level.exitX && py == level.exitY) {
                        startLevel(currentFloor + 1);
                        return;
                    }
            }

            if (dx != 0 || dy != 0) {
                if (level.isWalkable(px + dx, py + dy)) {
                    px += dx;
                    py += dy;
                    updatePlayerPos();
                    
                    // Simple "Turn" logic
                    if (Math.random() < 0.05) {
                        hp -= 1;
                        hud.showMessage("You feel hungry...");
                        hud.updateStats(hp, maxHp, currentFloor, inventory);
                        if (hp <= 0) {
                            onGameOver();
                        }
                    }
                } else {
                    hud.showMessage("Blocked.");
                }
            }
        }
    }
}