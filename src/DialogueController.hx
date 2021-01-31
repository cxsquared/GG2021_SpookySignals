import hxd.Rand;
import hxd.res.Sound;
import GameEvent.EventType;
import h2d.Bitmap;
import hxd.Event;
import h2d.Text;
import h2d.Tile;
import h2d.Graphics;
import h2d.Object;

class DialogueController extends Object {
	var dialogueQueue = new List<Dialogue>();
	var currentDialogue:Dialogue;
	var progress:Float = 0;
	var speed:Float = 20;
	var bg:Graphics;
	var actorTxt:Text;
	var text:Text;
	var onFinishListeners = new Array<Void->Void>();
	var icons = new Array<Tile>();
	var icon:Bitmap;
	var sounds = new Array<Sound>();
	var soundDelay = .25;
	var baseDelay = .15;
	var timeSinceLastSound:Float = 0;
	var rand = Rand.create();
	var ports = new Array<Tile>();
	var portrait:Bitmap;

	public function new(parent:Object) {
		super(parent);

		if (hxd.res.Sound.supportedFormat(Wav)) {
			sounds.push(hxd.Res.audio.text01);
			sounds.push(hxd.Res.audio.text02);
			sounds.push(hxd.Res.audio.text03);
			sounds.push(hxd.Res.audio.text04);
			sounds.push(hxd.Res.audio.text05);
			sounds.push(hxd.Res.audio.text06);
		}

		hxd.Window.getInstance().addEventTarget(onEvent);

		var parentBounds = parent.getBounds();

		this.y = parentBounds.height - parentBounds.height / 3;

		bg = new Graphics(this);
		bg.beginFill(0x000000, .75);
		bg.drawRect(0, 0, parentBounds.width, parentBounds.height / 3);
		bg.endFill();
		bg.visible = false;

		actorTxt = new Text(hxd.Res.fonts.stayhome.toFont(), bg);
		actorTxt.x = 10;
		actorTxt.y = 10;

		var font = hxd.Res.fonts.stayhome.toFont();

		text = new Text(font, bg);
		text.maxWidth = parentBounds.width * .75;
		text.y = 45;
		text.x = parentBounds.width - (parentBounds.width * .90);
		text.textAlign = Left;

		var iconSize = 64;
		var radioIcon = hxd.Res.radio.toTile();
		radioIcon.scaleToSize(iconSize, iconSize);
		icons.push(radioIcon);

		var walkieIcon = hxd.Res.walkie.toTile();
		walkieIcon.scaleToSize(iconSize, iconSize);
		icons.push(walkieIcon);

		icon = new Bitmap(icons[0], bg);
		icon.x = parentBounds.width - iconSize - 50;
		icon.y = bg.getBounds().height / 2 - iconSize / 2;

		// ports
		ports.push(hxd.Res.TalkingSister.toTile());
		ports.push(hxd.Res.TalkingBrother.toTile());
		ports.push(hxd.Res.TalkingJenkinson.toTile());

		portrait = new Bitmap(ports[0], bg);
		portrait.scale(.5);
		portrait.y = bg.getBounds().height / 2 - portrait.getBounds().height / 2;
		portrait.x = 20;
		portrait.visible = false;
	}

	public function onFinish(fn:Void->Void) {
		onFinishListeners.push(fn);
	}

	public function update(dt:Float) {
		if (currentDialogue == null && dialogueQueue.isEmpty()) {
			if (bg.visible) {
				bg.visible = false;
				icon.visible = false;
				timeSinceLastSound = 0;
				emitFinish();
			}
			return;
		}

		if (currentDialogue == null) {
			currentDialogue = dialogueQueue.pop();
			var newColor = getTextColor(currentDialogue.actor);
			actorTxt.textColor = newColor;
			text.textColor = newColor;

			var iconTile = getIconTile(currentDialogue.actor, currentDialogue.type);
			if (iconTile != null) {
				icon.tile = iconTile;
				icon.visible = true;
			} else {
				icon.visible = false;
			}

			var portraitTile = getPortrai(currentDialogue.actor);
			if (portraitTile != null) {
				portrait.visible = true;
				portrait.tile = portraitTile;
			} else {
				portrait.visible = false;
			}

			progress = 0;
		}

		updateSounds(dt);

		actorTxt.text = currentDialogue.actor;
		progress += dt * speed;
		text.text = text.getTextProgress(currentDialogue.text, progress);
	}

	function updateSounds(dt:Float) {
		if (currentDialogue != null) {
			if (progress >= currentDialogue.text.length) {
				timeSinceLastSound = 0;
				for (s in sounds) {
					s.stop();
				}

				return;
			} else {
				timeSinceLastSound += dt;

				if (timeSinceLastSound > soundDelay) {
					rand.shuffle(sounds);
					timeSinceLastSound = 0;
					soundDelay = baseDelay + rand.srand(.25);
					sounds[0].play();
				}
			}
		}
	}

	public function addDialouge(d:Dialogue) {
		dialogueQueue.add(d);

		if (currentDialogue == null)
			bg.visible = true;
	}

	override public function onRemove() {
		hxd.Window.getInstance().removeEventTarget(onEvent);
	}

	function onEvent(event:Event) {
		switch (event.kind) {
			case EPush:
				if (event.button == 0)
					handlePress();
			case _:
		}
	}

	function handlePress() {
		if (currentDialogue != null) {
			if (progress >= currentDialogue.text.length) {
				currentDialogue = null;
			} else {
				progress = currentDialogue.text.length;
			}
		}
	}

	function emitFinish() {
		for (fn in onFinishListeners) {
			fn();
		}
	}

	function getTextColor(actor:String):Int {
		var lowerActor = actor.toLowerCase();

		if (lowerActor.indexOf("katie") >= 0)
			return 0x00fff3;

		if (lowerActor.indexOf("brandon") >= 0)
			return 0xcc89ff;

		return 0xf0f0f0;
	}

	function getPortrai(actor:String):Tile {
		var lowerActor = actor.toLowerCase();

		if (lowerActor.indexOf("katie") >= 0)
			return ports[0];

		if (lowerActor.indexOf("brandon") >= 0)
			return ports[1];

		if (lowerActor.indexOf("Jenkinson") >= 0)
			return ports[2];

		return null;
	}

	function getIconTile(actor:String, type:EventType):Tile {
		var radios = ['news', 'singer', 'host', 'advertisement'];
		var walkies = ['radio'];
		var lowerActor = actor.toLowerCase();

		switch type {
			case Radio:
				for (a in radios)
					if (lowerActor.indexOf(a) >= 0)
						return icons[0];
			case Map:
				for (a in walkies)
					if (lowerActor.indexOf(a) >= 0)
						return icons[1];
			case _:
				return null;
		}

		return null;
	}
}
