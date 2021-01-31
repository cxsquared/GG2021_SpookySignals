import hxd.Rand;
import h2d.col.Point;
import h2d.col.Bounds;

class MapPoint {
	var tileSize:Int;
	var realLocation:Point;
	var rand = Rand.create();

	var maxCell = 8;
	var minCell = 1;
	var letterMap = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

	public function new(mapBounds:Bounds) {
		tileSize = 75;
		// Math.floor(mapBounds.width / maxCell);
	}

	public function updateRealLocation(location:Point) {
		realLocation = location;
	}

	public function getLetterLocation(?y:Float):String {
		if (y == null)
			y = realLocation.y;

		return letterMap[Math.floor(Math.min((y - 4) / tileSize, maxCell - 1))];
	}

	public function getNumberLocation(?x:Float):Int {
		if (x == null)
			x = realLocation.x;

		return Math.ceil(Math.max(1, Math.min((x + 16) / tileSize - 1, maxCell)));
	}

	public function letterLocationToFloat(letter:String):Float {
		return letterMap.indexOf(letter) * tileSize - 4 + rand.srand(tileSize / 2);
	}

	public function numberLocationToFloat(number:Int):Float {
		return Math.max(1, Math.min(number, maxCell)) * tileSize + 16 + rand.srand(tileSize / 2);
	}
}
