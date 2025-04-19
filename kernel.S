.syntax unified
.cpu cortex-m4
.thumb

.global vtable_kernel
.global __kernel_reset__

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__ + 1

.section .rodata
msg_start: .asciz "kernel started!\n"
msg_r3: .asciz "r3: "
msg_r4: .asciz "r4: "
msg_r5: .asciz "r5: "
msg_r6: .asciz "r6: "

.section .text
__kernel_reset__:
    ldr r0, =msg_start
    bl dbgput_line

    // Приклад 1: a=2, b=4, c=6 → r3 = 35
    movs r0, #2
    movs r1, #4
    movs r2, #6
    bl my_func_5
    mov r3, r0
    ldr r0, =msg_r3
    bl dbgput
    mov r0, r3
    bl dbgput_num

    // Приклад 2: a=3, b=5, c=2 → r4 = 13
    movs r0, #3
    movs r1, #5
    movs r2, #2
    bl my_func_5
    mov r4, r0
    ldr r0, =msg_r4
    bl dbgput
    mov r0, r4
    bl dbgput_num

    // Приклад 3: a=5, b=4, c=1 → r5 = 40
    movs r0, #5
    movs r1, #4
    movs r2, #1
    bl my_func_5
    mov r5, r0
    ldr r0, =msg_r5
    bl dbgput
    mov r0, r5
    bl dbgput_num

    // Приклад 4: a=7, b=8, c=4 → r6 = 39
    movs r0, #7
    movs r1, #8
    movs r2, #4
    bl my_func_5
    mov r6, r0
    ldr r0, =msg_r6
    bl dbgput
    mov r0, r6
    bl dbgput_num

1:  b 1b

// ==== my_func_5 ====
.global my_func_5
my_func_5:
    push {r4, r5, r6, r7, lr}
    mov r4, r0
    mov r5, r1
    mov r6, r2
    mul r7, r4, r5

    movs r0, #10
    cmp r7, r0
    blt .case1
    movs r0, #20
    cmp r7, r0
    blt .case2
    movs r0, #50
    cmp r7, r0
    blt .case3

.case4:
    mov r0, r6
    bl factorial
    orr r1, r4, r5
    add r0, r0, r1
    b .done

.case1:
    lsl r7, r7, #2
    lsr r1, r6, #1
    add r0, r7, r1
    b .done

.case2:
    lsr r7, r7, #1
    lsl r1, r5, #1
    eor r0, r7, r1
    b .done

.case3:
    adds r7, r4, r5
    adds r7, r7, r6
    and r1, r4, r5
    mul r0, r7, r1
    b .done

.done:
    pop {r4, r5, r6, r7, lr}
    bx lr

// ==== factorial ====
.type factorial, %function
factorial:
    push {r1, r2, lr}
    cmp r0, #1
    ble .fact_done
    mov r1, r0
.fact_loop:
    subs r1, r1, #1
    mul r0, r0, r1
    cmp r1, #1
    bgt .fact_loop
.fact_done:
    pop {r1, r2, lr}
    bx lr
