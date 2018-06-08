
LUA     := lua
VERSION := $(shell cd src && $(LUA) -e "m = require [[Coat]]; print(m._VERSION)")
TARBALL := lua-coat-$(VERSION).tar.gz
REV     := 1

LUAVER  := 5.3
PREFIX  := /usr/local
DPREFIX := $(DESTDIR)$(PREFIX)
BINDIR  := $(DPREFIX)/bin
LIBDIR  := $(DPREFIX)/share/lua/$(LUAVER)
INSTALL := install

all:
	@echo "Nothing to build here, you can just make install"

install:
	$(INSTALL) -m 755 -D src/coat2dot                       $(BINDIR)/coat2dot
	$(INSTALL) -m 644 -D src/Coat.lua                       $(LIBDIR)/Coat.lua
	$(INSTALL) -m 644 -D src/Coat/Role.lua                  $(LIBDIR)/Coat/Role.lua
	$(INSTALL) -m 644 -D src/Coat/Types.lua                 $(LIBDIR)/Coat/Types.lua
	$(INSTALL) -m 644 -D src/Coat/UML.lua                   $(LIBDIR)/Coat/UML.lua
	$(INSTALL) -m 644 -D src/Coat/file.lua                  $(LIBDIR)/Coat/file.lua
	$(INSTALL) -m 644 -D src/Coat/Meta/Class.lua            $(LIBDIR)/Coat/Meta/Class.lua
	$(INSTALL) -m 644 -D src/Coat/Meta/Role.lua             $(LIBDIR)/Coat/Meta/Role.lua

uninstall:
	rm -f $(BINDIR)/coat2dot
	rm -f $(LIBDIR)/Coat.lua
	rm -f $(LIBDIR)/Coat/Role.lua
	rm -f $(LIBDIR)/Coat/Types.lua
	rm -f $(LIBDIR)/Coat/UML.lua
	rm -f $(LIBDIR)/Coat/file.lua
	rm -f $(LIBDIR)/Coat/Meta/Class.lua
	rm -f $(LIBDIR)/Coat/Meta/Role.lua

manifest_pl := \
use strict; \
use warnings; \
my @files = qw{MANIFEST}; \
while (<>) { \
    chomp; \
    next if m{^\.}; \
    next if m{^debian/}; \
    next if m{^rockspec/}; \
    push @files, $$_; \
} \
print join qq{\n}, sort @files;

rockspec_pl := \
use strict; \
use warnings; \
use Digest::MD5; \
open my $$FH, q{<}, q{$(TARBALL)} \
    or die qq{Cannot open $(TARBALL) ($$!)}; \
binmode $$FH; \
my %config = ( \
    version => q{$(VERSION)}, \
    rev     => q{$(REV)}, \
    md5     => Digest::MD5->new->addfile($$FH)->hexdigest(), \
); \
close $$FH; \
while (<>) { \
    s{@(\w+)@}{$$config{$$1}}g; \
    print; \
}

version:
	@echo $(VERSION)

CHANGES: dist.info
	perl -i.bak -pe "s{^$(VERSION).*}{q{$(VERSION)  }.localtime()}e" CHANGES

dist.info:
	perl -i.bak -pe "s{^version.*}{version = \"$(VERSION)\"}" dist.info

tag:
	git tag -a -m 'tag release $(VERSION)' $(VERSION)

MANIFEST:
	git ls-files | perl -e '$(manifest_pl)' > MANIFEST

$(TARBALL): MANIFEST
	[ -d lua-Coat-$(VERSION) ] || ln -s . lua-Coat-$(VERSION)
	perl -ne 'print qq{lua-Coat-$(VERSION)/$$_};' MANIFEST | \
	    tar -zc -T - -f $(TARBALL)
	rm lua-Coat-$(VERSION)

dist: $(TARBALL)

rockspec: $(TARBALL)
	perl -e '$(rockspec_pl)' rockspec.in > rockspec/lua-coat-$(VERSION)-$(REV).rockspec

rock:
	luarocks pack rockspec/lua-coat-$(VERSION)-$(REV).rockspec

deb:
	echo "lua-coat ($(shell git describe --dirty)) unstable; urgency=medium" >  debian/changelog
	echo ""                         >> debian/changelog
	echo "  * UNRELEASED"           >> debian/changelog
	echo ""                         >> debian/changelog
	echo " -- $(shell git config --get user.name) <$(shell git config --get user.email)>  $(shell date -R)" >> debian/changelog
	fakeroot debian/rules clean binary

ifdef LUA_PATH
  export LUA_PATH:=$(LUA_PATH);../test/?.lua
else
  export LUA_PATH=;;../test/?.lua
endif
#export GEN_PNG=1

check: test

test:
	cd src && prove --exec=$(LUA) ../test/*.t

luacheck:
	luacheck --std=max --codes src --ignore 211/_ENV 212/t 421/v 423/i 631
	luacheck --std=min --config .test.luacheckrc test/*.t

coverage:
	rm -f src/luacov.stats.out src/luacov.report.out
	cd src && prove --exec="$(LUA) -lluacov" ../test/*.t
	cd src && luacov

coveralls:
	rm -f src/luacov.stats.out src/luacov.report.out
	cd src && prove --exec="$(LUA) -lluacov" ../test/*.t
	cd src && luacov-coveralls -e /HERE/ -e test/ -e %.t$

README.html: README.md
	Markdown.pl README.md > README.html

gh-pages:
	mkdocs gh-deploy --clean

clean:
	rm -f MANIFEST *.bak src/luacov.*.out src/*.png test/*.png *.rockspec README.html

realclean: clean

.PHONY: test rockspec deb CHANGES dist.info

