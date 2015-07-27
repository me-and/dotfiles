SHELL = bash

DESTDIR :=  $(wildcard ~)

VIMDIRS := $(addprefix vim/, ftdetect ftplugin plugin spell syntax)
VIMFILES := $(foreach dir,$(VIMDIRS),$(wildcard $(dir)/*)) vimrc

BASHFILES := bash_logout bash_completion bash_profile bashrc profile

IRSSIDIRS := irssi irssi/scripts/autorun
IRSSIFILES := irssi/config $(wildcard irssi/*.theme) \
	      $(wildcard irssi/scripts/autorun/*)

GITFILES := gitconfig gitignore

ALLDIRS := $(VIMDIRS) gnupg ssh $(IRSSIDIRS)
ALLFILES := $(VIMFILES) startxwinrc ctags minttyrc $(BASHFILES) ssh/config \
	    $(IRSSIFILES) muttrc $(GITFILES) gnupg/gpg.conf pinerc

# Check we're not about to try to do stuff in the root directory unless we've
# been explicitly told to do so.  Doing it silently seems like a recipe for
# deleting things I really don't want to delete.
ifeq (, $(DESTDIR))
$(error DESTDIR should not be empty)
endif

.PHONY : all install
all :
install : all

ifneq (, $(shell type -fp vim))
ifneq (, $(shell vim --version | grep 'Vi IMproved 7\.[34]'))
install : install-vim
else
$(warning Vim is installed, but I haven't seen this version before.)
$(warning Not installing the Vim configuration files.)
$(warning You can install them at your own risk with `make install-vim`.)
endif
endif

ifneq (, $(shell type -fp startxwin))
install : install-startxwin
endif

ifneq (, $(shell type -fp ctags))
ifneq (, $(shell ctags --help | grep -e --recurse))
install : install-ctags
else
$(warning Ctags is installed, but does not support recursion.)
$(warning Not installing the Ctags configuration files.)
endif
endif

ifneq (, $(shell type -fp mintty))
install : install-mintty
endif

ifneq (, $(shell type -fp bash))
ifneq (, $(shell bash --version | grep -F 'version 4.'))
install : install-bash
else
$(warning Bash is installed but I haven't seen this version before.)
$(warning Not installing the Bash configuration files.)
$(warning You can install them at your own risk with `make install-bash`.)
endif
endif

ifneq (, $(shell type -fp ssh))
install : install-ssh
endif

ifneq (, $(shell type -fp irssi))
install : install-irssi
endif

ifneq (, $(shell type -fp mutt))
install : install-mutt
endif

ifneq (, $(shell type -fp git))
ifneq (, $(shell git --version | grep -F 'git version 2.'))
install : install-git
else
$(warning Git is installed but this version is either one I haven't seen \
	  before, or one that's just plain too old.)
$(warning Not installing the Git configuration files.)
$(warning You can install them at your own risk with `make install-git`.)
endif
endif

ifneq (, $(shell type -fp gpg))
install : install-gpg
endif

ifneq (, $(shell type -fp pine))
install : install-pine
endif

.PHONY : install-vim install-startxwin install-ctags install-mintty \
	 install-bash install-ssh install-irssi install-mutt install-git \
	 install-gpg install-pine
install-vim : $(addprefix $(DESTDIR)/.,$(VIMFILES))
install-startxwin : $(DESTDIR)/.startxwinrc
install-ctags : $(DESTDIR)/.ctags
install-mintty : $(DESTDIR)/.minttyrc
install-bash : $(addprefix $(DESTDIR)/.,$(BASHFILES))
install-ssh : $(DESTDIR)/.ssh/config
install-irssi : $(DESTDIR)/.irssi
install-mutt : $(DESTDIR)/.muttrc
install-git : $(addprefix $(DESTDIR)/.,$(GITFILES))
install-gpg : $(DESTDIR)/.gnupg/gpg.conf
install-pine : $(DESTDIR)/.pinerc

$(addprefix $(DESTDIR)/.,$(ALLDIRS)) :
	mkdir -p $@

.SECONDEXPANSION :
$(addprefix $(DESTDIR)/.,$(ALLFILES)) : \
		$$(patsubst $(DESTDIR)/.%,%,$$@) | $$(@D)
	cp $< $@
