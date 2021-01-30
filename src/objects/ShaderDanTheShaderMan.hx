package objects;

import h2d.Bitmap;
import h2d.Object;

class ShaderDanTheShaderMan extends h2d.Object {
	public function new(parent:Object) {
		super(parent);

        var bg = new Bitmap(hxd.Res.pmarker.toTile(), this);

        //var l = new Bitmap(hxd.Res.map.toTile(), this);

        var shader = new Lightning();
        shader.ltexture = hxd.Res.map.toTile().getTexture();
        
        bg.addShader(shader);

	}
}

class Lightning extends hxsl.Shader {
    static var SRC = {

        @global var time : Float;
		var calculatedUV : Vec2;
        var absolutePosition : Vec4;
        var pixelColor : Vec4;

        @param var ltexture : Sampler2D;

		function fragment() {
            //pixelColor.x = ltexture.get(calculatedUV).x;
            var ouv = calculatedUV;
            ouv.x += sin(absolutePosition.y * time);
            pixelColor = pixelColor * ltexture.get(ouv);
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