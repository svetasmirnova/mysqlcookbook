#!/bin/sh
sed -e 's/"/""/g' -e 's/	/","/g' -e 's/^/"/' -e 's/$/"/'
