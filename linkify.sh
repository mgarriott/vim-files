DIR="$( cd "$( dirname "$0" )" && pwd )" 

# Link rc files to home directory
ln -s $DIR/vimrc $HOME/.vimrc
ln -s $DIR/gvimrc $HOME/.gvimrc

# Internal vim links
ln -s $DIR/pathogen/autoload/pathogen.vim $DIR/autoload/
