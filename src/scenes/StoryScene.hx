package scenes;

import h2d.Scene;
import h2d.Text;
import hxd.Key;

class StoryScene extends Scene {
    var text:Text;
    var onComplete:Void->Void;
    var timer:Float = 0;

    public function new(story:String, onComplete:Void->Void) {
        super();
        this.onComplete = onComplete;
        var font = hxd.res.DefaultFont.get();
        text = new Text(font, this);
        text.text = story + "

[Press ENTER]";
        text.scale(2);
        text.textAlign = Center;
        text.x = getScene().width / 2;
        text.y = getScene().height / 2 - 50;
    }

    override function update(dt:Float) {
        if (Key.isPressed(Key.ENTER)) {
            onComplete();
        }
    }
}