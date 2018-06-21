TITLE Program Template     (Program05.asm)

; Author: Tristan Santiago
; Last Modified: May 28, 2018
; OSU email address: santiatr@oregonstate.edu
; Course number/section: CS271_400
; Project Number: 05               Due Date: May 27, 2018
; Description: This program generates random numbers anywhere between 100 and 999 based on
; the number of numbers the user wants to generate. This program borrows a lot of code from
; the lecture slides provided to us for this week.
;------------------------------------------------------------------------
INCLUDE Irvine32.inc
;------------------------------------------------------------------------
UPPER_LIMIT = 999																; Variable used to represent the random number upper limit.
LOWER_LIMIT = 100																; Variable used to represent the random number lower limit.
MIN_NUM_TERMS = 10																; Variable used to represent the minimum number of random numbers to generate.	
MAX_NUM_TERMS = 200																; Variable used to represent the maximum number of random numbers to generate.
;------------------------------------------------------------------------
.data
;------------------------------------------------------------------------
; Program information and introduction variables.
;------------------------------------------------------------------------
intro_1			BYTE		"Sorting Random Integers		Programmed by Tristan Santiago", 0
intro_2			BYTE		"This program generates random numbers in the range [100 .. 999], ", 0
intro_3			BYTE		"displays the original list, sorts the list, and calculates the ", 0
intro_4			BYTE		"median value. Finally, it displays the list sorted in descending order.", 0
;------------------------------------------------------------------------
; User input variables.
;------------------------------------------------------------------------
prompt_1		BYTE		"How many numbers should be generated? [10 .. 200]: ", 0
numsGenerated	DWORD		?													; Variabled used to store the number of random integers user wants to generate.
userInput		DWORD		?													; Used to hold the user's input for number of random numbers.
;------------------------------------------------------------------------
; Array variables.
;------------------------------------------------------------------------
array			DWORD		MAX_NUM_TERMS	DUP(?)								; Array declaration, initialized to hold up to 200 numbers.
rowCount		DWORD		0													; Variable used to count number of integers printed per row.
spaces			BYTE		"     ", 0											; Variable used to print five spaces for formatting the printed integers.
;------------------------------------------------------------------------
; Results prompts.
;------------------------------------------------------------------------
results_1		BYTE		"The unsorted random numbers:", 0
results_2		BYTE		"The median is ", 0
results_3		BYTE		"The sorted list:", 0
period			BYTE		".", 0
;------------------------------------------------------------------------
; Validation Variables
;------------------------------------------------------------------------
rangeError		BYTE		"Invalid input", 0									; Error message for user entering a number above the upper limit.
;------------------------------------------------------------------------
.code				; Main procedure.
;------------------------------------------------------------------------
main PROC			; intro procedure
;------------------------------------------------------------------------
					call	RANDOMIZE											; Seed unique random number sequence.
					call	intro												; [ESP]
;------------------------------------------------------------------------
;					getUserData procedure
;------------------------------------------------------------------------
					push	OFFSET userInput									; [ESP + 4]
					call	getUserData											; [ESP]
;------------------------------------------------------------------------
;					fillArray procedure
;------------------------------------------------------------------------
					push	OFFSET array										; [ESP + 8]
					push	userInput											; [ESP + 4]
					call	fillArray											; [ESP]
;------------------------------------------------------------------------
;					displayList procedure (unsorted list)
;------------------------------------------------------------------------
					push	OFFSET array										; [ESP+12]
					push	userInput											; [ESP+8]
					push	OFFSET results_1									; [ESP+4]
					call	displayList											; [ESP]
;------------------------------------------------------------------------
;					sortList procedure
;------------------------------------------------------------------------
					push	OFFSET array										; [ESP +8]
					push	userInput											; [ESP +4]
					call	sortList											; [ESP]
;------------------------------------------------------------------------
;					displayMedian procedure
;------------------------------------------------------------------------
					push	OFFSET array										; [ESP +8]
					push	userInput											; [ESP +4]
					call	displayMedian										; [ESP]
;------------------------------------------------------------------------
;					displayList procedure (sorted list)
;------------------------------------------------------------------------
					push	OFFSET array										; [ESP+12]
					push	userInput											; [ESP+8]
					push	OFFSET results_3									; [ESP+4]
					call	displayList	
					call	CrLf
					call	CrLf
;------------------------------------------------------------------------
					exit														; Exit to operating system.
;------------------------------------------------------------------------
main ENDP
;------------------------------------------------------------------------
;							intro										;
; This procedure displays the programmer's name and prints a brief		;
; description of the program.											;
;------------------------------------------------------------------------
;------------------------------------------------------------------------
intro PROC
;------------------------------------------------------------------------
					mov		edx, OFFSET intro_1
					call	WriteString
					call	CrLf
;------------------------------------------------------------------------
					mov		edx, OFFSEt intro_2
					call	WriteString
					call	CrLf
;------------------------------------------------------------------------
					mov		edx, OFFSET intro_3
					call	WriteString
					call	CrLf
;------------------------------------------------------------------------
					mov		edx, OFFSET intro_4
					call	WriteString
					call	CrLf
					ret
intro ENDP
;------------------------------------------------------------------------
;							getUserData									;
; This procedure prompts the user to enter a number of random integers	;
; to be generated and loops until the user enters a number within range	;
; of 10 to 200. The verified number is stored within the numsGenerated	;
; variable.	If the user enters a number out of range, an error message	;
; is displayed and the user is prompted to try again.					;
;------------------------------------------------------------------------
getUserData	PROC	; Set up the stack and begin the loop for receiving the user's input.
;------------------------------------------------------------------------
					push	ebp
					mov		ebp, esp
					mov		ebx, [esp+8]
					; Begin loop after the stack is set to avoid errors.
;------------------------------------------------------------------------
;							inputValidation								;
; inputValidation uses one parameter, the user's input, from the EAX	;
; Register and validates whether or not it is within range. If the		;
; number is out of range, an error message is displayed.				;
;------------------------------------------------------------------------
userInputLoop:
					mov		edx, OFFSET prompt_1							; Move the offset into the EDX register.
					call	WriteString										; Print prompt_1 to the screen.
					call	ReadInt											; Wait for the user's input.
					cmp		eax, MIN_NUM_TERMS
					jl		rangeErrorMsg
					cmp		eax, MAX_NUM_TERMS
					jg		rangeErrorMsg
					jmp		inputValidated									; Once the number is generated, exit loop.
;------------------------------------------------------------------------
rangeErrorMsg:		; If the user's not in range:
;------------------------------------------------------------------------
					; Set the text color to light red.
					mov		eax, lightRed									; Move the offset into the EAX register.
					call	setTextColor									; Change the text color to light red.
					mov		edx, OFFSET rangeError							; Move the offset into the EDX register.
					call	WriteString										; Call WriteString to display highError to the screen.
					; Set the text color back to light green.
					mov		eax, lightGreen									; Move the offset into the EAX register.
					call	setTextColor									; Change the text color to light green.
					call	CrLf											; Write an end-of-line sequence to the console window.
					jmp		userInputLoop
;------------------------------------------------------------------------
; The user's input has been validated so restore the stack:
;------------------------------------------------------------------------
inputValidated:
					mov		[ebx], eax
					pop		ebp												; Return EBP to old EBP.
					ret		4												; Return stack to original state.
getUserData	ENDP
;------------------------------------------------------------------------
;							fillArray									;
; fillArray can reference our array without knowing its name. It also	;
; uses register indirect addressing to fill the array with the random	;
; numbers we've generated. This code has been borrowed from lectures 19	;
; and 20.																;
;------------------------------------------------------------------------
fillArray PROC
;------------------------------------------------------------------------
					push	ebp
					mov		ebp, esp
					mov		edi, [ebp+12]									; Address of the array in the EDI register.
					mov		ecx, [ebp+8]									; Contains the value of count in the ECX register.
;------------------------------------------------------------------------
continueFill:		; Continue filling array until the array is full.
;------------------------------------------------------------------------
					mov		eax, UPPER_LIMIT								; Move UPPER_LIMIT into the EAX register.
					sub		eax, LOWER_LIMIT								; Subtract the LOWER_LIMIT from the UPPER_LIMIT. (999 - 100 = 899)
					inc		eax												; And increment the EAX register by one to get the range 100-999.
					call	RandomRange										; Call RandomRange to set the range for the program.
					add		eax, LOWER_LIMIT
					mov		[edi], eax										; Move the generated number into the array.
					add		edi, 4											; Increment EDI, moving to the next spot in the array.
					loop	continueFill									; Repeat the loop until full.
					pop		ebp
					ret		8												; Restore stack to original state.
fillArray ENDP
;------------------------------------------------------------------------
;							displayList									;
; The displayList procedure prints the contents of the array, 10		;
; numbers per row. This code is based on the code presented in Lecture	;
; 20 and has been modified to print prompts and limit the number of		;
; integers printed to 10 per row.										;
;------------------------------------------------------------------------
displayList PROC	; Set up the stack frame.
;------------------------------------------------------------------------
					push	ebp												; set up stack frame. Old ebp to stack. +4 to others.
					mov		ebp, esp										; now pointing at same
					mov		esi, [ebp+16]									; address of array
					mov		ecx, [ebp+12]									; amount to print to ecx loop
;------------------------------------------------------------------------
; Print prompt.
;------------------------------------------------------------------------
					call	CrLf
					mov		edx, [ebp+8]									; location of the global string on stack
					call	WriteString										; print
					call	CrLf
;------------------------------------------------------------------------
printCurrentNumber:
;------------------------------------------------------------------------
					inc		rowCount										; Increment rowCount to track number of integers printed per row.
					cmp		rowCount, 10									; Compare 10 to rowCount.
					jg		newRow											; If rowCount > 10, jump to newRow identifier to start a new row.
					mov		eax, [esi]										; Else (if rowCount < 10), get the current element of the array.
					call	WriteDec										; Print the number.
					mov		edx, OFFSET spaces								; Move the offset into the EDX register.
					call	WriteString										; Print five spaces.
					add		esi, 4											; Increment ESI by 4 to move to the next element.
					loop	printCurrentNumber								; Continue looping while there are more numbers to be placed.
					jmp		Finished										; jump to skip the creation of a new row
;------------------------------------------------------------------------
newRow:				; Print a new row.
;------------------------------------------------------------------------
					call	CrLf											; Call CrLf to make a new row.
					mov		rowCount, 0										; Reset rowCount.
					jmp		printCurrentNumber								; Jump back to printCurrentNumber
;------------------------------------------------------------------------
Finished:			; Clear the stack.
;------------------------------------------------------------------------
					pop		ebp												; Pop what's been pushed.
					ret		12												; Return the bytes that were pushed before the procedure was called.
displayList ENDP
;------------------------------------------------------------------------
;							sortList									;
; The sortList procedure sorts the contents of array full of random		;
; integers by receiving parameters from the system stack in order. This	;
; procedure uses the BubbleSort algorithm provided with the Irvine		;
; library and also found on page 375 of the textbook, only it has been	;
; modified to print the number in descending order instead of ascending ;
; order.																;
;------------------------------------------------------------------------
; This procedure mimics the following code:
;for(k=0; k<request-1; k++) {
;    i = k;
;    for(j=k+1; j<request; j++) {
;        if(array[j] > array[i])
;        i = j;
;    }
;    exchange(array[k], array[i]);
;}
;------------------------------------------------------------------------
sortList PROC
;------------------------------------------------------------------------
					push	ebp												
					mov		ebp, esp										
					mov		ecx, [ebp+8]									
					dec		ecx
;------------------------------------------------------------------------
L1:					; for(k=0; k<request-1; k++) {
;------------------------------------------------------------------------
					push	ecx												; Save outer loop to the stack.
					mov		esi, [ebp+12]									; @array
;------------------------------------------------------------------------
L2:					; for(j=k+1; j<request; j++) {
;------------------------------------------------------------------------
					mov		eax, [esi]										; Contents in that element of the array
					cmp		[esi +4], eax									; Compare the current value to next value.
					jl		L3												; If the next value is < than the current value, jump to L3.
					xchg	eax, [esi+4]									; Swap the values.
					mov		[esi], eax										; And save it to the current position in the array.
;------------------------------------------------------------------------
L3:					; Continue until finished.
;------------------------------------------------------------------------
					add		esi, 4											; Increment ESI to move to the next element.
					loop	L2												; Inner Loop.
;------------------------------------------------------------------------
; Return to the outer loop.
;------------------------------------------------------------------------
					pop		ecx												; Restore the outer loop.
					loop	L1												; Repeat the outer loop.
;------------------------------------------------------------------------
					pop		ebp												; Pop pushed values.
					ret		8												; Restore the stack to its original state.
sortList ENDP
;------------------------------------------------------------------------
;							displayMedian								;
; The displayMedian procedure receives parameters from the system stack	;
; in order to calculate the median of the numbers generated and display	;
; them to the console. If the array contains an odd number of elements,	;
; the middle number is display. However, if the array contains an even	;
; number of elements, the average of those two values is calculated and ;
; displayed instead.													;
;------------------------------------------------------------------------
displayMedian PROC
					push	ebp												
					mov		ebp, esp										; Save old EBP on to the system stack.
					mov		esi, [ebp+12]									; Move the address of the array to the ESI register.
					mov		eax, [ebp+8]									; The number of elements to put in to the EAX register.
					mov		edx, 0											; Reset the EDX register by making it 0.
;------------------------------------------------------------------------
; Begin calculating the median first by finding the middle of the array:
;------------------------------------------------------------------------					
					mov		ebx, 2											; Move 2 into the EBX register to prepare to:
					div		ebx												; Divide the array in half (EAX / EBX).
					cmp		edx, 0											; If the remainder == 0, the array has an even number of elements.
					je		findMedian										; So jump to find the average between the two array numbers in the middle.
;------------------------------------------------------------------------
; Determine the middle of the array.
;------------------------------------------------------------------------
					mov		ebx, 4											; Move 4 into the EBX register.
					mul		ebx												; Multiply by 4 to get the location in array.
					add		esi, eax										; EAX = the location in the array + ESI = @array
					mov		eax, [esi]										; There's no remainder so move the value in the ESI register into the EAX register.
;------------------------------------------------------------------------
; Display the median.
;------------------------------------------------------------------------
					call	CrLf
					call	CrLf
					mov		edx, OFFSET results_2							; Move the offset into the EDX register.
					call	WriteString										; Print "the median is" to the screen.
					call	WriteDec										; Print the median.
					mov		edx, OFFSET period								; Move the offset into the EDX register.
					call	WriteString										; Print "."
					call	CrLf
					jmp		Finished										; Exit loop.
;------------------------------------------------------------------------
findMedian:			; The number of elements is even:
;------------------------------------------------------------------------
					mov		ebx, 4											; Find @higher position.
					mul		ebx												; Multiply by 4 because of DWORD byte size.
					add		esi, eax										; EAX = the location in the array + ESI = @array
					mov		edx, [esi]										; Store the value.
;------------------------------------------------------------------------
; Find the lower position's address location.
;------------------------------------------------------------------------
					mov		eax, esi										; @higher positon
					sub		eax, 4											; Move down one address by subtracting 4 (because of DWORD).
					mov		esi, eax										; This is the new address location in the ESI register.
					mov		eax, [esi]										; Store the value.
;------------------------------------------------------------------------		
; Find the average of the two middle values. (Odd number of elements)
;------------------------------------------------------------------------
					add		eax, edx										; Add the two values together.
					mov		edx, 0											; Reset the EDX register before dividing.
					mov		ebx, 2											; Move 2 to EBX to divide in half.
					div		ebx												; EAX / EBX (Divide the sum stored in the EAX by 2, i.e. in half)
;------------------------------------------------------------------------
; Display the median.
;------------------------------------------------------------------------
					call	CrLf
					call	CrLf
					mov		edx, OFFSET results_2							; Move the offset into the EDX register.
					call	WriteString										; Print "the median is" to the screen.
					call	WriteDec										; Print the median.
					mov		edx, OFFSET period
					call	WriteString
					call	CrLf	
;------------------------------------------------------------------------
Finished:			; Clear the stack and return to original state.
;------------------------------------------------------------------------
					pop		ebp
					ret 8
displayMedian ENDP

END main
