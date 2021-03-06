package objects;

import h2d.Bitmap;
import h2d.Object;
import h2d.Graphics;
import motion.Actuate;

class ShaderDanTheShaderMan extends h2d.Object {
	public function new(parent:Object) {
		super(parent);

        var bg = new Bitmap(hxd.Res.pmarker.toTile(), this);

        //var l = new Bitmap(hxd.Res.map.toTile(), this);

        var shader = new Lightning();
        shader.ltexture = hxd.Res.map.toTile().getTexture();
        bg.addShader(shader);

        var white : Graphics = new Graphics(this);
        white.beginFill(0xFFFFFF);
        white.drawRect(0,0,800,600);
        white.endFill();

       strike(3);
    }
    
    public function strike(count = 1) {
        var c = count;
        this.alpha = 1;
        Actuate.tween(this, 1.1, {  alpha: 0 } ).repeat(count-1);
    }
}

//Port of behithop's Godot lightning shader
class Lightning extends hxsl.Shader {
    static var SRC = {

        @global var time : Float;
		var calculatedUV : Vec2;
        var absolutePosition : Vec4;
        var pixelColor : Vec4;

        @param var ltexture : Sampler2D;

        
        // rand, noise and fbm function
        function rand(n : Vec2 ) : Float {
            return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
        }
        
        function noise( n:Vec2 ) : Float {
            var d =  vec2(0.0, 1.0);
            var b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
            return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
        }

        function fbm( n : Vec2) : Float {
            var total = 0.0, amplitude = 1.0;
            for (i in 0 ... 7) {
                total += noise(n) * amplitude;
                n += n;
                amplitude *= 0.5;
            }
            return total;
        }  

        function plot( st : Vec2, pct : Float,  half_width : Float) : Float {
            return  smoothstep( pct-half_width, pct, st.y) -
                    smoothstep( pct, pct+half_width, st.y);
        }

		function fragment() {
                 
            var color = vec4(0.0, 0.0, 0.0, 0.0);
            
            var t  = vec2(0);
            var y = 0.0;
            var pct = 0.0;
            var buffer = 0.0;

            // add more lightning
            for ( i in 0 ... 5){
                t = calculatedUV.yx * vec2(1.0,0.0) + vec2(float(i), -float(i)) - time*3.0;
                y = fbm(t)*0.5;
                pct = plot(calculatedUV.yx, y, 0.02);
                buffer = plot(calculatedUV.yx, y, 0.08);
                color += pct*vec4(1.0, 1.0, 1.0, 1.0);
                color += buffer*vec4(0.2, 0, 0.8, 0.0);
            }

            color *= rand(vec2(time, time));
            color.a *= rand(vec2(time, time)) * ( pixelColor.a * 3 );
            pixelColor = color ;


            //Absolute madness
            //var d =  vec2(0.0, 1.0);
            //pixelColor.r = rand( vec2(0.0, 200.0));
            //pixelColor.g = rand( vec2(calculatedUV.x, 200.0) );
            //pixelColor.b = rand( vec2(calculatedUV.y, 200.0) );

            //Fun old code
            
            //pixelColor.x = ltexture.get(calculatedUV).x;
            //var ouv = calculatedUV;
            //ouv.x += sin(absolutePosition.y * time);
            //pixelColor = pixelColor * ltexture.get(ouv);
           //calculatedUV.y += sin(absolutePosition.y * time);

		}

    };
    
    public function new(  ) {
		super();
	}
}



class SinusDeform extends hxsl.Shader {

	static var SRC = {

		@global var time : Float;
		@param var speed : Float;
		@param var frequency : Float;
		@param var amplitude : Float;

		var calculatedUV : Vec2;
		var absolutePosition : Vec4;

		function fragment() {
			calculatedUV.x += sin(absolutePosition.y * frequency + time * speed + absolutePosition.x * 0.1) * amplitude;
		}

	};

	public function new( frequency = 10., amplitude = 0.01, speed = 1. ) {
		super();
		this.frequency = frequency;
		this.amplitude = amplitude;
		this.speed = speed;
	}

}


/*

name: Plasma
type: fragment
author: triggerHLM (https://www.shadertoy.com/view/MdXGDH)
---

precision mediump float;

uniform float time;
uniform vec2 resolution;

varying vec2 fragCoord;

const float PI = 3.14159265;

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {

    float time = time * 0.2;

    float color1, color2, color;

    color1 = (sin(dot(fragCoord.xy,vec2(sin(time*3.0),cos(time*3.0)))*0.02+time*3.0)+1.0)/2.0;

    vec2 center = vec2(640.0/2.0, 360.0/2.0) + vec2(640.0/2.0*sin(-time*3.0),360.0/2.0*cos(-time*3.0));

    color2 = (cos(length(fragCoord.xy - center)*0.03)+1.0)/2.0;

    color = (color1+ color2)/2.0;

    float red   = (cos(PI*color/0.5+time*3.0)+1.0)/2.0;
    float green = (sin(PI*color/0.5+time*3.0)+1.0)/2.0;
    float blue  = (sin(+time*3.0)+1.0)/2.0;

    fragColor = vec4(red, green, blue, 1.0);
}

void main(void)
{
    mainImage(gl_FragColor, fragCoord.xy);
    gl_FragColor.a = 1.0;
}
*/