TITLE Quicksortx86
INCLUDE Irvine32.inc

;Quicksorting decimal numbers

.data
intarray		SDWORD 1,-1,-3,1,2,7
copyText		BYTE " copied: ",0
separator		BYTE " ",0



       
.data?
copy    SDWORD lengthof intarray dup (?)


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
	;if i is greater or equal than j, jmp to over
	cmp		EAX,EBX
	jge		over
	
	call		printCopy
	call		Crlf
	push		EAX					;Saving EAX for low index, EAX=i
	push		EBX					;Saving EBX for high index, EBX=j
	add		EBX, TYPE SDWORD		;Adding 4 bytes to EBX, j+1

	mov		EDI, [ESI+EAX]			;Select PIVOT element into EDI, pivot=[i]

mainLoop:
iLoop:
	;i++
     add		EAX, TYPE SDWORD
            
     ;If i >= j, exit this loop
     cmp		EAX, EBX
     jge		iLoopEnd
            
     ;If array[i] >= pivot, exit this loop
     cmp		[ESI+EAX], EDI
     jge		iLoopEnd
            
     ;Go back to the top of this loop
     jmp		iLoop

iLoopEnd:
jLoop:
	;j--
	sub		EBX, TYPE SDWORD

	;If array[j] <= pivot, exit this loop
     cmp		[ESI+EBX], EDI
     jle		jLoopEnd
            
     ;Go back to the top of this loop
     jmp		jLoop

jLoopEnd:
	;If i >= j, then don't swap and end the main loop
     cmp		EAX, EBX
     jge		mainLoopEnd
        
     ;Else, swap array[i] with array [j]
     push		[ESI+EAX]
     push		[ESI+EBX]
        
     pop		[ESI+EAX]
     pop		[ESI+EBX]
        
     ;Go back to the top of the main loop
     jmp		mainLoop

mainLoopEnd:
	;Restore the high index into EDI
	pop		EDI
    
	;Restore the low index into ECX
	pop		ECX
    
	;If low index == j, don't swap
	cmp		ECX, EBX
	je		swapEnd
    
	;Else, swap array[low index] with array[j]
	push		[ESI+ECX]
	push		[ESI+EBX]
        
	pop		[ESI+ECX]
	pop		[ESI+EBX]

swapEnd:     
	;Setting EAX back to the low index
	mov		EAX, ECX 

	push		EDI    ;Saving the high Index
	push		EBX    ;Saving j
    
	sub		EBX, TYPE SDWORD  ;Setting EBX to j-1
	
	;QuickSort(array, low index, j-1)
	call		recursive
    
	;Restore 'j' into EAX
	pop		EAX
	add		EAX, 4  ;setting EAX to j+1
    
	;Restore the high index into EBX
	pop		EBX
    
	;QuickSort(array, j+1, high index)
	call		recursive
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
	

