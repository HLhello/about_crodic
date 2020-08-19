`timescale 1ns/1ps

module cordic_rmod(clk,rst,phase_in,sin_out,cos_out,eps);

parameter DATA_WIDTH = 32;
parameter PIPELINE = 32;
parameter PI_d2 = 32'h40000000;
parameter PI = 32'h80000000;
parameter PI_m3_d2 = 32'hc0000000;
parameter INI_VAL = 32'h4DBA76D2;		//2^32/1.64676

input clk;
input rst;
input [DATA_WIDTH-1:0] phase_in;

output reg [17:0] sin_out;
output reg [17:0] cos_out;
output reg [17:0] eps;

reg  [DATA_WIDTH-1:0] phase_in_reg;

reg  [DATA_WIDTH-1:0] x[PIPELINE:0];
reg  [DATA_WIDTH-1:0] y[PIPELINE:0];
reg  [DATA_WIDTH-1:0] z[PIPELINE:0];

reg [1:0] quadrant_t[PIPELINE:0];
reg [1:0] quadrant;

wire [DATA_WIDTH-1:0] theta[PIPELINE-1:0];

assign theta[0] = 32'h20000000;
assign theta[1] = 32'h12E4051E;
assign theta[2] = 32'h09FB385B;
assign theta[3] = 32'h051111D4;
assign theta[4] = 32'h028B0D43;
assign theta[5] = 32'h0145D7E1;
assign theta[6] = 32'h00A2F61E;
assign theta[7] = 32'h00517C55;
assign theta[8] = 32'h0028BE53;
assign theta[9] = 32'h00145F2F;
assign theta[10] = 32'h000A2F98;
assign theta[11] = 32'h000517CC;
assign theta[12] = 32'h00028BE6;
assign theta[13] = 32'h000145F3;
assign theta[14] = 32'h0000A2FA;
assign theta[15] = 32'h0000517D;
assign theta[16] = 32'h000028BE;
assign theta[17] = 32'h0000145F;
assign theta[18] = 32'h00000A30;
assign theta[19] = 32'h00000518;
assign theta[20] = 32'h0000028C;
assign theta[21] = 32'h00000146;
assign theta[22] = 32'h000000A3;
assign theta[23] = 32'h00000051;
assign theta[24] = 32'h00000029;
assign theta[25] = 32'h00000014;
assign theta[26] = 32'h0000000A;
assign theta[27] = 32'h00000005;
assign theta[28] = 32'h00000003;
assign theta[29] = 32'h00000001;
assign theta[30] = 32'h00000001;
assign theta[31] = 32'h00000000;

//get real quadrant and map to first_n quadrant

always @(posedge clk or negedge rst)
	if(!rst)
		phase_in_reg <= 32'h00000000;
	else
		case(phase_in[DATA_WIDTH-1:DATA_WIDTH-2])
			2'b00: phase_in_reg <= phase_in;
			2'b01: phase_in_reg <= phase_in - PI_d2;  	//-pi/2
			2'b10: phase_in_reg <= phase_in - PI;  		//-pi
			2'b11: phase_in_reg <= phase_in - PI_m3_d2;	//-3pi/2
			default: phase_in_reg <= phase_in;
		endcase

always @(posedge clk or negedge rst)
	if(!rst)
		x[0] <= 32'h00000000;
	else
		x[0] <= INI_VAL;

always @(posedge clk or negedge rst)
	if(!rst)
		y[0] <= 32'h00000000;
	else
		y[0] <= 32'h00000000; 

always @(posedge clk or negedge rst)
	if(!rst)
		z[0] <= 32'h00000000;
	else
		z[0] <= phase_in_reg; 

always @(posedge clk or negedge rst)
	if(!rst)
		quadrant_t[0] <= 2'd0;
	else
		quadrant_t[0] <= phase_in[DATA_WIDTH-1:DATA_WIDTH-2];

genvar i;
generate
	begin
		for (i=0; i<PIPELINE; i=i+1)
			begin: loop
				always @(posedge clk or negedge rst)
					if(!rst)
						x[i+1] <= 32'h00000000;
					else
						if(z[i][DATA_WIDTH-1]==1'b0)
							x[i+1] <= x[i] - {{i{y[i][DATA_WIDTH-1]}}, y[i][DATA_WIDTH-1:i]};
					else
						x[i+1] <= x[i] + {{i{y[i][DATA_WIDTH-1]}}, y[i][DATA_WIDTH-1:i]};
						
				always @(posedge clk or negedge rst)
					if(!rst)
						y[i+1] <= 32'h00000000;
					else
						if(z[i][DATA_WIDTH-1]==1'b0)
							y[i+1] <= y[i] + {{i{x[i][DATA_WIDTH-1]}}, x[i][DATA_WIDTH-1:i]};
					else
						y[i+1] <= y[i] - {{i{x[i][DATA_WIDTH-1]}}, x[i][DATA_WIDTH-1:i]};
						
				always @(posedge clk or negedge rst)
					if(!rst)
						z[i+1] <= 32'h00000000;
					else
						if(z[i][DATA_WIDTH-1]==1'b0)
							z[i+1] <= z[i] - theta[i];
					else
						z[i+1] <= z[i] + theta[i];
						
				//remain the quadrant information for 'duiqi'
				always @(posedge clk or negedge rst)
					if(!rst)
						quadrant_t[i+1] <= 2'b00;
					else
						quadrant_t[i+1] <= quadrant_t[i];
			end
	end
endgenerate
					
always @(posedge clk or negedge rst)
	if(!rst)
		quadrant <= 2'b00;
	else
		quadrant <= quadrant_t[PIPELINE];			
					
always @(posedge clk or negedge rst)
	if(!rst)
		sin_out <= 18'd0;
	else
		case(quadrant)
            2'b00: sin_out <= y[PIPELINE][31:14]; 
            2'b01: sin_out <= x[PIPELINE][31:14]; 
            2'b10: sin_out <= ~(y[PIPELINE][31:14]) + 1'b1; 
            2'b11: sin_out <= ~(x[PIPELINE][31:14]) + 1'b1; 
		endcase

always @(posedge clk or negedge rst)
	if(!rst)
		cos_out <= 18'd0;
	else
		case(quadrant)
            2'b00: cos_out <= x[PIPELINE][31:14];
            2'b01: cos_out <= ~(y[PIPELINE][31:14]) + 1'b1;
            2'b10: cos_out <= ~(x[PIPELINE][31:14]) + 1'b1;
            2'b11: cos_out <= y[PIPELINE][31:14];
		endcase

always @(posedge clk or negedge rst)
	if(!rst)
		eps <= 18'd0;
	else
		eps <= z[PIPELINE][31:14];

endmodule

