#!/bin/sh -e
cd ..

for file in `ls .dot_files/`; do
  if [[ $file != "install.sh" ]]; then
    ln -s .dot_files/$file .$file
  fi
done
