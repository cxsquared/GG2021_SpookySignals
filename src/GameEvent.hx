import h2d.col.Point;

class GameEvent {
	public var id:String;
	public var type:EventType = Event;
	public var text:Array<Dialogue>;
	public var audioFile:String;
	public var dependsOn:Array<String>;
	public var freq:Float;
	public var location:String;
	public var times:Array<TimeRequirement>; // minutes (probably from 0)

	public function new(id:String, text:Array<Dialogue>, audioFile:String, dependsOn:Array<String>, times:Array<TimeRequirement>) {
		this.id = id;
		this.text = text;
		this.audioFile = audioFile;
		this.dependsOn = dependsOn;
		this.times = times;
	}

	public function radio(freq:Float) {
		this.freq = freq;
		this.type = Radio;
	}

	public function map(location:String) {
		this.location = location;
		this.type = Map;
	}

	public function shouldTrigger(currentTime:Int):Bool {
		for (time in times) {
			if (!time.shouldTrigger(currentTime))
				return false;
		}

		return true;
	}

	public function shouldRemove(currentTime:Int):Bool {
		for (time in times) {
			if (time.shouldRemove(currentTime))
				return true;
		}

		return false;
	}
}

enum EventType {
	Radio;
	Map;
	Event;
}
