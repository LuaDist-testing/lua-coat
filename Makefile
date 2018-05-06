
LUA     := lua
VERSION := $(shell cd src && $(LUA) -e "require [[Coat]]; print(Coat._VERSION)")
TARBALL := lua-coat-$(VERSION).tar.gz
ifndef REV
  REV   := 1
endif

ifndef DESTDIR
  DESTDIR := /usr/local
endif
BINDIR  := $(DESTDIR)/bin
LIBDIR  := $(DESTDIR)/share/lua/5.1

install:
	mkdir -p $(BINDIR)
	cp src/coat2dot                 $(BINDIR)
	mkdir -p $(LIBDIR)/Coat/Meta
	cp src/Coat.lua                 $(LIBDIR)
	cp src/Coat/Role.lua            $(LIBDIR)/Coat
	cp src/Coat/Types.lua           $(LIBDIR)/Coat
	cp src/Coat/UML.lua             $(LIBDIR)/Coat
	cp src/Coat/file.lua            $(LIBDIR)/Coat
	cp src/Coat/Meta/Class.lua      $(LIBDIR)/Coat/Meta
	cp src/Coat/Meta/Role.lua       $(LIBDIR)/Coat/Meta

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

CHANGES:
	perl -i.bak -pe "s{^$(VERSION).*}{q{$(VERSION)  }.localtime()}e" CHANGES

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

install-rock: clean dist rockspec
	perl -pe 's{http://cloud.github.com/downloads/fperrad/lua-Coat/}{};' \
	    rockspec/lua-coat-$(VERSION)-$(REV).rockspec > lua-coat-$(VERSION)-$(REV).rockspec
	luarocks install lua-coat-$(VERSION)-$(REV).rockspec

ifdef LUA_PATH
  export LUA_PATH:=$(LUA_PATH);../test/?.lua
else
  export LUA_PATH=;;../test/?.lua
endif
#export GEN_PNG=1

check: test

test:
	cd src && prove --exec=$(LUA) ../test/*.t

coverage:
	rm -f src/luacov.stats.out src/luacov.report.out
	cd src && prove --exec="$(LUA) -lluacov" ../test/*.t
	cd src && luacov

html:
	xmllint --noout --valid doc/*.html

clean:
	rm -f MANIFEST *.bak src/*.png test/*.png *.rockspec

.PHONY: test rockspec CHANGES

