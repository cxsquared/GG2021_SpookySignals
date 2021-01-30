import h2d.col.Point;
import h2d.col.Bounds;

class MapPoint {
	var tileSize:Int;
	var realLocation:Point;

	var maxCell = 8;
	var minCell = 1;
	var letterMap = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

	public function new(mapBounds:Bounds) {
		tileSize = Math.floor(mapBounds.width / maxCell);
	}

	public function updateRealLocation(location:Point) {
		realLocation = location;
	}

	public function getLetterLocation():String {
		return letterMap[Math.floor(Math.min(realLocation.y / tileSize, maxCell - 1))];
	}

	public function getNumberLocation():Int {
		return Math.ceil(Math.min(realLocation.x / tileSize, maxCell - 1));
	}
}
