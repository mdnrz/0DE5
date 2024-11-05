# --------------------- CONSTANTS ------------------------- #

.set SYSCALL_READ, 0
.set SYSCALL_WRITE, 1
.set SYSCALL_OPEN, 2
.set SYSCALL_CLOSE, 3
.set SYSCALL_EXIT, 60
.set SYSCALL_GETRLIMIT, 97

.set FLAG_O_CREAT_RDWR, 0x42 # O_RDWR | O_CREAT
.set FILE_MODE, 0x1ED # rwxr-xr-x 

.set STDIN, 0
.set STDOUT, 1
.set STDERR, 2

.include "./elf-struct.s"


# --------------------- DATA ------------------------- #
.data

file_path:
    .asciz "./bin/hello.elf"

machine_code:
    .byte 0xc7, 0xc0, 0x01, 0x00, 0x00, 0x00
    .byte 0xc7, 0xc7, 0x01, 0x00, 0x00, 0x00
    .byte 0xc7, 0xc6, 0xf0, 0x00, 0x60, 0x00
    .byte 0xc7, 0xc2, 0x10, 0x00, 0x00, 0x00
    .byte 0x0f, 0x05
    .byte 0xc7, 0xc7, 0x00, 0x00, 0x00, 0x00
    .byte 0xc7, 0xc0, 0x3c, 0x00, 0x00, 0x00
    .byte 0x0f, 0x05
machine_code_sz = . - machine_code

padding_8b:
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

msg:
    .asciz "hello, world\n"
msg_len = . - msg



.bss
ph_array:
    .space 2*p_header_size

# --------------------- CODE ------------------------- #
    .global _start

.text

_start:

    mov $file_path, %rdi
    mov $FLAG_O_CREAT_RDWR, %rsi
    mov $FILE_MODE, %rdx
    mov $SYSCALL_OPEN, %rax
    syscall

    # -------------- ELF header ---------#
    lea elf_header, %r8
    lea eh_idx_ident(%r8), %r9
    movb $0x7F, ei_idx_mag0(%r9)
    movb $0x45, ei_idx_mag1(%r9)
    movb $0x4C, ei_idx_mag2(%r9)
    movb $0x46, ei_idx_mag3(%r9)
    movb $ei_val_class_64, ei_idx_class(%r9)
    movb $ei_val_data_lsb, ei_idx_data(%r9)
    movb $ev_val_current, ei_idx_version(%r9)

    lea eh_idx_type(%r8), %r9
    movw $et_val_exec, (%r9)

    lea eh_idx_machine(%r8), %r9
    movw $em_val_x8664, (%r9)

    lea eh_idx_version(%r8), %r9
    movl $ev_val_current, (%r9)

    lea eh_idx_entry(%r8), %r9
    movq $0x4000B0, (%r9)

    lea eh_idx_phoff(%r8), %r9
    movq $0x40, (%r9)

    lea eh_idx_ehsize(%r8), %r9
    movw $0x40, (%r9)

    lea eh_idx_phentsize(%r8), %r9
    movw $0x38, (%r9)

    lea eh_idx_phnum(%r8), %r9
    movw $0x2, (%r9)

    # -------- Program header 1: code -------#
    lea ph_array, %r8
    lea ph_idx_type(%r8), %r9
    movl $pt_val_load, (%r9)

    lea ph_idx_flags(%r8), %r9
    movl $0x5, (%r9)

    lea ph_idx_vaddr(%r8), %r9
    movq $0x400000, (%r9)

    lea ph_idx_filesz(%r8), %r9
    movq $0xE8, (%r9)

    lea ph_idx_memsz(%r8), %r9
    movq $0xE8, (%r9)

    lea ph_idx_align(%r8), %r9
    movq $0x1000, (%r9)

    # -------- Program header 2: read-only data -------#
    lea ph_array + p_header_size, %r8
    lea ph_idx_type(%r8), %r9
    movl $pt_val_load, (%r9)

    lea ph_idx_flags(%r8), %r9
    movl $0x4, (%r9)

    lea ph_idx_vaddr(%r8), %r9
    movq $0x600000, (%r9)

    lea ph_idx_filesz(%r8), %r9
    movq $0x1000, (%r9)

    lea ph_idx_memsz(%r8), %r9
    movq $0x1000, (%r9)

    lea ph_idx_align(%r8), %r9
    movq $0x1000, (%r9)
    # write elf_header to the file
    mov %rax, %rdi
    lea elf_header, %rsi
    mov $elf_header_size, %rdx
    mov $SYSCALL_WRITE, %rax
    syscall

    # write program header 1 to the file
    lea ph_array, %rsi
    mov $p_header_size, %rdx
    mov $SYSCALL_WRITE, %rax
    syscall

    # write program header 2 to the file
    lea ph_array+p_header_size, %rsi
    mov $p_header_size, %rdx
    mov $SYSCALL_WRITE, %rax
    syscall

    # write machine code to the file
    lea machine_code, %rsi
    mov $machine_code_sz, %rdx
    mov $SYSCALL_WRITE, %rax
    syscall

    # write padding
    lea padding_8b, %rsi
    mov $8, %rdx
    mov $SYSCALL_WRITE, %rax
    syscall

    # write msg string to the file
    lea msg, %rsi
    mov $msg_len, %rdx
    mov $SYSCALL_WRITE, %rax
    syscall

    xor %rdi, %rdi
    mov $SYSCALL_EXIT, %rax
    syscall
