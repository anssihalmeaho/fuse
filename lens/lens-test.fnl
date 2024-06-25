
ns main

import lens

do-print = false

pr = func(expr)
	if(do-print print(expr) '')
	expr
end

test-get-from = func()
	persons = map(
		'Ben' map(
			'info' map(
				'age'        50
				'profession' 'engineer'
			)
		)
		'Bill' 'whatever'
	)
	and(
		eq(
			call(pr call(lens.get-from list('Ben' 'info' 'age') persons))
			list(true 50)
		)
		eq(
			call(pr call(lens.get-from list('Ben' 'info') persons))
			list(true map('age' 50 'profession' 'engineer'))
		)
		eq(
			call(pr call(lens.get-from list() persons))
			list(true persons)
		)
		eq(
			call(pr call(lens.get-from list('Ben' 'info' 'xxx') persons))
			list(false '')
		)
		eq(
			call(pr call(lens.get-from list('Ben' 'xxx' 'age') persons))
			list(false '')
		)
		eq(
			call(pr call(lens.get-from list('xxx' 'info' 'age') persons))
			list(false '')
		)
		eq(
			call(pr call(lens.get-from list('Ben' 'info' 'age' 'xxx') persons))
			list(false 'target is not a map')
		)
		eq(
			call(pr call(lens.get-from 'not list' persons))
			list(false 'path is not a list')
		)
	)
end

test-set-to-OK-cases = func()
	and(
		eq(
			call(pr call(lens.set-to list('Ben' 'info' 'age') map() 50))
			map('Ben' map('info' map('age' 50)))
		)

		eq(
			call(pr call(lens.set-to list('A') map(1 2) 'Hi'))
			map(1 2 'A' 'Hi')
		)
		eq(
			call(pr call(lens.set-to list('A' 'B') map() 'Hi'))
			map('A' map('B' 'Hi'))
		)
		eq(
			call(pr call(lens.set-to list('A' 'B') map('X' 'yeah') 'Hi'))
			map('X' 'yeah' 'A' map('B' 'Hi'))
		)
		eq(
			call(pr call(lens.set-to list('A' 'B') map('A' 'yeah') 'Hi'))
			map('A' map('B' 'Hi'))
		)
		eq(
			call(pr call(lens.set-to list('A' 'B') map('X' 'yeah' 'A' map(1 2 'B' 3)) 'Hi'))
			map('X' 'yeah' 'A' map(1 2 'B' 'Hi'))
		)
		eq(
			call(pr call(lens.set-to list('A' 'B') map('A' 'yeah') map(10 20)))
			map('A' map('B' map(10 20)))
		)
		eq(
			call(pr call(lens.set-to list('A' 'B') map('A' map('B' map(1 2))) map(10 20)))
			map('A' map('B' map(10 20)))
		)
		eq(
			call(pr call(lens.set-to list('A' 'B' 1) map('A' map('B' map(1 2))) map(10 20)))
			map('A' map('B' map(1 map(10 20))))
		)
		eq(
			call(pr call(lens.set-to list('A' 'B' 9)
			map(
				'A' map(
					'B' map(
						1 2
					)
				)
			) 'ok'))
			map(
				'A' map(
					'B' map(
						9 'ok'
						1 2
					)
				)
			)
		)
		eq(
			call(pr call(lens.set-to list('A' 'B' 9)
			map(
				'A' map(
					'B' 'not map'
					'X' 10
				)
			) 'ok'))
			map(
				'A' map(
					'B' map(
						9 'ok'
					)
					'X' 10
				)
			)
		)
		eq(
			call(pr call(lens.set-to list('A' 'B' 9)
			map(
				'A' 'not map'
			) 'ok'))
			map(
				'A' map(
					'B' map(
						9 'ok'
					)
				)
			)
		)
		eq(
			call(pr call(lens.set-to list('A' 'B' 9)
			map(
				'A' 'not map'
				'X' 10
			) 'ok'))
			map(
				'A' map(
					'B' map(
						9 'ok'
					)
				)
				'X' 10
			)
		)
		eq(
			call(pr call(lens.set-to list('A' 'B')
			map(
				'A' map('B' 1)
				'X' 10
			) 'ok'))
			map(
				'A' map(
					'B' 'ok'
				)
				'X' 10
			)
		)
	)
end

test-set-to-RTE-cases = proc()
	and(
		eq(
			call(pr tryl(call(lens.set-to 'not list' map(1 2) 3)))
			list(false 'path is not a list' '')
		)
		eq(
			call(pr tryl(call(lens.set-to list() map(1 2) 3)))
			list(false 'empty path' '')
		)
		eq(
			call(pr tryl(call(lens.set-to list(10) list(1 2) 3)))
			list(false 'target not a map' '')
		)
	)
end

test-apply-to-RTE-cases = proc()
	f = func() 'whatever' end
	and(
		eq(
			call(pr tryl(call(lens.apply-to 'not list' map(1 2) f)))
			list(false 'path is not a list' '')
		)
		eq(
			call(pr tryl(call(lens.apply-to list() map(1 2) f)))
			list(false 'empty path' '')
		)
		eq(
			call(pr tryl(call(lens.apply-to list(10) list(1 2) f)))
			list(false 'target not a map' '')
		)
	)
end

test-del-from-RTE-cases = proc()
	and(
		eq(
			call(pr tryl(call(lens.del-from 'not list' map(1 2) 3)))
			list(false 'path is not a list' '')
		)
		eq(
			call(pr tryl(call(lens.del-from list() map(1 2) 3)))
			list(false 'empty path' '')
		)
		eq(
			call(pr tryl(call(lens.del-from list(10) list(1 2) 3)))
			list(false 'target not a map' '')
		)
	)
end

test-apply-to-cases= func()
	and(
		eq(
			call(pr call(lens.apply-to list('A') map('A' 1) func(x) plus(x 1) end))
			map('A' 2)
		)
		eq(
			call(pr call(lens.apply-to list('Ben' 'info' 'age') map('Ben' map('info' map('age' 50))) func(x) plus(x 1) end))
			map('Ben' map('info' map('age' 51)))
		)
		eq(
			call(pr call(lens.apply-to list('Bill' 'info' 'age') map('Ben' map('info' map('age' 50))) func(x) plus(x 1) end func() 25 end))
			map(
				'Ben' map('info' map('age' 50))
				'Bill' map('info' map('age' 25))
			)
		)
		eq(
			call(pr call(lens.apply-to list('Bill' 'info') map('Ben' map('info' map('age' 50))) func(x) plus(x 1) end))
			map(
				'Ben' map('info' map('age' 50))
				'Bill' map('info' map())
			)
		)
		eq(
			call(pr call(lens.apply-to list('Ben' 'rubbish' 'age') map('Ben' map('info' map('age' 50))) func(x) plus(x 1) end))
			map('Ben' map('info' map('age' 50) 'rubbish' map('age' map())))
		)
		eq(
			call(pr call(lens.apply-to list('Ben' 'info' 'age') map('X' 1 'Ben' map('Y' 2 'info' map('Z' 3 'age' 50))) func(x) plus(x 1) end))
			map('X' 1 'Ben' map('Y' 2 'info' map('Z' 3 'age' 51)))
		)
	)
end

test-del-from-cases = func()
	and(
		eq(
			call(pr
				call(lens.del-from
					list('Ben' 'info' 'age')
					map('X' 1 'Ben' map('Y' 2 'info' map('Z' 3 'age' 51)))
				)
			)
			list(true map('X' 1 'Ben' map('Y' 2 'info' map('Z' 3))))
		)
		eq(
			call(pr
				call(lens.del-from
					list('Ben' 'rubbish' 'age')
					map('X' 1 'Ben' map('Y' 2 'info' map('Z' 3 'age' 51)))
				)
			)
			list(false map('X' 1 'Ben' map('Y' 2 'info' map('Z' 3 'age' 51))))
		)
		eq(
			call(pr
				call(lens.del-from
					list('Ben' 'info' 'age' 'nope')
					map('X' 1 'Ben' map('Y' 2 'info' map('Z' 3 'age' 51)))
				)
			)
			list(false map('X' 1 'Ben' map('Y' 2 'info' map('Z' 3 'age' 51))))
		)
		eq(
			call(pr
				call(lens.del-from
					list('Ben' 'info')
					map('X' 1 'Ben' map('Y' 2 'info' map('Z' 3 'age' 51)))
				)
			)
			list(true map('X' 1 'Ben' map('Y' 2)))
		)
	)
end

main = proc()
	if(
		and(
			call(test-get-from)
			call(test-set-to-OK-cases)
			call(test-set-to-RTE-cases)
			call(test-apply-to-cases)
			call(test-apply-to-RTE-cases)
			call(test-del-from-cases)
			call(test-del-from-RTE-cases)
		)
		'PASSED'
		'FAILED'
	)
end

endns

