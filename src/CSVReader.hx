using StringTools;

// https://gist.github.com/markknol/3971853e2b6f81ea4d4454a8fac17128
class CSVReader {
	private static var format:CSVFormat = {
		del: ",",
		quote: '"',
		escape: '""',
		linedel: "\r\n"
	};

	private var csv:String;

	public function new(csv:String) {
		this.csv = csv;
	}

	/**
	 * @return sheet [row [cell, cell], row [cell, cell] ]
	 */
	public function parseSheet():Array<Array<String>> {
		inline function replaceQuote(v:String)
			return v.replace(format.escape, format.quote);
		return [
			for (line in csv.split(format.linedel)) {
				var ereg = ~/("([^"]*)"|[^,]*)(,|$)/;
				var rows = [];
				while (ereg.match(line)) {
					var cell = ereg.matched(1);
					if (cell.startsWith(format.quote) && cell.endsWith(format.quote)) {
						// unquote
						cell = cell.substr(format.quote.length, cell.length - format.quote.length * 2);
					}
					rows.push(cell);
					line = ereg.matchedRight();
					if (line.length == 0)
						break;
				}

				rows;
			}
		];
	}
}

typedef CSVFormat = {
	del:String,
	// delimiter for columns
	quote:String,
	// quote wrapped around cell
	escape:String,
	// escaped quote in cell
	linedel:String,
	// delimiter for rows
}
