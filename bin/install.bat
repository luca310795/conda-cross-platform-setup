@echo off
rem Windows installation script.
rem If `conda` is not already available on the system (e.g. through Anaconda), Miniconda will be automatically downloaded and installed.

set name=test
set display_name=Fancy Name

echo Welcome to the %display_name% installation script.
echo.
echo Press enter to continue, Ctrl+C to quit:
pause>nul

echo Installing conda...
where conda >nul && (
  echo conda already installed
) || (
  bitsadmin /transfer Miniconda3 https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe %~dp0Miniconda3-latest-Windows-x86_64.exe
  %~dp0Miniconda3-latest-Windows-x86_64.exe /S /AddToPath=1
  del %~dp0Miniconda3-latest-Windows-x86_64.exe
  set PATH=%PATH%;%HOMEDRIVE%%HOMEPATH%\miniconda3\condabin\
)

echo Installing conda environment...
conda env list | findstr "%name%-env" >nul && (
  echo %name%-env already installed
) || (
  call conda create -n %name%-env -y _libgcc_mutex=0.1 ca-certificates=2020.1.1 certifi=2020.4.5.1 colorama=0.4.3 m2w64-gcc-libgfortran=5.3.0 m2w64-gcc-libs=5.3.0 m2w64-gcc-libs-core=5.3.0 m2w64-gmp=6.1.0 m2w64-libwinpthread-git=5.0.0.4634.697f757 msys2-conda-epoch=20160418 openssl=1.1.1g python=3.7.7 pywin32=227 pywinpty=0.5.7 setuptools=46.4.0 sqlite=3.31.1 tk=8.6.8 vc=14.1 vs2015_runtime=14.16.27012 wheel=0.34.2 wincertstore=0.2 xz=5.2.5 zlib=1.2.11
)

echo Updating conda environment...
set parent_dir=%~dp0..
call conda env update -f %parent_dir%\environment.yml

echo Installing Jupyter Notebook kernel...
call conda activate "%name%-env"
jupyter kernelspec list | findstr "python3-%name%" >nul && (
  echo Python 3 [%name%-env] already installed
) || (
  call python -m ipykernel install --user --name "python3-%name%" --display-name "Python 3 [%name%-env]"
)
call conda deactivate

echo Done!
