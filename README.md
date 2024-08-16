# Global Dirs Cache plugin
This plugin provides you to cache the list of used directories and navigate between them like commands `dirs` and `cd -<number>` but it doesn't depend to one terminal session and this cache is shared between all zsh sessions with this plugin.
## Commands
- `dirs-global -n` prints the previous working directory
- `dirs-global -n <number>` prints the directory with number **<number>**
- `dirs-global -c` cd to the previous working directory
- `dirs-global -c <number>` cd to the directory with number **<number>**
- `dirs-global -a` shows all cached directories with less command
- `dirs-global` shows the short list of directories which size is `$GDC_SHORT_DIRS`
## Path variables
- `$GDC_MAX_DIRS` is the number of maximum directories to cache
- `$GDC_SHORT_DIRS` is the number of directories to show in short output
