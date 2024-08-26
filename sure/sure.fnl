
ns sure

# assumes two kind of lists:
# 1) pair:    list(ok:bool error-text:string)
# 2) triplet: list(ok:bool error-text:string value)
#
# Checks that ok is true (by using stddbc.assert)
# if it is then return value is:
# 1) pair
# 2) last item of triplet (value)

ok = func(value)
	import stddbc

	is-ok err = value:
	call(stddbc.assert is-ok err)
	case(len(value)
		3 last(value)
		2 list(true err)
		call(stddbc.assert false plus('unexpected list: ' str(value)))
	)
end

endns

