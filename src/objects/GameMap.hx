package objects;

import h2d.Object;

class GameMap extends h2d.Object {

	public function new(parent : h2d.Object) {
      super(parent);

      //image background
      var tile = hxd.Res.map.toTile();
      var bmp = new h2d.Bitmap(tile, this);

      this.y = 200;
    }
}