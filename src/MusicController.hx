import haxe.display.Display.Package;
import hxd.snd.ChannelGroup;
import hxd.snd.Channel;
import hxd.res.Sound;

class MusicController {
	var music = new Map<Int, Channel>();
	var currentlyPlaying:Channel;
	var channelGrp:ChannelGroup;

	public function new() {
		channelGrp = new ChannelGroup('music');
		channelGrp.volume = 0;
		if (Sound.supportedFormat(Mp3)) {
			var m = hxd.Res.audio.text01;
			music.set(115, m.play(true, 1, channelGrp));
		}

		for (channel in music) {
			channel.volume = 0;
		}
	}

	public function setFreq(freq:Float) {
		var wholeFreq = Math.round(freq);

		for (freqKey => channel in music) {
			if (freqKey == wholeFreq && channel.volume <= 0) {
				channel.fadeTo(1, .5);
			} else {
				channel.fadeTo(0, .5);
			}
		}
	}
}
