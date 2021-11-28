section .data
	tape_ptr: dd 0

section .text
	global _start

_start:
    call init_tape
    mov eax, [tape_ptr]
    mov BYTE [eax], 'H'
    call print
    jmp exit

init_tape:
    mov eax, 192    ; mmap2
    xor ebx, ebx    ; addr = NULL
    mov ecx, 4096   ; len = 4096
    mov edx, 3h     ; prot = PROT_READ|PROT_EXEC
    mov esi, 22h    ; flags = MAP_PRIVATE|MAP_ANONYMOUS
    mov edi, -1     ; fd = -1
    xor ebp, ebp    ; offset = 0 (4096*0)
    int 80h         ; make call
    mov [tape_ptr], eax    ; save ptr to tape start
    ret

print:
	mov eax,4            ; The system call for write (sys_write)
	mov ebx,1            ; File descriptor 1 - standard output
	mov ecx,[tape_ptr]   ; Put the offset of hello in ecx
	mov edx,1            ; len to print
	int 80h              ; Call the kernel
    ret

exit:
	mov eax,1            ; The system call for exit (sys_exit)
	mov ebx,0            ; Exit with return code of 0 (no error)
	int 80h