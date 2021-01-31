import scenes.BaseScene;
import scenes.Intro;

class Main extends hxd.App {
	override function init() {
		setScene(new Intro(this));
	}

	override function update(dt:Float) {
		super.update(dt);
		var baseScene:BaseScene = cast s2d; // Make sure we only use scenes derived from base
		baseScene.update(dt);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
