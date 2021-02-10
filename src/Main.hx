import scenes.Title;
import scenes.Game;
import scenes.BaseScene;

class Main extends hxd.App {
	override function init() {
		#if !debug
		setScene(new Title(this));
		#else
		setScene(new Game(this));
		#end
	}

	override function update(dt:Float) {
		super.update(dt);
		var baseScene:BaseScene = cast s2d; // Make sure we only use scenes derived from base
		baseScene.update(dt);
	}

	static function main() {
		// Heaps resources
		#if (hl && debug)
		hxd.Res.initLocal();
		#else
		hxd.Res.initEmbed();
		#end
		new Main();
	}
}
