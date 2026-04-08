# fd
# left
# right
# a
# b

.section .rodata
input: .asciz "input.txt"
yes: .asciz "Yes\n"
no: .asciz "No\n"

.text

.globl main
main:
addi sp, sp, -48
sd ra, 0(sp)
sd s0, 8(sp) # fd
sd s1, 16(sp) # left
sd s2, 24(sp) # right
sd s3, 32(sp) # a
sd s4, 40(sp) # b

la a0, input
li a1, 0
call open

mv s0, a0

li a1, 0
li a2, 2
call lseek
# a0: n
li s1, 0
addi s2, a0, -1

li a0, 1
call malloc
mv s3, a0

li a0, 1
call malloc
mv s4, a0

bge s1, s2, print_yes
loop:
    mv a0, s0
    mv a1, s1
    li a2, 0
    call lseek
    mv a0, s0
    mv a1, s3
    li a2, 1
    call read

    mv a0, s0
    mv a1, s2
    li a2, 0
    call lseek
    mv a0, s0
    mv a1, s4
    li a2, 1
    call read

    # t0: *a, t1: *b
    lbu t0, 0(s3)
    lbu t1, 0(s4)
    beq t0, t1, continue

    la a0, no
    call printf
    mv a0, s0
    call close
    j exit

    continue:
        addi s1, s1, 1
        addi s2, s2, -1
blt s1, s2, loop

print_yes:
la a0, yes
call printf
mv a0, s0
call close

exit:
    ld ra, 0(sp)
    ld s0, 8(sp) # fd
    ld s1, 16(sp) # left
    ld s2, 24(sp) # right
    ld s3, 32(sp) # a
    ld s4, 40(sp) # b
    addi sp, sp, 48
    li a0, 0
    ret