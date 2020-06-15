@echo off
rem Windows uninstallation script.
rem Note: `conda` will not be removed.

set name=test
set display_name=Fancy Name

echo Welcome to the %display_name% uninstallation script.
echo.
echo Press enter to continue, Ctrl+C to quit:
pause>nul

echo Uninstalling Jupyter Notebook kernel...
call conda activate "%name%-env"
call jupyter kernelspec uninstall -f "python3-%name%"
call conda deactivate

echo Uninstalling conda environment...
call conda env remove -n "%name%-env" -y

echo Done!
