package objects;

import h2d.col.Point;
import h2d.Bitmap;
import h2d.Object;
import motion.Actuate;

class GameMap extends h2d.Object {
	var playerChar:h2d.Bitmap;
	var mapPoint:MapPoint;
	var jenkinson:Bitmap;

	public var canMove = true;

	public function new(parent:h2d.Object) {
		super(parent);

		// image background
		var tile = hxd.Res.map.toTile();
		var bmp = new h2d.Bitmap(tile, this);

		var mapBounds = bmp.getBounds();
		var interaction = new h2d.Interactive(mapBounds.width, mapBounds.height, this);

		mapPoint = new MapPoint(mapBounds);

		// Locations
		var dumpter = new h2d.Bitmap(hxd.Res.iconDumpster.toTile(), this);
		setLocation(dumpter, 'a', 8);
		var forest = new h2d.Bitmap(hxd.Res.iconForest.toTile(), this);
		setLocation(forest, 'g', 7);
		jenkinson = new h2d.Bitmap(hxd.Res.iconJenkinson.toTile(), this);
		setLocation(jenkinson, 'f', 1);
		jenkinson.visible = false;
		var iconMines = new h2d.Bitmap(hxd.Res.iconMines.toTile(), this);
		setLocation(iconMines, 'a', 1);
		var iconTownHall = new h2d.Bitmap(hxd.Res.iconTownHall.toTile(), this);
		setLocation(iconTownHall, 'e', 5);
		var iconTreeHouse = new h2d.Bitmap(hxd.Res.iconTreehouse.toTile(), this);
		setLocation(iconTreeHouse, 'd', 4);

		// player character
		var pTile = hxd.Res.iconJenkinson.toTile();
		// pTile = pTile.center();
		playerChar = new h2d.Bitmap(pTile, this);
		playerChar.setScale(1);

		var playerBounds = playerChar.getBounds();
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

			if (EventController.instance.triggeredEvents.exists('009_radio')
				&& letterNumToString(mapPoint.getLetterLocation(targetY), mapPoint.getNumberLocation(targetX)) == 'f,1') {
				jenkinson.visible = true;
			}
		}
	}

	function updatePlayer(x:Float, y:Float) {
		playerChar.x = x;
		playerChar.y = y;
		var bounds = playerChar.getBounds();
		mapPoint.updateRealLocation(new Point(playerChar.x + bounds.width / 2, playerChar.y + bounds.height / 2));
	}

	public function getCharLocation():String {
		return letterNumToString(mapPoint.getLetterLocation(), mapPoint.getNumberLocation());
	}

	public function letterNumToString(letter:String, num:Int) {
		return '$letter,$num';
	}

	function setLocation(obj:Bitmap, letter:String, number:Int) {
		var objBounds = obj.getBounds();
		obj.y = mapPoint.letterLocationToFloat(letter);
		obj.x = mapPoint.numberLocationToFloat(number) - objBounds.height / 2;
	}
}
