`timescale 1ns / 1ns // `timescale time_unit/time_precision

// top level module
module mux2to1(LEDR, SW);

    input [9:0] SW;
    output [9:0] LEDR;
	 wire not2_and2, and3_or1, and6_or2;
	 
	 v7404 notGate (
		.pin1(SW[9]),
		.pin2(not2_and2)
	 );

	 v7408 andGate (
		.pin1(SW[0]),
		.pin2(not2_and2),
		.pin3(and3_or1),
		.pin4(SW[9]),
		.pin5(SW[1]),
		.pin6(and6_or2)
	 );

	 v7432 orGate (
		.pin1(and3_or1),
		.pin2(and6_or2),
		.pin3(LEDR[0])
	 );
	 
endmodule

// not gate
module v7404 (input pin1, pin3, pin5, pin9, pin11, pin13,
					output pin2, pin4, pin6, pin8, pin10, pin12);
	
	assign pin2 = ~pin1;
	assign pin4 = ~pin3;
	assign pin6 = ~pin5;
	assign pin12 = ~pin13;
	assign pin10 = ~pin11;
	assign pin8 = ~pin9;
	
endmodule

// and gate
module v7408 (input pin1, pin2, pin4, pin5, pin12, pin13, pin10, pin9,
					output pin3, pin6, pin11, pin8);
	
	assign pin3 = pin1 & pin2;
	assign pin6 = pin4 & pin5;
	assign pin8 = pin10 & pin9;
	assign pin11 = pin12 & pin13;
	
endmodule
	
// or gate
module v7432 (input pin1, pin2, pin4, pin5, pin13, pin12, pin10, pin9, 
					output pin3, pin6, pin11, pin8);
	
	assign pin3 = pin1 | pin2;
	assign pin6 = pin4 | pin5;
	assign pin11 = pin13 | pin12;
	assign pin8 = pin9 | pin10;
	
endmodule
