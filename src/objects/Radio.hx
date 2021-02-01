package objects;

import h2d.Scene;
import h2d.Object;
import h2d.Interactive;
import h2d.Text;

class Radio extends h2d.Object {
	public var changeCallback:Void->Void;
	public var frequency:Float;

	var scene:Scene;

	var line:h2d.Bitmap;
	var knob:Object;
	var knobInteraction:Interactive;
	var tuning = false;
	var noise:hxd.snd.Channel;
	var bubble:h2d.Bitmap;
	var hrzTxt:Text;

	var minLine = 100;
	var maxLine = 360;

	var minFreq = 80;
	var maxFreq = 120;

	var lpx = 0.0;
	var lpy = 0.0;
	var lr = 0.0;

	public var canMove = true;

	public function new(parent:Scene) {
		super(parent);

		this.scene = parent;

		// image background
		var tile = hxd.Res.radio.toTile();
		var bmp = new h2d.Bitmap(tile, this);

		// the line for tunin'
		tile = hxd.Res.radioLine.toTile();
		line = new h2d.Bitmap(tile, this);
		line.x = minLine;
		line.y = 215;

		// bubble
		bubble = new h2d.Bitmap(hxd.Res.hertzBubble.toTile(), this);
		bubble.x = 60;
		bubble.y = -40;

		var myFontona = hxd.res.DefaultFont.get();
		myFontona.resizeTo(72);
		hrzTxt = new Text(myFontona, this);
		hrzTxt.textColor = 0x000000;
		// hrzTxt.scale(2);
		hrzTxt.x = 190;
		hrzTxt.y = -10;
		hrzTxt.textAlign = Center;
		hrzTxt.text = "88.1" + "hz";

		// radio sound
		var res = if (hxd.res.Sound.supportedFormat(Wav)) hxd.Res.audio.radioNoise else null;

		noise = res.play(true);
		noise.pause = true;
		// knob
		var tile = hxd.Res.radioDial.toTile();
		knob = new Object(this);
		var knobGfx = new h2d.Bitmap(tile, knob);
		knobGfx.x = -knob.getBounds().width / 2;
		knobGfx.y = -knob.getBounds().height / 2;
		knob.x = 355;
		knob.y = 295;
		var knobB = knob.getBounds();

		knobInteraction = new h2d.Interactive(knobB.width, knobB.height, knob);

		knobInteraction.isEllipse = true;
		knobInteraction.x -= knobB.width / 2;
		knobInteraction.y -= knobB.height / 2;
		knobInteraction.onPush = function(event:hxd.Event) {
			if (!canMove)
				return;

			knobInteraction.startDrag(doDrag);
			tuning = true;

			lpx = event.relX;
			lpy = event.relY;

			// begin the noisening
			if (res != null) {
				noise.pause = false;
			}
		}

		knobInteraction.onRelease = onKnobRelease;
	}

	function onKnobRelease(?event:hxd.Event) {
		// end drag
		knobInteraction.stopDrag();
		// end sound
		noise.pause = true;
		// calc freq
		this.frequency = (line.x / (this.maxLine - this.minLine)) * (this.maxFreq - this.minFreq) + this.minFreq;
		// emit event
		if (onChange != null) {
			this.changeCallback();
		}
	}

	public function onChange(f:Void->Void) {
		this.changeCallback = f;
	}

	// make the drag more
	private function doDrag(event:hxd.Event) {
		var knobX = this.x + knob.x; // knob is based on the parent
		var knobY = this.y + knob.y; // knob is based on the parent
		var currentX = scene.mouseX;
		var currentY = scene.mouseY;

		var newAngle = Math.atan2(currentY - knobY, currentX - knobX);
		newAngle += Math.PI / 2; // Offset 90
		knob.rotation = newAngle;

		var rdiff = lr - knob.rotation;
		if (Math.abs(rdiff) > .07) {
			rdiff = 0;
		}

		// use the angle velocity to move the line
		line.x -= rdiff * 30;

		// keep the bounds
		if (line.x < minLine)
			line.x = minLine;
		if (line.x > maxLine)
			line.x = maxLine;

		// 95 - 115
		// freq count
		this.frequency = (line.x / (this.maxLine - this.minLine)) * (this.maxFreq - this.minFreq) + this.minFreq;
		hrzTxt.text = toFixed(this.frequency) + "hz";

		lr = knob.rotation;
	}

	function toFixed(num:Float):Float {
		num *= 10;
		var nnum = Math.fround(num);
		nnum /= 10;
		return nnum;
	}

	public function stop() {
		canMove = false;
		onKnobRelease();
	}
}
