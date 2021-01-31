package objects;

import h2d.col.Point;
import h2d.Bitmap;
import h2d.Object;
import motion.Actuate;

class GameMap extends h2d.Object {
	var playerChar:h2d.Bitmap;
	var mapPoint:MapPoint;

	public var canMove = true;

	public function new(parent:h2d.Object) {
		super(parent);

		// image background
		var tile = hxd.Res.map.toTile();
		var bmp = new h2d.Bitmap(tile, this);

		// player character
		var pTile = hxd.Res.iconJenkinson.toTile();
		//pTile = pTile.center();
		playerChar = new h2d.Bitmap(pTile, this);
		playerChar.setScale(1);
		trace('width:${playerChar.getBounds().width} height:${playerChar.getBounds().height}');

		var playerBounds = playerChar.getBounds();
		var mapBounds = bmp.getBounds();
		var interaction = new h2d.Interactive(mapBounds.width, mapBounds.height, this);

		mapPoint = new MapPoint(mapBounds);

		updatePlayer(mapBounds.width / 2 - playerBounds.width / 2 - 32, mapBounds.height / 2 - playerBounds.height / 2 - 32);

		// move char
		interaction.onClick = function(event:hxd.Event) {
			if (!canMove)
				return;

			var bounds = playerChar.getBounds();
			var curX = playerChar.x;
			var curY = playerChar.y;
			var targetX = event.relX - bounds.width / 2;
			var targetY = event.relY - bounds.height / 2;

			var distance = Math.sqrt(Math.pow(targetX - curX, 2) + Math.pow(targetY - curY, 2));
			var playerSpeed = .05;
			Actuate.update(updatePlayer, distance * playerSpeed, [curX, curY], [targetX, targetY]);
		}
	}

	function updatePlayer(x:Float, y:Float) {
		playerChar.x = x;
		playerChar.y = y;
		var bounds = playerChar.getBounds();
		mapPoint.updateRealLocation(new Point(playerChar.x + bounds.width / 2, playerChar.y + bounds.height / 2));
	}

	public function getCharLocation():String {
		return '${mapPoint.getLetterLocation()},${mapPoint.getNumberLocation()}';
	}
}
