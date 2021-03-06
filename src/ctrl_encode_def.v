// ALU control signal
`define ALUOp_ADDU  2'b00
`define ALUOp_SUBU  2'b01
`define ALUOp_OR    2'b10
`define  ALUOP_MOV  2'b11



// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10   

// GPR control signal
`define GPRSel_RT   2'b00
`define GPRSel_RD   2'b01
`define GPRSel_R31   2'b10

`define WDSel_FromALU 2'b00
`define WDSel_FromMEM 2'b01
`define WDSel_FromPC  2'b10

`define BSel_FromRD2 1'b0
`define BSel_FromEXT 1'b1

// EXT control signal
`define EXT_ZERO    1'b0
`define EXT_SIGNED  1'b1

// OP
`define INSTR_RTYPE_OP      6'b000000
`define INSTR_LW_OP         6'b100011
`define INSTR_SW_OP         6'b101011
`define INSTR_ORI_OP        6'b001101  
`define INSTR_BEQ_OP        6'b000100
`define INSTR_JAL_OP        6'b000011
`define INSTR_BNE_OP        6'b000101

// Funct
`define INSTR_ADDU_FUNCT    6'b100001
`define INSTR_SUBU_FUNCT    6'b100011

