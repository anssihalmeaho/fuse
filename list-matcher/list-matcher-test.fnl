
ns main

test-list-matcher = func()
	import list-matcher
	import stdfu

	pattern = list(200 '*' 'Hi' func(x) eq(len(x) 2) end '...')

	check-is-match = func(input-list)
		call(list-matcher.match pattern input-list)
	end

	check-is-not-match = func(input-list)
		not(call(list-matcher.match pattern input-list))
	end

	matching-lists = list(
		list(200 'whatever' 'Hi' list(1 2) map(1 2))
		list(200 map() 'Hi' list('a' 'b') 1 2 3)
		list(200 false plus('H' 'i') list('a' 'b') chan())
		list(200 false plus('H' 'i') list('a' 'b'))
	)
	non-matching-lists = list(
		list(201 'whatever' 'Hi' list(1 2) map(1 2))
		list(200 map() 'zzz' list('a' 'b') 1 2 3)
	)

	test-sub-matcher = func()
		sub-pattern = list('inner' '*' '...')
		pat = list('A' func(x) call(list-matcher.match sub-pattern x) end '...')
		and(
			# match
			call(list-matcher.match pat list('A' list('inner' map() 123) 'B'))

			# no match
			not(call(list-matcher.match pat list('A' list('wrong' map() 123) 'B')))
			not(call(list-matcher.match pat list('X' list('inner' map() 123) 'B')))
		)
	end

	test-set-of-options = func()
		pat = list(func(x) in(list('green' 'red' 'blue') x) end 'is' 'color')
		and(
			call(list-matcher.match pat list('red' 'is' 'color')) # match
			call(list-matcher.match pat list('blue' 'is' 'color')) # match
			not(call(list-matcher.match pat list('car' 'is' 'color'))) # no match
		)
	end

	test-match-rest-of-the-list = func()
		pat = list('A' '...')
		and(
			call(list-matcher.match list('...') list())
			call(list-matcher.match pat list('A'))
			call(list-matcher.match pat list('A' 'B'))
			call(list-matcher.match pat list('A' 'B' map()))
		)
	end

	test-invalid-types = func()
		and(
			not(call(list-matcher.match 'not a list' list(1 2)))
			not(call(list-matcher.match list(1 2) 'not a list'))
		)
	end

	if(
		and(
			call(stdfu.apply matching-lists check-is-match):
			call(stdfu.apply non-matching-lists check-is-not-match):
			call(test-sub-matcher)
			call(test-set-of-options)
			call(test-match-rest-of-the-list)
			call(test-invalid-types)
		)
		'PASSED'
		'FAILED'
	)
end

main = func()
	call(test-list-matcher)
end

endns

