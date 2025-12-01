package scenes;

import h2d.Scene;
import h2d.Text;
import hxd.Key;
import ui.Button;

class MenuScene extends Scene {
    var options = ["New Game", "Continue", "Settings", "Exit"];
    var buttons:Array<Button> = [];
    var selectedIdx = 0;
    var title:Text;

    public function new() {
        super();
        var font = hxd.res.DefaultFont.get();
        
        title = new Text(font, this);
        title.text = "FATAL LABYRINTH CLONE";
        title.scale(3);
        title.x = (getScene().width - title.textWidth * 3) / 2;
        title.y = 100;

        for (i in 0...options.length) {
            var btn = new Button(options[i], font, this);
            btn.x = (getScene().width - 100) / 2;
            btn.y = 300 + i * 40;
            btn.scale(2);
            buttons.push(btn);
        }
        updateSelection();
    }

    function updateSelection() {
        for (i in 0...buttons.length) {
            buttons[i].setSelected(i == selectedIdx);
        }
    }

    override function update(dt:Float) {
        if (Key.isPressed(Key.UP)) {
            selectedIdx--;
            if (selectedIdx < 0) selectedIdx = options.length - 1;
            updateSelection();
        }
        if (Key.isPressed(Key.DOWN)) {
            selectedIdx++;
            if (selectedIdx >= options.length) selectedIdx = 0;
            updateSelection();
        }
        if (Key.isPressed(Key.ENTER)) {
            selectOption();
        }
    }

    function selectOption() {
        switch (options[selectedIdx]) {
            case "New Game":
                Main.inst.startGame(true);
            case "Continue":
                Main.inst.startGame(false);
            case "Settings":
                // Placeholder for settings
                trace("Settings clicked");
            case "Exit":
                hxd.System.exit();
        }
    }
}