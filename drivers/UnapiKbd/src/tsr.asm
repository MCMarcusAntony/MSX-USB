CSRSW: equ 0FCA9h
PUTPNT EQU 0F3F8h
GETPNT EQU 0F3FAh
KEYBUF EQU 0FBF0h

   org 8000h
TSR_ORG:

TSR_START:
    call OLD_HCHGE
    ; show cursor
    ld a, 255
    ld (CSRSW),a
_SCAN_AGAIN:
    call READ_HID_KEYBOARD
    call c, UNHOOK_US ; when error or ALT+Q
    or a
    jr z, _SCAN_AGAIN

    call C0F55

    ret
 
    include "keyboard.asm"

;	Subroutine	put keycode in keyboardbuffer
;	Inputs		A = keycode
;	Outputs		________________________
;	Remark		entrypoint compatible among keyboard layout versions
C0F55:
	LD	HL,(PUTPNT)
	LD	(HL),A			; put in keyboardbuffer
	CALL	C10C2		; next postition in keyboardbuffer with roundtrip
	LD	A,(GETPNT)
	CP	L			    ; keyboard buffer full ?
	RET	Z			    ; yep, quit
	LD	(PUTPNT),HL		; update put pointer
    RET

;	Subroutine	increase keyboardbuffer pointer
;	Inputs		________________________
;	Outputs		________________________
C10C2:
	INC	HL			    ; increase pointer
	LD	A,L
	CP	(KEYBUF+40) AND 255
	RET	NZ			    ; not the end of buffer, quit
	LD	HL,KEYBUF		; wrap around to start of buffer
	RET

OLD_HCHGE:
    ; old H.CHGE is stored at 6th entry
    ld hl, (TSR_SCRATCH_AREA)
    ; select 6th
    ld bc, 6*8
    add hl, bc
    ; jump 
    jp (hl)

UNHOOK_US:
    ret

TSR_END:

TSR_SHARED_VARS_START:
TSR_JUMP_TABLE:                 DS 7*8 ; 5 functions with each 8 bytes
TSR_KEYBOARD_INTERFACENR:       DB 0
TSR_KEYBOARD_ENDPOINTNR:        DB 0
TSR_KEYBOARD_MAX_PACKET_SIZE:   DB 0
TSR_SCRATCH_AREA:               DW 0
TSR_SHARED_VARS_END: