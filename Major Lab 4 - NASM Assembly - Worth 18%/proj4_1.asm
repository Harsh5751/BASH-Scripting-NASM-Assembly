%include "asm_io.inc"
global asm_main

section .data
string db "Hello World",0
;string db "HelloHelloHelloHello WorldWorldWorldWorldWorld",0
msg1 db "too many characters",0
msg2 db "the length of the string is ",0
msg3 db "the number of lower case letters is ",0

section .bss
N resd 1
M resd 1

section .text

asm_main:
  enter 0, 0

  ;; calculate the string's length by traversing it
  ;; using ebx to traverse the string
  mov ebx,string
  mov dword [N], dword 0
  mov dword [M], dword 0
  L1: 
    cmp byte [ebx], byte 0
    je L2
    cmp byte [ebx], 'a'
    jb L11
    cmp byte [ebx], 'z'
    ja L11
    inc dword [M]
    L11:
    inc ebx
    add dword [N],1
    cmp dword [N],20
    jb L1
  mov eax,msg1       ;; string too long
  call print_string
  call print_nl
  jmp END

  L2: 
  mov eax,string     ;; printf the string
  call print_string
  call print_nl
  mov eax, msg2          ;; print the length  message
  call print_string
  mov eax, dword [N]     ;; print the length
  call print_int
  call print_nl
  mov eax, msg3          ;; print the # of lower case letters message
  call print_string
  mov eax, dword [M]     ;; print the # of lower case letters
  call print_int
  call print_nl

  END:
  leave
  ret
