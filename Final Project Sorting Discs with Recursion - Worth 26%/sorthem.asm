%include "asm_io.inc"

SECTION .data

error1: db "Incorrect number of command line arguments",10,0
error2: db "Command line argument must be between 2 and 9",10,0
error3: db "Incorrect length of command line arguments",10,0
D1: db "                o|o",0
D2: db "               oo|oo",0
D3: db "              ooo|ooo",0
D4: db "             oooo|oooo",0
D5: db "            ooooo|ooooo",0
D6: db "           oooooo|oooooo",0
D7: db "          ooooooo|ooooooo",0
D8: db "         oooooooo|oooooooo",0
D9: db "        ooooooooo|ooooooooo",0
base: db "      XXXXXXXXXXXXXXXXXXXXXXX",0
initial: db "   initial configuration",0
final: db "   final configuration",0

SECTION .bss
PEG: resd 9
NDISKS: resd 1

SECTION .txt
	global asm_main


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;subroutine showp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showp:
	enter 0,0
	pusha 
	
	mov ebx, [ebp+12]
	mov ecx, [ebp+8]
	mov edx, 0
	mov eax, 1
	
	;;;Go to end of Array ;;;
	GoToEnd:
	cmp eax, ebx
	je Pause
	add ecx, 4
	inc eax
	jmp GoToEnd

	;;; When to press key ;;;
	Pause:
	cmp ebx, edx
	je Depress
	jmp DisplayIt

	DisplayIt:
	cmp dword [ecx], 1
	je Disk1
	cmp dword [ecx], 2
	je Disk2
	cmp dword [ecx], 3
	je Disk3
	cmp dword [ecx], 4
	je Disk4
	cmp dword [ecx], 5
	je Disk5
	cmp dword [ecx], 6
	je Disk6
	cmp dword [ecx], 7
	je Disk7
	cmp dword [ecx], 8
	je Disk8
	jmp Disk9

	Disk1:
	mov eax, D1
	call print_string
	call print_nl
	jmp NextStep

	Disk2:
	mov eax, D2
	call print_string
	call print_nl
	jmp NextStep
	
	Disk3:
	mov eax, D3
	call print_string
	call print_nl
	jmp NextStep

	Disk4:
	mov eax, D4
	call print_string
	call print_nl
	jmp NextStep

	Disk5:
	mov eax, D5
	call print_string
	call print_nl
	jmp NextStep

	Disk6:
	mov eax, D6
	call print_string
	call print_nl
	jmp NextStep
	
	Disk7:
	mov eax, D7
	call print_string
	call print_nl
	jmp NextStep
	
	Disk8:
	mov eax, D8
	call print_string
	call print_nl
	jmp NextStep

	Disk9:
	mov eax, D9
	call print_string
	call print_nl
	jmp NextStep

	NextStep:
	sub ecx, 4
	inc edx
	jmp Pause	

	Depress:
	mov eax, base
	call print_string
	call print_nl

	call read_char

	popa
	leave
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Subroutine showp ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Subroutine sorthem
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sorthem:
	enter 0,0
	pusha

	mov ecx, [ebp+8]
	mov edx, [ebp+12]
	
	cmp edx, 1
	je ElementBack
	
	dec edx
	push edx
	add ecx,4
	push ecx
	call sorthem
	add esp, 8

	ElementBack:
	mov ecx, [ebp+8]
	mov edx, [ebp+12]
	mov edi, 1

	loop2:
	cmp edi, edx
	je loop_end
	mov eax, dword[ecx]
	mov ebx, dword[ecx+4]
	cmp eax, ebx
	ja loop_end
	mov [ecx+4], eax
	mov [ecx], ebx
	add ecx, 4
	inc edi
	jmp loop2
	
	loop_end:
	push dword[NDISKS]
	push PEG
	call showp
	add esp, 8 

	sorthem_end:
	popa
	leave
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Subroutine sorthem ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Subroutine asm_main
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_main:
	enter 0,0

	mov eax, [ebp+8]
	cmp eax, dword 2
	jne err1
	jmp NextCheck

	err1:
	mov eax, error1
	call print_string
	jmp End
	
	NextCheck:
	mov ebx, [ebp+12]
	mov ecx, [ebx+4]
	mov bl, byte[ecx]

	CheckArguments:
	cmp bl, byte 0
	je err3
	mov bl, byte[ecx+1]
	cmp bl, byte 0
	jne err3
	jmp CheckRange

	err3:
	mov eax, error3
	call print_string
	jmp End

	CheckRange:
	mov bl, byte[ecx]
	cmp bl, '2'
	jb err2
	cmp bl, '9'
	ja err2
	jmp AllGood

	err2:
	mov eax, error2
	call print_string
	jmp End

        ;;; Setting up the random order of the disks ;;;
	AllGood:
	mov eax, 0
	mov al, byte[ecx]
	sub eax, dword '0'
	mov dword [NDISKS], eax
	push dword [NDISKS]
	push PEG
	call rconf
	add esp, 8

	;;; Display message initial ;;;
	mov eax, 0
	mov eax, initial
	call print_string
	call print_nl

        ;;; Call subroutine showp to display ;;;
	push dword[NDISKS]
	push PEG
	call showp
	add esp, 8
	
	;;; Call the subroutine sorthem ;;;
	push dword[NDISKS]
	push PEG
	call sorthem
	add esp, 8 
	
	;;; final configuration ;;;
	mov eax, final
	call print_string
	call print_nl
	push dword[NDISKS]
	push PEG
	call showp
	add esp, 8


	End:
	leave 
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Subroutine asm_main ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
