@echo off
rem Windows Jupyter Notebook run script.

name="test"

rem Run Jupyter Notebook in parent directory.
echo Starting Jupyter Notebook...
set current_dir=%cd%
set parent_dir=%~dp0..
cd %parent_dir%/notebooks
call conda activate "%name%-env"
call jupyter-notebook
call conda deactivate
cd %current_dir%

echo Shutdown
