// Radioshack RGB LED driver
// Originally by Tyler Worman, tsworman at novaslp.net
//   and Jon Karve, jkarve at gmail.com
// Restructured by Wynter Woods, wynter at makermedia.com
// May 9th 2014
// 

// Make sure this is run on each boot:
// export PINS=/sys/kernel/debug/pinctrl/44e10800.pinmux/pins
// export SLOTS=/sys/devices/bone_capemgr.*/slots
// echo BB-BONE-PRU > $SLOTS

#define OUT_PIN             r30.t14        // pin P8_12
#define SEGMENTS_PER_STRIP  10             // number of light segments to illuminate

// this include needs to come after the above definitions so as not to cause assembler errors
#include "tm1803.p"

.origin 0
.entrypoint START


/*
 *  INIT
 */
.macro INIT
    LBCO r0, C4, 4, 4                   // Load Bytes Constant Offset (?)
    CLR  r0, r0, 4                      // Clear bit 4 in reg 0
    SBCO r0, C4, 4, 4                   // Store Bytes Constant Offset
.endm

/*
 *  SHUTDOWN
 */
.macro SHUTDOWN
    CLR OUT_PIN                         // clear output pin to LOW
    MOV R31.b0, PRU0_ARM_INTERRUPT+16   // Send notification to Host for program completion
    HALT
.endm

/*
 *  START
 *  begin the LED driver here
 */
START:
    INIT
    
    SEND_RESET
    
    SEND_EMPTY_SEGMENTS SEGMENTS_PER_STRIP

    SHUTDOWN