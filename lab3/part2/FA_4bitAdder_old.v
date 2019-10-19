`timescale 1ns / 1ns // `timescale time_unit/time_precision

module FA_4bitAdder (LEDR, SW);

	input [9:0] SW;
	output [9:0] LEDR;
	
		wire [3:0] a;
	wire [3:0] b;
	wire cin;
	wire [3:0] s;
	wire cout;
	
	assign a = SW[7:4];
	assign b = SW[3:0];
	assign cin = SW[8];
	assign cout = LEDR[9];
	assign s = LEDR[3:0];
	
	ripple_carry_adder (
		a, b, cin, s, cout
	);

endmodule

module ripple_carry_adder(A, B, Cin, S, Cout);
	
	input [3:0] A,B;
	input Cin;
	output [3:0] S;
	output Cout;
	wire C1, C2, C3;
	
	FA bit0 (A[0], B[0], Cin, S[0], C1);
	FA bit1 (A[1], B[1], C1, S[1], C2);
	FA bit2 (A[2], B[2], C2, S[2], C3);
	FA bit3 (A[3], B[3], C3, S[3], Cout);
	
endmodule

module FA(a, b, Cin, S, Cout);
	
	input a, b, Cin;
	output S, Cout;
	
	assign S = Cin ^ b ^ a;
	assign Cout = (b & a)|(Cin & b)|(Cin & a);
	
endmodule
