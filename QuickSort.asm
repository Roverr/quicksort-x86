TITLE Quicksortx86
INCLUDE Irvine32.inc

; Quicksorting decimal numbers

.data
intarray		SDWORD 1,-1,-3,1,2
prompt		BYTE " copied: ",0


       
.data?
copy    SDWORD lengthof intarray dup (?)


.code
_copyArray:
	mov		edi,OFFSET intarray		
	mov		esi,OFFSET copy

	mov		ecx,LENGTHOF intarray		
	xor		eax,eax						
L2:									
	mov		eax, [edi]				
	call		WriteInt
	mov		edx,OFFSET prompt
     call		WriteString
	mov		[esi], eax
	mov		eax, [esi]
	call		WriteInt
	call		Crlf
	add		esi, TYPE SDWORD
	add		edi, TYPE SDWORD   		
	loop		L2	
	ret

_quicksort:
	mov		ecx,LENGTHOF copy
	mov		esi,OFFSET copy
	xor		eax, eax
	add		esi, TYPE SDWORD
	mov		eax, [esi]
	call		WriteString
	ret

main proc
	call		_copyarray
	invoke	ExitProcess,0
main endp
end main
	

