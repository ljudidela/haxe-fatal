package game;

class MapGen {
    public static function generate(w:Int, h:Int):Array<Array<Int>> {
        var map = [for (y in 0...h) [for (x in 0...w) 1]]; // 1 = Wall
        
        // Simple Random Walker
        var cx = Std.int(w / 2);
        var cy = Std.int(h / 2);
        var steps = 400;
        
        for (i in 0...steps) {
            map[cy][cx] = 0; // 0 = Floor
            var dir = Std.random(4);
            switch(dir) {
                case 0: if (cx < w - 2) cx++;
                case 1: if (cx > 1) cx--;
                case 2: if (cy < h - 2) cy++;
                case 3: if (cy > 1) cy--;
            }
        }
        return map;
    }
}