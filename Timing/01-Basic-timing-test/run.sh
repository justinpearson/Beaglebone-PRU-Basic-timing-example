#!/bin/bash

pasm -b timing-test.p && gcc timing-test.c -o timing-test -lprussdrv && ./timing-test