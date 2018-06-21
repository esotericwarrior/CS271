TITLE Program Template     (Project06.asm)

; Author: Tristan Santiago
; Last Modified: 6/21/18
; OSU email address: santiatr@oregonstate.edu
; Course number/section: CS271_400
; Project Number: 06              Due Date: 6/10/18
; Description: This program prompts the user to enter 10 integers, validates those integers, calculates the sum and average, and displays the results.
;------------------------------------------------------------------------
; Problem Definition:
;------------------------------------------------------------------------
; Implement and test your own ReadVal and WriteVal procedures for unsigned integers.
; Implement macros getString and displayString. The macros may use Irvine’s ReadString to get input from the user, and WriteString to display output.
; getString should display a prompt, then get the user’s keyboard input into a memory location
; displayString should print the string which is stored in a specified memory location.
; readVal should invoke the getString macro to get the user’s string of digits.
; It should then convert thedigit string to numeric, while validating the user’s input.
; writeVal should convert a numeric value to a string of digits, and invoke the displayString macro toproduce the output.
; Write a small test program that gets 10 valid integers from the user and stores the
;------------------------------------------------------------------------
INCLUDE Irvine32.inc
;------------------------------------------------------------------------
; Constant definitions
;------------------------------------------------------------------------
TOTAL_NUM = 10																; Max number of integers to be received from the user.
ARRAYSIZE		EQU		10													; Max number of integers to be stored in the array.
;------------------------------------------------------------------------
; Macro: getString														;
; Description: This macro uses ReadString to get input from the user	;
; and stores the user's input into a memory location. This code is		;
; borrowed from lecture 26 and page 415 in the textbook.				;
; Parameters: address, length											;
;------------------------------------------------------------------------
getString			MACRO	address, length
					push	edx												; Save EDX register.
					push	ecx												; Save ECX register.
					mov		edx, address									; Set up to call ReadString.
					mov		ecx, length										; Set up to call ReadString.
					call	ReadString										; Call ReadString procedure.
					pop		ecx												; Restore ECX register.
					pop		edx												; Restore EDX register.
ENDM
;------------------------------------------------------------------------
; Macro: displayString													;
; Description: This macro is borrowed from lecture 26. It simplifies	;
; the Irvine WriteString procedure so that it is easier to call in Main.;
; Parameters: string													;
;------------------------------------------------------------------------
displayString		MACRO	string
					push	edx
					mov		edx, OFFSET string
					call	WriteString
					pop		edx
ENDM
;------------------------------------------------------------------------
.data
;------------------------------------------------------------------------
intro_1				BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
intro_2				BYTE	"Written by: Tristan Santiago", 0
intro_3				BYTE	"Please provide 10 unsigned decimal integers.", 0
intro_4				BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
intro_5				BYTE	"After you have finished inputting the raw numbers, I will display a list ", 0
intro_6				BYTE	"of the integers, their sum, and their average value.", 0
;------------------------------------------------------------------------
prompt_1			BYTE	"Please enter an unsigned number: ", 0
prompt_2			BYTE	"You entered the following numbers: ", 0
prompt_3			BYTE	"The sum of these numbers is: ", 0
prompt_4			BYTE	"The average is: ", 0
comma				BYTE	", ", 0
period				BYTE	".", 0
;------------------------------------------------------------------------
buffer				BYTE	255 DUP(0)										; Character buffer.
userString			BYTE	32	DUP(?)										; 32-bit number.
numCount			DWORD	10												; Number of unsigned integers to get from the user.
array				DWORD	10	DUP(0)										; Array to hold user's integers, initialized to 0, max 10.
sum					DWORD	?												; Variable used to hold the sum of user's integers.
average				DWORD	?												; Variable used to hold the average of user's integers.
;------------------------------------------------------------------------
; Validation Variables
;------------------------------------------------------------------------
rangeError			BYTE	"ERROR: You did not enter an unsigned number or your number was too big", 0
rangeErrorMsg		BYTE	"Please try again: ", 0							; Generic error message for being out of range (ASCII 0-9).
test_finished		BYTE	"Finished.", 0									; Testing error message.
;------------------------------------------------------------------------
; Extra Credit Variables
;------------------------------------------------------------------------
EC_prompt1			BYTE	"**EC: This program numbers each line of the user's input and displays a running subtotal of the user’s numbers.", 0
EC_prompt2			BYTE	"**EC: The ReadVal and WriteVal procedures handle floating point values.", 0
runningTotal		DWORD	?												; Variable used to hold the running total of user's integers.
runningTotalMsg		BYTE	"Running subtotal: ", 0							; Running total display message.
changeFloat			REAL8	0.00											; Variable used to change numbers to floats.
round1				REAL8	1000.0											; Variable used to round the float to integer.
round2				REAL8	1000.0											; Variable used to return back into float with division when rounding.
userFloat1			REAL8	?												; Variable used to hold the float of user's integers.
remainder			REAL8	?												; Variable used to hold the float version of remainder.
dividend			DWORD	10												; Variable used to hold dividend.
roundedAverage		BYTE	"The average rounded down is: ", 0				; Rounded results message.
floatResult			BYTE	"The average is: ", 0							; Average results message.
lineCount			DWORD	1												; Variable used to track line numbers while receiving user's integers.
space				BYTE	" ", 0											; Space used for formatting line numbers.
.code
main PROC
;------------------------------------------------------------------------
call	introduction	; Introduce program and programmer.
;------------------------------------------------------------------------
					mov		ecx, TOTAL_NUM									; Loop counter = 10.
					mov		edi, OFFSET array								; Array to be stored in EDI. (Start of the array)
;------------------------------------------------------------------------
getUserInput:		; Begin accepting integers from the user.
;------------------------------------------------------------------------
					mov		eax, lineCount									; Move lineCount (1) into the EAX register.
					push	eax												; Push EAX (1) onto the system stack.
					push	OFFSET userString								; Push userString onto the system stack.
					call	WriteVal										; Call WriteVal to print line numbers for each loop iteration.
					displayString	period									; Print "."
					displayString	space									; Print " "
					displayString	prompt_1								; Print prompt_1.
					push	OFFSET buffer									; Push @buffer on to the system stack.
					push	SIZEOF buffer									; Push sizeof buffer on to the system stack.
					call	ReadVal											; Call ReadVal procedure.
					push	runningTotal									; Push runningTotal onto the system stack.
					push	OFFSET userString								; Push userString on to the system stack to call WriteVal.
					displayString	runningTotalMsg							; Display running total message.
					call	WriteVal										; Call WriteVal procedure to print the running total.
					call	CrLf											; Carriage Return Line Feed.
					inc		lineCount										; Increment line count.
;------------------------------------------------------------------------			
					mov		eax, DWORD PTR buffer							; Go to the next element in the array.
					mov		[edi], eax										; Move value in the EAX register into the EDI register.
					add		edi, 4											; Increment by 4 to move to the next element of array (DWORD).
;------------------------------------------------------------------------				
					loop	getUserInput									; Loop if the user has not entered 10 integers.
;------------------------------------------------------------------------
; Set loop controls and begin displaying integers entered into array.
;------------------------------------------------------------------------
					mov		ecx, TOTAL_NUM									; ECX = 10.
					mov		esi, OFFSET array								; ESI points to @array.
					mov		ebx, 0											; For calculating sum
;------------------------------------------------------------------------
					displayString	prompt_2								; Print prompt 2.
;------------------------------------------------------------------------
calculate_sum:
					mov		eax, [esi]										; Move the next number in the array to the EAX register.
					add		ebx, eax										; Add current number in the EAX register to the current sum.
;------------------------------------------------------------------------
					push	eax												; Push the EAX register onto the stack for calculating the sum.
					push	OFFSET userString								; Push address of userString onto the stack.
					call	WriteVal										; Call WriteVal procedure.
					cmp		ecx, 1											; Check the number of integers printed.
					je		noComma											; If the number of integers printed is 10, don't print a comma.
					jg		printComma										; If the number of integers printed is less than 10, print a comma.
;------------------------------------------------------------------------
printComma:					
;------------------------------------------------------------------------
					displayString	comma									; Print a comma.
					jmp		skip											; Continue processing integers.
;------------------------------------------------------------------------
noComma:
;------------------------------------------------------------------------
					jmp		skip											; Print nothing and continue processing integers.
;------------------------------------------------------------------------
skip:	
;------------------------------------------------------------------------
					add		esi, 4											; Move to the next element in the array.
					loop	calculate_sum									; Loop while there are still numbers to add.
;------------------------------------------------------------------------
					displayString	period									; Print "."
					call	CrLf
;------------------------------------------------------------------------
					push	OFFSET array									; Push @array on to the system stack.
					push	ARRAYSIZE										; Push ARRAYSIZE on to the system stack.
					push	sum												; Push sum on to the system stack.
					call	calculateSum									; Call calculateSum procedure.
;------------------------------------------------------------------------					
					push	sum												; Push sum on to the system stack.
					push	ARRAYSIZE										; Push ARRAYSIZE on to the system stack.
					call	calculateAvg									; Call calculateAvg procedure.
					call	CrLf
					exit													; Exit to the operating system.
main ENDP
;------------------------------------------------------------------------
;							introduction								;
; This procedure displays the programmer's name and prints a brief		;
; description of the program.											;
;------------------------------------------------------------------------
;------------------------------------------------------------------------
introduction PROC
;------------------------------------------------------------------------
					displayString	intro_1									; Print intro_1.
					call	CrLf
					displayString	intro_2									; Print intro_2.
					call	CrLf
					call	CrLf
					displayString	intro_3									; Print intro_3.
					call	CrLf
					displayString	intro_4									; Print intro_4.
					call	CrLf
					displayString	intro_5									; Print intro_5
					call	CrLf
					displayString	intro_6									; Print intro_6.
					call	CrLf
					displayString	EC_prompt1
					call	CrLf
					displayString	EC_prompt2
					call	CrLf
					ret
introduction ENDP
;------------------------------------------------------------------------
;								readVal									;
; readVal should invoke the getString macro to get the user’s string of	;
; digits. It should then convert thedigit string to numeric, while		;
; validating the user’s input.											;
;------------------------------------------------------------------------
readVal	PROC
;------------------------------------------------------------------------
					push	ebp												; [ESP]
					mov		ebp, esp										; [ESP+4]
					pushad													; Push the contents of the registers onto the stack.
;------------------------------------------------------------------------
start:
;------------------------------------------------------------------------
					mov		edx, [EBP+12]									; Move the address of buffer [ESP+12] into the EDX register
					mov		ecx, [EBP+8]									; Move the size of buffer [ESP+8] into the ECX register.
;------------------------------------------------------------------------					
again:				getString edx, ecx										; Call getString and send the EDI and ECX registers as parameters.
;------------------------------------------------------------------------
					mov		esi, edx										; The EDX register holds the address, so move it into the ESI register.
					mov		eax, 0											; Reset the EAX register to prepare for the user's input.
					mov		ecx, 0											; Reset the ECX register.
					mov		ebx, 10											; Move 10 into the EBX register.
;------------------------------------------------------------------------
loadStringByte:		; Start loading the string, one character at a time.				
;------------------------------------------------------------------------
					lodsb													; Loads from the memory at ESI.
					cmp		eax, 0											; Check for null terminator to see if we've reached the end of the string.
					je		done											; If EAX == 0, we've reached the end of the string, so we're finished.					
;------------------------------------------------------------------------
inputValidation:	; Verify that the user's input is within range.
;------------------------------------------------------------------------
					cmp		eax, 48											; User's input is ASCII string before converted, so compare to "0" in ASCII (48).
					jl		invalidInput									; If the ASCII value is less than 48, it is not a digit, and out of range.
					cmp		eax, 57											; User's input is ASCII string before converted, so compare to "9" in ASCII (57).
					jg		invalidInput									; If the ASCII value is greater than 57, it is not a digit, and out of range.
;------------------------------------------------------------------------
;					Begin calculation for conversion.
;------------------------------------------------------------------------
					sub		eax, 48											; Subtract 48 from user's validated input to convert the ASCII value to integer.
					xchg	eax, ecx
					mul		ebx												; Multiply by 10 for correct digit placement.
					jc		invalidInput									; Jump if carry flag set.
					jnc		continue										; Jump if carry flag is not set.
;------------------------------------------------------------------------
invalidInput:		; User's input out of range.
;------------------------------------------------------------------------
					displayString	rangeError								; Print error message.
					call	CrLf											; New line.
					displayString	rangeErrorMsg							; Print error message.
					jmp		start											; Jump back to the start of the loop.
;------------------------------------------------------------------------
continue:			; When finished converting or when carry flag is not set:		
;------------------------------------------------------------------------
					add		eax, ecx										; Adding ECX to EAX keeps running total of the sum of user's integers.
					xchg	eax, ecx										; Exchange EAX and ECX register to prepare for the next iteration of the loop.
					jmp		LoadStringByte									; Jump to identifier to begin parsing the next byte of the user's string.
;------------------------------------------------------------------------
done:				; Before proceeding to the next value:
;------------------------------------------------------------------------
					add		runningTotal, ecx								; The ECX register holds the current sum, so store in the runningTotal variable.
					xchg	ecx, eax										; Exchange contents of ECX and EAX registers.
					mov		DWORD PTR buffer, eax							; Save the user's integer in passed variable.					
					popad													; Pop all general registers.
					pop ebp													; Restore EBP.
					ret 8													; Restore system stack.
readVal	ENDP
;------------------------------------------------------------------------
; writeVal should convert a numeric value to a string of digits, and	;
; invoke the displayString macro toproduce the output.					;
;------------------------------------------------------------------------
writeVal PROC		; Set up the system stack.
;------------------------------------------------------------------------
					push	ebp												; [ESP]
					mov		ebp, esp										; [ESP+4]
					pushad													; Push the contents of the registers onto the stack.
;------------------------------------------------------------------------
					; Set for looping through the integer
					mov		eax, [ebp+12]									; Move the integer to be converted to string to the EAX register.
					mov		edi, [ebp+8]									; Move @address to the EDI register to store the string.
					mov		ebx, 10											; Loop counter.
					push	0												; Reset.
;------------------------------------------------------------------------
convert:			; Begin converting integers back to string of digits.
;------------------------------------------------------------------------
					mov		edx, 0											; Reset the EDX register to 0.
					div		ebx
					add		edx, 48
					push	edx												; Push the next digit onto the system stack.
					cmp		eax, 0											; Check for null terminator to see if we've reached the end of the string.
					jne		convert											; If we aren't at the end of the string, jump back to the convert identifier.
;------------------------------------------------------------------------
pop_array:
;------------------------------------------------------------------------
					pop		[edi]											; Pop numbers off the stack.
					mov		eax, [edi]										; Move the next integer into the EAX register.
					inc		edi												; Increment EDI to move to the next digit.
					cmp		eax, 0											; Check for null terminator to see if we've reached the end of the string.
					jne		pop_array
;------------------------------------------------------------------------
					mov				edx, [ebp+8]							; Move @address into the EDX register.
					displayString	OFFSET userString						; Call displayString
;------------------------------------------------------------------------
					popad													; Restore general registers.
					pop ebp													; Restore EBP.
					ret 8													; Restore stack. [4+8]

writeVal ENDP
;------------------------------------------------------------------------
calculateSum PROC
;------------------------------------------------------------------------
; Description: This procedure calculates the sum of the user's integers ;
; by using the values in the array. It returns the sum.					;
; Registers Used: EBP, EDI, ECX, EAX.									;
;------------------------------------------------------------------------
;					Setup the system stack.
;------------------------------------------------------------------------
					push	ebp
					mov		ebp, esp
					mov		edi, [ebp+16]
					mov		ecx, [ebp+12]
					mov		ebx, [ebp+8]
;------------------------------------------------------------------------
					calcLoop:
					mov		eax, [edi]										; Move the current array value into the EAX register.
					add		ebx, eax										; Add the current value in the EAX register to the EBX register (sum).
					add		edi, 4											; Increment by 4 for next DWORD in array.
					loop	calcLoop										; Loop until all integers have been added to the sum.
					call	CrLf											; New line.
					displayString	prompt_3								; Print prompt_3.
					mov		eax,	ebx										; The EBX register contains the sum, so move to the EAX register to print.
					;call	WriteDec										; Call WriteDec to print the sum. (Testing)
					push	eax												; The EAX register has the sum, so push the EAX register onto the system stack.
					push	OFFSET userString								; Push @userString onto the system stack.
					call	WriteVal										; Call WriteVal procedure to print the sum.
					call	CrLf											; New line.
					mov		sum,	ebx										; Store the contents of the EBX register (the sum) into the sum variable.
;------------------------------------------------------------------------					
					pop		ebp												; Restore EBP.
					ret		8												; Restore system stack.
calculateSum		ENDP
;------------------------------------------------------------------------
calculateAvg		PROC
;------------------------------------------------------------------------
; Procedure: calculateAvg												;
; Description: This procedure receives the array of integers and the sum;
; calculates the average of the user's integers. It returns the sum and	;
; also gives a float average.											;
; Registers Used: EBP, EDI, ECX, EAX, ESP								;
;------------------------------------------------------------------------
;					Setup the system stack.
;------------------------------------------------------------------------	
					push	ebp
					mov		ebp, esp
					mov		eax, [ebp+12]
					mov		ebx, [ebp+8]
					mov		edx, 0
;------------------------------------------------------------------------
;					Begin converting the calculated average to a float.
;------------------------------------------------------------------------
					fld		changeFloat										; Push 0.00 onto the system stack.
					fiadd	sum												; Add the integer contents of register ECX to stack element 0.
					fstp	userFloat1										; Copy the contents of stack element 0 onto stack element userFloat1 and pop stack element 0.
					fld		userFloat1										; Load stack element userFloat1 onto stack element 0.
					fidiv	dividend										; Integer divide, return register to the ECX register.
					fstp	remainder										; The current value of stack element 0 is copied to remainder.
					fld		remainder										; Load stack element remainder onto stack element 0.
					fmul	round1											; Multiply real and return product to stack element 0.
					frndint													; Round to integer.
					fdiv	round2											; Integer divide.
					fstp    remainder										; The current value of stack element 0 is copied to remainder.
					fld		remainder										; Load stack element remainder onto stack element 0.
					displayString	floatResult								; Print floatResult message.
					call	WriteFloat										; Print float.
					call CrLf												; New line.
					call CrLf												; New line.
					idiv	ebx												; Signed integer divide.
					displayString	roundedAverage							; Print roundedAverage message.
					push	eax												; Rounded average is stored in the EAX register, so push onto the system stack.
					push	OFFSET userString								; Push @userString onto the system stack for WriteVal procedure.
					call	WriteVal										; Call WriteVal procedure to print the rounded average.
					;call	WriteDec										; Print rounded average (testing).
					call	CrLf											; New line.
					call	CrLf											; New line.
;------------------------------------------------------------------------
					pop ebp													; Restore EBP.
					ret 8													; Restore the system stack.
calculateAvg		ENDP
;------------------------------------------------------------------------
END main
