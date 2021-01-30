package objects;

import haxe.macro.Expr.Function;
import hxd.res.DefaultFont;
import h2d.Object;
import h2d.Graphics;
import h2d.Interactive;

class Radio extends h2d.Object {

    public var changeCallback : Void -> Void;
    public var frequency : Float;
    
    var line : Graphics;
    var noise : hxd.snd.Channel;

    var minLine = 0;
    var maxLine = 100;

    var minFreq = 88;
    var maxFreq = 108;

	public function new(parent : h2d.Object) {
        super(parent);

        //image background
		var tile = hxd.Res.bg.toTile();
		var bmp = new h2d.Bitmap(tile, this);
        
        //the line for tunin'
        line = new h2d.Graphics(parent);
        line.beginFill(0x009900);
        line.drawRect(0,0,20,100);
        line.endFill();

        //radio sound
        var res = if( hxd.res.Sound.supportedFormat(Wav) ) hxd.Res.audio.radioNoise else null;

        //intraction
        var interaction = new h2d.Interactive(20,100, line);

        //begin draggening
        interaction.onPush = function(event : hxd.Event) {
            interaction.startDrag( doDrag );

            //begin the noisening
            if( res != null ) {
                noise = res.play(true);
            }
        }

        //stops the dragging, sets the freq, and emits emit
        interaction.onRelease = function(event : hxd.Event) {
            //end drag
            interaction.stopDrag();

            //end sound
            res.stop();

            //calc freq
            this.frequency = (line.x / (this.maxLine - this.minLine)) * (this.maxFreq-this.minFreq) + this.maxFreq;

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
