## Installation

    # Clone the repository
    git clone git@github.com:mgarriott/vim-files.git ~/.vim

    # Initialize and clone the submodules
    cd ~/.vim
    git submodule init
    git submodule update

    # Create file symlinks
    sh ~/.vim/linkify.sh

_Note that if any of the files listed in linkify.sh already exist they will NOT
be overwritten._
