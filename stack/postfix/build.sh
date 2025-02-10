#!/bin/sh
mkdir -p bin
as --64 -g -o ./bin/rpn.o ./rpn.s && ld -m elf_x86_64 ./bin/rpn.o -o ./bin/rpn.elf
