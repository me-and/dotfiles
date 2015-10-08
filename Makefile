###############################################################################
# Initial setup.
###############################################################################
.SECONDEXPANSION :
SHELL = bash

###############################################################################
# File locations.
###############################################################################
SRC_PREFIX := src/
DEST_PREFIX := output/
INSTALL_PREFIX := $(wildcard ~)/.

###############################################################################
# General project information.
###############################################################################
PROJECTS := bash ctags git gnupg irssi mintty mutt pine startxwin ssh vim

###############################################################################
# Collating file information for all files.
###############################################################################
# Simple files are those that merely need copying from the source directory to
# the target directory.
proj_simple_src_files = $($(1)_simple_src_files)
simple_src_files = $(foreach project,$(PROJECTS),\
			 $(call proj_simple_src_files,$(project)))
simple_dest_files = \
	$(patsubst $(SRC_PREFIX)%,$(DEST_PREFIX)%,$(simple_src_files))
simple_install_files = \
	$(patsubst $(SRC_PREFIX)%,$(INSTALL_PREFIX)%,$(simple_src_files))

dest_files = $(simple_dest_files)
install_files = $(simple_install_files)

###############################################################################
# Definitions for specific projects.
###############################################################################
bash_simple_src_files = $(addprefix $(SRC_PREFIX),\
	bash_completion bash_logout bash_profile bashrc profile)

ctags_simple_src_files = $(SRC_PREFIX)ctags

git_simple_src_files = $(addprefix $(SRC_PREFIX),gitconfig gitignore)

gnupg_simple_src_files = $(SRC_PREFIX)gnupg/gpg.conf

irssi_simple_src_files = \
	$(wildcard $(addprefix \
		$(SRC_PREFIX),irssi/config irssi/*.theme \
			      irssi/scripts/autorun/*.pl))

mintty_simple_src_files = $(SRC_PREFIX)minttyrc

mutt_simple_src_files = $(SRC_PREFIX)muttrc

pine_simple_src_files = $(SRC_PREFIX)pinerc

startxwin_simple_src_files = $(SRC_PREFIX)startxwinrc

ssh_simple_src_files = $(SRC_PREFIX)ssh/config

vim_dirs := $(addprefix vim/,ftdetect ftplugin plugin spell syntax)
vim_simple_src_files = \
	$(wildcard $(addprefix $(SRC_PREFIX), \
			       $(foreach dir,$(vim_dirs),$(dir)/*) vimrc))

###############################################################################
# Phony build targets.
###############################################################################
.PHONY : all install $(PROJECTS) $(addprefix install-,$(PROJECTS)) \
	diff $(addprefix diff-,$(PROJECTS))
all : $(PROJECTS)
$(PROJECTS) : \
	$$(patsubst $(SRC_PREFIX)%,$(DEST_PREFIX)%,$$($$@_simple_src_files))

install : $(addprefix install-,$(PROJECTS))
$(addprefix install-,$(PROJECTS)) : \
		$$(patsubst $(SRC_PREFIX)%,$(INSTALL_PREFIX)%, \
			    $$($$(patsubst install-%,%,$$@)_simple_src_files))

diff : $(addprefix diff-,$(PROJECTS))
$(addprefix diff-,$(PROJECTS)) : \
		$$(patsubst $(SRC_PREFIX)%,$(DEST_PREFIX)%, \
			    $$($$(patsubst diff-%,%,$$@)_simple_src_files))
	@$(foreach file,$($(patsubst diff-%,%,$@)_simple_src_files), \
		diff -u $(patsubst $(SRC_PREFIX)%,$(INSTALL_PREFIX)%,$(file)) \
		        $(patsubst $(SRC_PREFIX)%,$(DEST_PREFIX)%,$(file)) ;)

###############################################################################
# Generic build targets.
###############################################################################
# Creating directories (use sort to remove duplicates):
$(sort $(dir $(dest_files) $(install_files))) :
	mkdir -p $@

# No need to do anything with simple source files!
$(simple_src_files) : ;

# Copying simple source files into their destination location:
$(simple_dest_files) : $$(patsubst $(DEST_PREFIX)%,$(SRC_PREFIX)%,$$@) | \
		$$(dir $$@)
	cp $< $@

# And copying compiled files into their install location:
$(install_files) : $$(patsubst $(INSTALL_PREFIX)%,$(DEST_PREFIX)%,$$@) | \
		$$(dir $$@)
	cp $< $@

# Overwrite the implicit rule search for this Makefile; we never want to
# rebuild that, so don't bother trying.
Makefile : ;
