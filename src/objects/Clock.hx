package objects;

import h2d.Tile;
import h2d.Bitmap;
import h3d.Vector;
import h2d.Text;
import h2d.Object;

class Clock extends Object {
	var tf:Text;
	var pause:Bitmap;
	var one:Bitmap;
	var two:Bitmap;
	var three:Bitmap;
	var tiles:Array<Tile>;

	public function new(parent:Object) {
		super(parent);

		EventController.instance.registerSpeedListener(onSpeedChange);

		// background
		var bg = new h2d.Bitmap(hxd.Res.clock.toTile(), this);

		tf = new Text(hxd.Res.fonts.digital.toFont(), this);
		tf.color = new Vector(255, 0, 0);
		tf.x += 160;
		tf.y -= 5;
		tf.scale(3);
		tf.textAlign = Center;
		tf.text = "00:00";

		// buttons
		var tileImage = hxd.Res.clock_arrows.toTile();
		tiles = [
			for (y in 0...2)
				for (x in 0...4)
					tileImage.sub(x * 64, y * 64, 64, 64)
		];

		// pause
		pause = new Bitmap(tiles[2], this);
		pause.x += 65;
		pause.y += 80;
		var pauseInteraction = new h2d.Interactive(64, 64, pause);
		pauseInteraction.onClick = function(event:hxd.Event) {
			EventController.instance.setSpeed(0);
		}

		// one
		one = new Bitmap(tiles[1], this);
		one.x += 125;
		one.y += 80;
		var oneInteraction = new h2d.Interactive(64, 64, one);
		oneInteraction.onClick = function(event:hxd.Event) {
			EventController.instance.setSpeed(1);
		}

		// two
		two = new Bitmap(tiles[4], this);
		two.x += 175;
		two.y += 80;
		var twoInteraction = new h2d.Interactive(64, 64, two);
		twoInteraction.onClick = function(event:hxd.Event) {
			EventController.instance.setSpeed(2);
		}

		// three
		three = new Bitmap(tiles[6], this);
		three.x += 235;
		three.y += 80;
		var threeInteraction = new h2d.Interactive(64, 64, three);
		threeInteraction.onClick = function(event:hxd.Event) {
			EventController.instance.setSpeed(3);
		}
	}

	function onSpeedChange(speed:Int):Void {
		switch speed {
			case 0:
				pause.tile = tiles[3];
				one.tile = tiles[0];
				two.tile = tiles[4];
				three.tile = tiles[6];
			case 1:
				pause.tile = tiles[2];
				one.tile = tiles[1];
				two.tile = tiles[4];
				three.tile = tiles[6];
			case 2:
				pause.tile = tiles[2];
				one.tile = tiles[0];
				two.tile = tiles[5];
				three.tile = tiles[6];
			case 3:
				pause.tile = tiles[2];
				one.tile = tiles[0];
				two.tile = tiles[4];
				three.tile = tiles[7];
		}
	}

	public function setTimeText(time:String) {
		tf.text = time;
	}
}
