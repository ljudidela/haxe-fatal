package;

import hxd.App;
import hxd.Res;
import h2d.Scene;
import scenes.MenuScene;
import scenes.GameScene;
import scenes.StoryScene;

class Main extends App {
    public static var inst:Main;
    
    public var saveData:Dynamic;

    override function init() {
        inst = this;
        hxd.Res.initEmbed();
        engine.backgroundColor = 0xFF000000;
        
        // Load save if exists
        saveData = hxd.Save.load({}, "fatal_save");
        
        setScene(new MenuScene());
    }

    public function setScene(scene:h2d.Scene) {
        if (s2d != null) {
            // Cleanup previous scene if needed
        }
        setScene2D(scene);
    }

    public function startGame(isNew:Bool) {
        if (isNew) {
            saveData = { level: 1, hp: 100, maxHp: 100, xp: 0, gold: 0 };
            setScene(new StoryScene("You enter the Cursed Tower...
Goal: Reach Floor 10.", () -> {
                setScene(new GameScene(saveData));
            }));
        } else {
            if (saveData.level == null) saveData = { level: 1, hp: 100, maxHp: 100, xp: 0, gold: 0 };
            setScene(new GameScene(saveData));
        }
    }

    static function main() {
        new Main();
    }
}