#!/bin/bash
# Linux/macOS installation script.
# If `conda` is not already available on the system (e.g. through Anaconda), Miniconda will be automatically downloaded and installed.

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
Welcome to the $display_name installation script.

Press enter to continue, Ctrl+C to quit:
"

echo "Installing conda..."
if which conda >/dev/null; then
  echo "conda already installed"
else
  if [ $(uname) == "Linux" ]; then
    # Linux
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b
    rm Miniconda3-latest-Linux-x86_64.sh
    echo ". ~/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
    source ~/.bashrc
  else
    # macOS
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    bash Miniconda3-latest-MacOSX-x86_64.sh -b
    rm Miniconda3-latest-MacOSX-x86_64.sh
    if [ ! -f ~/.bash_profile ]; then
      # Create .bash_profile if not found.
      touch ~/.bash_profile
    fi
    echo ". ~/miniconda3/etc/profile.d/conda.sh" >> ~/.bash_profile
    source ~/.bash_profile
  fi
fi

echo "Installing conda environment..."
if conda env list | grep "$name-env" >/dev/null; then
  echo "$name-env already installed"
else
  common="_libgcc_mutex=0.1 ca-certificates=2020.1.1 certifi==2020.4.5.1 openssl=1.1.1g python=3.7.7 setuptools=46.4.0 sqlite=3.31.1 tk=8.6.8 wheel=0.34.2 xz=5.2.5 zlib=1.2.11"
  if [ $(uname) == "Linux" ]; then
    # Linux
    conda create -n "$name-env" -y ld_impl_linux-64=2.33.1 libedit=3.1.20181209 libffi=3.3 libgcc-ng=9.1.0 libstdcxx-ng=9.1.0 ncurses=6.2 readline=8.0 $common
  else
    # macOS
    conda create -n "$name-env" -y appnope=0.1.0 libcxx=4.0.1 libcxxabi=4.0.1 libedit=3.1.20181209 libffi=3.3 ncurses=6.2 readline=8.0 $common
  fi
fi

echo "Updating conda environment..."
parent_dir=$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)")
conda env update -f $parent_dir/environment.yml

echo "Installing Jupyter Notebook kernel..."
eval "$(command conda 'shell.bash' 'hook' 2> /dev/null)"
conda activate "$name-env"
if jupyter kernelspec list | grep "python3-$name" >/dev/null; then
  echo "Python 3 [$name-env] already installed"
else
  python -m ipykernel install --user --name "python3-$name" --display-name "Python 3 [$name-env]"
fi
conda deactivate

echo "Done!"
