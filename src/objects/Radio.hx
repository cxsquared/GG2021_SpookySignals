package objects;

import haxe.macro.Expr.Function;
import hxd.res.DefaultFont;
import h2d.Object;
import h2d.Graphics;
import h2d.Interactive;

class Radio extends h2d.Object {

    public var changeCallback : Void -> Void;
    public var frequency : Float;
    
    var line : h2d.Bitmap;
    var knob : h2d.Bitmap;
    var tuning = false;
    var noise : hxd.snd.Channel;

    var minLine = 100;
    var maxLine = 360;

    var minFreq = 88;
    var maxFreq = 108;

	public function new(parent : h2d.Object) {
        super(parent);

        //image background
		var tile = hxd.Res.radio.toTile();
		var bmp = new h2d.Bitmap(tile, this);
        
        //the line for tunin'
        tile = hxd.Res.radioLine.toTile();
        line = new h2d.Bitmap(tile, this);

        line.x = minLine;
        line.y = 215;

        //radio sound
        var res = if( hxd.res.Sound.supportedFormat(Wav) ) hxd.Res.audio.radioNoise else null;
        noise = res.play(true);
        noise.pause = true;

        //knob
        var tile = hxd.Res.radioDial.toTile();
        knob = new h2d.Bitmap(tile, this);
        knob.x = 320;
        knob.y = 260;
        
        var knobInteraction = new h2d.Interactive(60,60, knob);

        knobInteraction.onPush = function(event : hxd.Event) {

            knobInteraction.startDrag( doDrag );

            tuning = true;

            //begin the noisening
            if( res != null ) {
                noise.pause = false;
            }
        }

        knobInteraction.onRelease = function(event : hxd.Event) {
            //end drag
            knobInteraction.stopDrag();

            //end sound
            noise.pause = true;

            //calc freq
            this.frequency = (line.x / (this.maxLine - this.minLine)) * (this.maxFreq-this.minFreq) + this.minFreq;

            //emit event
            if(onChange != null) {
                this.changeCallback();
            }
        }
    }

    public function onChange( f:Void->Void) {
        this.changeCallback = f;
    }

    //make the drag more
    private function doDrag(event : hxd.Event) {
        line.x += event.relX;

        if(line.x < minLine) line.x = minLine;
        if(line.x > maxLine) line.x = maxLine;
    }
    
}
