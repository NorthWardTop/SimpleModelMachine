module KGATE_3S(A,B,N_EN);
parameter N=8;
input [N-1:0] A;
output [N-1:0] B;
input N_EN;

assign B=N_EN? 32'Bz : A;
endmodule