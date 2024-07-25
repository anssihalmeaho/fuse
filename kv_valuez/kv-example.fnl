
ns main

import kv-valuez

kvs = call(kv-valuez.new-kv-store 'some-db' 'some-collection')
db = call(get(kvs 'open'))
#NOTE: options map can be given also: db = call(get(kvs 'open') map('in-mem' true))

write = get(kvs 'write')
read = get(kvs 'read')
remove = get(kvs 'remove')
readall = get(kvs 'readall')

read-key = proc(key)
	print('read: ' key ': ' call(read key))
end

del-key = proc(key)
	print('remove: ' key ': ' call(remove key))
end

main = proc()
	print('write key-values: ' list(
		call(write 'Key-A' 1)
		call(write 'Key-B' 2)
	))
	call(read-key 'Key-A')
	call(read-key 'No key') # not found
	call(read-key 'Key-B')
	print('readall: ' call(readall))

	print('update values: ' list(
		call(write 'Key-A' 10)
		call(write 'Key-B' 20)
	))

	call(read-key 'Key-A')
	call(read-key 'Key-B')
	print('readall: ' call(readall))

	call(del-key 'No key') # not found
	call(del-key 'Key-B') # remove ok
	call(del-key 'Key-B') # not found anymore

	call(read-key 'Key-A')
	call(read-key 'Key-B')
	print('readall: ' call(readall))

	call(get(kvs 'close'))
end

endns

