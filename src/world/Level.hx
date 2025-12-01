package world;

class Level {
    public var width:Int;
    public var height:Int;
    public var data:Array<Array<Int>>;
    public var startX:Int;
    public var startY:Int;
    public var exitX:Int;
    public var exitY:Int;

    public function new(w:Int, h:Int) {
        this.width = w;
        this.height = h;
        generate();
    }

    function generate() {
        // Initialize walls
        data = [for (y in 0...height) [for (x in 0...width) 0]];

        // Simple Random Walker for dungeon generation
        var cx = Std.int(width / 2);
        var cy = Std.int(height / 2);
        startX = cx;
        startY = cy;

        var floorCount = 0;
        var maxFloors = Std.int(width * height * 0.4);

        while (floorCount < maxFloors) {
            if (data[cy][cx] == 0) {
                data[cy][cx] = 1;
                floorCount++;
            }

            var dir = Std.random(4);
            switch(dir) {
                case 0: cy--; // Up
                case 1: cy++; // Down
                case 2: cx--; // Left
                case 3: cx++; // Right
            }

            // Clamp
            if (cx < 1) cx = 1;
            if (cx >= width - 1) cx = width - 2;
            if (cy < 1) cy = 1;
            if (cy >= height - 1) cy = height - 2;
        }

        // Place exit far from start (simplified: just the last walker position)
        exitX = cx;
        exitY = cy;
        
        // Ensure exit isn't on start
        if (exitX == startX && exitY == startY) {
            exitX = startX + 1;
        }
    }

    public function isWalkable(x:Int, y:Int):Bool {
        if (x < 0 || x >= width || y < 0 || y >= height) return false;
        return data[y][x] == 1;
    }
}