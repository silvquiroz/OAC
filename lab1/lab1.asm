section .data
    ; mensajes
    firstmsg db "El mcm es "
    lenf equ $-firstmsg

    resultmsg db "El resultado debería ser el siguiente: "
    lenr equ $-resultmsg

    ; arreglo
    arreglo dq 5, 3, 4

    ; aux
    solution dq 0
    mayor dq 0
    char dq 10 ; ACII del cambio de linea

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, firstmsg
    mov rdx, lenf
    syscall

    ; limpiar registros
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

    ; guardar los valores del arrelgo en registros aux
    mov r9, [arreglo + 8 * 0]
    mov r10, [arreglo + 8 * 1]
    mov r11, [arreglo + 8 *2]

    ; encontrar el mayor
    cmp r9, r10
    jg r9vsr11
    cmp r10, r11
    jg r10_mayor
    mov [mayor], r11
    jmp mayor_encontrado

    r9vsr11:
        cmp r9, r11
        jg r9_mayor
        mov [mayor], r11
        jmp mayor_encontrado
    
    r9_mayor:
        mov [mayor], r9
        jmp mayor_encontrado
    r10_mayor:
        mov [mayor], r10
        jmp mayor_encontrado

mayor_encontrado:
    mov r8, [mayor]

    ; limpiar registros
    xor rax, rax
    xor rbx, rbx
    xor rcx, rcx
    xor rdx, rdx

    bucle: 
        ; dividir con r9
        mov rax, r8
        xor rdx, rdx
        div r9
        cmp rdx, 0
        jne next

        ; dividir con r10
        mov rax, r8
        xor rdx, rdx
        div r10
        cmp rdx, 0
        jne next

        ; dividir con r11
        mov rax, r8
        xor rdx, rdx
        div r11
        cmp rdx, 0
        jne next

        ; sí se encontró el mcm
        jmp mcm_encontrado

    next:
        inc r8
        jmp bucle

mcm_encontrado:
    mov [solution], r8

    ; impresion del mcm
    xor rcx, rcx
    xor rax, rax
    xor rdx, rdx
    mov r12, 10
    mov rcx, [solution] ; mover el resultado a rcx
    mov rbx, 0 ; rbx es el contador de dígitos
    

    division:
        mov rax, rcx ; mover el resultado a rax
        cmp rax, r12 ; ver si el resultado es mayor que 10
        jl printsolution

        div r12 ; dividir el resultado entre 10 -> residuo se va a rdx
        inc rbx ; incrementa el contador de dígitos
        push rdx ; pushear el residuo a la pila 

        mov rcx, rax ; mover a rcx lo que queda del resultado
        jmp division

    printsolution:
        push rax
        inc rbx

    loopprint:
        cmp rbx, 0 ; ver si ya no quedan dígitos
        je final
        dec rbx
        pop rcx

        add rcx, 30H ; re-convertir a ascii
        mov [solution], rcx

        mov rax, 1
        mov rdi, 1
        mov rsi, solution
        mov rdx, 1
        syscall

        jmp loopprint

final:
    mov rax, 1
    mov rdi, 1
    mov rsi, char
    mov rdx, 1
    syscall

    mov rax, 60
    mov rdi, 0
    syscall
