#! /usr/bin/env bash


git submodule update --init -r
git submodule foreach git checkout main
git submodule foreach git pull
