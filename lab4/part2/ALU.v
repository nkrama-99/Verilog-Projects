`timescale 1ns / 1ns //timescale time_unit/time_precision

module ripple_carry_adder(A, B, Cin, S, Cout);
	
	
	input [3:0] A;
	input [3:0] B;
	input Cin;
	output [3:0] S;
	output Cout;
	wire C1, C2, C3;
	
	FA bit0 (A[0], B[0], Cin, S[0], C1);
	FA bit1 (A[1], B[1], C1, S[1], C2);
	FA bit2 (A[2], B[2], C2, S[2], C3);
	FA bit3 (A[3], B[3], C3, S[3], Cout);
	
endmodule

module FA (a, b, Cin, S, Cout);
	
	input a, b, Cin;
	output S, Cout;
	
	assign S = Cin ^ b ^ a;
	assign Cout = (b & a)|(Cin & b)|(Cin & a);
	
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

module flipflop (D, Clk, Reset_b, Q); //D enter & Q exit & Rese_b force to zeor
	
	input [7:0] D;
	input Clk, Reset_b;
	output reg [7:0] Q;

	always@(posedge Clk)
	begin
		if (Reset_b == 1'b0)
			Q <= 0;
		else
			Q <= D;
	end

endmodule

module ALU (SW, KEY, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, ALUout); //top level module

	input [9:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1; 
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4; 
	output [6:0] HEX5;

	wire [3:0] Data;
	wire [3:0] B; 
	wire [7:0] FAout; //used output in old code
	wire [7:0] FFout; //used output in old code
	output reg [7:0] ALUout;

	// assigning switches to Data && four least sig bits to B
	assign Data = SW[3:0];
	assign B = FFout[3:0];

	// computing for ripple carry adder
	ripple_carry_adder FA1 (Data[3:0], B[3:0], 0, FAout[3:0], FAout[4]);
	assign FAout[5] = 0;
	assign FAout[6] = 0;
	assign FAout[7] = 0;

	always @(*)
	begin
		case(KEY[3:1])
			//0: A + B using the adder from Part II of this Lab (ripple-carry adder)
			3'b000: 
			begin
				ALUout = FAout;
			end
			
			//1: A + B using the Verilog ‘+’ operator
			3'b001:
			begin
				ALUout[7:0] = Data[3:0] + B[3:0];
			end
			
			//2: A XNOR B in the lower four bits of ALUout and A NAND B in the upper four bits 
			3'b010:
			begin
				ALUout[3:0] = Data[3:0] ~^ B[3:0];
				ALUout[7:4] = ~(Data[3:0] & B[3:0]);
			end
			
			//3: Output 8’b00001111 if at least 1 of the 8 bits in the two inputs is 1 (use a single OR operation) 
			3'b011:
			begin
				if ({B[3:0],Data[3:0]} != (8'b0000000))
					ALUout[7:0] = (8'b0001111);
				else
					ALUout[7:0] = (8'b0000000);				
			end
			
			//4: Output 8’b11110000 if exactly 1 bit of the A switches is 1, and exactly 2 bits of the B switches are 1 
			3'b100: 
			begin
				if ((Data[3] + Data[2] + Data[1] + Data[0] == 1) && (B[3] + B[2] + B[1] + B[0] == 2))
					ALUout[7:0] = (8'b1110000);
				else
					ALUout[7:0] = (8'b0000000);
			end
			
			//5: Display the A switches in the most significant four bits of ALUout and the complement of the B switches in the least-significant four bits without complementing the bits individually
			3'b101:
			begin
				ALUout[3:0] = ~B[3:0]; //must be the compliments of B
				ALUout[7:4] = Data[3:0];
			end

			//6: Hold the current value of the Register, i.e., the Register value does not change
			3'b110:
			begin
				ALUout = FFout;
			end
		
			default: 
			begin
				ALUout[7:0] = 8'b00000000;
			end
		endcase
	end

	//register is instantiated
	flipflop register (ALUout, KEY[0], SW[9], FFout);

	assign LEDR = FFout;

	// HEX0 - input A
	HEXdefinition hex0(
		.x1(Data[3]),
		.x2(Data[2]),
		.x3(Data[1]),
		.x4(Data[0]),
		.y0(HEX0[0]),
		.y1(HEX0[1]),
		.y2(HEX0[2]),
		.y3(HEX0[3]),
		.y4(HEX0[4]),
		.y5(HEX0[5]),
		.y6(HEX0[6])
	);

	// HEX1 - 0
	HEXdefinition hex1(
		.x1(0),
		.x2(0),
		.x3(0),
		.x4(0),
		.y0(HEX1[0]),
		.y1(HEX1[1]),
		.y2(HEX1[2]),
		.y3(HEX1[3]),
		.y4(HEX1[4]),
		.y5(HEX1[5]),
		.y6(HEX1[6])
	);

	// HEX2 - 0
	HEXdefinition hex2(
		.x1(0),
		.x2(0),
		.x3(0),
		.x4(0),
		.y0(HEX2[0]),
		.y1(HEX2[1]),
		.y2(HEX2[2]),
		.y3(HEX2[3]),
		.y4(HEX2[4]),
		.y5(HEX2[5]),
		.y6(HEX2[6])
	);

	// HEX3 - 0
	HEXdefinition hex3(
		.x1(0),
		.x2(0),
		.x3(0),
		.x4(0),
		.y0(HEX3[0]),
		.y1(HEX3[1]),
		.y2(HEX3[2]),
		.y3(HEX3[3]),
		.y4(HEX3[4]),
		.y5(HEX3[5]),
		.y6(HEX3[6])
	);

	// HEX4 - FFout[3-0]
	HEXdefinition hex4(
		.x1(FFout[3]),
		.x2(FFout[2]),
		.x3(FFout[1]),
		.x4(FFout[0]),
		.y0(HEX4[0]),
		.y1(HEX4[1]),
		.y2(HEX4[2]),
		.y3(HEX4[3]),
		.y4(HEX4[4]),
		.y5(HEX4[5]),
		.y6(HEX4[6])
	);   
	// HEX5 - FFout[7-4
	HEXdefinition hex5(
		.x1(FFout[7]),
		.x2(FFout[6]),
		.x3(FFout[5]),
		.x4(FFout[4]),
		.y0(HEX5[0]),
		.y1(HEX5[1]),
		.y2(HEX5[2]),
		.y3(HEX5[3]),
		.y4(HEX5[4]),
		.y5(HEX5[5]),
		.y6(HEX5[6])
	);

endmodule

