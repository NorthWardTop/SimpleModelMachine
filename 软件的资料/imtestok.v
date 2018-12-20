module im( addr, dout,clk );
    input clk;
    input [7:0] addr;
    output reg [31:0] dout;
    
    reg [31:0] imem[127:0];
   
initial
begin
imem[0]=32'h341d000c;
imem[1]	=32'h34021234;
imem[2]	=32'h34033456;
imem[3]	=32'h432021;
imem[4]	=32'h643023;
imem[5]	=32'hac020000;
imem[6]	=32'hac030004;
imem[7]	=32'hafa40004;
imem[8]	=32'h8c050000;
imem[9]	=32'h10450001;
imem[10]=32'h8fa30004;
imem[11]=32'h8c050004;
imem[12]=32'h1065fffd;
imem[13]=32'h0c000c0e;
imem[14]=32'h00c23023;
imem[15]=32'hafa6fffc;
imem[16]=32'h1064ffff;
end

// initial 
// $readmemh( "code.txt" , imem) ;

 
 always@(posedge clk)
    dout = imem[addr];
    
endmodule    
