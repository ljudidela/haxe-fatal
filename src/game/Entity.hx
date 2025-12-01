package game;

import h2d.Object;
import h2d.Bitmap;
import h2d.Tile;

class Entity extends Object {
    public var gx:Int;
    public var gy:Int;
    public var hp:Int;
    public var maxHp:Int;
    public var name:String;
    
    var bmp:Bitmap;

    public function new(x:Int, y:Int, color:Int, parent:Object) {
        super(parent);
        this.gx = x;
        this.gy = y;
        
        var tile = Tile.fromColor(color, Const.TILE_SIZE, Const.TILE_SIZE);
        bmp = new Bitmap(tile, this);
        
        updatePos();
    }

    public function updatePos() {
        this.x = gx * Const.TILE_SIZE;
        this.y = gy * Const.TILE_SIZE;
    }

    public function takeDamage(dmg:Int):Bool {
        hp -= dmg;
        // Simple flash effect
        bmp.alpha = 0.5;
        haxe.Timer.delay(() -> { if(bmp != null) bmp.alpha = 1; }, 100);
        return hp <= 0;
    }
}