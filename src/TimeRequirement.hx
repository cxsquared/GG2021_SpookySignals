class TimeRequirement {
	public var time:Int;
	public var modifier:TimeModifier;

	public function new(time:Int, modifier:TimeModifier) {
		this.time = time;
		this.modifier = modifier;
	}

	public function shouldTrigger(currentTime:Int):Bool {
		switch (modifier) {
			case LE:
				return currentTime <= time;
			case GE:
				return currentTime >= time;
			case EE:
				return currentTime == time;
		}

		return false;
	}

	// Can this event ever trigger?
	public function shouldRemove(currentTime:Int):Bool {
		if (modifier == GE)
			return false;

		if (currentTime > time)
			return true;

		return false;
	}
}

enum TimeModifier {
	LE;
	EE;
	GE;
}
