
ns lens

# TODO maybe:
#  - applying same for lists (by index)
#  - support for dot-separated strings

del-from = func(path target)
	del-value = func(next-path prev-target)
		if(eq(len(next-path) 1)
			call(func()
				next-key = head(next-path)
				if( not(eq(type(prev-target) 'map'))
					list(false prev-target)
					dell(prev-target next-key)
				)
			end)

			call(func()
				next-key = head(next-path)
				if( eq(type(prev-target) 'map')
					call(func()
						found next-target = getl(prev-target next-key):
						if(found
							call(func()
								next-found new-target = call(del-value rest(next-path) next-target):
								if(next-found
									list(
										true
										put(
											del(prev-target next-key)
											next-key
											new-target
										)
									)
									list(false target)
								)
							end)
							list(false target)
						)
					end)
					list(false target)
				)
			end)
		)
	end

	cond(
		not(eq(type(path) 'list'))
		error('path is not a list')

		empty(path)
		error('empty path')

		not(eq(type(target) 'map'))
		error('target not a map')

		call(del-value path target)
	)
end

apply-to = func()
	args = argslist()
	path target f = args:
	init-f = if(eq(len(args) 4)
		last(args)
		func() map() end
	)

	apply = func(next-path prev-target)
		if(eq(len(next-path) 1)
			call(func()
				next-key = head(next-path)
				if( not(eq(type(prev-target) 'map'))
					map(head(next-path) map())

					call(func()
						found old-value = getl(prev-target next-key):
						if(found
							put(del(prev-target next-key) next-key call(f old-value))
							put(prev-target next-key call(init-f))
						)
					end)
				)
			end)

			call(func()
				next-key = head(next-path)
				ptarget = if( eq(type(prev-target) 'map')
					prev-target
					map()
				)
				found next-target = getl(ptarget next-key):
				new-target = if(found next-target map())
				next-map = call(apply rest(next-path) new-target)
				if(found
					put(del(ptarget next-key) next-key next-map)
					put(ptarget next-key next-map)
				)
			end)
		)
	end

	cond(
		not(eq(type(path) 'list'))
		error('path is not a list')

		empty(path)
		error('empty path')

		not(eq(type(target) 'map'))
		error('target not a map')

		call(apply path target)
	)
end

set-to = func(path target value)
	set-value = func(next-path prev-target)
		if(eq(len(next-path) 1)
			call(func()
				next-key = head(next-path)
				if( not(eq(type(prev-target) 'map'))
					map(head(next-path) value)
					if(in(prev-target next-key)
						put(del(prev-target next-key) next-key value)
						put(prev-target next-key value)
					)
				)
			end)

			call(func()
				next-key = head(next-path)
				ptarget = if( eq(type(prev-target) 'map')
					prev-target
					map()
				)
				found next-target = getl(ptarget next-key):
				new-target = if(found next-target map())
				next-map = call(set-value rest(next-path) new-target)
				if(found
					put(del(ptarget next-key) next-key next-map)
					put(ptarget next-key next-map)
				)
			end)
		)
	end

	cond(
		not(eq(type(path) 'list'))
		error('path is not a list')

		empty(path)
		error('empty path')

		not(eq(type(target) 'map'))
		error('target not a map')

		call(set-value path target)
	)
end

get-from = func(path target)
	find-value = func(next-path next-target)
		cond(
			empty(next-path)
			list(true next-target)

			not(eq(type(next-target) 'map'))
			list(false 'target is not a map')

			call(func()
				next-key = head(next-path)
				found val = getl(next-target next-key):
				if(found
					call(find-value rest(next-path) val)
					list(false '')
				)
			end)
		)
	end

	cond(
		not(eq(type(path) 'list'))
		list(false 'path is not a list')

		call(find-value path target)
	)
end

endns

