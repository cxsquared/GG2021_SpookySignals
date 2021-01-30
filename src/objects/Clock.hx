package objects;

import h3d.Vector;
import h2d.Text;
import h2d.Object;

class Clock extends Object {
	var tf:Text;

	public function new(parent:Object) {
		super(parent);

		var bitmap = new h2d.Bitmap(hxd.Res.clock.toTile(), this);

		tf = new Text(hxd.Res.fonts.digital.toFont(), this);
		tf.color = new Vector(255, 0, 0);
		tf.x += 160;
		tf.scale(3);
		tf.textAlign = Center;
		tf.text = "00:00";
	}

	public function setTimeText(time:String) {
		tf.text = time;
	}
}
