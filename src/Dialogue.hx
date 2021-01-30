import haxe.CallStack.StackItem;

class Dialogue {
	public var actor:String;
	public var text:String;

	public function new(actor:String, text:String) {
		this.actor = actor;
		this.text = text;
	}
}
