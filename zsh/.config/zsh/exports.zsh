# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export TMOUT=0

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/bin":$PATH

# PYENV
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# ASDF
export ASDF_DIR="$HOME/asdf"
export ASDF_DATA_DIR=$ASDF_DIR
export PATH="$ASDF_DATA_DIR/shims:$PATH"
export PATH="$ASDF_DIR/bin:$PATH"

# JAVA 21 (used by jdtls / Neovim)
typeset -a _java21_candidates
_java21_candidates=(
  "${JAVA21_HOME:-}"
  "${JDK21_HOME:-}"
  "/usr/lib/jvm/java-21-openjdk-amd64"
  "/usr/lib/jvm/java-1.21.0-openjdk-amd64"
  "/usr/lib/jvm/default-java"
  "$HOME/.sdkman/candidates/java/current"
)

for _java_home in "${_java21_candidates[@]}"; do
  [ -z "$_java_home" ] && continue
  if [ -x "$_java_home/bin/java" ] && "$_java_home/bin/java" -version 2>&1 | grep -q 'version "21'; then
    export JAVA21_HOME="$_java_home"
    break
  fi
done
unset _java_home _java21_candidates
[ -n "${JAVA21_HOME:-}" ] && export JAVA_HOME="$JAVA21_HOME"

eval "$(pyenv init -)"
