#!/bin/bash
# Linux/macOS Jupyter Notebook run script.

# Exit on first error.
set -e

# Killable by SIGINT.
trap "exit" INT

name="test"

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

# Run Jupyter Notebook in parent directory.
echo "Starting Jupyter Notebook..."
parent_dir=$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)")
cd $parent_dir/notebooks
eval "$(command conda 'shell.bash' 'hook' 2> /dev/null)"
conda activate "$name-env"
jupyter-notebook
conda deactivate

echo "Shutdown"
