TITLE Quicksortx86
INCLUDE Irvine32.inc

;Quicksorting decimal signed numbers

.data
intarray		SDWORD 1,-1,-3,1,2,7,4,-5,6,3
copyText		BYTE " copied: ",0
separator		BYTE " ",0

.data?
copy			SDWORD lengthof intarray dup (?)


.code
;copyArray is a function for copying the original intarray into a copy array
;this way the original array won't be modified during quicksort
copyArray:
	mov		EDI, OFFSET intarray
	mov		ESI, OFFSET copy

	mov		ECX, LENGTHOF intarray
L2:
	mov		EAX, [EDI]
	call		WriteInt
	mov		EDX, OFFSET copyText
	call		WriteString
	mov		[ESI], EAX
	mov		EAX, [ESI]
	call		WriteInt
	call		Crlf
	add		ESI, TYPE SDWORD
	add		EDI, TYPE SDWORD
	loop		L2
	ret
;----------------------------------------------------------------------------------------


;printCopy is a function for printing out every number found in copy 4byte elements array
printCopy:
	push		EDI
	push		ECX
	push		EAX
	push		EDX
	mov		EDI, OFFSET copy
	mov		ECX, LENGTHOF copy
printLoop:
	mov		EAX, [EDI]
	call		WriteInt
	mov		EDX, OFFSET separator
	call		WriteString
	add		EDI, TYPE SDWORD
	loop		printLoop
	pop		EDX
	pop		EAX
	pop		ECX
	pop		EDI
	ret
;----------------------------------------------------------------------------------------


;quicksort is a main function of the quicksorting algorithm
quicksort:
	push		EBP
	mov		EBP, ESP
	push		EBX
	push		ESI
	push		EDI

	mov		ESI,OFFSET copy		;ESI is the first element of the array
	mov		EBX,LENGTHOF copy-1		;EBX initiated with the number of elements -1 as the last index
	mov		EAX, 4				;Add 4 to EAX because every element is 4 bytes long
	mul		EBX					;Multiply EBX with EAX to get the last element's index
	mov		EBX, EAX				;Multiply's result will be stored in EAX, so we have to move it into EBX
	xor		EAX,EAX				;EAX will be the first index of the array, aka low index, starting at 0
	call		recursive				;Call recursive function to continue sorting
	pop		EDI
	pop		ESI
	pop		EBX
	pop		EBP
	ret

;recursive is the recursive sorting part of the quicksorting algorithm
recursive:
	cmp		EAX,EBX				;If i is greater or equal than j, jmp to over
	jge		over
	
	call		printCopy
	call		Crlf
	push		EAX					;Saving EAX for low index, EAX=i
	push		EBX					;Saving EBX for high index, EBX=j
	add		EBX, TYPE SDWORD		;Adding 4 bytes to EBX, j+1

	mov		EDI, [ESI+EAX]			;Select PIVOT element into EDI, pivot=[i]

mainLoop:
iLoop:
	add		EAX, TYPE SDWORD		;i++

	cmp		EAX, EBX				;Compare, if i(EAX) is greater or equal than j(EBX), exit loop
	jge		iLoopEnd

	cmp		[ESI+EAX], EDI			;If array[i] is greater or equal than pivot, exit loop
	jge		iLoopEnd

	jmp		iLoop				;Jump back to the top of iLoop

iLoopEnd:
jLoop:
	sub		EBX, TYPE SDWORD		;Decrease j value by 4 bytes

	cmp		[ESI+EBX], EDI			;If array[j] is less or equal than pivot, exit this loop
	jle		jLoopEnd

	jmp		jLoop				;Get back to the top of jLoop

jLoopEnd:
	cmp		EAX, EBX				;If i >= j end the main loop
	jge		mainLoopEnd

	push		[ESI+EAX]				;Else, swap array[i] with array[j] by pushing these values and popping them
	push		[ESI+EBX]

	pop		[ESI+EAX]
	pop		[ESI+EBX]

	jmp		mainLoop				;Get back to the main loop to continue sorting

mainLoopEnd:
	pop		EDI					;Restore the high index into EDI

	pop		ECX					;Restore the low index into ECX

	cmp		ECX, EBX				;If the saved low index == j, don't swap the values
	je		swapEnd

	push		[ESI+ECX]				;Else, swap array[low index] with array[j] by pushing and popping these values
	push		[ESI+EBX]

	pop		[ESI+ECX]
	pop		[ESI+EBX]

swapEnd:
	mov		EAX, ECX				;Setting EAX back to the low index

	push		EDI					;Saving the high Index
	push		EBX					;Saving j

	sub		EBX, TYPE SDWORD		;Setting EBX to j-1
	
	call		recursive				;Calling QuickSort(array, low index, j-1)

	pop		EAX					;Restore 'j' into EAX
	add		EAX, 4				;Setting EAX to j+1

	pop		EBX					;Restore the high index into EBX

	call		recursive				;Calling QuickSort(array, j+1, high index)
over:
	ret
;----------------------------------------------------------------------------------------


main proc
	call		copyArray
	call		quicksort
	call		printCopy
	invoke	ExitProcess,0
main endp
end main
	

