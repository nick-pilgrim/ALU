//This .v File contains my alu_pv module, ALU module, and alu_tb module

//This is my ALU module that uses the opcode and inputs to do the required calculations using instances of the FUll adder and twos complement
module ALU(input [3:0] aluin_a, aluin_b, OPCODE, input Cin, output reg [3:0] alu_out, output reg Cout, output OF);
	reg[3:0] Bin;
	wire[3:0] Bn, S;
	wire Co, of;
	reg of_;
	assign OF = of_;
	com2s C1(aluin_b, Bn);
	FA4 FAA (aluin_a, Bin, Cin, S, Co, of);
	always @ (*) begin
		Bin = 4'b0000; alu_out = 4'b0000; Cout = 1'b0; of_ = 1'b0;
		case (OPCODE)
			4'b0001: begin //add with Cin alu_out = alu_in_a + alu_in_b + Cin
				Bin = aluin_b; alu_out = S; Cout = Co; of_ = of;
				end
			4'b0010: begin //add alu_out = alu_in_a + alu_in_b
				Bin = aluin_b; alu_out = S; Cout = Co; of_ = of;
				end
			4'b0011: begin //sub b from a alu_out = alu_in_a - alu_in_b
				Bin = Bn; alu_out = S; Cout = Co;
				end
			4'b0100: begin // Bitwise AND alu_out = (alu_in_a&alu_in_b)
				alu_out = (aluin_a & aluin_b);
				end
			4'b0101: begin // Bitwise NOR alu_out = ~(alu_in_a|alu_in_b)
				alu_out = ~(aluin_a|aluin_b);
				end
			4'b0110: begin // Bitwise XNOR alu_out = ~(alu_in_a^alu_in_b)
				alu_out = ~(aluin_a^aluin_b);
				end
			4'b0111: begin // Bitwise NOT alu_out = ~alu_in_a
				alu_out = ~aluin_a;
				end
			4'b1000: begin //logical right shift  alu_out = alu_in_a>>1
				alu_out = aluin_a>>1;
				end
			default: begin Bin = 4'b0000; alu_out = 4'bxxxx; Cout = 1'b0; of_ = 1'b0; end
		endcase
	end
endmodule

//this is my 4 bit full adder
module FA4(input [3:0] A, B, input Cin, output [3:0] Sum, output Cout, OF);
wire Cout1, Cout2, Cout3;
FA fa1(A[0], B[0], Cin, Sum[0], Cout1);
FA fa2(A[1], B[1], Cout1, Sum[1], Cout2);
FA fa3(A[2], B[2], Cout2, Sum[2], Cout3);
FA fa4(A[3], B[3], Cout3, Sum[3], Cout);
xor X1 (OF, Cout3, Cout);
endmodule

//this is my two's complement module
module com2s(input [3:0] B, output [3:0] Bn);
wire [3:0] Bn1;
wire OF;
assign Bn1 = ~B;
FA4 FAC(Bn1, 4'b0000, 1'b1, Bn, Cout, OF);
endmodule

//this is my 1 bit full adder
module FA(input A, B, Cin, output Sum, Cout);
wire S1, C1, C2;
HA M1 (A, B, S1, C1);
HA M2 (S1, Cin, Sum, C2);
or M3(Cout, C1, C2);
endmodule

//this is my half adder
module HA(input A, B, output Sum, Cout);
assign Sum = A^B;
assign Cout = A&B;
endmodule

//This is my test bench module with the simulation verification
module ALU_tb();
reg [3:0] A, B, OPCODE;
wire [3:0] S1, RESULT, S;
reg Cin;
wire Cout, OF;
initial begin

//add
OPCODE = 4'b0010; A = 4'b0011; B = 4'b0011; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S, OPCODE, Cout, OF);

//add with Cin
OPCODE = 4'b0001; A = 4'b0110; B = 4'b0101; Cin = 1; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S, OPCODE, Cout, OF);

//sub b from a
OPCODE = 4'b0011; A = 4'b0111; B = 4'b0110; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S, OPCODE, Cout, OF);

//Bitwise AND
OPCODE = 4'b0100; A = 4'b0111; B = 4'b1010; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S, OPCODE, Cout, OF);

//Bitwise NOR
OPCODE = 4'b0101; A = 4'b0111; B = 4'b0011; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S, OPCODE, Cout, OF);

//Bitwise XNOR
OPCODE = 4'b0110; A = 4'b0101; B = 4'b1110; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S, OPCODE, Cout, OF);

//Bitwise NOT
OPCODE = 4'b0111; A = 4'b1011; B = 4'b0000; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S, OPCODE, Cout, OF);

//logical right shift
OPCODE = 4'b1000; A = 4'b0101; B = 4'b0000; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S, OPCODE, Cout, OF);


/*
//Result of given function
//~(aluin_a^aluin_b)
OPCODE = 4'b0101; A = 4'b0100; B = 4'b0011; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S1, OPCODE, Cout, OF);

//~(~(aluin_a^aluin_b))
OPCODE = 4'b0111; A = S1; B = 4'b0000; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, S1, OPCODE, Cout, OF);

//(aluin_a & aluin_b)
OPCODE = 4'b0100; A = 4'b0100; B = 4'b0011; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, RESULT, OPCODE, Cout, OF);

//~(aluin_a & aluin_b)
OPCODE = 4'b0111; A = RESULT; B = 4'b0000; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, RESULT, OPCODE, Cout, OF);

//(~(aluin_a & aluin_b))>>1
OPCODE = 4'b1000; A = RESULT; B = 4'b0000; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, RESULT, OPCODE, Cout, OF);

//(~(~(aluin_a^aluin_b)))+((~(aluin_a & aluin_b))>>1)
OPCODE = 4'b0001; A = S1; B = RESULT; Cin = 0; #5;
$display("A= %b, B = %b, C = %b, Sum = %b, OPCODE = %b, Cout = %b, OF = %b", A, B, Cin, RESULT, OPCODE, Cout, OF);
*/

end

//ALU alu2(A,B,OPCODE,Cin, S1, Cout, OF); // Result part 1
//ALU alu3(A,B,OPCODE,Cin, RESULT, Cout, OF); // Result part 2

ALU alu1(A,B,OPCODE,Cin, S, Cout, OF);
endmodule


//This is my alu parent module that instantiates the ALU module so that it can work with the physical board's inputs
module ALU_pv (input [3:0] aluin_a, OPCODE, input Cin, output reg [3:0] alu_out, output reg Cout, output reg OF); 
	reg [3:0] A;
	reg [3:0] OP;
	wire[3:0] aluin_b;
	reg in;
	assign aluin_b = 4'b0011;
	wire [3:0] a_out;
	wire Co;
	wire O;
	ALU a1(A,aluin_b,OP, in, a_out, Co, O);
	always @ (*) begin
		A = aluin_a;
		OP = OPCODE;
		in = Cin;
		alu_out = a_out;
		Cout = Co;
		OF = O;
end
endmodule
