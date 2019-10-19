`timescale 1ns / 1ns // `timescale time_unit/time_precision

module FA_4bitAdder (LEDR, SW);
	
	input [9:0] SW;
	output [9:0] LEDR;
	wire C1, C2, C3;
	
	// output reading is suppose to be LED 3,2,1,0 in order
	
	FA bit0 (SW[4], SW[0], SW[8], LEDR[0], C1);
	FA bit1 (SW[5], SW[1], C1, LEDR[1], C2);
	FA bit2 (SW[6], SW[2], C2, LEDR[2], C3);
	FA bit3 (SW[7], SW[3], C3, LEDR[3], LEDR[9]);

endmodule

module FA(a, b, Cin, S, Cout);
	
	input a, b, Cin;
	output S, Cout;
	
	assign S = Cin ^ b ^ a;
	assign Cout = (b & a)|(Cin & b)|(Cin & a);
	
endmodule
