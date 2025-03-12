// StringConversion.s
// Student names: Carlos Rojas, Grant Osinde
// Last modification date: 3-10-2025
// Runs on any Cortex M0
// ECE319K lab 6 number to string conversion
//
// You write udivby10 and Dec2String
     .data
     .align 2
// no globals allowed for Lab 6
    .global OutChar    // virtual output device
    .global OutDec     // your Lab 6 function
    .global Test_udivby10

    .text
    .align 2
// **test of udivby10**
// since udivby10 is not AAPCS compliant, we must test it in assembly
Test_udivby10:
    PUSH {LR}

    MOVS R0,#123
    BL   udivby10
// put a breakpoint here
// R0 should equal 12 (0x0C)
// R1 should equal 3

    LDR R0,=12345
    BL   udivby10
// put a breakpoint here
// R0 should equal 1234 (0x4D2)
// R1 should equal 5

    MOVS R0,#0
    BL   udivby10
// put a breakpoint here
// R0 should equal 0
// R1 should equal 0
    POP {PC}

//****************************************************
// divisor=10
// Inputs: R0 is 16-bit dividend
// quotient*10 + remainder = dividend
// Output: R0 is 16-bit quotient=dividend/10
//         R1 is 16-bit remainder=dividend%10 (modulus)
// not AAPCS compliant because it returns two values
udivby10:
   PUSH {R4, R5, LR}
// write this

   MOVS R4, R0
   LDR R2, =0xCCCD
   MULS R0, R0, R2
   LSRS R0, R0, #19
   MOVS R5, R0
   MOVS R3, #10
   MULS R5, R3
   SUBS R1, R4, R5
   //SUBS R1, R3, R2
   // MOVS R1, R3

   POP  {R4, R5, PC}

  
//-----------------------OutDec-----------------------
// Convert a 16-bit number into unsigned decimal format
// Call the function OutChar to output each character
// You will call OutChar 1 to 5 times
// OutChar does not do actual output, OutChar does virtual output used by the grader
// Input: R0 (call by value) 16-bit unsigned number
// Output: none
// Invariables: This function must not permanently modify registers R4 to R11

    .equ n, 0           // *Binding*: Local variable n at offset 0 w.r.t SP
    .equ buffer, 4      // Local variable buffer at offset 4 w.r.t SP
    .equ count, 24      // Local variable count at offset 24 w.r.t SP

OutDec:
    PUSH {R4, R5, R6, R7, LR} // Save registers
    SUB SP, #28               // *Allocation*: Allocate 3 local variables (all 4-byte aligned)

    MOV R4, R0                // Copy n
    STR R4, [SP, #n]          // *Access*: Store n 
    MOVs R5, #0                
    STR R5, [SP, #count]      // *Access*: Store count on stack
    ADD R6, SP, #buffer       // Store base address of buffer in R6

ExtractDigits:
    LDR R4, [SP, #n]          // *Access*: Load n
    CMP R4, #0                // case for 0
    BEQ PrintDigits

    
    MOV R0, R4                
    // MOVS R1, #10               
    BL udivby10               // Calls division function
    MOV R5, R0                // Quotient
    MOV R4, R1                // Remainder

    STR R5, [SP, #n]          // *Access*: Store updated n 
    ADDS R4, #'0'              // Convert remainder to ASCII
    STR R4, [R6]              // Store ASCII in buffer
    ADDS R6, #4                // Move buffer pointer 

    LDR R5, [SP, #count]      // *Access*: Load count
    ADDS R5, #1                // count++
    STR R5, [SP, #count]      // *Access*: Store updated count
    B ExtractDigits           // 

PrintDigits:
    LDR R5, [SP, #count]      // *Access*: Load count
    CMP R5, #0                // 0 case
    BNE PrintLoop
    MOVS R0, #'0'              // Load ASCII '0'
    BL OutChar                // Print "0"
    B Done

PrintLoop:
    SUBS R6, #4                // Move buffer pointer back
    LDR R4, [R6]              // Load ASCII digit from buffer
    MOV R0, R4
    BL OutChar                // Print char
    SUBS R5, #1                // count--
    STR R5, [SP, #count]      // *Access*: Store updated count
    CMP R5, #0
    BNE PrintLoop

Done:
    ADD SP, #28               // *DeAllocation*: Deallocate stack space
    POP {R4, R5, R6, R7, PC}  // Restore registers and return
    
//* * * * * * * * End of OutDec * * * * * * * *

// ECE319H recursive version
// Call the function OutChar to output each character
// You will call OutChar 1 to 5 times
// Input: R0 (call by value) 16-bit unsigned number
// Output: none
// Invariables: This function must not permanently modify registers R4 to R11

OutDec2:
   PUSH {LR}
// write this

   POP  {PC}



     .end
