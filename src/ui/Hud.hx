package ui;

import h2d.Object;
import h2d.Text;
import h2d.Flow;

class Hud extends Object {
    var hpText:Text;
    var levelText:Text;
    var invText:Text;
    var msgText:Text;

    public function new(parent:Object) {
        super(parent);
        
        var font = hxd.res.DefaultFont.get();
        
        var bg = new h2d.Bitmap(h2d.Tile.fromColor(Const.COLOR_UI_BG, 200, 720), this);
        bg.x = 1280 - 200;

        var flow = new Flow(this);
        flow.layout = Vertical;
        flow.verticalSpacing = 20;
        flow.x = 1280 - 190;
        flow.y = 20;
        flow.maxWidth = 180;

        levelText = new Text(font, flow);
        levelText.scale(1.5);

        hpText = new Text(font, flow);
        hpText.scale(1.5);
        hpText.textColor = 0x00FF00;

        var sep = new Text(font, flow);
        sep.text = "----------";

        var invLabel = new Text(font, flow);
        invLabel.text = "INVENTORY:";
        invLabel.textColor = 0xAAAAAA;

        invText = new Text(font, flow);
        invText.text = "Empty";

        msgText = new Text(font, this);
        msgText.x = 20;
        msgText.y = 680;
        msgText.scale(1.5);
        msgText.textColor = 0xFFFFFF;
    }

    public function updateStats(hp:Int, maxHp:Int, level:Int, items:Array<String>) {
        hpText.text = 'HP: $hp / $maxHp';
        levelText.text = 'FLOOR: $level';
        if (items.length > 0) {
            invText.text = items.join("
");
        } else {
            invText.text = "(Empty)";
        }
    }

    public function showMessage(msg:String) {
        msgText.text = msg;
        msgText.alpha = 1;
        // Simple fade out logic could be added in update loop
    }
}