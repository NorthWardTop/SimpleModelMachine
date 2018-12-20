module im_4K( addr, dout);
    input [29:0] addr;
    output  [31:0] dout;
    
    reg [31:0] imem[127:0];
   
initial
begin
imem[0]=32'h34010004 ;
imem[1]	=32'h34020001 ;
imem[2]	=32'h34030001 ;
imem[3]	=32'hac420000  ;
imem[4]	=32'h00431021  ;
imem[5]	=32'h1441fffd  ;
imem[6]	=32'h34020006  ;
imem[7]	=32'h34010000  ;
imem[8]	=32'h8c440000  ;
imem[9]	=32'h00240821   ;
imem[10]=32'h00431023   ;
imem[11]=32'h1440fffc  ;
imem[12]=32'hac010000;
imem[13]=32'h0c000000;
imem[14]=32'h 0;
imem[15]=32'h 0;
imem[16]=32'h 0;
end

assign  dout = imem[addr];
    
endmodule    


























