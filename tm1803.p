
#define PRU0_ARM_INTERRUPT  19


/*
 *  DELAY_CYCLES
 *  macro taken from PRU sample code
 */
.macro  DELAY_CYCLES
.mparam cycles
    MOV r14, (cycles)   // set register 14 to the number of cycles we want to delay
    SUB r14, r14, 3     // subtract function entry + overhead
    LSR r14, r14, 1     // right shift cycle count one bit to divide by two
                        // we do this because the loop costs two cycles
LOOP:
    SUB r14, r14, 1     // subtract 1 from register 14
    QBNE LOOP, r14, 0   // if (register 14 is not equal to 0) then goto to LOOP
.endm

/*
 *  SEND_0
 *  macro that outputs a 0 bit as per tm1803 spec
 */
.macro SEND_0
    // T0H
    SET OUT_PIN         // set HIGH
    DELAY_CYCLES 140    // delay for 0.7us

    // T0L
    CLR OUT_PIN         // clear to LOW
    DELAY_CYCLES 360    // delay for 1.8us
.endm

/*
 *  SEND_1
 *  macro that outputs a 1 bit as per tm1803 spec
 */
.macro SEND_1
    // T1H
    SET OUT_PIN         // set HIGH
    DELAY_CYCLES 360    // delay for 1.8us

    // T1L
    CLR OUT_PIN         // clear to LOW
    DELAY_CYCLES 140    // delay for 0.7us
.endm

/*
 *  SEND_BYTE
 */
.macro SEND_BYTE
.mparam byte
    mov r2, (byte & 0xFF)       //  a = 0xFF
    mov r3, 8                   //  i = 8
byteloop:
    sub r3, r3, 1               //  i = i - 1
    
    qbbs bit_1, r2, r3          //  if( (byte 'i' of a is set) goto bit_1
    jmp bit_0                   //  else  goto bit_0
bit_0:
    SEND_0                      //  output 0
    jmp loopend                 //  continue loop
bit_1:
    SEND_1                      //  output 0
    jmp loopend                 //  continue loop
loopend:
    QBNE byteloop, r3, 0        //  if ( i != 0 ) goto byteloop

.endm

/*
 *  SEND_EMPTY_SEGMENTS
 */
.macro SEND_EMPTY_SEGMENTS
.mparam number_of_segments
    mov r4, (number_of_segments)
send_segment:
    SEND_BYTE 0x00
    SEND_BYTE 0x00
    SEND_BYTE 0x00
    SEGMENT_END
    sub r4, r4, 1
    qbne send_segment, r4, 0

.endm

/*
 *  SEGMENT_END
 *  delay for 3.25us (650 cycles) in between each segment
 *  in some cases this may not be necessary
 *  but it mimics the output of the arduino
 *  driver code.
 */
.macro SEGMENT_END
    DELAY_CYCLES 650
.endm

/*
 *  SEND_RESET
 */
.macro SEND_RESET
    CLR OUT_PIN                         // clear to LOW
    DELAY_CYCLES 4800                   // delay for 24us to make sure the strip knows we want to set values.
.endm