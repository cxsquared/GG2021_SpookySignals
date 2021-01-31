import GameEvent.EventType;

class EventController {
	public static final instance:EventController = new EventController();

	var time:Int = 11 * 60 + 45; // in minutes
	var events:List<GameEvent>;

	public var triggeredEvents = new Map<String, GameEvent>();

	public var speed:Int = 0; // 0 paused, 1 regular, 2 medium, 3 fast

	var currentDt:Float = 0;
	var secondPerTick = 5; // Not sure about this yet
	var listeners = new Array<GameEvent->Void>();
	var speedChangeListeners = new Array<Int->Void>();
	var freqRange = 2;
	var locationRange = 5;

	public var canChangeSpeed = true;

	public var currentEvent:GameEvent;

	private function new() {}

	public function registerEventListener(fn:GameEvent->Void) {
		listeners.push(fn);
	}

	public function registerSpeedListener(fn:Int->Void) {
		speedChangeListeners.push(fn);
	}

	public function loadEvents() {
		// replacing double quotes to parse everything correctly
		var dqreg = ~/""/g;
		var file = hxd.Res.events.entry.getText();
		file = dqreg.replace(file, "/dq/");
		var csv = new CSVReader(file);
		var eventRows = csv.parseSheet();
		eventRows.shift(); // remove the headers

		this.events = new List<GameEvent>();

		for (event in eventRows) {
			var type = EventType.createByName(event[1]);
			var dependsOn = new Array<String>();
			for (eventId in event[4].split('|')) {
				if (eventId.length > 0)
					dependsOn.push(eventId);
			}

			var dialogues = new Array<Dialogue>();
			var dialogueLines = event[2].split(';');
			for (dialogue in dialogueLines) {
				var actor = dialogue.split('|')[0];
				var text = dialogue.split('|')[1];
				if (text.indexOf("/dq/") >= 0) {
					// undo us changing double quotes
					var undqreg = ~/\/dq\//g;
					text = undqreg.replace(text, "\"");
				}

				dialogues.push(new Dialogue(actor, text, type));
			}

			var times = new Array<TimeRequirement>();
			var timeLines = event[7].split('|');
			for (time in timeLines) {
				var mod = time.substr(0, 2);
				var time = time.substr(2);
				times.push(new TimeRequirement(timeToInt(time), TimeModifier.createByName(mod)));
			}

			var newEvent = new GameEvent(event[0], dialogues, event[3], dependsOn, times);

			switch (type) {
				case Radio:
					newEvent.radio(Std.parseFloat(event[5]));
				case Map:
					newEvent.map(event[6]);
				default:
					// Do nothing for Event type
			}

			this.events.add(newEvent);
		}
	}

	private function timeToInt(time:String):Int {
		var hour = Std.parseInt(time.split(':')[0]);
		var min = Std.parseInt(time.split(':')[1]);

		return min + Std.int(hour) * 60;
	}

	public function setSpeed(speed:Int) {
		if (!canChangeSpeed)
			return;

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
		var hour = Math.floor(this.time / 60);
		if (hour > 12) {
			hour -= 12;
		}

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

		for (event in this.events) {
			var hasTriggered = false;

			if (event.type == Radio && !between(event.freq, freq, freqRange)) {
				continue; // skip this event
			} else if (event.type == Map && event.location != location) {
				continue; // skip this event
			}

			if (event.dependsOn.length > 0) {
				for (eventId in event.dependsOn) {
					if (!this.triggeredEvents.exists(eventId)) {
						continue; // skip this event
					}
				}
			}

			if (event.shouldTrigger(time)) {
				for (fn in listeners) {
					fn(event);
				}
				hasTriggered = true;
			}

			if (hasTriggered)
				events.remove(event); // We can do this because it's a list not an array
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
