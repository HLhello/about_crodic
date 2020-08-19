`timescale 1ns/1ps

module cordic_rmod20(clk,rst,phase_in,sin_out,cos_out,eps);

parameter DATA_WIDTH = 20;
parameter PIPELINE = 20;
parameter PI_d2 = 20'h40000;
parameter PI =20'h80000;
parameter PI_m3_d2 = 20'hc0000;
parameter INI_VAL = 20'h4DBA5;		//2^20/1.64676

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

assign theta[0]  = 20'h20000;
assign theta[1]  = 20'h12E40;
assign theta[2]  = 20'h09FB4;
assign theta[3]  = 20'h05111;
assign theta[4]  = 20'h028B1;
assign theta[5]  = 20'h0145D;
assign theta[6]  = 20'h00A2F;
assign theta[7]  = 20'h00518;
assign theta[8]  = 20'h0028C;
assign theta[9]  = 20'h00146;
assign theta[10] = 20'h000A3;
assign theta[11] = 20'h00051;
assign theta[12] = 20'h00029;
assign theta[13] = 20'h00014;
assign theta[14] = 20'h0000A;
assign theta[15] = 20'h00005;
assign theta[16] = 20'h00003;
assign theta[17] = 20'h00001;
assign theta[18] = 20'h00001;
assign theta[19] = 20'h00000;

//get real quadrant and map to first_n quadrant

always @(posedge clk or negedge rst)
	if(!rst)
		phase_in_reg <= 20'h00000;
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
		x[0] <= 20'h00000;
	else
		x[0] <= INI_VAL;

always @(posedge clk or negedge rst)
	if(!rst)
		y[0] <= 20'h00000;
	else
		y[0] <= 20'h00000; 

always @(posedge clk or negedge rst)
	if(!rst)
		z[0] <= 20'h00000;
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
						x[i+1] <= 20'h00000;
					else
						if(z[i][DATA_WIDTH-1]==1'b0)
							x[i+1] <= x[i] - {{i{y[i][DATA_WIDTH-1]}}, y[i][DATA_WIDTH-1:i]};
					else
						x[i+1] <= x[i] + {{i{y[i][DATA_WIDTH-1]}}, y[i][DATA_WIDTH-1:i]};
						
				always @(posedge clk or negedge rst)
					if(!rst)
						y[i+1] <= 20'h00000;
					else
						if(z[i][DATA_WIDTH-1]==1'b0)
							y[i+1] <= y[i] + {{i{x[i][DATA_WIDTH-1]}}, x[i][DATA_WIDTH-1:i]};
					else
						y[i+1] <= y[i] - {{i{x[i][DATA_WIDTH-1]}}, x[i][DATA_WIDTH-1:i]};
						
				always @(posedge clk or negedge rst)
					if(!rst)
						z[i+1] <= 20'h00000;
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
            2'b00: sin_out <= y[PIPELINE][19:2]; 
            2'b01: sin_out <= x[PIPELINE][19:2]; 
            2'b10: sin_out <= ~(y[PIPELINE][19:2]) + 1'b1; 
            2'b11: sin_out <= ~(x[PIPELINE][19:2]) + 1'b1; 
		endcase

always @(posedge clk or negedge rst)
	if(!rst)
		cos_out <= 18'd0;
	else
		case(quadrant)
            2'b00: cos_out <= x[PIPELINE][19:2];
            2'b01: cos_out <= ~(y[PIPELINE][19:2]) + 1'b1;
            2'b10: cos_out <= ~(x[PIPELINE][19:2]) + 1'b1;
            2'b11: cos_out <= y[PIPELINE][19:2];
		endcase

always @(posedge clk or negedge rst)
	if(!rst)
		eps <= 18'd0;
	else
		eps <= z[PIPELINE][19:2];

endmodule

