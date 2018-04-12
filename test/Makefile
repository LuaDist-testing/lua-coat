
export LUA_PATH=;;../src/?.lua

test: lunity.lua
	@lua harness

lunity.lua:
#	perl -MLWP::Simple -e "getstore(q{http://phrogz.net/lua/lunity.lua}, q{lunity.lua});"
	wget http://phrogz.net/lua/lunity.lua

