import h2d.col.Point;

class GameEvent {
	var id:String;
	var type:EventType = Event;
	var text:String;
	var audioFile:String;
	var dependOn:Array<String>;
	var freq:Float;
	var location:Point;

	public var time:Int; // minutes (probably from 0)

	public function new(id:String, text:String, audioFile:String, dependsOn:Array<String>, time:Int) {
		this.id = id;
		this.text = text;
		this.audioFile = audioFile;
		this.dependOn = dependsOn;
		this.time = time;
	}

	public function radio(freq:Float) {
		this.freq = freq;
		this.type = Radio;
	}

	public function map(location:Point) {
		this.location = location;
		this.type = Map;
	}
}

enum EventType {
	Radio;
	Map;
	Event;
}
