#!/bin/bash
as -gstabs -o partition.o partition.s
as -gstabs -o quicksort.o quicksort.s
gcc -g -static -DTEST -o quicksort partition.o quicksort.o quicksort-main.c
for i in {1..25}; do
    echo $i
    ./quicksort
    sleep 0.3s
done
