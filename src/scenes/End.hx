package scenes;

import hxd.App;
import h2d.Text;

class End extends BaseScene {
	public function new(app:App) {
		super(app);

		var bg = new h2d.Bitmap(hxd.Res.EndScreen.toTile(), this);

		var credits = new Text(hxd.Res.fonts.stayhome.toFont(), bg);
		credits.x = 250;
		credits.y = 650;

		credits.text = "A game by Cody Claborn (@cxsquared), Kayleigh Jones (@Foxxie_Q),\n Travis Faas (@meanderingleaf), and Gabrielle Bayani (@starafires)";
	}

	override public function update(dt:Float) {
		super.update(dt);
	}
}
