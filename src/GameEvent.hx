import h2d.col.Point;

class GameEvent {
	public var id:String;
	public var type:EventType = Event;
	public var text:String;
	public var audioFile:String;
	public var dependsOn:Array<String>;
	public var freq:Float;
	public var location:Point;
	public var time:Int; // minutes (probably from 0)

	public function new(id:String, text:String, audioFile:String, dependsOn:Array<String>, time:Int) {
		this.id = id;
		this.text = text;
		this.audioFile = audioFile;
		this.dependsOn = dependsOn;
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
