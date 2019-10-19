`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[3:0] data inputs
//HEX0 output display

module HEXdecoder(HEX0, SW);
    input [3:0] SW;
    output [6:0] HEX0;

    HEXdefinition hex0(
        .x1(SW[0]),
        .x2(SW[1]),
        .x3(SW[2]),
        .x4(SW[3]),
		  .y0(HEX0[0]),
		  .y1(HEX0[1]),
		  .y2(HEX0[2]),
		  .y3(HEX0[3]),
		  .y4(HEX0[4]),
		  .y5(HEX0[5]),
		  .y6(HEX0[6])
        );
		  
endmodule

module HEXdefinition (x1, x2, x3, x4, y0, y1, y2, y3, y4, y5, y6);
    input x1; //input1
    input x2; //input2
    input x3; //input3
    input x4; //input4
	output y0; //output0
	output y1; //output1
	output y2; //output2
	output y3; //output3
	output y4; //output4
	output y5; //output5
	output y6; //output6

    assign y0 = ((~x1 & ~x2 & ~x3 & x4) | (~x1 & x2 & ~x3 & ~x4) | (x1 & ~x2 & x3 & x4) | (x1 & x2 & ~x3 & x4)); //eq0
	assign y1 = ((~x1 & x2 & ~x3 & x4) | (~x1 & x2 & x3 & ~x4) | (x1 & ~ x2 & x3 & x4) | (x1 & x2 & ~x3 & ~x4) | (x1 & x2 & x3 & ~x4) | (x1 & x2 & x3 & ~x4) | (x1 & x2 & x3 & x4)); //eq1
	assign y2 = ((~x1 & ~x2 & x3 & ~x4)|(x1 & x2 & ~x3 & ~x4)|(x1 & x2 & x3 & ~x4)|(x1 & x2 & x3 & x4)); //eq2
	assign y3 = ((~x1 & ~x2 & ~x3 & x4) | (~x1 & x2 & ~x3 & ~x4) |(~x1 & x2 & x3 & x4) |(x1 & ~x2 & x3 & ~x4) | (x1 & x2 & x3 & x4)); //eq3
	assign y4 = ((~x1 & ~x2 & ~x3 & x4) |(~x1 & ~x2 & x3 & x4) |(~x1 & x2 & ~x3 & ~x4) |(~x1 & x2 & ~x3 & x4) |(~x1 & x2 & x3 & x4) |(x1 & ~x2 & ~x3 & x4)); //eq4
	assign y5 = ((~x1 & ~x2 & ~x3 & x4)|(~x1 & ~x2 & x3 & ~x4)|(~x1 & ~x2 & x3 & x4)|(~x1 & x2 & x3 & x4)|(x1 & x2 & ~x3 & x4)); //eq5
	assign y6 = ((~x1 & ~x2 & ~x3 & ~x4)|(~x1 & ~x2 & ~x3 & x4)|(~x1 & x2 & x3 & x4)|(x1 & x2 & ~x3 & ~x4)); //eq6

endmodule
