
ns kv-valuez

new-kv-store = proc(db-name colname)
	import stdvar
	import valuez

	store-ref = call(stdvar.new map('open' false))

	open-col = proc(db)
		col-ok col-err colvalue = call(valuez.get-col db colname):
		if(col-ok
			list(col-ok col-err colvalue)
			call(valuez.new-col db colname)
		)
	end

	# method for opening db/collection
	open = proc()
		open-ok open-err db = call(valuez.open db-name argslist():):
		if(open-ok
			call(proc()
				col-ok col-err colvalue = call(open-col db):
				if(col-ok
					call(stdvar.set store-ref map('db' db 'col' colvalue 'open' true))
					'no db available'
				)
				list(col-ok col-err)
			end)
			list(false open-err)
		)
	end

	# method for closing db/collection
	close = proc()
		info = call(stdvar.value store-ref)
		if(get(info 'open')
			call(valuez.close get(info 'db'))
			'already closed'
		)
		call(stdvar.set store-ref map('open' false))
		true
	end

	# write by key (add or update)
	write = proc(key value)
		info = call(stdvar.value store-ref)
		col = get(info 'col')

		upd = proc(txn)
			kv-list = call(valuez.get-values
				txn
				func(kv-item) eq(key head(kv-item)) end
			)
			if( empty(kv-list)
				call(proc()
					ok _ = call(valuez.put-value txn list(key value)):
					ok
				end)

				call(valuez.update
					txn
					func(kv-item)
						if( eq(key head(kv-item))
							list(true list(key value))
							list(false '')
						)
					end
				)
			)
		end

		committed = call(valuez.trans col upd)
		if(committed
			list(true '')
			list(false sprintf('key %v already found' key))
		)
	end

	# remove by key
	remove = proc(key)
		info = call(stdvar.value store-ref)
		col = get(info 'col')
		taken-items = call(valuez.take-values
			col
			func(kv-item) eq(key head(kv-item)) end
		)
		not(empty(taken-items))
	end

	# read key value
	read = proc(key)
		info = call(stdvar.value store-ref)
		col = get(info 'col')
		kv-list = call(valuez.get-values
			col
			func(kv-item) eq(key head(kv-item)) end
		)
		case(len(kv-list)
			0 list(false 'not found' '')
			1 list(true '' last(head(kv-list)))
			list(false 'more than one key found' '')
		)
	end

	# read all key values
	readall = proc()
		info = call(stdvar.value store-ref)
		col = get(info 'col')
		call(valuez.get-values col func() true end)
	end

	# key-value store object
	map(
		'open'    open
		'close'   close

		'write'   write
		'remove'  remove

		'read'    read
		'readall' readall
	)
end

endns

