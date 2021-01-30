package objects;

import h2d.Bitmap;
import h2d.Object;

class Walkie extends h2d.Object {
	public function new(parent:Object) {
		super(parent);

		var bg = new Bitmap(hxd.Res.walkie.toTile(), this);
	}
}
