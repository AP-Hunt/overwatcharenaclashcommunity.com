#!/bin/bash

date +%Y-%m-%d > version.txt

BRANCH=$(git symbolic-ref --short -q HEAD)
git add version.txt
git commit -m \"bump version to $(cat version.txt)\"
git push origin $BRANCH