import h2d.col.Point;
import GameEvent.EventType;

class EventController {
	public static final instance:EventController = new EventController();

	var time:Int = 0; // in minutes
	var events:Array<GameEvent>;
	var triggeredEvents = new Map<String, GameEvent>();
	var speed:Int = 0; // 0 paused, 1 regular, 2 medium, 3 fast
	var currentDt:Float = 0;
	var secondPerTick = 5; // Not sure about this yet
	var listeners = new Array<GameEvent->Void>();
	var speedChangeListeners = new Array<Int->Void>();
	var freqRange = 2;
	var locationRange = 5;

	public var currentEvent:GameEvent;

	private function new() {}

	public function registerEventListener(fn:GameEvent->Void) {
		listeners.push(fn);
	}

	public function registerSpeedListener(fn:Int->Void) {
		speedChangeListeners.push(fn);
	}

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
					newEvent.map(event[6]);
				default:
					// Do nothing for Event type
			}

			this.events.push(newEvent);
		}

		// sort by time
		this.events.sort((a, b) -> a.time - b.time);
	}

	private function timeToInt(time:String):Int {
		var hour = Std.parseInt(time.split(':')[0]);
		var min = Std.parseInt(time.split(':')[1]);

		return min + Std.int(Math.max(0, hour - 7)) * 60;
	}

	public function setSpeed(speed:Int) {
		this.speed = speed;

		for (fn in speedChangeListeners) {
			fn(speed);
		}
	}

	public function update(dt:Float, freq:Float, location:String) {
		if (shouldTick(dt)) {
			tick(freq, location);
		}
	}

	public function getTimeString():String {
		var min = this.time % 60;
		var hour = Math.floor(this.time / 60) + 7; // 7 hour offest?

		var minText = "";
		if (min < 10) {
			minText += "0";
		}
		minText += min;

		var hourText = "";
		if (hour < 10) {
			hourText += "0";
		}
		hourText += hour;

		return '$hourText:$minText';
	}

	private function tick(freq:Float, location:String) {
		this.currentDt = 0;
		this.time += 15; // each tick is 15 minutes

		while (this.events.length > 0 && this.events[0].time <= this.time) {
			var potentialEvent = events.shift();

			// Actually check radio and map stuff
			if (potentialEvent.type == Radio && !between(potentialEvent.freq, freq, freqRange)) {
				continue; // skip this event
			} else if (potentialEvent.type == Map && potentialEvent.location != location) {
				continue; // skip this event
			}

			if (potentialEvent.dependsOn.length > 0) {
				for (eventId in potentialEvent.dependsOn) {
					if (!this.triggeredEvents.exists(eventId)) {
						continue; // skip this event
					}
				}
			}

			for (fn in listeners) {
				fn(potentialEvent);
			}
		}
	}

	function between(input:Float, compare:Float, offset:Float) {
		return input <= compare + offset && input >= compare - offset;
	}

	function shouldTick(dt:Float):Bool {
		if (this.speed == 0)
			return false;

		this.currentDt += dt;

		switch (this.speed) {
			case 1: // Regular
				if (this.currentDt >= this.secondPerTick)
					return true;
			case 2:
				if (this.currentDt >= this.secondPerTick / 1.5)
					return true;
			case 3:
				if (this.currentDt >= this.secondPerTick / 2)
					return true;
		}

		return false;
	}
}
