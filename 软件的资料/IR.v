module IR (clk, rst, IRWr, im_dout,Op,rs,rt,rd,Funct,Imm16,IMM26,oIR);
               
   input         clk;
   input         rst;
   input         IRWr; 
   input  [31:0] im_dout;
   output [5:0] Op,Funct;
   output [4:0] rs,rt,rd;
   output [15:0] Imm16;
   output [25:0] IMM26;
   output  [31:0] oIR;
   
   reg [31:0] instr;
      
   assign Op = instr[31:26];
   assign Funct = instr[5:0];
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign rd = instr[15:11];
   assign Imm16 = instr[15:0];
   assign IMM26 = instr[25:0];
   assign oIR=instr;
               
   always @(posedge clk or posedge rst) begin
      if ( rst ) 
         instr <= 0;
      else if (IRWr)
         instr <= im_dout;
   end // end always
      
endmodule
