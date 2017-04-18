TITLE Quicksortx86
INCLUDE Irvine32.inc

; Quicksorting decimal numbers

.data
intarray		SDWORD 1,-1,-3,1,2,7
prompt		BYTE " copied: ",0


       
.data?
copy    SDWORD lengthof intarray dup (?)


.code
;copyArray is a function for copying the original intarray into a copy array
;this way the original array won't be modified during quicksort
copyArray:
	mov		EDI,OFFSET intarray		
	mov		ESI,OFFSET copy

	mov		ECX,LENGTHOF intarray		
	xor		EAX,EAX						
L2:									
	mov		EAX, [EDI]				
	call		WriteInt
	mov		EDX,OFFSET prompt
     call		WriteString
	mov		[ESI], EAX
	mov		EAX, [ESI]
	call		WriteInt
	call		Crlf
	add		ESI, TYPE SDWORD
	add		EDI, TYPE SDWORD   		
	loop		L2	
	ret


;getLastElement is a function for getting the current last element of copy array
;into EBX
getLastElement:
	push		ESI
	push		EAX
	push		ECX
	mov		ESI,OFFSET copy
	mov		EAX,LENGTHOF copy-1
	mov		ECX, 4				;4 for multiply, because SDWORD is 4 bytes
	mul		ECX
	mov		ECX, EAX
	mov		EBX, [ESI+ECX]			;EBX is going to be the last element of the array
	pop		EAX
	pop		ESI
	pop		ECX
	ret

quicksort:
	push		EBP
	mov		EBP, ESP
	push		EBX
	push		ESI
	push		EDI
	push		EAX

	mov		ESI,OFFSET copy		;ESI is the first element of the array
	mov		EBX,LENGTHOF copy-1		;EBX will be the last index of the array, aka high index
	xor		EAX,EAX				;EAX will be the first index of the array, aka low index
	ret


main proc
	call		copyArray
	call		quicksort
	invoke	ExitProcess,0
main endp
end main
	

