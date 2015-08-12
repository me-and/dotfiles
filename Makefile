.SECONDEXPANSION :

SHELL = bash

SRC_PREFIX :=
DEST_PREFIX := output/
INSTALL_PREFIX := $(wildcard ~)/.

PROJECTS := BASH CTAGS GIT GNUPG IRSSI MINTTY MUTT PINE STARTXWIN SSH VIM

# Simple files are those that merely need copying from the source directory to
# the target directory.
PROJ_SIMPLE_FILES = $($(1)_SIMPLE_FILES)
SIMPLE_FILES = $(foreach project,$(PROJECTS),\
			 $(call PROJ_SIMPLE_FILES,$(project)))

BASH_SIMPLE_FILES = bash_completion bash_logout bash_profile bashrc profile

CTAGS_SIMPLE_FILES = ctags

GIT_SIMPLE_FILES = gitconfig gitignore

GNUPG_SIMPLE_FILES = gnupg/gpg.conf

# @@TODO Currently this fails to pick up files using the wildcard if SRC_PREFIX
# is not the current directory.
IRSSI_SIMPLE_FILES = irssi/config $(wildcard irssi/*.theme) \
	$(wildcard irssi/scripts/autorun/*.pl)

MINTTY_SIMPLE_FILES = minttyrc

MUTT_SIMPLE_FILES = muttrc

PINE_SIMPLE_FILES = pinerc

STARTXWIN_SIMPLE_FILES = startxwinrc

SSH_SIMPLE_FILES = ssh/config

# @@TODO Currently this fails to pick up files using the wildcard if SRC_PREFIX
# is not the current directory.
VIM_DIRS := $(addprefix vim/,ftdetect ftplugin plugin spell syntax)
VIM_SIMPLE_FILES = $(foreach dir,$(VIM_DIRS),$(wildcard $(dir)/*)) vimrc

Makefile : ;
