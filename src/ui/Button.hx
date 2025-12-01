package ui;

import h2d.Object;
import h2d.Text;
import h2d.Font;

class Button extends Object {
    var text:Text;
    var label:String;
    var isSelected:Bool = false;

    public function new(label:String, font:Font, parent:Object) {
        super(parent);
        this.label = label;
        text = new Text(font, this);
        text.text = label;
        text.color = h3d.Vector.fromColor(0xFFAAAAAA);
    }

    public function setSelected(s:Bool) {
        isSelected = s;
        text.color = h3d.Vector.fromColor(s ? 0xFFFFFFFF : 0xFFAAAAAA);
        text.text = s ? "> " + label : label;
    }
}