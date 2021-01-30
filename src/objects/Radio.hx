package objects;

import hxd.res.DefaultFont;
import h2d.Object;

class Radio extends h2d.Object {

	public function new(parent : h2d.Object) {
        super(parent);
        
    
		var tile = hxd.Res.bg.toTile();
		var bmp = new h2d.Bitmap(tile, this);
		
    }
    
}
