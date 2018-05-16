TITLE Programming Assignment #1     (Project01.asm)

; Author: Tristan Santiago
; Last Modified: April 8, 2018
; OSU email address: santiatr@oregonstate.edu
; Course number/section: CS271_400
; Project Number: 01                Due Date: April 15, 2018
; Description:	This program introduces the programmer (me), displays instructions for the user,
; prompting the user to enter two numbers, calculates the sum, difference, product, (integer)
; quotient, remainder, and then displays a terminating message.

; include standard Irvine library.
INCLUDE Irvine32.inc

;------------------------------------------------------------------------
.data
;------------------------------------------------------------------------
int_1				DWORD	?							; First integer to be entered by the user.
int_2				DWORD	?							; Second integer to be entered by the user.
intro_1				BYTE	"		Elementary Arithmetic by Tristan Santiago", 0
intro_2				BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder. ", 0
prompt_1			BYTE	"First number: ", 0			; Prompt used to get the first integer from the user.
prompt_2			BYTE	"Second number: ", 0		; Prompt used to get the second integer from the user.
yes					DWORD	1							; Variable that checks to see whether or not the user wants to repeat the program.
sum					DWORD	?							; Sum stored here.
quotient			DWORD	?							; Quotient stored here.
remainder			DWORD	?							; Remainder stored here.
plus				BYTE	" + ", 0					; Plus sign.
minus				BYTE	" - ", 0					; Minus sign.
equals				BYTE	" = ", 0					; Equal sign.
times				BYTE	" x ", 0					; Times sign.
space				BYTE	" ", 0						; An empty space to be inserted to improve readability.
dividedby			WORD	246d						; Division symbol.
product				DWORD	?							; Product to be stored here.
difference			DWORD	?							; Difference to be stored here.
rstring				BYTE	" remainder ", 0
zeroErrorMsg		BYTE 	"Invalid Input. Cannot divide by zero.", 0
goodBye				BYTE	"Impressed? Bye!", 0
;------------------------------------------------------------------------
; Extra Credit
;------------------------------------------------------------------------
intro_3				BYTE	"**EC: This program verifies that the second number is less than the first. ", 0
intro_4				BYTE	"**EC: This program also calculates and displays the quotient as a floating-point number, rounded to the nearest .001. ", 0
intro_5				BYTE	"**EC: And finally, this program repeats until the user chooses to quit. ", 0
EC_error			BYTE	"The second number must be less than the first! ", 0
EC2string			BYTE	"Quotient as a floating-point value, rounded to the nearest .001: ", 0
quit				BYTE	"Would you like to continue? (Yes = 1 / No = 0) ", 0
oneThousand			DWORD	1000						; Variable used to convert an integer to a floating point number rounded to .001.
ECremainder			DWORD	?							; Variable for floating point integer creation.
decimal				BYTE	".",0						; Variable serves as the decimal place of a floating point number.
mantissa			DWORD	?							; Mantissa of floating-point quotient.

.code
;------------------------------------------------------------------------
main PROC
;------------------------------------------------------------------------

; Introduction
	mov		edx, OFFSET intro_1							; Move the offset into the EDX register.
	call	WriteString									; WriteString will display the text as it's stored in memory.
	call	CrLf										; Call Carriage Return Line Feed to skip to the next line.
	mov		edx, OFFSET intro_2							; Move the offset into the EDX register.
	call	WriteString									; WriteString will display the text as it's stored in memory.
	call	CrLf										; Call Carriage Return Line Feed to skip to the next line.
	mov		edx, OFFSET intro_3							; Move the offset into the EDX register.
	call	WriteString									; WriteString will display the text as it's stored in memory.
	call	CrLf										; Call Carriage Return Line Feed to skip to the next line.
	mov		edx, OFFSET intro_4							; Move the offset into the EDX register.
	call	WriteString									; WriteString will display the text as it's stored in memory.
	call	CrLf										; Call Carriage Return Line Feed to skip to the next line.
	mov		edx, OFFSET intro_5							; Move the offset into the EDX register.
	call	WriteString									; WriteString will display the text as it's stored in memory.
	call	CrLf										; Call Carriage Return Line Feed to skip to the next line.
	call	CrLf										; Call Carriage Return Line Feed to skip to the next line.
	
; Begin the While Loop here:
whileLoop:
;------------------------------------------------------------------------
; Get the data
;------------------------------------------------------------------------
	; Get the first integer.
	mov		edx, OFFSET prompt_1						; Move the offset into the EDX register.
	call	WriteString									; Call WriteString to display the prompt on the screen.
	call	ReadInt										; Call ReadInt to wait until the user enters something and presses ENTER.
	mov		int_1, eax									; The post-conditions for ReadInt include that the number the user entered is stored in the EAX register.
	
	; Get the second integer.
	mov		edx, OFFSET prompt_2						; Move the offset into the EDX register.
	call	WriteString									; This tells the user what they are expected to enter here.
	call	ReadInt										; Call ReadInt to wait until the user enters something and presses ENTER.
	mov		int_2, eax									; The post-conditions for ReadInt include that the number the user entered is stored in the EAX register.

	; Compare the user's integers to verfiy that the first integer is larger than the second.
	cmp		int_1, eax
	; If the second number is larger than the first integer, print the error message to the screen and prompt the user to enter two integers again.
	jle		valError
;------------------------------------------------------------------------
Calculate:		; Calculate the required values
;------------------------------------------------------------------------
					; Calculate the sum.
					mov		eax, int_1					; Move the first integer into the EAX register. 
					add		eax, int_2					; Add the second integer to the value stored in the EAX register.
					mov		sum, eax					; Store the sum of the two integers in the sum variable.

					; Calculate the difference.
					mov		eax, int_1					; Move the first integer into the EAX register. 
					sub		eax, int_2					; Subtract the second integet from the value stored in the EAX register.
					mov		difference, eax				; Store the difference of the two integers in the difference variable.

					; Calculate the product.
					mov		eax, int_1					; Move the first integer into the EAX register.
					mov		ebx, int_2					; Move the second integer into the EBX register.
					mul		ebx							; Multiply the two integers.
					mov		product, eax				; Store the product of the two integers into the product variable.

					; Calculate the quotient.
					mov		edx, 0						; Move 0 into the EAX register.
					mov		eax, int_1					; Move the first integer into the EAX register. 
					cdq									; EDX:EAX = sign-extend of EAX. (First integer)
					mov		ebx, int_2					; Move the second integer into the EAX register.
					cmp		ebx, 0						; Check for division by zero.
					je		zeroError					; If the second integer is zero, jump to the zeroError identifier.
					cdq									; EDX:EAX = sign-extend of EAX. (Second integer)
					idiv	ebx							; Divide the two integers.
					mov		quotient, eax				; Store the quotient of the two integers into the quotient variable.
					mov		remainder, edx				; Store the value remaining in the EDX into the remainder variable.

					; Extra Credit Floating Point calculations:
					; Multiply the remainder by 1000 to get a floating point to the nearest .001.
					mov 	eax, oneThousand			; Move 1000 into the EAX register.
					mov 	ebx, remainder				; Move the value stored in the remainder variable into the EBX register.
					mul 	ebx							; Multiply 1000 times the remainder.
					cdq									; EDX:EAX = sign-extend of EAX.
					mov 	ebx, int_2					; Move the second integer into the EBX register.
					; Divide the remainder*1000 by the second integer to get the mantissa of the floating point.
					cdq									; EDX:EAX = sign-extend of EAX.
					mov 	edx, 0						; Move 0 into the EDX register.
					div 	ebx							; Divide the two integers.
					mov 	mantissa, eax				; Store the remaining value in the EAX register into the mantissa variable.
;------------------------------------------------------------------------
Display:		; Display the results.
;------------------------------------------------------------------------
					; Display the sum.
					mov		eax, int_1					; Move the first integer into the EAX register.
					call	WriteInt					; Call WriteInt to display the first integer on the screen.
					mov		edx, OFFSET plus			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display " + " to the screen.
					mov		eax, int_2					; Move the second integer into the EAX register.
					call	WriteInt					; Call WriteInt to display the second integer on the screen.
					mov		edx, OFFSET equals			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display " = " to the screen.
					mov		eax, sum					; Move the sum into the EAX register, so we can display it.
					call	WriteInt					; Call WriteInt to display the sum on the screen.
					call	CrLf						; Call Carriage Return Line Feed to skip to the next line. 

					; Display the difference.
					mov		eax, int_1					; Move the first integer into the EAX register.
					call	WriteInt					; Call WriteInt to display the first integer on the screen.
					mov		edx, OFFSET minus			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display " - " to the screen.
					mov		eax, int_2					; Move the second integer into the EAX register.
					call	WriteInt					; Call WriteInt to display the second integer on the screen.
					mov		edx, OFFSET equals			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display " = " to the screen.
					mov		eax, difference				; Move the difference into the EAX register, so we can display it.
					call	WriteInt					; Call WriteInt to display the difference to the screen.
					call	CrLf						; Call Carriage Return Line Feed to skip to the next line. 

					; Display the product.
					mov		eax, int_1					; Move the first integer into the EAX register.
					call	WriteInt					; Call WriteInt to display the first integer on the screen.
					mov		edx, OFFSET times			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display " x " to the screen.
					mov		eax, int_2					; Move the second integer into the EAX register.
					call	WriteInt					; Call WriteInt to display the second integer on the screen.
					mov		edx, OFFSET equals			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display " = " to the screen.
					mov		eax, product				; Move the product into the EAX register, so we can display it.
					call	WriteInt					; Call WriteInt to display the product to the screen.
					call	CrLf						; Call Carriage Return Line Feed to skip to the next line. 

					; Display the quotient.
					mov		eax, int_1					; Move the first integer into the EAX register.
					call	WriteInt					; Call WriteInt to display the first integer on the screen.
					mov		edx, OFFSET space			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display " " to the screen.
					mov		edx, OFFSET dividedby		; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display "÷" to the screen.
					mov		edx, OFFSET space			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display " " to the screen.
					mov		eax, int_2					; Move the second integer into the EAX register.
					call	WriteInt					; Call WriteInt to display the second integer on the screen.
					mov		edx, OFFSET equals			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display " = " to the screen.
					mov		eax, quotient				; Move the value stored in the quotient to the EAX register.
					call	WriteInt					; Call WriteInt to display the quotient to the screen.
					mov		edx, OFFSET rstring			; Move the offset into the EDX Register.
					call	WriteString					; Call WriteString to display the remainder string to the screen.
					mov		eax, remainder				; Move the value stored in remainder to the EAX register.
					call	WriteInt					; Call WriteInt to display the remainder to the screen.
					call	CrLf						; Call Carriage Return Line Feed to skip to the next line. 

					; Display the EC2 Output.
					mov 		edx, OFFSET EC2string	; Move the offset into the EDX register.
					call 		WriteString				; Call WriteString to display the EC2string to the screen.
					mov 		eax, quotient			; Move the value stored in the quotient to the EAX register.
					call 		WriteInt				; Call WriteInt to display the quotient to the screen.
					mov 		edx, OFFSET decimal		; Move the offset into the EDX register.
					call 		WriteString				; Call WriteString to disaplay "." to the screen.
					mov			eax, mantissa			; Copy the value stored in mantissa to the EAX register.
					call 		WriteDec				; Call WriteInt to display the mantissa to the screen.
					call 		CrLf					; Call Carriage Return Line Feed to skip to the next line. 

					; Ask the user if they want the continue or quit.
					mov		edx, offset quit			; Move the offset into the EDX register.
					call	WriteString					; Call WriteString to display the quit string to the screen.
					call	ReadInt						; Call ReadInt to wait until the user enters something and presses ENTER.
					call	CrLf						; Call Carriage Return Line Feed to skip to the next line. 
					cmp		yes, eax					; Check to see if the user chooses yes or no.
					jne		gameOver					; If the user chooses no, jump to the gameOver identifier.
					jmp		whileLoop					; Jump to the whileLoop identifier.
;------------------------------------------------------------------------	
valError:
;------------------------------------------------------------------------
	; Error message for the second integer being larger than the first.
	mov		edx, offset EC_error						; Move the offset into the EDX register.
	call	WriteString									; Call WriteString to display the EC_error string.
	call	CrLf										; Call Carriage Return Line Feed to skip to the next line. 
	jmp		whileLoop									; Jump to the whileLoop identifier.
;------------------------------------------------------------------------
zeroError:
;------------------------------------------------------------------------
	; Error message for trying to divide by zero.
	mov 		edx, OFFSET zeroErrorMsg				; Move the offset into the EDX register.
	call 		WriteString								; Call WriteString to display the zeroErrorMsg to the screen.
	call 		CrLf									; Call Carriage Return Line Feed to skip to the next line.
	jmp			Display									; Jump to the Display identifier.
;------------------------------------------------------------------------
	gameOver:
;------------------------------------------------------------------------
	; Say "Good-Bye"
	mov		edx, OFFSET goodBye							; Move the offset into the EDX register.
	call	WriteString									; Call WriteString to display the goodBye string to the screen.
	call	CrLf										; Call Carriage Return Line Feed to skip to the next line. 

	exit												; exit to operating system
main ENDP

END main
