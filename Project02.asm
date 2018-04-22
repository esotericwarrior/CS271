TITLE Programming Assignment #2     (Project02.asm)

; Author: Tristan Santiago
; Last Modified: April 17, 2018
; OSU email address: santiatr@oregonstate.edu
; Course number/section: CS271_400
; Project Number: 02			Due Date: April 22, 2018
; Description: This program calculates Fibonacci numbers up to and including the nth term. The results are displayed
; in aligned columns with 5 terms per line with at least 5 spaces between them.

; Include standard Irvine library.
INCLUDE Irvine32.inc
;------------------------------------------------------------------------
.data
;------------------------------------------------------------------------
intro_1			BYTE		"Fibonacci Numbers", 0										; Title.
intro_2			BYTE		"Programmed by Tristan Santiago", 0							; Author.
prompt_1		BYTE		"What's your name? ", 0										; Prompt used to ask user for their name.
userName		BYTE		33 DUP(0)													; String to be entered by user.
intro_3			BYTE		"Hello, ", 0												; String used to greet the user.
prompt_2		BYTE		"Enter the number of Fibonacci terms to be displayed.", 0	; Prompt the user with instructions.
prompt_3		BYTE		"Give the number as an integer in the range [1 .. 46].", 0	; Make the user aware of the upper and lower limit.
prompt_4		BYTE		"How many Fibonacci terms do you want? ", 0					; Prompt the user to enter the number of terms.
numTerms		DWORD		?															; Number of Fibonacci terms to be determined by the user.
upperLimit		DWORD		46															; The maximum number of terms that can be displayed.
lowerLimit		DWORD		1															; The least number of terms that can be displayed.
firstTerm		DWORD		1															; The first term of the Fibonacci sequence.
secondTerm		DWORD		1															; The second term of the Fibonacci sequence.
lineCount		DWORD		?															; Variable used to count every 5 lines.
;------------------------------------------------------------------------
; Validation Variables
;------------------------------------------------------------------------
highError		BYTE		"Out of range. Enter a number in [1 .. 46] ", 0				; Error message for user entering a number above the upper limit.
lowError		BYTE		"Out of range. Enter a number in [1 .. 46] ", 0				; Error message for user entering a number below the lower limit.
;------------------------------------------------------------------------
; Exit Variables
;------------------------------------------------------------------------
goodBye_1		BYTE		"Results certified by Tristan Santiago.", 0					; First goodbye message.
goodBye_2		BYTE		"Goodbye, ", 0												; Second goodbye message.
period			BYTE		".", 0														; Punctuation mark used for grammatical purposes.
;------------------------------------------------------------------------
; Extra Credit
;------------------------------------------------------------------------
five			WORD		9																								; ASCII Character 9 = TAB.
rowCount		DWORD		?																								; Variable used to count the number of rows printed.
EC1_string		BYTE		"**EC: This program displays the numbers in aligned columns.", 0								; Extra Credit 1 statement.
EC2_string		BYTE		"**EC: This program does lots of incredible things!", 0											; Extra Credit 2 statement.
EC3_string		BYTE		"**EC: You've seen the message box. This program also displays error messages in red text.", 0	; Extra Credit 3 statement.
EC4_string		BYTE		"**EC: This program also repeats until the user wants to quit.", 0								; Extra Credit 4 statement.
caption			BYTE		"Incredible Extra Credit!", 0																	; Title of message box.
HelloMsg		BYTE		"Welcome to my second program! ", 0dh,0ah														; Text of message box.
				BYTE		"The text has been set to light green. Incredible, right? ",	0dh,0ah
				BYTE		"Click OK to continue...", 0																	; Continued text of message box.
yes				DWORD		1																								; Boolean variable used for quit prompt.
quit			BYTE		"Would you like to continue? (Yes = 1 / No = 0) ", 0											; Prompts the user whether or not they want to continue.

.code
;------------------------------------------------------------------------
main PROC
;------------------------------------------------------------------------
;------------------------------------------------------------------------
Introduction:		; Introduction.
;------------------------------------------------------------------------
					mov		ebx, OFFSET caption											; Move the offset into the EBX register.
					mov		edx, OFFSET HelloMsg										; Move the offset into the EDX register.
					call	MsgBox														; Call MsgBox to display the message box to the screen.
					mov		eax, lightGreen												; Move lightGreen into the EAX register.
					call	setTextColor												; Set the text color to light green.
					mov		edx, OFFSET intro_1											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display intro_1 to the screen.
					call	CrLf														; Writes an end-of-line sequence to the console window.
					mov		edx, OFFSET intro_2											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display intro_2 to the screen.
					call	CrLf														; Writes an end-of-line sequence to the console window.
					mov		edx, OFFSET EC2_string										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display EC2_string to the screen.
					call	CrLf														; Writes an end-of-line sequence to the console window.
					mov		edx, OFFSET EC3_string										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display EC3_string to the screen.
					call	CrLf														; Writes an end-of-line sequence to the console window.
					mov		edx, OFFSET EC1_string										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to disaply EC1_string to the screen.
					call	CrLf														; Writes an end-of-line sequence to the console window.
					mov		edx, OFFSET EC4_string										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display EC4_string to the screen.
					call	CrLf														; Writes an end-of-line sequence to the console window.
					call	CrLf														; Writes an end-of-line sequence to the console window.


;------------------------------------------------------------------------
getUserData:		; Get the user's name.
;------------------------------------------------------------------------
					mov		edx, OFFSET prompt_1										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display prompt_1 to the screen.
					mov		edx, OFFSET userName										; Move the offset into the EDX register.
					mov		ecx, 32														; Set the max number of characters for the user's name to 32.
					call	ReadString													; Wait for user's input.

					; Display the user's name and say hello.
					mov		edx, OFFSET intro_3											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display intro_3 to the screen.
					mov		edx, OFFSET userName										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display the user's name to the screen.
					mov		edx, OFFSET period											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display period to the screen.
					call	CrLf														; Write an end-of-line sequence to the console window.
;------------------------------------------------------------------------
userInstructions:	; Give the user instructions.
;------------------------------------------------------------------------
					mov		edx, OFFSET prompt_2										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display prompt_2 to the screen.
					call	CrLf														; Write an end-of-line sequence to the console window.
					mov		edx, OFFSET prompt_3										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display prompt_3 to the screen.
					call	CrLf														; Write an end-of-line sequence to the console window.
					call	CrLf														; Write an end-of-line sequence to the console window.
;------------------------------------------------------------------------
displayFibs:		; Prompt the user to determine number of Fibonacci terms.
;------------------------------------------------------------------------
					mov		edx, OFFSET prompt_4										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to write prompt_4 to thescreen.
					call	ReadInt														; Wait for the user to enter the number of terms.
					mov		numTerms, eax												; Store the user's input in the numTerms variable.
					
					; Validate user data
					cmp      eax, upperLimit											; Compare the number of terms to the upper limit.
					jg       tooHigh													; If the number of terms > the upper limit, jump to the tooHigh identifier.
					cmp      eax, lowerLimit											; Compare the number of terms to the lower limit.
					jl       tooLow														; If the number of terms < the lower limit, jump to the tooLow identifier.
					je       oneTerm													; If the number of terms = 1, jump to the oneTerm identifier.
					cmp      eax, 2														; Compare the number of terms to 2.
					je       twoTerms													; If the number of terms = 2, jump to the twoTerms identifier.

					; Write the first two terms of the Fibonacci sequence.
					mov		eax, firstTerm												; Copy the value in firstTerm to the EAX register.
					call	WriteDec													; Call WriteDec to display the value to the screen.
					mov		edx, OFFSET five											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display five spaces to the screen.
					call	WriteString													; Call WriteString to display five spaces to the screen.
					mov		eax, secondTerm												; Copy the value in secondTerm to the EAX register.
					call	WriteDec													; Call WriteDec to display the value to the screen.
					call	WriteString													; Call WriteString to display five spaces to the screen.

					; Initialize first number, second number, and loop control.
					mov		eax, firstTerm												; Copy the value in firstTerm to the EAX register.
					mov		ebx, secondTerm												; Copy the value in secondTerm to the EBX register.
					mov		ecx, numTerms												; Loop control.
					sub		ecx, 2														; Subtract 2 from numTerms since we start at iteration 3.
					mov		lineCount, 1												; Initialize accumulator.
					mov		rowCount, 1													; Initialize rowCount.
					call	WriteString													; Call WriteString to display five spaces to the screen.
;------------------------------------------------------------------------
fibLoop:			; Loop to calculate the Fibonacci terms.
;------------------------------------------------------------------------
					inc		lineCount													; Increment the line count.
					cmp		lineCount, 5												; Compare the lineCount to 5.
					je		newLine														; Jump to the nextLine identifier when the lineCount = 5.
					add		eax, ebx													; Add the next term to the previous term.
					call	WriteDec													; Print the new term to the screen.
					xchg	eax, ebx													; Exchanges the contents of the destination (first) and source (second) operands.
					cmp		rowCount, 8													; Compare the row count to 8.
					jl		double														; If the row counter is less than 8, jump to the double identifier.
					jge		single														; If the row counter is greater than or equal to 8, jump to the single identifier.
					loop	fibLoop														; Subtract 1 from the ECX register. If the ECX register is != 0, go to fibLoop.
					call	CrLf														; Write an end-of-line sequence to the console window.
					jmp		farewell													; If loop ECX register = 0, jump to the farewell identifier.
;------------------------------------------------------------------------
newLine:			; Displays 5 terms per line with proper spacing.
;------------------------------------------------------------------------
					inc		rowCount													; Increment the row count.
					call	CrLf														; Write an end-of-line sequence to the console window.
					call	CrLf														; Write an end-of-line sequence to the console window.
					add		eax, ebx													; Add the next term to the previous term.
					call	WriteDec													; Print the new term to the screen.
					xchg	eax, ebx													; Exchange the contents of the EBX register with those of the EAX register and vice versa.
					mov		lineCount, 0												; Reset the line count to 0.
					cmp		rowCount, 8													; Compare the row count to 8.
					jl		double														; If the row count is less than 8, jump to the double identifier.
					jge		single														; If the row count is greater than or equal to 8, jump to the single identifier.
					loop	fibLoop														; Subtract 1 from the ECX register. If the ECX register is != 0, go to fibLoop. 
					jmp		farewell													; If the ECX register = 0, jump to the farewell identifier.
;------------------------------------------------------------------------
double:
;------------------------------------------------------------------------
					mov		edx, OFFSET five											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display five spaces to the screen.
					call	WriteString													; Call WriteString to display five spaces to the screen.
					loop	fibLoop														; Subtract 1 from the ECX register. If the ECX register is != 0, go to fibLoop. 
					jmp		farewell													; If the ECX register = 0, jump to the farewell identifier.
;------------------------------------------------------------------------
single:				
;------------------------------------------------------------------------
					mov		edx, OFFSET five											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display five spaces to the screen.
					dec		ecx															; Subtract 1 from the ECX register.
					jne		fibLoop														; If the ECX register is != 0, jump to the fibLoop identifier.
					jmp		farewell													; If the ECX register = 0, jump to the farewell identifier.
;------------------------------------------------------------------------
tooHigh:			; If the user's number of terms > the upper limit:
;------------------------------------------------------------------------
					; Set the text color to light red.
					mov		eax, lightRed												; Move the offset into the EAX register.
					call	setTextColor												; Change the text color to light red.
					mov		edx, OFFSET highError										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display highError to the screen.
					; Set the text color back to light green.
					mov		eax, lightGreen												; Move the offset into the EAX register.
					call	setTextColor												; Change the text color to light green.
					call	CrLf														; Write an end-of-line sequence to the console window.
					jmp		displayFibs													; Jump back to the displayFibs identifier.
;------------------------------------------------------------------------
tooLow:				; If the user's number of terms < the lower limit:
;------------------------------------------------------------------------
					; Set the text color to light red.
					mov		eax, lightRed												; Move the offset into the EAX register.
					call	setTextColor												; Change the text color to light red.
					mov		edx, OFFSET lowError										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display lowError to the screen.
					; Set the text color back to light green.
					mov		eax, lightGreen												; Move the offset into the EAX register.
					call	setTextColor												; Change the text color to light green.
					call	CrLf														; Write an end-of-line sequence to the console window.
					jmp		displayFibs													; Jump to the displayFibs identifier.
;------------------------------------------------------------------------
oneTerm:			; If the user wants to see just one Fibonacci term:
;------------------------------------------------------------------------
					call	CrLf														; Write an end-of-line sequence to the console window.
					mov		eax, firstTerm												; Copy the value in firstTerm to the EAX register.
					call	WriteDec													; Call WriteDec to display the value to the screen.
					mov		edx, OFFSET five											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display fiveSpaces to the screen.
					call	WriteString													; Call WriteString to display fiveSpaces to the screen.
					jmp		farewell													; Jump to the farewell identifier.
;------------------------------------------------------------------------
twoTerms:			; If the user wants to see just two Fibonacci terms:
;------------------------------------------------------------------------
					call	CrLf														; Write an end-of-line sequence to the console window.
					mov		eax, firstTerm												; Copy the value in firstTerm to the EAX register.
					call	WriteDec													; Call WriteDec to display the value to the screen.
					mov		edx, OFFSET five											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display fiveSpaces to the screen.
					call	WriteString													; Call WriteString to display fiveSpaces to the screen.
					mov		eax, secondTerm												; Copy the value in secondTerm to the EAX register.
					call	WriteDec													; Call WriteDec to display the value to the screen.
					jmp		farewell													; If ECX = 0, jump to the farewell identifier
;------------------------------------------------------------------------
farewell:			; Display farewell message and terminate program.
;------------------------------------------------------------------------
					; Ask the user if they want the continue or quit.
					call	CrLf														; Write an end-of-line sequence to the console window.
					call	CrLf														; Write an end-of-line sequence to the console window.
					mov		edx, offset quit											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display the quit string to the screen.
					call	ReadInt														; Call ReadInt to wait until the user enters something and presses ENTER.
					call	CrLf														; Call Carriage Return Line Feed to skip to the next line. 
					cmp		yes, eax													; Check to see if the user chooses yes or no.
					je		displayFibs													; If user enters 1, jump to the displayFibs identifier, else:
					mov		edx, OFFSET goodbye_1										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display goodbye_1 to the screen.
					call	CrLf														; Write an end-of-line sequence to the console window.
					mov		edx, OFFSET goodbye_2										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display goodbye_2 to the screen.
					mov		edx, OFFSET userName										; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display the user's name to the screen.
					mov		edx, OFFSET period											; Move the offset into the EDX register.
					call	WriteString													; Call WriteString to display period to the screen.
					call	CrLf														; Write an end-of-line sequence to the console window.
	exit	; exit to operating system
main ENDP

END main