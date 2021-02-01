package sfx;

import hxd.Rand;
import h2d.Object;

class ScreenShake {
	public var shakeDuration = 0.0;
	public var shakeIntensity = 2.0;

	private var sx:Float;
	private var sy:Float;

	private var obj:h2d.Object;
	private var shakeActive = false;

	public function new(o:h2d.Object) {
		obj = o;
	}

	public function shake(duration = 1.0, intensity = 1.0) {
		shakeIntensity = intensity;
		shakeDuration = duration;
		sx = obj.x;
		sy = obj.y;
		shakeActive = true;
		trace("hi!");
		trace(shakeActive);
	}

	public function update(dt:Float) {
		if (shakeDuration > 0) {
			shakeDuration -= dt;
			obj.x += (Math.random() * shakeIntensity * 2) - shakeIntensity;
			obj.y += (Math.random() * shakeIntensity * 2) - shakeIntensity;
		} else {
			if (shakeActive) {
				trace("Shake over");
				shakeActive = false;
				obj.x = sx;
				obj.y = sy;
			}
		}
	}
}
