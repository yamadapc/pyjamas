default: source/pyjamas.d
	dub

test: tests/pyjamas_test.d source/pyjamas.d
	dub --config=test
