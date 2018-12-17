module im_4K( addr, dout);
    input [29:0] addr;
    output  [31:0] dout;
    
    reg [31:0] imem[127:0];
  
//code initial  here
//initial
//begin
//
//end

assign  dout = imem[addr];
    
endmodule    


























