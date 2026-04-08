.section .rodata
fmt_out: .asciz "%d "
fmt_last: .asciz "%d\n"

.text
.globl main
main:
    addi sp, sp, -80
    # s0: commonSize
    # s1: arr
    # s2: i
    # s3: stack
    # s4: top
    # s5: res
    # s6: n
    # s7: argv
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)
    sd s4, 40(sp)
    sd s5, 48(sp)
    sd s6, 56(sp)
    sd s7, 64(sp)

    mv s7, a1
    addi s6, a0, -1

    bgt s6, zero, continue1
    li a0, 0
    j exit
    continue1:
    slli s0, s6, 2
    mv a0, s0
    call malloc
    mv s1, a0

    li s2, 0

    bge s2, s6, continue2
    loop1:
        slli t0, s2, 2
        # t0: currArr
        add t0, s1, t0
        # t1: currArgv
        slli t1, s2, 3
        add t1, s7, t1
        addi t1, t1, 8
        # t2: currString
        ld t2, 0(t1)
        mv a0, t2
        call atoi
        slli t0, s2, 2
        # t0: currArr
        add t0, s1, t0
        # a0: convertedInt
        sw a0, 0(t0)
        addi s2, s2, 1
    blt s2, s6, loop1
    continue2:
    mv a0, s0
    call malloc
    mv s3, a0
    li s4, -1

    mv a0, s0
    call malloc
    mv s5, a0
    mv a0, s5
    li a1, -1
    mv a2, s0
    call memset

    addi s2, s6, -1

    blt s2, x0, continue3
    loop2:
        li t0, -1
        beq s4, t0, continue4
        loop3:
        slli t0, s4, 2
        # t0: stackTopLoc
        add t0, s3, t0
        # t1: stackTopElement
        lw t1, 0(t0)
        slli t2, t1, 2
        # t2: arrStackLoc
        add t2, s1, t2
        # t3: addStackVal
        lw t3, 0(t2)
        slli t4, s2, 2
        # t4: arrIndexLoc
        add t4, s1, t4
        # t5: arrIndexVal
        lw t5, 0(t4)
        ble t3, t5, pop1
        j continue4
        pop1:
            addi s4, s4, -1
            li t0, -1
        bne s4, t0, loop3

        continue4:
            li t0, -1
            beq s4, t0, continue5
            slli t0, s2, 2
            # t0: resLoc
            add t0, s5, t0
            slli t1, s4, 2
            # t1: stackLoc
            add t1, s3, t1
            # t2: stackTop
            lw t2, 0(t1)
            sw t2, 0(t0)
        continue5:
            addi s4, s4, 1
            slli t0, s4, 2
            # t0: stackLoc
            add t0, s3, t0
            sw s2, 0(t0)
            addi s2, s2, -1

    bge s2, x0, loop2

    continue3:
    li s2, 0
    addi s6, s6, -1
    bge s2, s6, print_last
    loop4:
    la a0, fmt_out
    slli t0, s2, 2
    # t0: res + i
    add t0, s5, t0
    lw a1, 0(t0)
    call printf
    addi s2, s2, 1
    blt s2, s6, loop4

    print_last:
    la a0, fmt_last
    slli t0, s2, 2
    add t0, s5, t0
    lw a1, 0(t0)
    call printf

    exit:
        ld ra, 0(sp)
        ld s0, 8(sp)
        ld s1, 16(sp)
        ld s2, 24(sp)
        ld s3, 32(sp)
        ld s4, 40(sp)
        ld s5, 48(sp)
        ld s6, 56(sp)
        ld s7, 64(sp)
        addi sp, sp, 80
        li a0, 0
        ret