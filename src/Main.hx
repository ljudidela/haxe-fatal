package;

import hxd.App;
import hxd.Event;
import h2d.Scene;
import h2d.Text;
import ui.Menu;
import ui.Hud;

enum GameState {
    Menu;
    Story;
    Playing;
    Settings;
}

class Main extends App {
    var state:GameState;
    
    var menu:Menu;
    var game:Game;
    var hud:Hud;
    var storyText:Text;

    override function init() {
        s2d.scaleMode = LetterBox(1280, 720);
        hxd.Window.getInstance().title = "Fatal Labyrinth: Reborn";
        
        // Init Resources (even if empty for now)
        // hxd.Res.initEmbed(); 

        goToMenu();
    }

    function goToMenu() {
        s2d.removeChildren();
        state = Menu;
        menu = new Menu(s2d, onMenuAction);
    }

    function onMenuAction(action:String) {
        switch(action) {
            case "New Game":
                startStory();
            case "Continue":
                startGame(2); // Mock continue
            case "Settings":
                // Mock settings toggle
                trace("Settings toggled");
            case "Exit":
                hxd.System.exit();
        }
    }

    function startStory() {
        s2d.removeChildren();
        state = Story;
        
        var t = new Text(hxd.res.DefaultFont.get(), s2d);
        t.text = "The castle of Dragonia has been cursed.

You, a brave warrior, must enter the
FATAL LABYRINTH to retrieve the Holy Goblet.

Beware the hunger... and the traps.

[PRESS ENTER]";
        t.scale(2);
        t.textAlign = Center;
        t.x = s2d.width / 2;
        t.y = s2d.height / 2 - 100;
        storyText = t;
    }

    function startGame(startFloor:Int = 1) {
        s2d.removeChildren();
        state = Playing;
        
        hud = new Hud(s2d);
        game = new Game(s2d, hud, onGameOver);
        game.startLevel(startFloor);
    }

    function onGameOver() {
        s2d.removeChildren();
        var t = new Text(hxd.res.DefaultFont.get(), s2d);
        t.text = "YOU DIED

Press ENTER to return to menu";
        t.textColor = 0xFF0000;
        t.scale(4);
        t.textAlign = Center;
        t.x = s2d.width / 2;
        t.y = s2d.height / 2 - 100;
        
        // Quick hack to wait for input to go back to menu
        haxe.Timer.delay(function() {
             state = Story; // Reuse story input logic for simplicity to go back
        }, 500);
    }

    override function update(dt:Float) {
        // Global updates if needed
    }

    override function onEvent(e:Event) {
        switch(state) {
            case Menu:
                menu.handleInput(e);
            case Playing:
                game.handleInput(e);
            case Story:
                if (e.kind == EKeyDown && e.keyCode == hxd.Key.ENTER) {
                    if (storyText.text.indexOf("YOU DIED") != -1) {
                        goToMenu();
                    } else {
                        startGame();
                    }
                }
            case Settings:
                if (e.kind == EKeyDown && e.keyCode == hxd.Key.ESCAPE) goToMenu();
        }
    }

    static function main() {
        new Main();
    }
}