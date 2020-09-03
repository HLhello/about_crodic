`timescale 1ns/1ps
module cordic(clk,rst_n,ena,phase_in,sin_out,cos_out,eps);

parameter DATA_WIDTH=16;
parameter PIPELINE=16;

input clk;
input rst_n;
input ena;
input [DATA_WIDTH-1:0] phase_in;

output [DATA_WIDTH-1:0] sin_out;
output [DATA_WIDTH-1:0] cos_out;
output [DATA_WIDTH-1:0] eps;

reg [DATA_WIDTH-1:0] sin_out;
reg [DATA_WIDTH-1:0] cos_out;
reg [DATA_WIDTH-1:0] eps;

reg  [DATA_WIDTH-1:0] phase_in_reg;

reg  [DATA_WIDTH-1:0] x0;
reg  [DATA_WIDTH-1:0] x1;
reg  [DATA_WIDTH-1:0] x2;
reg  [DATA_WIDTH-1:0] x3;
reg  [DATA_WIDTH-1:0] x4;
reg  [DATA_WIDTH-1:0] x5;
reg  [DATA_WIDTH-1:0] x6;
reg  [DATA_WIDTH-1:0] x7;
reg  [DATA_WIDTH-1:0] x8;
reg  [DATA_WIDTH-1:0] x9;
reg  [DATA_WIDTH-1:0] x10;
reg  [DATA_WIDTH-1:0] x11;
reg  [DATA_WIDTH-1:0] x12;
reg  [DATA_WIDTH-1:0] x13;
reg  [DATA_WIDTH-1:0] x14;
reg  [DATA_WIDTH-1:0] x15;

reg  [DATA_WIDTH-1:0] y0;
reg  [DATA_WIDTH-1:0] y1;
reg  [DATA_WIDTH-1:0] y2;
reg  [DATA_WIDTH-1:0] y3;
reg  [DATA_WIDTH-1:0] y4;
reg  [DATA_WIDTH-1:0] y5;
reg  [DATA_WIDTH-1:0] y6;
reg  [DATA_WIDTH-1:0] y7;
reg  [DATA_WIDTH-1:0] y8;
reg  [DATA_WIDTH-1:0] y9;
reg  [DATA_WIDTH-1:0] y10;
reg  [DATA_WIDTH-1:0] y11;
reg  [DATA_WIDTH-1:0] y12;
reg  [DATA_WIDTH-1:0] y13;
reg  [DATA_WIDTH-1:0] y14;
reg  [DATA_WIDTH-1:0] y15;

reg  [DATA_WIDTH-1:0] z0;
reg  [DATA_WIDTH-1:0] z1;
reg  [DATA_WIDTH-1:0] z2;
reg  [DATA_WIDTH-1:0] z3;
reg  [DATA_WIDTH-1:0] z4;
reg  [DATA_WIDTH-1:0] z5;
reg  [DATA_WIDTH-1:0] z6;
reg  [DATA_WIDTH-1:0] z7;
reg  [DATA_WIDTH-1:0] z8;
reg  [DATA_WIDTH-1:0] z9;
reg  [DATA_WIDTH-1:0] z10;
reg  [DATA_WIDTH-1:0] z11;
reg  [DATA_WIDTH-1:0] z12;
reg  [DATA_WIDTH-1:0] z13;
reg  [DATA_WIDTH-1:0] z14;
reg  [DATA_WIDTH-1:0] z15;

reg [1:0] quadrant[PIPELINE:0];
integer i;
//get real quadrant and map to first_n quadrant

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      phase_in_reg<=16'h0000;
   else
      if(ena)
         begin
            case(phase_in[15:14])
               2'b00:phase_in_reg<=phase_in;
               2'b01:phase_in_reg<=phase_in - 16'h4000;  //-pi/2
               2'b10:phase_in_reg<=phase_in - 16'h8000;  //-pi
               2'b11:phase_in_reg<=phase_in - 16'hc000;  //-3pi/2
               default:;
            endcase
         end
end

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x0<=16'h0000;
         y0<=16'h0000;
         z0<=16'h0000;
      end
   else
      if(ena)
         begin
            x0 <= 16'h4db8;//16'h4dba
//define aggregate constant Xi=1/P=1/1.6467=0.69725(Xi=2^7*P=8'h4D)
            y0 <= 16'h0000; 
            z0 <=phase_in_reg; 
         end
end

//level 1
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x1<=16'h0000;
         y1<=16'h0000;
         z1<=16'h0000;
      end
   else
      if(ena)
         if(z0[15]==1'b0)
            begin
               x1 <= x0 - y0;
               y1 <= y0 + x0;
               z1 <= z0 - 16'h2000;  //45deg
            end
         else
            begin
               x1 <= x0 + y0;
               y1 <= y0 - x0;
               z1 <= z0 + 16'h2000;  //45deg
            end
end

//level 2
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x2<=16'h0000;
         y2<=16'h0000;
         z2<=16'h0000;
      end
   else
      if(ena)
         if(z1[15]==1'b0)
            begin
               x2 <= x1 - {y1[DATA_WIDTH-1],y1[DATA_WIDTH-1:1]};
               y2 <= y1 + {x1[DATA_WIDTH-1],x1[DATA_WIDTH-1:1]};
               z2 <= z1 - 16'h12e4;  //26deg
            end
         else
            begin
               x2 <= x1 + {y1[DATA_WIDTH-1],y1[DATA_WIDTH-1:1]};
               y2 <= y1 - {x1[DATA_WIDTH-1],x1[DATA_WIDTH-1:1]};
               z2 <= z1 + 16'h12e4;  //26deg
            end
end

//level 3
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x3<=16'h0000;
         y3<=16'h0000;
         z3<=16'h0000;
      end
   else
      if(ena)
         if(z2[15]==1'b0)
            begin
               x3 <= x2 - {{2{y2[DATA_WIDTH-1]}},y2[DATA_WIDTH-1:2]};
               y3 <= y2 + {{2{x2[DATA_WIDTH-1]}},x2[DATA_WIDTH-1:2]};
               z3 <= z2 - 16'h09fb;  //14deg
            end
         else
            begin
              x3 <= x2 + {{2{y2[DATA_WIDTH-1]}},y2[DATA_WIDTH-1:2]};
              y3 <= y2 - {{2{x2[DATA_WIDTH-1]}},x2[DATA_WIDTH-1:2]};
              z3 <= z2 + 16'h09fb;  //14deg
            end
end            
  
//level 4
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x4<=16'h0000;
         y4<=16'h0000;
         z4<=16'h0000;
      end
   else
      if(ena)
         if(z3[15]==1'b0)
            begin
               x4 <= x3 - {{3{y3[DATA_WIDTH-1]}},y3[DATA_WIDTH-1:3]};
               y4 <= y3 + {{3{x3[DATA_WIDTH-1]}},x3[DATA_WIDTH-1:3]};
               z4 <= z3 - 16'h0511;  //7deg
            end
         else
            begin
               x4 <= x3 + {{3{y3[DATA_WIDTH-1]}},y3[DATA_WIDTH-1:3]};
               y4 <= y3 - {{3{x3[DATA_WIDTH-1]}},x3[DATA_WIDTH-1:3]};
               z4 <= z3 + 16'h0511;  //7deg
            end
end 

//level 5
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x5<=16'h0000;
         y5<=16'h0000;
         z5<=16'h0000;
      end
   else
      if(ena)
         if(z4[15]==1'b0)
            begin
               x5 <= x4 - {{4{y4[DATA_WIDTH-1]}},y4[DATA_WIDTH-1:4]};
               y5 <= y4 + {{4{x4[DATA_WIDTH-1]}},x4[DATA_WIDTH-1:4]};
               z5 <= z4 - 16'h028b;  //4deg
            end
         else
            begin
               x5 <= x4 + {{4{y4[DATA_WIDTH-1]}},y4[DATA_WIDTH-1:4]};
               y5 <= y4 - {{4{x4[DATA_WIDTH-1]}},x4[DATA_WIDTH-1:4]};
               z5 <= z4 + 16'h028b;  //4deg
            end
end 

//level 6
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x6<=16'h0000;
         y6<=16'h0000;
         z6<=16'h0000;
      end
   else
      if(ena)
         if(z5[15]==1'b0)
            begin
               x6 <= x5 - {{5{y5[DATA_WIDTH-1]}},y5[DATA_WIDTH-1:5]};
               y6 <= y5 + {{5{x5[DATA_WIDTH-1]}},x5[DATA_WIDTH-1:5]};
               z6 <= z5 - 16'h0146;  //2deg
            end
         else
            begin
               x6 <= x5 + {{5{y5[DATA_WIDTH-1]}},y5[DATA_WIDTH-1:5]};
               y6 <= y5 - {{5{x5[DATA_WIDTH-1]}},x5[DATA_WIDTH-1:5]};
               z6 <= z5 + 16'h0146;  //2deg
            end
end 

//level 7
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x7<=16'h0000;
         y7<=16'h0000;
         z7<=16'h0000;
      end
   else
      if(ena)
         if(z6[15]==1'b0)
            begin
               x7 <= x6 - {{6{y6[DATA_WIDTH-1]}},y6[DATA_WIDTH-1:6]};
               y7 <= y6 + {{6{x6[DATA_WIDTH-1]}},x6[DATA_WIDTH-1:6]};
               z7 <= z6 - 16'h00a3;  
            end
         else
            begin
               x7 <= x6 + {{6{y6[DATA_WIDTH-1]}},y6[DATA_WIDTH-1:6]};
               y7 <= y6 - {{6{x6[DATA_WIDTH-1]}},x6[DATA_WIDTH-1:6]};
               z7 <= z6 + 16'h00a3;  
            end
end 

//level 8
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x8<=16'h0000;
         y8<=16'h0000;
         z8<=16'h0000;
      end
   else
      if(ena)
         if(z7[15]==1'b0)
            begin
               x8 <= x7 - {{7{y7[DATA_WIDTH-1]}},y7[DATA_WIDTH-1:7]};
               y8 <= y7 + {{7{x7[DATA_WIDTH-1]}},x7[DATA_WIDTH-1:7]};
               z8 <= z7 - 16'h0051;  
            end
         else
            begin
               x8 <= x7 + {{7{y7[DATA_WIDTH-1]}},y7[DATA_WIDTH-1:7]};
               y8 <= y7 - {{7{x7[DATA_WIDTH-1]}},x7[DATA_WIDTH-1:7]};
               z8 <= z7 + 16'h0051;  
            end
end 

//level 9
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x9<=16'h0000;
         y9<=16'h0000;
         z9<=16'h0000;
      end
   else
      if(ena)
         if(z8[15]==1'b0)
            begin
               x9 <= x8 - {{8{y8[DATA_WIDTH-1]}},y8[DATA_WIDTH-1:8]};
               y9 <= y8 + {{8{x8[DATA_WIDTH-1]}},x8[DATA_WIDTH-1:8]};
               z9 <= z8 - 16'h0028;  
            end
         else
            begin
               x9 <= x8 + {{8{y8[DATA_WIDTH-1]}},y8[DATA_WIDTH-1:8]};
               y9 <= y8 - {{8{x8[DATA_WIDTH-1]}},x8[DATA_WIDTH-1:8]};
               z9 <= z8 + 16'h0028;  
            end
end 

//level 10
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x10<=16'h0000;
         y10<=16'h0000;
         z10<=16'h0000;
      end
   else
      if(ena)
         if(z9[15]==1'b0)
            begin
               x10 <= x9 - {{9{y9[DATA_WIDTH-1]}},y9[DATA_WIDTH-1:9]};
               y10 <= y9 + {{9{x9[DATA_WIDTH-1]}},x9[DATA_WIDTH-1:9]};
               z10 <= z9 - 16'h0014;  
            end
         else
            begin
               x10 <= x9 + {{9{y9[DATA_WIDTH-1]}},y9[DATA_WIDTH-1:9]};
               y10 <= y9 - {{9{x9[DATA_WIDTH-1]}},x9[DATA_WIDTH-1:9]};
               z10 <= z9 + 16'h0014;  
            end
end 

//level 11
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x11<=16'h0000;
         y11<=16'h0000;
         z11<=16'h0000;
      end
   else
      if(ena)
         if(z10[15]==1'b0)
            begin
               x11 <= x10 - {{10{y10[DATA_WIDTH-1]}},y10[DATA_WIDTH-1:10]};
               y11 <= y10 + {{10{x10[DATA_WIDTH-1]}},x10[DATA_WIDTH-1:10]};
               z11 <= z10 - 16'h000a;  
            end
         else
            begin
               x11 <= x10 + {{10{y10[DATA_WIDTH-1]}},y10[DATA_WIDTH-1:10]};
               y11 <= y10 - {{10{x10[DATA_WIDTH-1]}},x10[DATA_WIDTH-1:10]};
               z11 <= z10 + 16'h000a;  
            end
end 

//level 12
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x12<=16'h0000;
         y12<=16'h0000;
         z12<=16'h0000;
      end
   else
      if(ena)
         if(z11[15]==1'b0)
            begin
               x12 <= x11 - {{11{y11[DATA_WIDTH-1]}},y11[DATA_WIDTH-1:11]};
               y12 <= y11 + {{11{x11[DATA_WIDTH-1]}},x11[DATA_WIDTH-1:11]};
               z12 <= z11 - 16'h0005;  
            end
         else
            begin
               x12 <= x11 + {{11{y11[DATA_WIDTH-1]}},y11[DATA_WIDTH-1:11]};
               y12 <= y11 - {{11{x11[DATA_WIDTH-1]}},x11[DATA_WIDTH-1:11]};
               z12 <= z11 + 16'h0005;  
            end
end 

//level 13
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x13<=16'h0000;
         y13<=16'h0000;
         z13<=16'h0000;
      end
   else
      if(ena)
         if(z12[15]==1'b0)
            begin
               x13 <= x12 - {{12{y12[DATA_WIDTH-1]}},y12[DATA_WIDTH-1:12]};
               y13 <= y12 + {{12{x12[DATA_WIDTH-1]}},x12[DATA_WIDTH-1:12]};
               z13 <= z12 - 16'h0003;  
            end
         else
            begin
               x13 <= x12 + {{12{y12[DATA_WIDTH-1]}},y12[DATA_WIDTH-1:12]};
               y13 <= y12 - {{12{x12[DATA_WIDTH-1]}},x12[DATA_WIDTH-1:12]};
               z13 <= z12 + 16'h0003;  
            end
end 

//level 14
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x14<=16'h0000;
         y14<=16'h0000;
         z14<=16'h0000;
      end
   else
      if(ena)
         if(z13[15]==1'b0)
            begin
               x14 <= x13 - {{13{y13[DATA_WIDTH-1]}},y13[DATA_WIDTH-1:13]};
               y14 <= y13 + {{13{x13[DATA_WIDTH-1]}},x13[DATA_WIDTH-1:13]};
               z14 <= z13 - 16'h0001;  
            end
         else
            begin
               x14 <= x13 + {{13{y13[DATA_WIDTH-1]}},y13[DATA_WIDTH-1:13]};
               y14 <= y13 - {{13{x13[DATA_WIDTH-1]}},x13[DATA_WIDTH-1:13]};
               z14 <= z13 + 16'h0001;  
            end
end 

//level5////
//overflow
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x15<=16'h0000;
         y15<=16'h0000;
         z15<=16'h0000;
      end
   else
      if(ena)
         if(z14[15]==1'b0)
           
            begin
               x15 <= x14 - {{14{y14[DATA_WIDTH-1]}},y14[DATA_WIDTH-1:14]};// -3'b100;
               y15 <= y14 + {{14{x14[DATA_WIDTH-1]}},x14[DATA_WIDTH-1:14]};// -3'b100;
               z15 <= z14;  
            end
         else 
            begin
               x15 <= x14 + {{14{y14[DATA_WIDTH-1]}},y14[DATA_WIDTH-1:14]};// -3'b100;
               y15 <= y14 - {{14{x14[DATA_WIDTH-1]}},x14[DATA_WIDTH-1:14]};// -3'b100;
               z15 <= z14;  
            end
        
end 

//remain the quadrant information for 'duiqi'
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      for(i=0; i<=PIPELINE; i=i+1)
         quadrant[i]<=2'b00;
   else
      if(ena)
         begin
            for(i=0; i<PIPELINE; i=i+1)
               quadrant[i+1]<=quadrant[i];
               quadrant[0]<=phase_in[15:14];
         end
end

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         sin_out <= 16'h0000;
         cos_out <= 16'h0000;
         eps <= 16'h0000;
      end
   else
      if(ena)
         case(quadrant[16])
            2'b00:begin
                     sin_out <= y15; 
                     cos_out <= x15;
                     eps <= z15;
                  end
            2'b01:begin
                     sin_out <= x15; 
                     cos_out <= ~(y15) + 1'b1;
                     eps <= z15;
                  end
            2'b10:begin
                     sin_out <= ~(y15) + 1'b1; 
                     cos_out <= ~(x15) + 1'b1;
                     eps <= z15;
                  end
            2'b11:begin
                     sin_out <= ~(x15) + 1'b1; 
                     cos_out <= y15;
                     eps <= z15;
                  end
         endcase
end

endmodule

