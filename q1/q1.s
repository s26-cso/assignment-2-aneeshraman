.globl make_node
make_node:
    addi sp, sp, -16
    sd ra, 0(sp)
    sd s0, 8(sp)

    mv s0, a0

    li a0, 24
    call malloc
    sw s0, 0(a0)
    sd x0, 8(a0)
    sd x0, 16(a0)

    ld s0, 8(sp)
    ld ra, 0(sp)
    addi sp, sp, 16
    ret

# struct Node *insert(struct Node *root, int val) {
#     if (!root)
#         return make_node(val);
#     if (val > root->val)
#         root->right = insert(root->right, val);
#     else
#         root->left = insert(root->left, val);
#     return root;
# }

.globl insert
insert:
    addi sp, sp, -32
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)

    # s0: root, s1: val
    mv s0, a0
    mv s1, a1
    bnez s0, continue1

    mv a0, s1
    call make_node
    j exit1

    continue1:
        # t0: root->val
        lw t0, 0(s0)
        ble s1, t0, final1
        # t1: root->right
        ld a0, 16(s0)
        mv a1, s1
        call insert
        sd a0, 16(s0)
        mv a0, s0
        j exit1
        final1:
            # t1: root->left
            ld t1, 8(s0)
            mv a0, t1
            mv a1, s1
            call insert
            sd a0, 8(s0)
            mv a0, s0

    exit1:
        ld ra, 0(sp)
        ld s0, 8(sp)
        ld s1, 16(sp)
        addi sp, sp, 32
        ret

# struct Node *get(struct Node *root, int val) 
# {
#     if (!root) return NULL;
#     if (root->val == val)
#         return root;
#     if (root->val < val)
#         return get(root->right, val);
#     return get(root->left, val);
# }


.globl get
get: 
    addi sp, sp, -16
    sd ra, 0(sp)

    bnez a0, continue2
    j exit2

    continue2:
        # t0: root->val
        lw t0, 0(a0)
        bne t0, a1, continue3
        j exit2

        continue3:
            bgt t0, a1, continue4

            # t1: root->right
            ld t1, 16(a0)

            mv a0, t1
            call get
            j exit2

            continue4:
                ld t1, 8(a0)
                mv a0, t1
                call get
                j exit2


    exit2:
        ld ra, 0(sp)
        addi sp, sp, 16
        ret


# int getAtMost(int val, struct Node *root) {
#     if (!root) return -1;
#     if (root->val == val)
#         return val;
#     if (root->val < val) {
#         int ans = getAtMost(val, root->right);
#         if (ans != -1) return ans;
#         if (val >= -1)
#             if (get(root->right, -1))
#                 return -1;
#         return root->val;
#     }
#     return getAtMost(val, root->left);
# }


.globl getAtMost
getAtMost:
    addi sp, sp, -32
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)

    bnez a1, continue31
    li a0, -1
    j exit3
    continue31:
        # s0: root
        # t1: root->val
        # s1: val
        mv s0, a1
        mv s1, a0
        lw t1, 0(s0)

        bne t1, s1, continue32

        mv a0, s1
        j exit3
        continue32:
            bgt t1, s1, continue33
            mv a0, s1
            # a1: root->right
            ld a1, 16(s0)
            call getAtMost
            li t0, -1
            beq a0, t0, continue34
            j exit3
            continue34:
                li t0, -1
                blt s1, t0, continue35
                ld a0, 16(s0)
                li a1, -1
                call get
                beqz a0, continue35
                li a0, -1
                j exit3

            continue35:
            # a0: root->val
            lw a0, 0(s0)
            j exit3

            continue33:
                mv a0, s1
                # a1: root->left
                ld a1, 8(s0)
                call getAtMost
                j exit3

    exit3:
        ld ra, 0(sp)
        ld s0, 8(sp)
        ld s1, 16(sp)
        addi sp, sp, 32    
        ret