extends SongScript

func entry():
	var d = 0.275
	track("TripleOsc", [
		pattern(0, 2, [
			pattern(0, 4, [
				note(d, d, { "key": 62 }),
				note(d, d, { "key": 66 }),
				note(d, d, { "key": 64 }),
				note(d, d, { "key": 66 }),
			]),
			pattern(0, 4, [
				note(d, d, { "key": 64 }),
				note(d, d, { "key": 66 }),
				note(d, d, { "key": 64 }),
				note(d, d, { "key": 66 }),
			]),
		]),
		pattern(0, 2, [
			pattern(0, 4, [
				note(d, d, { "key": 62 }),
				note(d, d, { "key": 66 }),
				note(d, d, { "key": 69 }),
				note(d, d, { "key": 66 }),
			]),
			pattern(0, 4, [
				note(d, 2*d, { "key": 64 }),
				note(d, d, { "key": 66 }),
				note(d, d, { "key": 0 }),
				note(d, d, { "key": 66 }),
			]),
		]),
	])
