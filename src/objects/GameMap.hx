package objects;

import h2d.Bitmap;
import h2d.Object;
import motion.Actuate;

class GameMap extends h2d.Object {
	var playerChar:h2d.Bitmap;

	public function new(parent:h2d.Object) {
		super(parent);

		// position map
		this.y = 200;

		// image background
		var tile = hxd.Res.map.toTile();
		var bmp = new h2d.Bitmap(tile, this);

		// player character
		playerChar = new h2d.Bitmap(hxd.Res.pmarker.toTile(), this);

		//
		var interaction = new h2d.Interactive(800, 600, this);

		// move char
		interaction.onClick = function(event:hxd.Event) {
      playerChar.x = 1;
    
			Actuate.update(updatePlayer, 1, [playerChar.x, playerChar.y], [200, 200]);
			// Actuate.tween(playerChar, 10, { x: 200, y: 200, posChange: true });

			trace(playerChar.x, playerChar.y);
		}
	}

	function updatePlayer(x, y) {
		playerChar.x = x;
		playerChar.y = y;
	}
}
