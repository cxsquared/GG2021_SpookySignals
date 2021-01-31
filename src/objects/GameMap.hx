package objects;

import motion.easing.Linear;
import motion.easing.Elastic;
import motion.easing.Quad;
import motion.easing.Quart;
import format.abc.Data.ABCData;
import h2d.col.Point;
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile.Tile;
import motion.Actuate;

class GameMap extends h2d.Object {
	var playerChar:h2d.Bitmap;
	var mapPoint:MapPoint;
	var jenkinson:Bitmap;
	var bmp:Bitmap;
	var onGameEvent:GameEvent->Void;
	var pTiles = new Array<Tile>();

	public var canMove = true;

	public function new(parent:h2d.Object, onGameEvent:GameEvent->Void) {
		super(parent);

		this.onGameEvent = onGameEvent;

		// image background
		var tile = hxd.Res.map.toTile();
		bmp = new h2d.Bitmap(tile, this);

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
		setLocation(iconTownHall, 'b', 2);
		var iconTreeHouse = new h2d.Bitmap(hxd.Res.iconTreehouse.toTile(), this);
		setLocation(iconTreeHouse, 'd', 4);
		var corn = new h2d.Bitmap(hxd.Res.IconCorn.toTile(), this);
		setLocation(corn, 'e', 5);
		var cem = new h2d.Bitmap(hxd.Res.IconCemetary.toTile(), this);
		setLocation(cem, 'g', 3);
		var house = new h2d.Bitmap(hxd.Res.IconHouse.toTile(), this);
		setLocation(house, 'd', 8);

		// player character
		var pTile = hxd.Res.Stickman.toTile();
		pTiles.push(pTile.sub(0, 0, 33, 47));
		pTiles.push(pTile.sub(33, 0, 27, 47));
		playerChar = new h2d.Bitmap(pTiles[1], this);
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
			var playerSpeed = .02;
			Actuate.update(updatePlayer, distance * playerSpeed, [curX, curY], [targetX, targetY]).onComplete(onPlayerMove).ease(Linear.easeNone);
			playerChar.tile = pTiles[0];

			if (EventController.instance.triggeredEvents.exists('009_radio')
				&& !EventController.instance.triggeredEvents.exists('099_event')
				&& letterNumToString(mapPoint.getLetterLocation(targetY), mapPoint.getNumberLocation(targetX)) == 'f,1') {
				jenkinson.visible = true;
				jenkinson.alpha = 0;
				Actuate.tween(jenkinson, 1, {alpha: 1});
				var dc = new Array<Dialogue>();
				dc.push(new Dialogue("BRANDON", "What was the podcast host's clue again?"));
				dc.push(new Dialogue("Katie", "\"Formula 1 is my favorite sport.\" Why?"));
				dc.push(new Dialogue("Brandon",
					"What if by formuala 1 he means F1? Look at this map of Westbrook! The coordinates F and 1 meet up in the middle of nowhere! "));
				dc.push(new Dialogue("Katie", "That's where his house could be! Great work Brandon! Now I just have to be there at 7:30 in the morning!"));
				onGameEvent(new GameEvent("099_event", dc, "", new Array<String>(), [new TimeRequirement(0, GE)]));
			}
		}
	}

	function onPlayerMove() {
		playerChar.tile = pTiles[1];
	}

	public function resetPlayer() {
		var mapBounds = bmp.getBounds();
		var playerBounds = playerChar.getBounds();
		updatePlayer(mapBounds.width / 2 - playerBounds.width / 2 - 32, mapBounds.height / 2 - playerBounds.height / 2 - 32);
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
