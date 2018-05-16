TITLE Programming Assignment #3    (Project03.asm)

; Author: Tristan Santiago
; Last Modified: May 3, 2018
; OSU email address: santiatr@oregonstate.edu
; Course number/section: CS271_400
; Project Number: 03               Due Date: May 6, 2018
; Description: This program prompts the user to enter integers within the range of -100 to -1. It continues accepting
; integers until the user enters a non-negative integer. After validating the numbers to be within range, the program
; calculates the sum of the integers, the average, displays how many integers were entered and displays a farewell message.

INCLUDE Irvine32.inc
;------------------------------------------------------------------------
; Constants
;------------------------------------------------------------------------
LOWER_LIMIT = -100										; Constant lower limit value.
;------------------------------------------------------------------------
.data
;------------------------------------------------------------------------
welcome_1		BYTE		"Welcome to the Integer Accumulator by Tristan Santiago", 0
welcome_2		BYTE		"What's your name? ", 0
welcome_3		BYTE		"Hello, ", 0
userName		BYTE		33 DUP(0)					; String to be entered by user.
prompt_1		BYTE		"Please enter numbers in [-100, -1].", 0
prompt_2		BYTE		"Enter a non-negative number when you are finished to see results.", 0
prompt_3		BYTE		". Enter number: ", 0
prompt_4		BYTE		"You entered ", 0
prompt_5		BYTE		" valid numbers.", 0
period			BYTE		".", 0						; Punctuation mark.
userInt			DWORD		?							; Variable used to store the user's integers.
zeroErrorMsg	BYTE 		"Invalid Input. Cannot divide by zero.", 0
;------------------------------------------------------------------------
; Results
;------------------------------------------------------------------------
sum_prompt		BYTE		"The sum if your valid numbers is ", 0
avg_prompt		BYTE		"The rounded average is ", 0
sum				DWORD		0							; Sum stored here.
average			DWORD		0							; Average stored here.
quotient		DWORD		?							; Quotient stored here.
remainder		DWORD		?							; Remainder stored here.
goodBye			BYTE		"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0				; Farewell message.
;------------------------------------------------------------------------
; Validation Variables
;------------------------------------------------------------------------
highError		BYTE		"Out of range. Enter a number in [-100, -1] ", 0		; Error message for user entering a number above the upper limit.
lowError		BYTE		"Out of range. Enter a number in [-100, -1] ", 0		; Error message for user entering a number below the lower limit.

specialMessage	BYTE		"Uh, oh. Looks like you didn't enter any negative integers. Exiting.", 0
;------------------------------------------------------------------------
; Extra Credit
;------------------------------------------------------------------------
ECprompt_1		BYTE		"**EC: This program numbers the lines during user input.", 0
ECprompt_2		BYTE		"**EC: This program calculates and display the average as a floating-point number, rounded to the nearest .001.", 0
lineCount		DWORD		?							; Variable used to display line numbers to count the user's integers.
EC2string		BYTE		"Quotient as a floating-point value, rounded to the nearest .001: ", 0
oneThousand		DWORD		1000						; Variable used to convert an integer to a floating point number rounded to .001.
neg1k			DWORD		-1000						; Variable used to convert an integer to a floating point number rounded to .001.
ECremainder		DWORD		?							; Variable for floating point integer creation.
decimal			BYTE		".",0						; Variable serves as the decimal place of a floating point number.
mantissa		DWORD		?							; Mantissa of floating-point quotient.
subtractor		DWORD		?							; Variable used in the calculation of the floating point number.
floating_point	DWORD		?							; Variable used in the calculation of the floating point number.
.code
;------------------------------------------------------------------------
main PROC
;------------------------------------------------------------------------
				; Setting things up.
				mov		eax, lightGreen										; Move lightGreen into the EAX register.
				call	setTextColor										; Set the text color to light green.
;------------------------------------------------------------------------
; Display extra credit descriptions.
;------------------------------------------------------------------------
				mov		edx, OFFSET ECprompt_1								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display ECprompt_1 to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
				mov		edx, OFFSET ECprompt_2								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display ECprompt_2 to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
;------------------------------------------------------------------------
; Display the program title and programmer's title.
;------------------------------------------------------------------------
				call	CrLf												; Write an end-of-line sequence to the console window.
				mov		edx, OFFSET welcome_1								; Move the offset into the EDX register.
				call	WriteString											; Call WriteSting to display welcome_1 to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
				mov		edx, OFFSET welcome_2								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display welcome_2 to the screen.
				mov		edx, OFFSET userName								; Move the offset into the EDX register to store user's name.
				mov		ecx, 32												; Set the max number of characters for the user's name to 32.
				call	ReadString											; Wait for user's input.
				mov		edx, OFFSET welcome_3								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display welcome_3 to the screen.
				mov		edx, OFFSET	userName								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display userName to the screen.
				mov		edx, OFFSET period									; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display "." to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
				call	CrLf												; Write an end-of-line sequence to the console window.
;------------------------------------------------------------------------
; Display the program's instructions to the user.
;------------------------------------------------------------------------
				mov		edx, OFFSET prompt_1								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display prompt_1 to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
				mov		edx, OFFSET prompt_2								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display prompt_2 to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
				mov		eax, 0												; Initialize accumulator.
				mov		lineCount, 1										; lineCount = 1
;------------------------------------------------------------------------
prompt:
;------------------------------------------------------------------------
				mov		eax, lineCount										; Move lineCount into the EAX register.
				call	WriteDec											; Print lineCount to the screen.
				mov		edx, OFFSET prompt_3								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display prompt_3 to the screen.
				call	ReadInt												; Wait for user's input.
;------------------------------------------------------------------------
; Validate the user's integers.
;------------------------------------------------------------------------
				cmp		eax, 0												; Compare the user's input to 0.
				jge		results												; If the user enters a number > zero, end the loop and jump to results.
				cmp		eax, LOWER_LIMIT									; Compare the number of terms to the lower limit.
				jl		tooLow												; If the number of terms < the lower limit, jump to the tooLow identifier.
;------------------------------------------------------------------------
; Add each valid number to the sum.
;------------------------------------------------------------------------
				mov		userInt, eax										; Move the value of the EAX register into userInt.
				add		sum, eax											; Add the value in the EAX register to the sum.
				inc		lineCount											; Increment lineCount.
				loop	prompt												; Continue to loop until the user enters a non-negative value.
;------------------------------------------------------------------------
results:
;------------------------------------------------------------------------
				call	CrLf
				call	CrLf
				cmp		sum, 0												; Compare the sum to 0.
				je		spMsg												; If sum = 0, jump to spMsg identifier, as user didn't enter any integers.
				dec		lineCount											; Decrement lineCount.
				mov		edx, OFFSET prompt_4								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to write prompt_4 to the screen.
				mov		eax, lineCount										; Copy lineCount into the EAX register.
				call	WriteDec											; Print lineCount to the screen.
				mov		edx, OFFSET prompt_5								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display prompt_5 to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
				mov		edx, OFFSET sum_prompt								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display sum_prompt to the screen.
				mov		eax, sum											; Copy the value of sum into the EAX register.
				call	WriteInt											; Print the sum to the screen.
				mov		edx, OFFSET period									; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display "." to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
;------------------------------------------------------------------------				
; Calculate the average.
;------------------------------------------------------------------------
				mov		edx, 0												; Move 0 into the EAX register.
				mov		eax, sum											; Move the first integer into the EAX register. 
				cdq															; EDX:EAX = sign-extend of EAX. (First integer)
				mov		ebx, lineCount										; Move lineCount into the EBX register.
				cmp		ebx, 0												; Check for division by zero.
				je		zeroError											; If the second integer is zero, jump to the zeroError identifier.
				cdq															; EDX:EAX = sign-extend of EAX. (Second integer)
				idiv	ebx													; Divide the two integers.
				mov		quotient, eax										; Store the quotient of the two integers into the quotient variable.
				mov		remainder, edx										; Store the value remaining in the EDX into the remainder variable.
				mov		edx, OFFSET avg_prompt								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display avg_prompt to the screen.
				mov		quotient, eax										; Copy the value in the EAX register into the quotient.
				call	WriteInt											; Print the quotient to the screen.
				mov		edx, OFFSET period									; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display "." to the screen.
;------------------------------------------------------------------------
; Extra Credit Floating Point calculations:
;------------------------------------------------------------------------
				call	CrLf												; Write an end-of-line sequence to the console window.
				mov		eax, remainder										; Copy the value stored in remainder to the EAX register.
				mul		neg1k												; Multiply EAX by -1000.
				mov		remainder, eax										; Copy the value in the EAX register to remainder.
				mov		eax, linecount										; Copy the value of lineCount into the EAX register.
				mul		oneThousand											; Multiply EAX by 1000.
				mov		subtractor, eax										; Copy the value of the EAX register into subtractor.
				fld		remainder											; Push remainder onto the FPU register stack.
				fdiv	subtractor											; Divide the destination operand by subtractor.
				fimul	oneThousand											; Multiply ECX by 1000, return the product to the ECX register.
				frndint														; Round to integer.
				fist	floating_point										; Convert value to signed integer & transfer the result to ECX register.
				mov		eax, floating_point									; Copy the value of floating_point into the EAX register.
				mov		mantissa, eax										; Copy the value of the EAX register into mantissa.
				mov		edx, OFFSET EC2String								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display EC2String to the screen.
				mov		eax, quotient										; Move the quotient into the EAX register.
				call	WriteInt											; Print the quotient to the screen.
				mov		edx, OFFSET decimal									; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display "." to the screen.
				mov		eax, mantissa										; Move the mantissa into the EAX register.
				call	WriteDec											; Print the mantissa to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
				jmp		farewell											; Jump to the farewell identifier.
;------------------------------------------------------------------------
spMsg:			; If the user doesn't enter any negative integers:
;------------------------------------------------------------------------
				call	CrLf												; Write an end-of-line sequence to the console window.
				mov		edx, OFFSET specialMessage							; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display specialMessage to the screen.
				call	CrLf												; Write an end-of-line sequence to the console window.
				jmp		farewell											; Jump to the farewell identifier.
;------------------------------------------------------------------------
tooLow:			; If the user's number of terms < the lower limit:
;------------------------------------------------------------------------
				; Set the text color to light red.
				mov		eax, lightRed										; Move the offset into the EAX register.
				call	setTextColor										; Change the text color to light red.
				mov		edx, OFFSET lowError								; Move the offset into the EDX register.
				call	WriteString											; Call WriteString to display lowError to the screen.
				; Set the text color back to light green.
				mov		eax, lightGreen										; Move the offset into the EAX register.
				call	setTextColor										; Change the text color to light green.
				call	CrLf												; Write an end-of-line sequence to the console window.
				jmp		prompt												; Jump to the displayFibs identifier.
;------------------------------------------------------------------------
zeroError:
;------------------------------------------------------------------------
				; Error message for trying to divide by zero.
				mov 		edx, OFFSET zeroErrorMsg						; Move the offset into the EDX register.
				call 		WriteString										; Call WriteString to display the zeroErrorMsg to the screen.
				call 		CrLf											; Call Carriage Return Line Feed to skip to the next line.
				jmp			farewell										; Jump to the Display identifier.
;------------------------------------------------------------------------
farewell:
;------------------------------------------------------------------------
					call	CrLf											; Write an end-of-line sequence to the console window.
					call	CrLf											; Write an end-of-line sequence to the console window.
					mov		edx, OFFSET goodBye								; Move the offset into the EDX register.
					call	WriteString										; Call WriteString to display goodBye to the screen.
					mov		edx, OFFSET userName							; Move the offset into the EDX register.
					call	WriteString										; Call WriteString to display userName to the screen.
					mov		edx, OFFSET period								; Move the offset into the EDX register.
					call	WriteString										; Call WriteString to display "." to the screen.
					call	CrLf											; Write an end-of-line sequence to the console window.

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
