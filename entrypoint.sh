#!/bin/bash

FILE=package.json

if [ -e "$FILE" ]
then
    npm install
fi