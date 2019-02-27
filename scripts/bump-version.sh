#!/bin/bash

date +%Y%m%d%H%M%S > version.txt

BRANCH=$(git symbolic-ref --short -q HEAD)
git add "version.txt"
git commit -m "bump version to $(cat version.txt)"