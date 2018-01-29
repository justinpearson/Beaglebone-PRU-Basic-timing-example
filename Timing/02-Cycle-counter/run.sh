#!/bin/bash

name=reset-cycle-counter
pasm -b $name.p && gcc $name.c -o $name -lprussdrv && ./$name
