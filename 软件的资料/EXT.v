module EXT( Imm16,Imm32,EXTSigned );
  input EXTSigned;
  input  [15:0] Imm16;
  output reg [31:0] Imm32;
   
   
   always@(Imm16,EXTSigned)
   begin
	   if(EXTSigned)
			begin
			  if(Imm16[15])
			  Imm32={16'hffff,Imm16};
			  else
				Imm32={16'h0,Imm16};
			end
	   else
		  Imm32={16'h0,Imm16};
   end 
endmodule


module EXTPC( iPC30,oPC32);
  input [29:0] iPC30;
  output    [31:0] oPC32;
  
  assign oPC32={2'b00,iPC30};
endmodule

  
  