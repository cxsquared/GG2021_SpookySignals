import hxd.Event;
import hxd.res.DefaultFont;
import h2d.Text;
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
	}

	public function onFinish(fn:Void->Void) {
		onFinishListeners.push(fn);
	}

	public function update(dt:Float) {
		if (currentDialogue == null && dialogueQueue.isEmpty()) {
			if (bg.visible) {
				bg.visible = false;
				emitFinish();
			}
			return;
		}

		if (currentDialogue == null) {
			currentDialogue = dialogueQueue.pop();
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

	function onEvent(event:Event) {
		switch (event.kind) {
			case EPush:
				if (event.button == 0)
					handlePress();
			case _:
		}
	}

	function handlePress() {
		if (progress >= currentDialogue.text.length && currentDialogue != null) {
			currentDialogue = null;
		} else {
			progress = currentDialogue.text.length;
		}
	}

	function emitFinish() {
		for (fn in onFinishListeners) {
			fn();
		}
	}
}
