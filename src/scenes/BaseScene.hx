package scenes;

import h2d.Graphics;
import hxd.App;
import h2d.Scene;

class BaseScene extends Scene {
	var app:App;

	public function new(app:App) {
		super();
		this.app = app;

		scaleMode = Fixed(1280, 720, 1, Center, Center);

		var bg = new Graphics(this);
		bg.beginFill(0xf0f0f0, 1);
		bg.drawRect(0, 0, width, height);
		bg.endFill();

		setParentContainer(bg);
	}

	public function update(dt:Float) {}
}
