
ns list-matcher

match = func(pattern source)
	loopy = func(pat src)
		cond(
			and(empty(pat) empty(src))
			true

			empty(pat)
			false

			empty(src)
			eq(head(pat) '...')

			call(func()
				next-p = head(pat)
				next-s = head(src)
				cond(
					eq(type(next-p) 'function')
					if(call(next-p next-s)
						call(loopy rest(pat) rest(src))
						false
					)

					eq(next-p '...')
					true

					eq(next-p '*')
					call(loopy rest(pat) rest(src))

					if(eq(next-p next-s)
						call(loopy rest(pat) rest(src))
						false
					)
				)
			end)
		)
	end

	cond(
		not(eq(type(pattern) 'list')) false
		not(eq(type(source) 'list')) false
		call(loopy pattern source)
	)
end

endns

