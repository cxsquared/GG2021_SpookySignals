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

		var baseX = -50;
		var baseY = 25;

		// background
		var bg = new h2d.Bitmap(hxd.Res.clock.toTile(), this);

		tf = new Text(hxd.Res.fonts.digital.toFont(), this);
		tf.color = new Vector(255, 0, 0);
		tf.x += 160 + baseX;
		tf.y += baseY;
		tf.scale(2.5);
		tf.textAlign = Center;
		tf.text = "00:00";

		// buttons
		var bs = 64;
		var tileImage = hxd.Res.clock_arrows.toTile();
		tiles = [
			for (y in 0...2)
				for (x in 0...4)
					tileImage.sub(x * bs, y * bs, bs, bs)
		];

		var interactSize = 32;
		var cy = 100;

		// pause
		pause = new Bitmap(tiles[3], this);
		pause.x += 65 + baseX;
		pause.y += cy + baseY;
		var pauseInteraction = new h2d.Interactive(interactSize, interactSize, pause);
		pauseInteraction.onClick = function(event:hxd.Event) {
			EventController.instance.setSpeed(0);
		}

		// one
		one = new Bitmap(tiles[0], this);
		one.x += 125 + baseX;
		one.y += cy + baseY;
		var oneInteraction = new h2d.Interactive(interactSize, interactSize, one);
		oneInteraction.onClick = function(event:hxd.Event) {
			EventController.instance.setSpeed(1);
		}

		// two
		two = new Bitmap(tiles[5], this);
		two.x += 175 + baseX;
		two.y += cy + baseY;
		var twoInteraction = new h2d.Interactive(interactSize, interactSize, two);
		twoInteraction.onClick = function(event:hxd.Event) {
			EventController.instance.setSpeed(2);
		}

		// three
		three = new Bitmap(tiles[6], this);
		three.x += 235 + baseX;
		three.y += cy + baseY;
		var threeInteraction = new h2d.Interactive(interactSize, interactSize, three);
		threeInteraction.onClick = function(event:hxd.Event) {
			EventController.instance.setSpeed(3);
		}
	}

	function onSpeedChange(speed:Int):Void {
		switch speed {
			case 0:
				pause.tile = tiles[2];
				one.tile = tiles[1];
				two.tile = tiles[5];
				three.tile = tiles[7];
			case 1:
				pause.tile = tiles[3];
				one.tile = tiles[0];
				two.tile = tiles[5];
				three.tile = tiles[7];
			case 2:
				pause.tile = tiles[3];
				one.tile = tiles[1];
				two.tile = tiles[4];
				three.tile = tiles[7];
			case 3:
				pause.tile = tiles[3];
				one.tile = tiles[1];
				two.tile = tiles[5];
				three.tile = tiles[6];
		}
	}

	public function setTimeText(time:String) {
		tf.text = time;
	}
}
