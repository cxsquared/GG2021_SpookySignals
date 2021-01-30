package objects;

import hxd.res.DefaultFont;
import h2d.Object;

class Main extends h2d.Object {

	override function init() {

		
    }
    
    override function update(dt:Float) {
        // rotate our object every frame
        if( obj != null ) obj.rotation += 0.6 * dt;
    }
}
