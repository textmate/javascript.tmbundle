# Runs the current file in Node and displays output in an HTML window.
# 
# Decides on a particular version of Node based on the first of these
# strategies to succeed:
# 
# 1. If $TM_NODE is set and non-empty, use it.
# 2. If NVM is installed and there's an .nvmrc in the project root (if in a
#    project) or current file's directory (if not in a project), use that
#    version.
# 3. If NVM is installed and the user has a 'default' alias, use that
#    version.
# 4. If NVM is installed, use the 'system' version.
# 5. If NVM is not installed, use whatever version of node exists in $PATH.

if [[ -d "$TM_PROJECT_DIRECTORY" ]]; then
  working_dir=$TM_PROJECT_DIRECTORY
elif [[ -d "$TM_FILEPATH" ]]; then
  working_dir=$(dirname $TM_FILEPATH)
else
  working_dir=$HOME
fi

cd "$working_dir"

using_nvm=0
if [ -z "$TM_NODE" ]; then
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    using_nvm=1
    source "$NVM_DIR/nvm.sh"
    # We should respect any .nvmrc that may exist. If it doesn't exist, fall
    # back to a 'default' alias. If that doesn't exist, use the system node.
    nvm use --silent 2>/dev/null ||\
      nvm use --silent default 2>/dev/null ||\
      nvm use --silent system 2>/dev/null
  fi
fi

"$TM_BUNDLE_SUPPORT/run_script.rb" "$using_nvm"
