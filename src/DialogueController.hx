import GameEvent.EventType;
import h2d.Bitmap;
import hxd.Event;
import hxd.res.DefaultFont;
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

	public function new(parent:Object) {
		super(parent);

		hxd.Window.getInstance().addEventTarget(onEvent);

		var parentBounds = parent.getBounds();

		this.y = parentBounds.height - parentBounds.height / 4;

		bg = new Graphics(this);
		bg.beginFill(0x000000, .5);
		bg.drawRect(0, 0, parentBounds.width, parentBounds.height / 4);
		bg.endFill();
		bg.visible = false;

		actorTxt = new Text(DefaultFont.get(), bg);
		actorTxt.x = 10;
		actorTxt.y = 10;

		var font = DefaultFont.get().clone();
		font.resizeTo(24);

		text = new Text(font, bg);
		text.maxWidth = parentBounds.width * .75;
		text.y = 35;
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
	}

	public function onFinish(fn:Void->Void) {
		onFinishListeners.push(fn);
	}

	public function update(dt:Float) {
		if (currentDialogue == null && dialogueQueue.isEmpty()) {
			if (bg.visible) {
				bg.visible = false;
				icon.visible = false;
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

			progress = 0;
		}

		actorTxt.text = currentDialogue.actor;

		progress += dt * speed;

		text.text = text.getTextProgress(currentDialogue.text, progress);
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
