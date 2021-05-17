[bits 16]
[org 0x7c00]

jmp bootTarget

gdt_start:
gdt_null:
    dd 0
    dd 0
gdt_code:	; code segment descriptor
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:	; data segment descriptor
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:	; used to calculate size of gdt
gdt_descriptor:
    dw gdt_end - gdt_start - 1	; size of gdt and is always 1 less than its true size
    dd gdt_start	; start address of gdt
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start


bootTarget:
	mov ax, 0x2401
	int 0x15

	mov ax, 0x3
    int 0x10

	cli
	lgdt[gdt_descriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:beginProtected

[bits 32]

regPrint:
	mov ecx, 32
	mov ebx, 0xb8020
	mov edx, cr0
.loop2:
    mov eax, 00000130h   
    shl edx, 1           
    adc eax, 0           
    mov [ebx], ax
    add ebx, 2
    dec ecx
    jnz .loop2

halt:
    hlt
    jmp halt

beginProtected:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

printString:
	mov esi, String
    mov ebx, 0xb8000
.loop:
    lodsb
    or al, al
    jz regPrint
    or eax, 0x0100
    mov word [ebx], ax
    add ebx, 2
    jmp .loop

String: 
	db "Hello World!",0

times 510 - ($ - $$) db 0
dw 0xaa55
