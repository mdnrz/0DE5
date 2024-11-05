#!/bin/sh
mkdir -p ./bin
as --64 -g -o ./bin/elf-struct.o ./elf-struct.s
as --64 -g -o ./bin/elfer-hello.o ./elfer-hello.s && 
ld -m elf_x86_64 ./bin/elfer-hello.o ./bin/elf-struct.o -o ./bin/elfer-hello.elf
ctags -R .
