package scenes;

import hxd.App;

class Title extends BaseScene {

	public function new(app:App) {
        super(app);

        var tile = hxd.Res.bg.toTile();
        var bg = new h2d.Bitmap(tile, this);
        
        var logo = new h2d.Bitmap(hxd.Res.logo.toTile(), this);
        logo.y = 110;
        logo.x = 250;

        var playBtn = new h2d.Bitmap(hxd.Res.btnPlay.toTile(), this);
        playBtn.y = 450;
        playBtn.x = 280;

        var interaction = new h2d.Interactive(playBtn.width, playBtn.height, playBtn);

        interaction.onClick = function(event:hxd.Event) {
            app.setScene(new Game(app));
        }

    }

    override public function update(dt:Float) {
		super.update(dt);
	}
    
}