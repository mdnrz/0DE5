#!/bin/sh

mkdir -p bin
as --64 -g -o ./bin/wcx64e.o ./wcx64e.s && ld -m elf_x86_64 ./bin/wcx64e.o -o ./bin/wcx64e.elf
