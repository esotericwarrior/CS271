TITLE Programming Assignment #4    (Project04.asm)

; Author: Tristan Santiago
; Last Modified: May 8, 2018
; OSU email address: santiatr@oregonstate.edu
; Course number/section: CS271_400
; Project Number: 04              Due Date: May 13, 2018
; Description: This program calculates composite numbers within the range of 1 to 400, based on the user's input.

INCLUDE Irvine32.inc
;------------------------------------------------------------------------
; Constants
;------------------------------------------------------------------------
LOWER_LIMIT = 1																; Constant lower limit value.
UPPER_LIMIT = 400															; Constant upper limit value.
MAX_NUM_PER_PAGE = 50														; Maximum number of composites to print per page.
MAX_NUM_PER_COLUMN = 10														; Maximum number of composites to print per row.
;------------------------------------------------------------------------
.data
;------------------------------------------------------------------------
intro_1			BYTE		"Composite Numbers", 0							; Title.
intro_2			BYTE		"	Programmed by Tristan Santiago", 0			; Author.
prompt_1		BYTE		"Enter the number of composite numbers you would like to see.", 0
prompt_2		BYTE		"I'll accept orders for up to 400 composites.", 0
prompt_3		BYTE		"Enter the number of composites to display [1 .. 400]: ", 0
userNumber		DWORD		?												; This variable stores the number of composites the user wants to see.
;------------------------------------------------------------------------
; Validation Variables
;------------------------------------------------------------------------
rangeError		BYTE		"Out of range. Try again.", 0					; Error message for user entering a number above the upper limit.
;------------------------------------------------------------------------
; Variables for used for calculating the composite numbers.
;------------------------------------------------------------------------
testComposite	DWORD	4													; The first composite number is 4, so we use this value to start testing.
numCompCount	DWORD	?													; Total composite numbers.
primes			DWORD	2, 3, 5, 7, 0										; Prime divisors.
;------------------------------------------------------------------------
; Extra Credit variables.
;------------------------------------------------------------------------
EC_prompt1		BYTE	"**EC: This program aligns the output columns.", 0	; Extra Credit prompt.
EC_prompt2		BYTE	"**EC: This program displays the composites one page at a time.", 0	; Extra Credit prompt.
EC_prompt3		BYTE	"**EC: This program is more efficient because it uses prime divisors to find composite numbers.", 0 ; Extra Credit prompt.
continuePrompt	BYTE	"Press any key to continue to the next page...", 0	; This prompts the user to press any key to continue printing results.
columns			DWORD	0													; This determines the number of composites allowed to be printed per line.
pageNum			DWORD	?													; Variable used to assist with formatting pages for output.
oneSpace		BYTE	" ", 0												; Print one space to properly align three digit numbers.
twoSpaces		BYTE	"  ", 0												; Print two spaces to properly align two digit numbers.
threeSpaces		BYTE	"   ", 0											; Print three spaces to properly align single digit numbers.
;------------------------------------------------------------------------
; Exit Variables
;------------------------------------------------------------------------
goodBye_1		BYTE		"Results certified by Tristan Santiago.", 0		; First goodbye message.
goodBye_2		BYTE		"  Goodbye. ", 0								; Second goodbye message.
period			BYTE		".", 0											; Punctuation mark used for grammatical purposes.
;------------------------------------------------------------------------
.code
;------------------------------------------------------------------------
;------------------------------------------------------------------------
intro PROC			; The intro procedure displays the programmer name and a brief description of the program.
;------------------------------------------------------------------------
					mov		edx, OFFSET intro_1								; Move the offset into the EDX register.
					call	WriteString										; Print intro_1 to the screen.
					mov		edx, OFFSET intro_2								; Move the offset into the EDX register.
					call	WriteString										; Print intro_2 to the screen.
					call	CrLf											; Write an end-of-line sequence to the console window.
					mov		edx, OFFSET EC_prompt1							; Move the offset into the EDX register.
					call	WriteString										; Print EC_prompt1 to the screen.
					call	CrLf											; Write an end-of-line sequence to the console window.
					mov		edx, OFFSET EC_prompt2							; Move the offset into the EDX register.
					call	WriteString										; Print EC_prompt2 to the screen.
					call	CrLf											; Write an end-of-line sequence to the console window.
					mov		edx, OFFSET EC_prompt3							; Move the offset into the EDX register.
					call	WriteString										; Print EC_prompt3 to the screen.
					call	CrLf											; Write an end-of-line sequence to the console window.
					mov		edx, OFFSET prompt_1							; Move the offset into the EDX register.
					call	WriteString										; Print prompt_1 to the screen.
					call	CrLf											; Write an end-of-line sequence to the console window.
					mov		edx, OFFSET prompt_2							; Move the offset into the EDX register.
					call	WriteString										; Print prompt_2 to the screen.
					call	CrLf											; Write an end-of-line sequence to the console window.
					ret
intro ENDP
;------------------------------------------------------------------------
;							getUserData									;
; This procedure prompts the user to enter a number of composites to be	;
; displayed and loops until the user enters a number within range of 1	;
; to 400. The verified number is stored within the userNumber variable.	;
;------------------------------------------------------------------------
getUserData	PROC	; Begin the loop for receiving the user's input.
;------------------------------------------------------------------------
userInputLoop:
					mov		edx, OFFSET prompt_3							; Move the offset into the EDX register.
					call	WriteString										; Print prompt_3 to the screen.
					call	ReadInt											; Wait for the user's input.
					mov		userNumber, eax									; Store the user's input in the userNumber variable.
					call	inputValidation									; Call inputValidation procedure.
					ret
getUserData	ENDP
;------------------------------------------------------------------------
;							inputValidation								;
; This procedure uses one parameter, the user's input, from the EAX		;
; Register and validates whether or not it is within range. If the		;
; number is out of range, an error message is displayed.				;
;------------------------------------------------------------------------
inputValidation	PROC	; Begin the inputValidation loop:
;------------------------------------------------------------------------
					; Validate user data
					cmp		eax, UPPER_LIMIT								; Compare the number of terms to the upper limit.
					jg		rangeErrorMsg									; If the number of terms > the upper limit, jump to the tooHigh identifier.
					cmp		eax, LOWER_LIMIT								; Compare the number of terms to the lower limit.
					jl		rangeErrorMsg									; If the number of terms < the lower limit, jump to the tooLow identifier.
					jmp		inputValidated
;------------------------------------------------------------------------
rangeErrorMsg:		; If the user's number > the upper limit:
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
					call	getUserData
;------------------------------------------------------------------------
inputValidated:		; User's input is within range, so continue:
;------------------------------------------------------------------------
					mov		numCompCount, 0									; Set the number of composites found to 0.
					mov		columns, 0										; Set the number of columns to 0.
					mov		pageNum, 0										; Set the page number to 0.
					ret
inputValidation	ENDP
;------------------------------------------------------------------------
;							showComposites								;
; This procedure first checks to see whether or not the number of		;
; composites found exceeds the number that can "fit on the page" by		;
; comparing the number 
;------------------------------------------------------------------------
showComposites	PROC
;------------------------------------------------------------------------
displayComposites:
					mov		eax, pageNum									; Move pageNum into the EAX register.
					cmp		eax, MAX_NUM_PER_PAGE							; Compare pageNum to MAX_NUM_PER_PAGE.
					je		newPage											; If pageNum == MAX_NUM_PER_PAGE, jump to the newPage identifier.
					mov		eax, userNumber									; Move userNumber into the EAX register.
					cmp		eax, numCompCount								; Compare userNumber to numCompCount.
					je		exitLoop										; If userNumber == numCompCount, jump to the exitLoop identifier.

					call	isComposite										; Call isComposite procedure to begin calculating.
					inc		testComposite									; Once we return from the isComposite procedure, increment testComposite.
					mov		eax, columns									; Move columns into the EAX register.
					cmp		eax, MAX_NUM_PER_COLUMN							; Compare columns to MAX_NUM_PER_COLUMN.
					je		newLine											; If columns == MAX_NUM_PER_COLUMN, jump to the newLine identifier.
					jmp		displayComposites								; Jump to the displayComposites identifier.
;------------------------------------------------------------------------
newLine:			; Print a new line for formatting purposes.
;------------------------------------------------------------------------
					call	CrLf											; Write an end-of-line sequence to the console window.
					mov		columns, 0										; Reset columns to 0, since a new line has been printed.
					jmp		displayComposites								; Jump to the displayComposites identifier.
;------------------------------------------------------------------------
newPage:			; Ask user to press enter to continue printing:
;------------------------------------------------------------------------
					mov		edx, OFFSET continuePrompt						; Move the OFFSET into the EDX register.
					call	WriteString										; Call WriteString to print continuePrompt to the screen.
;------------------------------------------------------------------------
LookForKey:			; Procedure to wait for user to press ENTER to continue.
; http://programming.msjc.edu/asm/help/source/irvinelib/readkey.htm
;------------------------------------------------------------------------
					mov		eax, 50											; Sleep, to allow OS to time slice.
					call	Delay											; (otherwise, some key presses are lost)
					call	ReadKey											; Look for keyboard input.
					jz		LookForKey										; No key pressed yet.
					mov		pageNum, 0										; Reset pageNum to 0, since we've reached the max.
					call	CrLf											; Write an end-of-line sequence to the console window.
					call	CrLf											; Write an end-of-line sequence to the console window.
					jmp		displayComposites								; Jump to displayComposites identifier.
;------------------------------------------------------------------------
exitLoop:			; The number of composites printed == the user's number, so:
;------------------------------------------------------------------------
					ret
showComposites	ENDP
;------------------------------------------------------------------------
;							isComposite									;
; This procedure takes the user's input (userNumber) and calculates	the	;
; appropriate number of composite numbers.								;
; **EC: For Extra Credit, this procedure also uses the stack (pushad &	;
; popad) and prime numbers as divisors (2, 3, 5, and 7) to make			;
; compositing more efficient. For example, while computing, if we are	;
; testing the number 5 or 7, we skip the calculations for those values	;
; since we already know those numbers are prime and we are already		;
; using those values as divisors.										;
;------------------------------------------------------------------------
isComposite	PROC
					; Since we now know procedures affect the stack and omitting this call affected results:
					pushad													; Push all the registers to the stack.
					; https://stackoverflow.com/questions/9313098/pushfd-and-pushad-whats-the-point
					mov		eax, testComposite								; Move testComposite into the EAX register.
					cmp		eax, 5											; Compare testComposite to 5, since 5 is prime and is used as a divisor.
					je		skip											; If testComposite == 5, skip, because we know 5 is prime.
					cmp		eax, 7											; Compare testComposite to 7, since 7 is prime and is used as a divisor.
					je		skip											; If testComposite == 7, skip, because we know 7 is prime.
					mov		ebx, 0											; Move 0 into the EBX register, effectively resetting it.
					mov		esi, OFFSET primes								; Move the prime divisors into the ESI register.
;------------------------------------------------------------------------
calculations:		; Begin testing to see if an integer is composite.
;------------------------------------------------------------------------
					mov		edx, 0											; Move 0 into the EDX register, effectively resetting it.
					mov		eax, testComposite								; Move the testComposite into the EAX register.
					mov		ebx, [esi]										; De-reference an address, Move the contents of address ESI into EBX.
					div		ebx												; Divide EAX by EBX.
					cmp		edx, 0											; Check to see if the remainder is 0 or not.
					jz		compositeFound									; If the remainder == 0, jump to the compositeFound identifier.
					inc		esi												; Incrememt the ESI register, moving to the next divisor.
					mov		ebx, [esi]										; De-reference an address, Move the contents of address ESI into EBX.
					cmp		ebx, 0											; Check to see if we're at 0 in the ESI register, indicating all divisors have been used.
					je		skip											; If EBX == 0, jump to the skip identifier.
					jmp		calculations									; Jump to the calculations identifier.
;------------------------------------------------------------------------
compositeFound:		; If a composite number is found:
;------------------------------------------------------------------------
					mov     eax, testComposite								; Move the testComposite into the EAX register.
					call    formatting										; Call formatting procedure to properly space the output.
					call    WriteDec										; Print the integer to the screen.
					inc     numCompCount									; Increment the number of composite numbers found.
					inc     columns											; Increment columns.
					inc     pageNum											; Increment pageNum.
;------------------------------------------------------------------------
skip:				; End of the algorithm for finding composites.
;------------------------------------------------------------------------
					popad													; Pop the values back off the stack in reverse order, thus restoring all the register values.
					ret
isComposite	ENDP
;------------------------------------------------------------------------
;							formatting									;
; This procedure compares the number of digits in the composite number	;
; in order to determine the number of spaces that should be printed		;
; after the integer is printed on the screen in order to ensure a neat	;
; appearance on the console window.										;
;------------------------------------------------------------------------
formatting	PROC
					pushad													; Push all the registers to the stack.
					mov		eax, numCompCount								; Move numCompCount into the EAX register.
					cmp		eax, 10											; Compare numCompCount to 10.
					jl		oneDigit										; If numCompCount > 10, jump to the oneDigit identifier.
					cmp		eax, 100										; Compare numCompCount to 100.
					jl		twoDigits										; If numCompCount > 100, jump to the twoDigits identifer.
					cmp		eax, 1000										; Compare numCompCount to 1000.
					jl		threeDigits										; If numCompCount > 1000, jump to the threeDigits identifier.
;------------------------------------------------------------------------
oneDigit:			; Print three spaces after the composite number.
;------------------------------------------------------------------------
					mov		edx, OFFSET threeSpaces							; Move the offset into the EDX register.
					call	WriteString										; Print threeSpaces to the screen.
					jmp		continue										; Jump to the continue identifier.
;------------------------------------------------------------------------
twoDigits:			; Print two spaces after the composite number.
;------------------------------------------------------------------------
					mov		edx, OFFSET twoSpaces							; Move the offset into the EDX register.
					call	WriteString										; Print twoSpaces to the screen.
					jmp		continue										; Jump to the continue identifier.
;------------------------------------------------------------------------
threeDigits:		; Print one space after the composite number.
;------------------------------------------------------------------------
					mov		edx, OFFSET oneSpace							; Move the offset into the EDX register.
					call	WriteString										; Print oneSpace to the screen.
					jmp		continue										; Jump to the continue identifier.
continue:			
					popad													; Pop the values back off the stack in reverse order, thus restoring all the register values.
					ret
formatting	ENDP
;------------------------------------------------------------------------
farewell	PROC	; Say goodbye to the user.
;------------------------------------------------------------------------
					call	CrLf											; Write an end-of-line sequence to the console window.
					call	CrLf											; Write an end-of-line sequence to the console window.
					mov		edx, OFFSET goodBye_1							; Move the offset into the EDX register.
					call	WriteString										; Print goodBye_1 to the screen.
					mov		edx, OFFSET goodBye_2							; Move the offset into the EDX register.
					call	WriteString										; Print goodBye_2 to the screen.
					call	CrLf											; Write an end-of-line sequence to the console window.
					ret
farewell	ENDP

;------------------------------------------------------------------------
main PROC			; Main Procedure
;------------------------------------------------------------------------
					call	intro											; Call the intro procedure.
					call	getUserData										; Call the getUserData procedure.
					call	showComposites									; Call the showComposites procedure.
					call	farewell										; Call the farewell procedure.
					exit													; Exit to operating system.
main ENDP

END main