;; This is my first boot loader

  ;; When an x86 machine starts, it is in 16 bit real mode.
  ;; This directive tells the assembler to generate 16 bit instructions.
  [BITS 16]

  ;; The ORG directive tells the assembler which memory address the program will start at.
  ;; This is knowable for a boot loader because the BIOS will always load our code into the same memory space.
  ;; My current hypothesis here is that in protected mode, virtual memory would make every program appear to start at address 0x0000, but in real mode, I have to work with real memory addresses.
  [ORG 0x7C00]

  ;; This is the actual boot loader.
  ;; In this incarnation, it simply prints an 'A' to the terminal and then hangs.
main:
  mov ah, 0x0E                  ; ah stores the operation code to execute. 0Eh tells the BIOS that we want to print a single character.
  mov al, 'A'                   ; al stores the ASCII code of the character we want to print.
  mov bh, 0x0F                  ; bh stores the color of the text to print. 0Fh means "white"
  mov bl, 0x00                  ; I am not using the bl register (I don't know what it does), but I am told that 00h is a benign value to store there.
  int 0x10                      ; This is a software interupt. That means we're telling the processor to execute a function that it finds using a lookup table stored in the first kilobyte of memory.

hang:                           ; This is a lable which allows me to reference addresses to sets of instructions by name.
  jmp hang                      ; This creates an infinite loop as the procedure jumps back to itself.

  ;; The BIOS looks for the word 55AAh at byte 510 in the given disk sector to verify that it is indeed bootable.
  ;; This section of code fills the rest of the file up to byte 510 and then writes the word 55AAh there.
  ;; $ means "the address of this line"
  ;; $$ means "the address of the start of this (in this case code) section.
  ;; $ - $$ then tells you how far you are into the code section
  times 510-($-$$) db 0h        ; db is a NAMS pseudo instruction. It means "write a byte in assembled program here"
  dw 0xAA55                     ; dw is like db, but it writes a word instead of a byte.
