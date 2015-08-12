.SECONDEXPANSION :

SHELL = bash

SRC_PREFIX := src/
DEST_PREFIX := output/
INSTALL_PREFIX := $(wildcard ~)/.

PROJECTS := bash ctags git gnupg irssi mintty mutt pine startxwin ssh vim

# Simple files are those that merely need copying from the source directory to
# the target directory.
proj_simple_src_files = $($(1)_simple_src_files)
simple_src_files = $(foreach project,$(PROJECTS),\
			 $(call proj_simple_src_files,$(project)))

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

Makefile : ;
