import h2d.col.Point;
import GameEvent.EventType;

class EventController {
	public static final instance:EventController = new EventController();

	var time:Int; // in minutes
	var events:Array<GameEvent>;
	var speed:Int = 0; // 0 paused, 1 regular, 2 medium, 3 fast
	var currentDt:Float = 0;
	var secondPerTick = 5; // Not sure about this yet

	private function new() {}

	public function loadEvents() {
		var file = hxd.Res.events.entry.getText();
		var csv = new CSVReader(file);
		var eventRows = csv.parseSheet();
		eventRows.shift(); // remove the headers

		this.events = new Array<GameEvent>();

		for (event in eventRows) {
			var type = EventType.createByName(event[1]);
			var dependsOn = new Array<String>();
			for (eventId in event[4].split(',')) {
				if (eventId.length > 0)
					dependsOn.push(eventId);
			}

			var newEvent = new GameEvent(event[0], event[2], event[3], dependsOn, this.timeToInt(event[7]));

			switch (type) {
				case Radio:
					newEvent.radio(Std.parseFloat(event[5]));
				case Map:
					var x = Std.parseInt(event[6].split(",")[0]);
					var y = Std.parseInt(event[6].split(",")[1]);
					newEvent.map(new Point(x, y));
				default:
					// Do nothing for Event type
			}

			this.events.push(newEvent);
		}

		// sort by time
		this.events.sort((a, b) -> a.time - b.time);
	}

	private function timeToInt(time:String):Int {
		var hour = time.split(':')[0];
		var min = time.split(':')[1];

		return Std.parseInt(min) + Std.parseInt(hour) * 60;
	}

	public function setSpeed(speed:Int) {
		this.speed = speed;
	}

	public function update(dt:Float) {
		if (shouldTick(dt)) {
			tick();
		}
	}

	private function tick() {
		currentDt = 0;
		time += 15; // each tick is 15 minutes
	}

	function shouldTick(dt:Float):Bool {
		if (this.speed == 0)
			return false;

		currentDt += dt;

		switch (this.speed) {
			case 1: // Regular
				if (currentDt >= secondPerTick)
					return true;
			case 2:
				if (currentDt >= secondPerTick / 1.5)
					return true;
			case 3:
				if (currentDt >= secondPerTick / 2)
					return true;
		}

		return false;
	}
}
