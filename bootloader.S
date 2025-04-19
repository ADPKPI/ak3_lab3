.syntax unified
.cpu cortex-m4
.thumb

.global bootload

.section .rodata
image: .incbin "kernel.bin"
end_of_image:

str_boot_start: .asciz "bootloader started"
str_boot_end: .asciz "bootloader end"

.section .text
bootload:
    ldr r0, =str_boot_start
    bl dbgput_line

    ldr r0, =end_of_image     // кінцева адреса kernel.bin
    ldr r1, =image            // початкова адреса kernel.bin (в Flash)
    ldr r2, =_ram_start       // куди копіювати (в RAM)

    mov r4, #1                // зсув = 1 байт

loop:
    ldrb r3, [r1, r4]         // регістровий зсув на 1 байт
    strb r3, [r2, r4]         // копіюємо цей байт в RAM
    add r1, r1, #1            // інкремент вхідного вказівника
    add r2, r2, #1            // інкремент вихідного вказівника
    cmp r1, r0
    blo loop

    bl newline
    ldr r0, =str_boot_end
    bl dbgput_line

    // Переходимо до завантаженої програми
    ldr lr, =bootload_end
    add lr, #1

    ldr r2, =_ram_start
    add r2, #4
    ldr r0, [r2]
    bx r0

bootload_end:
    b bootload_end
