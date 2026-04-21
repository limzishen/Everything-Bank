# Main Control Unit 
Main Control unit takes in the opcode and generate: 
- RegDst (0: take in Inst[20:16], 1: Inst[15:11] for field WR)
- RegWrite (1: value from WD is writted in the address in WR)
- Branch (1: is a branch instruction)
- MemRead (1: sw/sb Instruction)
- MemWrite (1: lw/lb Instruction)
- MemToReg (0: Send value from ALU to WD, 1: Take value from Data Memory to WD)
- ALUSrc (0: take value for RD2 1: take value from Sign Extended Immediate)
- ALUop (10: R-type, 01: beq, 00: lw/sw (Sends this to the ALU Control Unit))

![[Pasted image 20260307231655.png]]
![[Pasted image 20260307231829.png]]

# ALU Control Unit 
ALU Control Unit takes in the ALUop (from Main Control Unit) and Funct code to generate 4 bit ALU Control code for the ALU unit
![[Pasted image 20260307232904.png]]