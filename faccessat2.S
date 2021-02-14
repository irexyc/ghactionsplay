.text
.global _start

write1:
mov $1, %rax # SYS_WRITE: 1
mov $1, %rdi # stdout
syscall
ret
exit:
mov $60, %rax # SYS_EXIT: 60
syscall
ret
faccessat2:
mov $439, %rax # SYS_FACCESSAT2: 439
syscall
ret

_start:
# write(1, "start\n", 6)
lea msg_start(%rip), %rsi # "start\n"
mov $6, %rdx # 6, sizeof(^) - 1
call write1

# faccessat2(NULL, "/bin/sh", X_OK, 0);
xor %rdi, %rdi # 0, NULL
lea msg_binsh(%rip), %rsi # "/bin/sh"
mov $1, %rdx # 1, X_OK
xor %rcx, %rcx # 0, no flags

# save result to b
mov %rax, %rbx

# write(1, "end\n", 4)
lea msg_end(%rip), %rsi # "end\n"
mov $4, %rdx # 4, sizeof(^) - 1
call write1

cmp $-1, %rbx # compare -EACCES with rbx
je .Lbad # if(-EACCES == $rbx) jmp .Lbad

# write(1, "ok\n", 3)
lea msg_ok(%rip), %rsi # "ok\n"
mov $3, %rdx # 3, sizeof(^) - 1
call write1

# exit(0)
mov $0, %rdi
call exit

.Lbad:

# write(1, "bad\n", 4)
lea msg_bad(%rip), %rsi # "bad\n"
mov $4, %rdx # 4, sizeof(^) - 1
call write1

# exit(1)
mov $1, %rdi
call exit

.data

msg_start: .ascii "start\n"
msg_end: .ascii "end\n"
msg_bad: .ascii "bad\n"
msg_ok: .ascii "ok\n"
msg_binsh: .ascii "/bin/sh"
