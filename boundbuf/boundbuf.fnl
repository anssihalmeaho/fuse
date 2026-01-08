
ns boundbuf

new-bounded-buf = proc(size)
	import stddbc
	import stdvar

	buf = call(stdvar.new list())

	push-back = proc()
		items = argslist()
		ok err _ = call(stdvar.change buf func(prev)
			next = extend(prev items)
			l = len(next)
			if(gt(l size)
				slice(next minus(l size))
				next
			)
		end):
		call(stddbc.assert ok err)
		true
	end

	pop-front = proc(how-many)
		ok err _ taken = call(stdvar.change-v2 buf func(prev)
			list(
				slice(prev how-many)
				slice(prev 0 minus(how-many 1))
			)
		end):
		call(stddbc.assert ok err)
		taken
	end

	as-list = proc()
		call(stdvar.value buf)
	end

	map(
		'push-back' push-back
		'pop-front' pop-front
		'as-list'   as-list
	)
end

test = proc()
	import stddbc

	buf = call(new-bounded-buf 6)
	push-back = get(buf 'push-back')
	pop-front = get(buf 'pop-front')
	as-list = get(buf 'as-list')

	has = proc(expected)
		actual = call(as-list)
		err-text = sprintf('as-list: expected: %v, got: %v' expected actual)
		call(stddbc.assert eq(actual expected) err-text)
	end

	pop = proc(n expected)
		got = call(pop-front n)
		err-text = sprintf('pop-front: expected: %v, got: %v' expected got)
		call(stddbc.assert eq(got expected) err-text)
	end

	passed err = tryl(call(proc()
		call(has list())
		call(pop 2 list())

		call(push-back 1 2 3)
		call(has list(1 2 3))
		call(push-back 4 5)
		call(has list(1 2 3 4 5))
		call(pop 2 list(1 2))
		call(has list(3 4 5))
		call(push-back 6)
		call(push-back 7)
		call(has list(3 4 5 6 7))
		call(pop 5 list(3 4 5 6 7))
		call(has list())

		call(push-back 10 20 30)
		call(pop 100 list(10 20 30))
		call(has list())

		call(push-back 1 2 3 4 5 6 7 8)
		call(has list(3 4 5 6 7 8))
		call(push-back 9 10 11)
		call(has list(6 7 8 9 10 11))
		call(pop 100 list(6 7 8 9 10 11))
		call(has list())
	end)):
	if(passed
		'PASSED'
		sprintf('FAILED: \n%v' err)
	)
end

endns

