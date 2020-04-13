# #!/usr/bin/env zsh

# Compatibility layer for zsh

# We're not caring about uniq-ing entries, as we're assuming the following
# command was executed earlier in the shell's history:
#   typeset -gU path
function path_prepend_dirs() {
  # Reverse iterate the array
  # Sources:
  # https://unix.stackexchange.com/questions/27382/how-do-i-reverse-a-for-loop
  # https://github.com/grml/zsh-lovers/blob/master/zsh-lovers.1.txt
  for dir in ${(Oa)argv}; do
    if [ -d "$dir" ]; then
      path=( $dir $path )
    fi
  done
}
function path_append_dirs() {
  for dir in $argv; do
    if [ -d "$dir" ]; then
      path=( $path $dir )
    fi
  done
}
