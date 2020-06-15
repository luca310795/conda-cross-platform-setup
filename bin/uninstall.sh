#!/bin/bash
# Linux/macOS uninstallation script.
# Note: `conda` will not be removed.

# Exit on first error.
set -e

# Killable by SIGINT.
trap "exit" INT

name="test"
display_name="Fancy Name"

if [ $(uname) == "Linux" ]; then
  # Linux
  source ~/.bashrc
else
  # macOS
  if [ -f ~/.bash_profile ]; then
    # Source .bash_profile if found.
    source ~/.bash_profile
  fi
fi
export PATH=~/miniconda3/condabin:$PATH

read -p \
"
Welcome to the $display_name uninstallation script.

Press enter to continue, Ctrl+C to quit:
"

echo "Uninstalling Jupyter Notebook kernel..."
eval "$(command conda 'shell.bash' 'hook' 2> /dev/null)"
conda activate "$name-env"
jupyter kernelspec uninstall -f "python3-$name"
conda deactivate

echo "Uninstalling conda environment..."
conda env remove -n "$name-env" -y

echo "Done!"
