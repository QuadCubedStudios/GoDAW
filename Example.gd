extends SongScript

func entry():
	var d = 0.275
	track("TripleOsc", [
		pattern([
			pattern([
				note(d, d, { "key": 62 }),
				note(d, d, { "key": 66 }),
				note(d, d, { "key": 64 }),
				note(d, d, { "key": 66 }),
			], 4),
			pattern([
				note(d, d, { "key": 64 }),
				note(d, d, { "key": 66 }),
				note(d, d, { "key": 64 }),
				note(d, d, { "key": 66 }),
			], 4),
		], 2),
		pattern([
			pattern([
				note(d, d, { "key": 62 }),
				note(d, d, { "key": 66 }),
				note(d, d, { "key": 69 }),
				note(d, d, { "key": 66 }),
			], 4),
			pattern([
				note(d, 2*d, { "key": 64 }),
				note(d, d, { "key": 66 }),
				note(d, d, { "key": 0 }),
				note(d, d, { "key": 66 }),
			], 4),
		], 2),
	])
