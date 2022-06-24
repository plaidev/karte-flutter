#!/bin/bash

flutter pub global list | grep melos
if [ $? = 1 ]; then
  echo 'melos is not installed.'
  echo 'You can run this command and fix the problem: `flutter pub global activate melos`'
  exit 1
fi

flutter pub global run melos bootstrap
