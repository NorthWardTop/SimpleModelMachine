`include "ctrl_encode_def.v"
//`include "instruction_def.v"
module ctrl(clk,	rst, Zero, Op, Funct,
            RFWr, DMWr, PCWr, IRWr,
            EXTOp, ALUOp, NPCOp, GPRSel,
            WDSel, BSel,  state);
    
   input 		     clk, rst, Zero;       
   input  [5:0] Op;
   input  [5:0] Funct; 
   output reg [2:0]  state;
   output       RFWr;
   output       DMWr;
   output       PCWr;
   output       IRWr;
   output  EXTOp;
   output [1:0] ALUOp;
   output [1:0] NPCOp;
   output [1:0] GPRSel;
   output [1:0] WDSel;
   output       BSel; 
    
   parameter Fetch  = 4'b000,
             DCD    = 4'b001,
             Exe    = 4'b010,
             Mem    = 4'b011,
             WB     = 4'b100;
    
	
   wire RType;   // Type of R-Type Instruction
   wire IType;   // Tyoe of Imm    Instruction  
   wire BrType;  // Type of Branch Instruction
   wire JType;   // Type of Jump   Instruction
   wire LdType;  // Type of Load   Instruction
   wire StType;  // Type of Store  Instruction
   wire MemType; // Type pf Memory Instruction(Load/Store)
	
   assign RType   = (Op == `INSTR_RTYPE_OP);
   assign IType   = (Op == `INSTR_ORI_OP  );
   assign BrType  = (Op == `INSTR_BNE_OP );
   assign JType   = (Op == `INSTR_JAL_OP  );
	assign LdType  = (Op == `INSTR_LW_OP   );
	assign StType  = (Op == `INSTR_SW_OP   );
   assign MemType = LdType || StType;
    
	/*************************************************/
	/******               FSM                   ******/
   reg [3:0] nextstate;
  // reg [3:0] state;
   
   always @(posedge clk or posedge rst) begin
	   if ( rst )
		   state <= Fetch;
      else
         state <= nextstate;
	end // end always
             
   always @(state or rst) begin
    if(rst)
        nextstate=Fetch;
    else  
        case (state)
         Fetch: nextstate = Exe;
         Exe:  nextstate = Mem;
         Mem:  nextstate = WB;
         WB:   nextstate = Fetch;
       	default: ;
       endcase
   end // end always
	
	
	/*************************************************/
	/******         Control Signal              ******/
	reg       RFWr;
   reg       DMWr;
   reg       PCWr;
   reg       IRWr;
   reg  EXTOp;
   reg [1:0] ALUOp;
   reg [1:0] NPCOp;
   reg [1:0] GPRSel;
   reg [1:0] WDSel;
   reg       BSel;
	
	always @(posedge clk or posedge rst) begin
     if(rst) begin
            PCWr   = 1'b0;
            NPCOp  = 0; 
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            EXTOp  = 0;
            GPRSel = 0;
            WDSel  = 0;
            BSel   = 0;
            ALUOp  = 0;
      end
    else
	   case ( state ) 
		 Fetch: begin
            PCWr   = 1'b0;
            NPCOp  = 0; 
            IRWr   = 1'b1;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            EXTOp  = 0;
            GPRSel = 0;
            WDSel  = 0;
            BSel   = 0;
            ALUOp  = 0;
			end // end Fetch
         Exe: 	begin
		    IRWr   = 1'b0;
		    NPCOp  = 0; 
		    PCWr   = 1'b1;
			if(IType) begin	
					EXTOp = `EXT_ZERO; 
					BSel=`BSel_FromEXT;
					 if(Op==`INSTR_ORI_OP) 
						 ALUOp = `ALUOp_OR;
				 end
			else if(RType)begin	
					 BSel=`BSel_FromRD2;
					 if(Funct==`INSTR_ADDU_FUNCT) 
						 ALUOp = `ALUOp_ADDU;
				     else if(Funct==`INSTR_SUBU_FUNCT) 
				          ALUOp = `ALUOp_SUBU;
				     else
				          ALUOp = 2'b00;
				 end
			else if(MemType)begin	
				     EXTOp = `EXT_ZERO;
					 BSel=`BSel_FromEXT;
				     ALUOp = `ALUOp_ADDU;
				 end
		   	else if(BrType) begin	
					BSel=`BSel_FromRD2;
				 if(Op==`INSTR_BNE_OP) 
						 ALUOp = `ALUOp_SUBU;
				 end					 
			 end // end Exe
		Mem: begin
			     PCWr   = 1'b0;
			     if(StType) begin	
				     DMWr   = 1'b1;
			      end
			 end // end MemWB
        WB: 	begin
			DMWr   = 1'b0;
			if(RType) begin
			   WDSel  = `WDSel_FromALU;
			   GPRSel = `GPRSel_RD;
			   RFWr  = 1'b1;
			end
			else if(IType)  begin
			   WDSel  = `WDSel_FromALU;
			   GPRSel = `GPRSel_RT;
			   RFWr  = 1'b1;
			end     
			else if(LdType)  begin
			   WDSel  = `WDSel_FromMEM;
			   GPRSel = `GPRSel_RT;
			   RFWr  = 1'b1;
			end     
			else if(JType)  begin
			   WDSel  = `WDSel_FromPC;
			   GPRSel = `GPRSel_R31;
			   RFWr  = 1'b1;
			end     
			if(BrType&&(~Zero)) 
			begin 
			   NPCOp=`NPC_BRANCH;
			   PCWr   = 1'b1;
			end
			else if(JType) 
			begin 
			   NPCOp=`NPC_JUMP;
			   PCWr   = 1'b1;
			end
			else
			  PCWr   = 1'b0;
			end  // end WB

//			default: begin
//            PCWr   = 1'b0;
//            NPCOp  = 0;
//            IRWr   = 1'b0;
//            RFWr  = 1'b0;
//            DMWr   = 1'b0;
//            EXTOp  = 0;
//            GPRSel = 0;
//            WDSel  = 0;
//            BSel   = 0;
//            ALUOp  = 0;
//			end // end default
	   endcase
   end // end always
    
endmodule
