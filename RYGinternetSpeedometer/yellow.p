/ Originally by Tyler Worman & Jon Karve
// Restructured by Wynter Woods

// Modified by Tingzhi Li 

// Make sure this is run on each boot:
// export PINS=/sys/kernel/debug/pinctrl/44e10800.pinmux/pins
// export SLOTS=/sys/devices/bone_capemgr.*/slots
// echo BB-BONE-PRU-RYG > $SLOTS

#define PRU0_ARM_INTERRUPT  19
#define OUT_PIN_R             r30.t14        // pin P8_12, Red
#define OUT_PIN_Y             r30.t15        // pin P8_11, Yellow
#define OUT_PIN_G             r30.t5         // pin P9_27, Green

.origin 0
.entrypoint START

/* INIT */
.macro INIT
    LBCO r0, C4, 4, 4                   // Load Bytes Constant Offset (?)
    CLR  r0, r0, 4                      // Clear bit 4 in reg 0
    SBCO r0, C4, 4, 4                   // Store Bytes Constant Offset
.endm

/* SHUTDOWN */
.macro SHUTDOWN
    MOV R31.b0, PRU0_ARM_INTERRUPT+16   // Send notification to Host for program completion
    HALT
.endm

/* START */
START:
    INIT
    
    CLR OUT_PIN_R
    CLR OUT_PIN_G
    SET OUT_PIN_Y

    SHUTDOWN
