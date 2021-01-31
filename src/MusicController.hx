import hxd.snd.Manager;
import hxd.snd.Channel;
import hxd.res.Sound;

class MusicController {
	var music = new Map<Int, Sound>();
	var currentlyPlaying:Sound;
	var channel:Channel;

	public function new() {
		if (Sound.supportedFormat(Mp3)) {
			music.set(115, hxd.Res.audio.Testing_the_Waters);
		}
	}

	public function setFreq(freq:Float) {
		var wholeFreq = Math.round(freq);

		if (music.exists(wholeFreq)) {
			var sound = music.get(wholeFreq);
			if (sound == currentlyPlaying) {
				channel = Manager.get().
			}
		}
	}
}
