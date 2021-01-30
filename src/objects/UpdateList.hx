package objects;

import h2d.Flow;
import h2d.Text;
import hxd.res.DefaultFont;

class UpdateList extends h2d.Flow  {

    public function new(?parent) {
        super(parent);

        this.layout = FlowLayout.Vertical;
        
        this.x = 300;
    }

    public function addUpdate(update : String) {
        var tf = new h2d.Text(DefaultFont.get(), this);
        tf.text = update;
    }

}