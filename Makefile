
LUA     := lua
VERSION := $(shell cd src && $(LUA) -e "require [[Coat]]; print(Coat._VERSION)")
TARBALL := lua-coat-$(VERSION).tar.gz
ifndef REV
  REV   := 1
endif

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

export LUA_PATH=;;./src/?.lua;./test/?.lua
#export GEN_PNG=1

test:
	prove --exec=$(LUA) test/*.t

html:
	xmllint --noout --valid doc/*.html

clean:
	rm -f MANIFEST *.bak *.png test/*.png

.PHONY: test rockspec CHANGES

