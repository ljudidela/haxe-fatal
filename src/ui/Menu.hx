package ui;

import h2d.Object;
import h2d.Text;
import h2d.Flow;
import hxd.Event;
import hxd.Key;

class Menu extends Object {
    var items:Array<Text> = [];
    var selectedIndex:Int = 0;
    var flow:Flow;
    var title:Text;
    var onAction:(String) -> Void;

    public function new(parent:Object, onAction:(String) -> Void) {
        super(parent);
        this.onAction = onAction;

        var font = hxd.res.DefaultFont.get();

        title = new Text(font, this);
        title.text = "FATAL LABYRINTH: REBORN";
        title.scale(3);
        title.textColor = 0xFF0000;
        title.x = 100;
        title.y = 50;

        flow = new Flow(this);
        flow.layout = Vertical;
        flow.verticalSpacing = 10;
        flow.x = 100;
        flow.y = 200;

        addMenuItem("New Game");
        addMenuItem("Continue");
        addMenuItem("Settings");
        addMenuItem("Exit");

        updateSelection();
    }

    function addMenuItem(label:String) {
        var t = new Text(hxd.res.DefaultFont.get(), flow);
        t.text = label;
        t.scale(2);
        items.push(t);
    }

    function updateSelection() {
        for (i in 0...items.length) {
            if (i == selectedIndex) {
                items[i].textColor = 0xFFFF00;
                items[i].text = "> " + StringTools.trim(items[i].text).replace("> ", "");
            } else {
                items[i].textColor = 0xFFFFFF;
                items[i].text = StringTools.trim(items[i].text).replace("> ", "");
            }
        }
    }

    public function handleInput(e:Event) {
        if (e.kind == EKeyDown) {
            switch (e.keyCode) {
                case Key.UP:
                    selectedIndex--;
                    if (selectedIndex < 0) selectedIndex = items.length - 1;
                    updateSelection();
                case Key.DOWN:
                    selectedIndex++;
                    if (selectedIndex >= items.length) selectedIndex = 0;
                    updateSelection();
                case Key.ENTER:
                    var action = StringTools.trim(items[selectedIndex].text).replace("> ", "");
                    onAction(action);
            }
        }
    }
}