package scenes;

import hxd.App;

class Intro extends BaseScene {
	var dc:DialogueController;

	public function new(app:App) {
		super(app);

		var bg = new h2d.Bitmap(hxd.Res.StartingScreen.toTile(), this);

		dc = new DialogueController(this);
		dc.onFinish(onDialogueFinish);
		dc.addDialouge(new Dialogue("KATIE", "Alright... looks like we're recording now."));
		dc.addDialouge(new Dialogue("BRANDON", "Are you sure? You said that the last three times..."));
		dc.addDialouge(new Dialogue("KATIE", "Yes, I'm sure, dummy! Now just do your big dramatic opening already!"));
		dc.addDialouge(new Dialogue("BRANDON", "Fine, but this better be the last time I have to do this!"));
		dc.addDialouge(new Dialogue("BRANDON",
			"Westbrook is a small town that many of you have probably never heard of. It's located right on the eastern border of Indiana and within spitting distance of Ohio."));
		dc.addDialouge(new Dialogue("KATIE", "Gross!"));
		dc.addDialouge(new Dialogue("BRANDON", "Excuse me! This is my opening! Now where was I... Oh right!"));
		dc.addDialouge(new Dialogue("BRANDON",
			"It may be small, but it's my sister, Katie, and I's home. People say strange things happen in small towns all the time. But not like this. 3 days ago our dog, Sunny, disappeared. Our parents say he just ran away, but we know better. Something happened to Sunny and we're gonna get to the bottom of it."));
		dc.addDialouge(new Dialogue("KATIE", "Well said, little brother."));
	}

	override public function update(dt:Float) {
		super.update(dt);

		dc.update(dt);
	}

	function onDialogueFinish() {
		// switch to main scene
		app.setScene(new Game(app));
	}

	override public function dispose() {
		dc.remove();
		super.dispose();
	}
}
