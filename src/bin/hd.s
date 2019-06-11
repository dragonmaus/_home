	global	_start

	section	.text
; write the current index (SI) to the output (DI) in hex dword (%08x) format
addindex:
	push	rdx
	mov	rdx, rdi	; save original pointer
	add	rdi, 6		; move pointer to the 4th byte (000000[0]0)
	std			; iterate right-to-left
.loop:	call	hexdump
	stosw
	shr	rsi, 8
	cmp	rdi, rdx
	jge	.loop		; loop until we pass the original pointer
	add	rdi, 10		; move past the 4th byte (00000000[.])
	cld
	pop	rdx
	ret

; translate the next byte pointed to by SI into '.' if it is not printable
chardump:
	lodsb
	cmp	al, 0x20	; return '.' if AL < ' '
	jl	.dot
	cmp	al, 0x7E	; return '.' if AL > '~'
	jg	.dot
	ret			; else return AL unmodified
.dot:	mov	al, 0x2E
	ret

; convert the bottom byte of SI into ASCII characters in hex byte format (%02x)
hexdump:
	push	rbx
	mov	rbx, htable	; lookup table
	mov	rax, rsi
	mov	ah, al		; duplicate so we can get at both nibbles
	and	al, 0x0F	; low nibble
	shr	ah, 4		; high nibble
	xlatb			; convert low nibble into ASCII
	xchg	ah, al
	xlatb			; convert high nibble into ASCII
	pop	rbx
	ret

_start:
	xor	r15, r15	; overall index

	; read 16 bytes into ibuf
.read:	mov	rdx, 16
	mov	rsi, ibuf
	xor	rdi, rdi	; stdin
	xor	rax, rax	; syscall read
	syscall
	cmp	rax, 0
	jl	.fail
	je	.done
	mov	r14, rax	; input size

	; output overall index
	mov	rsi, r15
	mov	rdi, obuf
	call	addindex

	xor	r13, r13	; current index in ibuf
.hexg:	xor	r12, r12	; current index in group

	; output a space
	mov	rax, 0x20
	stosb

	; output a space
.hexc:	mov	rax, 0x20
	stosb

	; if there are bytes remaining
	cmp	r13, r14
	jge	.none
	; then output hexdump of current byte
	mov	rsi, qword [ibuf+r13]
	call	hexdump
	stosw
	jmp	.endh
	; else output two spaces
.none:	mov	rax, 0x2020
	stosw
.endh:	inc	r12
	inc	r13
	cmp	r12, 8
	jl	.hexc
	cmp	r13, 16
	jl	.hexg

	; output two spaces
	mov	rax, 0x2020
	stosw

	; output a pipe
	mov	rax, 0x7C
	stosb

	; output the character dump section
	mov	r13, r14
	mov	rsi, ibuf
.char:	or	r13, r13
	jz	.endc
	call	chardump
	stosb
	dec	r13
	jmp	.char
.endc:
	; output a pipe and a newline
	mov	rax, 0x0A7C
	stosw

	; write the output
	sub	rdi, obuf	; get output length
	mov	rdx, rdi
	mov	rsi, obuf
	xor	rdi, rdi
	inc	rdi		; stdout
	xor	rax, rax
	inc	rax		; syscall write
	syscall

	; increment overall index
	add	r15, r14

	; quit if input size < 16
	cmp	r14, 16
	je	.read

.done:	or	r15, r15
	jz	.quit

	; output the final index if we have processed any data
	mov	rsi, r15
	mov	rdi, obuf
	call	addindex

	; output a newline
	mov	rax, 0x0A
	stosb

	; write the output
	sub	rdi, obuf	; get output length
	mov	rdx, rdi
	mov	rsi, obuf
	xor	rdi, rdi
	inc	rdi		; stdout
	xor	rax, rax
	inc	rax		; syscall write
	syscall

.quit:	xor	rdi, rdi
	mov	rax, 60		; syscall exit
	syscall

.fail:	neg	rax
;e004:	cmp	rax, 4
;	jne	e005
;	mov	dl, byte [e004l]
;	mov	rsi, e004m
;	jmp	die
;e005:	cmp	rax, 5
;	jne	e009
;	mov	dl, byte [e005l]
;	mov	rsi, e005m
;	jmp	die
;e009:	cmp	rax, 9
;	jne	e011
;	mov	dl, byte [e009l]
;	mov	rsi, e009m
;	jmp	die
;e011:	cmp	rax, 11
;	jne	e014
;	mov	dl, byte [e011l]
;	mov	rsi, e011m
;	jmp	die
;e014:	cmp	rax, 14
;	jne	e021
;	mov	dl, byte [e014l]
;	mov	rsi, e014m
;	jmp	die
e021:	cmp	rax, 21
	jne	e022
	mov	dl, byte [e021l]
	mov	rsi, e021m
	jmp	die
e022:	cmp	rax, 22
	jne	e___
	mov	dl, byte [e022l]
	mov	rsi, e022m
	jmp	die
e___:	mov	dl, byte [e___l]
	mov	rsi, e___m
die:	mov	rdi, 2		; stderr
	xor	rax, rax
	inc	rax		; syscall write
	syscall
	xor	rdi, rdi
	inc	rdi
	mov	rax, 60		; syscall exit
	syscall

	section	.data
; the commented errors seem unlikely, if not impossible
; uncomment if encountered in the wild
;e004m	db	'hd: fatal: interrupted syscall', 0x0A
;e004l	equ	$ - e004m
;e005m	db	'hd: fatal: IO error', 0x0A
;e005l	equ	$ - e005m
;e009m	db	'hd: fatal: bad file descriptor', 0x0A
;e009l	equ	$ - e009m
;e011m	db	'hd: fatal: resource temporarily unavailable', 0x0A
;e011l	equ	$ - e011m
;e014m	db	'hd: fatal: bad address', 0x0A
;e014l	equ	$ - e014m
e021m	db	'hd: fatal: input is a directory', 0x0A
e021l	equ	$ - e021m
e022m	db	'hd: fatal: invalid input', 0x0A
e022l	equ	$ - e022m
e___m	db	'hd: fatal: unknown error', 0x0A
e___l	equ	$ - e___m
htable	db	'0123456789abcdef'

	section	.bss
ibuf	resb	16
obuf	resb	79
