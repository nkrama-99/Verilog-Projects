module FA_4bitAdder(SW, LEDR);

	input [9:0] SW;
	output [9:0] LEDR;
	wire c1, c2, c3;
	
	fulladd stage0 (SW[8], SW[4], SW[0], LEDR[0], c1);
	fulladd stage1 (c1, SW[5], SW[1], LEDR[1], c2);
	fulladd stage2 (c2, SW[6], SW[2], LEDR[2], c3);
	fulladd stage3 (c3, SW[7], SW[3], LEDR[3], LEDR[9]);

endmodule

module fulladd (Cin, x, y, s, Cout);
   input Cin, x, y;
	output s, Cout;
	
	assign s=x^y^Cin;
	assign Cout=(x & y)|(x & Cin)|(y & Cin);
		
endmodule
