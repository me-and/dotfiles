.SECONDEXPANSION :

SHELL = bash

SRC_PREFIX := src/
DEST_PREFIX := output/
INSTALL_PREFIX := $(wildcard ~)/.

PROJECTS := bash ctags git gnupg irssi mintty mutt pine startxwin ssh vim

# Simple files are those that merely need copying from the source directory to
# the target directory.
proj_simple_files = $($(1)_simple_files)
simple_files = $(foreach project,$(PROJECTS),\
			 $(call proj_simple_files,$(project)))

bash_simple_files = bash_completion bash_logout bash_profile bashrc profile

ctags_simple_files = ctags

git_simple_files = gitconfig gitignore

gnupg_simple_files = gnupg/gpg.conf

# @@TODO Currently this fails to pick up files using the wildcard if SRC_PREFIX
# is not the current directory.
irssi_simple_files = irssi/config $(wildcard irssi/*.theme) \
	$(wildcard irssi/scripts/autorun/*.pl)

mintty_simple_files = minttyrc

mutt_simple_files = muttrc

pine_simple_files = pinerc

startxwin_simple_files = startxwinrc

ssh_simple_files = ssh/config

# @@TODO Currently this fails to pick up files using the wildcard if SRC_PREFIX
# is not the current directory.
vim_dirs := $(addprefix vim/,ftdetect ftplugin plugin spell syntax)
vim_simple_files = $(foreach dir,$(vim_dirs),$(wildcard $(dir)/*)) vimrc

Makefile : ;
