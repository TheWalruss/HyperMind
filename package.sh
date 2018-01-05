#!/bin/bash 

cp HyperMind.love HyperMind.backup
mv HyperMind.love HyperMind.zip

zip -ruv HyperMind.zip */*.lua
zip -ruv HyperMind.zip *.lua

mv HyperMind.zip HyperMind.love

