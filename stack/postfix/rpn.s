# --------------------- CONSTANTS ------------------------- #

.set SYSCALL_READ, 0
.set SYSCALL_WRITE, 1
.set SYSCALL_OPEN, 2
.set SYSCALL_CLOSE, 3
.set SYSCALL_EXIT, 60
.set SYSCALL_GETRLIMIT, 97

.set RLIMIT_STACK, 3

.set STDIN, 0
.set STDOUT, 1
.set STDERR, 2

# --------------------- DATA ------------------------- #
    .data

result_msg:
    .asciz "Result = "
result_msg_len = . - result_msg

error_msg:
    .asciz "[ERROR] File not fuond\n"
    error_msg_len = . - error_msg

usage_msg:
    .asciz "Usage: rpn <file>\n"
    usage_msg_len = . - usage_msg

newline:
    .asciz "\n"

.bss
    read_char_buf: .space 1
    digit: .space 1

    rlimit:  .space 16
    # struct rlimit {
    #     unsigned long rlim_cur;  // Soft limit (current limit)
    #     unsigned long rlim_max;  // Hard limit (maximum limit)
    # };
    # although we will only use the soft limit value




# --------------------- CODE ------------------------- #
    .global _start

.text

_start:

    mov (%rsp), %rbx # (%rsp) is argc
    cmp $1, %rbx
    jle .L_print_usage
    cmp $3, %rbx
    jge .L_print_usage

    call .F_get_stack_size # get the soft limit for stack and store it in rlimit

    # Devide the maximum stack size by 2, because we're pussies
    mov rlimit, %rax
    shr $1, %rax
    mov %rax, rlimit

    pop %rdi # argc
    pop %rdi # argv[0]
    pop %rdi # argv[1]
    # Try to open the file
    mov $SYSCALL_OPEN, %rax
    xor %rdx, %rdx
    xor %rsi, %rsi
    syscall

    mov %rax, %rdi
    cmp $0, %rdi
    jg .L_read_char_from_file
    mov $SYSCALL_WRITE, %rax
    mov $STDERR, %rdi
    mov $error_msg, %rsi
    mov $error_msg_len, %rdx
    syscall
    jmp .L_exit

.L_read_char_from_file:
    mov $SYSCALL_READ, %rax
    mov $read_char_buf, %rsi
    mov $1, %rdx
    syscall

    cmpb $' ', (%rsi)
    je .L_read_char_from_file
    cmpb $48, (%rsi) # compare with 0, "+ - * /" are less that 0 in ascii table
    jb .L_check_end
    subq $48, (%rsi) # convert to integer
    xor %rax, %rax
    movb (%rsi), %al
    push %rax
    jmp .L_read_char_from_file
.L_check_end:
    cmpb $'\n', (%rsi)
    jne .L_do_operation
    pop %r8
    call .F_prepare_result
    jmp .L_exit

.L_do_operation:
    # if we reach hre it means we have read an operator
    pop %rcx # restore last number from stack
    pop %rax # restore 1 before last number from stack
div:
    cmpb $47, (%rsi) # compare with /
    jne mul
    xor %rdx, %rdx
    div %rcx
    push %rax
    jmp .L_read_char_from_file


mul:
    cmpb $42, (%rsi) # compare with *
    jne addition
    mul %rcx
    push %rax
    jmp .L_read_char_from_file

addition:
    cmpb $43, (%rsi) # compare with +
    jne subtract
    add %rcx, %rax
    push %rax
    jmp .L_read_char_from_file

subtract:
    sub %rcx, %rax
    push %rax
    jmp .L_read_char_from_file

    .L_print_usage:
    mov $SYSCALL_WRITE, %rax
    mov $STDERR, %rdi
    mov $usage_msg, %rsi
    mov $usage_msg_len, %rdx
    syscall

    .L_exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall


# --------------------- FUNCTIONS ------------------------- #

.F_get_stack_size:
    mov $SYSCALL_GETRLIMIT, %rax
    mov $RLIMIT_STACK, %rdi
    mov $rlimit, %rsi
    syscall
    ret

# arguments: result value in r8
.F_prepare_result:
    mov $SYSCALL_WRITE, %rax
    mov $STDOUT, %rdi
    mov $result_msg, %rsi
    mov $result_msg_len, %rdx
    syscall
    mov %r8, %rax
    mov $10, %r8
    xor %rcx, %rcx
.L_next:
    xor %rdx, %rdx
    div %r8
    push %rdx
    inc %rcx
    cmp $0, %rax
    ja .L_next
.L_get_digits:
    pop %rdx
    add $'0', %rdx
    mov %rdx, digit
    lea digit, %rsi
    mov $1, %rdx
    push %rcx
    call .F_print
    pop %rcx
    loop .L_get_digits

    mov $newline, %rsi
    mov $1, %rdx
    call .F_print
    ret


    # arguments: 1. address of string: rsi
    #            2. length of the string: rdx
.F_print:
    mov $SYSCALL_WRITE, %rax
    mov $STDOUT, %rdi
    syscall
    ret

