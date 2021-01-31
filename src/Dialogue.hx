import GameEvent.EventType;

class Dialogue {
	public var actor:String;
	public var text:String;
	public var type:EventType;

	public function new(actor:String, text:String, ?type:EventType = Event) {
		this.actor = actor;
		this.text = text;
		this.type = type;
	}
}
