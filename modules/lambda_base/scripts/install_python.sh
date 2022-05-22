#!/bin/bash

echo "Start executing install_python.sh file..."

echo $path_module
echo $path_cwd

cd $function_name

mkdir build

cp $function_name.py build/$function_name.py

# Installing python dependencies...
FILE=Pipfile

if [ -f "$FILE" ]; then
  echo "Start installing python dependencies..."
  
  pipenv install

  pipenv lock -r | sed 's/-e //g' | pipenv run pip install --upgrade -r /dev/stdin --target build  

  cd build
  
  rm -f -r *.dist-info
else
  echo "Failed: Pipfile does not exist!"
fi