module color_ctrl(
	input [1:0] speed,
	input [1:0] light,
	input [2:0] mode,
	input rst_n,
	input clk,
		
	output wire [1439:0]rgb_reg
);

//二维数组打包成一维数�?
reg [23:0] RGB_reg [59:0];
//`PACK_ARRAY(24,8,RGB_reg,rgb_reg) 
//reg pack;
generate 
genvar pk_idx; for (pk_idx=0; pk_idx<(60); pk_idx=pk_idx+1) begin :pack
				assign rgb_reg[((24)*pk_idx+((24)-1)):((24)*pk_idx)] = RGB_reg[pk_idx][((24)-1):0]; 
		end 
endgenerate  

reg [25:0]  cnt;
reg [25:0]	SPEED;
reg [6:0] 	LIGHT;

reg dir;
reg [6:0] 	hxd_light;
reg [9:0]	dis_cnt;
reg [25:0]  hxd_cnt;
reg [25:0]	T_1ms;
localparam  T_cycle = 1000;

parameter WHITE	 = 24'b01111110_01111110_01111110;
parameter RED		 = 24'b00000000_01111110_00000000;
parameter YELLOW	 = 24'b01111110_01111110_00000000;
parameter GREEN 	 = 24'b01111110_00000000_00000000;
parameter CYAN 	 = 24'b00000000_01111110_01111110;
parameter BLUE		 = 24'b00000000_00000000_01111110;
parameter PURPLE   = 24'h D005D7;
parameter ORANGE   = 24'h D78013;

always@(posedge clk, negedge rst_n)	begin
	if(!rst_n)	begin
		RGB_reg	[0]	 <=	 RED;
		RGB_reg	[1]	 <=	 RED;
		RGB_reg	[2]	 <=	 RED;
		RGB_reg	[3]	 <=	 RED;
		RGB_reg	[4]	 <=	 RED;
		RGB_reg	[5]	 <=	 RED;
		RGB_reg	[6]	 <=	 RED;
		RGB_reg	[7]	 <=	 RED;
	    RGB_reg	[8]	 <=	 RED;
		RGB_reg	[9]	 <=	 RED;
		RGB_reg	[10]	 <=	 RED;
		RGB_reg	[11]	 <=	 RED;
		RGB_reg	[12]	 <=	 RED;
		RGB_reg	[13]	 <=	 RED;
		RGB_reg	[14]	 <=	 RED;
		RGB_reg	[15]	 <=	 RED;
		RGB_reg	[16]	 <=	 RED;
		RGB_reg	[17]	 <=	 RED;
	    RGB_reg	[18]	 <=	 RED;
		RGB_reg	[19]	 <=	 RED;
		RGB_reg	[20]	 <=	 RED;
		RGB_reg	[21]	 <=	 RED;
		RGB_reg	[22]	 <=	 RED;
		RGB_reg	[23]	 <=	 RED;
		RGB_reg	[24]	 <=	 RED;
		RGB_reg	[25]	 <=	 RED;
		RGB_reg	[26]	 <=	 RED;
		RGB_reg	[27]	 <=	 RED;
	    RGB_reg	[28]	 <=	 RED;
		RGB_reg	[29]	 <=	 RED;
		RGB_reg	[30]	 <=	 RED;
		RGB_reg	[31]	 <=	 RED;
		RGB_reg	[32]	 <=	 RED;
		RGB_reg	[33]	 <=	 RED;
		RGB_reg	[34]	 <=	 RED;
		RGB_reg	[35]	 <=	 RED;
		RGB_reg	[36]	 <=	 RED;
		RGB_reg	[37]	 <=	 RED;
	    RGB_reg	[38]	 <=	 RED;
		RGB_reg	[39]	 <=	 RED;
		RGB_reg	[40]	 <=	 RED;
		RGB_reg	[41]	 <=	 RED;
		RGB_reg	[42]	 <=	 RED;
		RGB_reg	[43]	 <=	 RED;
		RGB_reg	[44]	 <=	 RED;
		RGB_reg	[45]	 <=	 RED;
		RGB_reg	[46]	 <=	 RED;
		RGB_reg	[47]	 <=	 RED;
	    RGB_reg	[48]	 <=	 RED;
		RGB_reg	[49]	 <=	 RED;
		RGB_reg	[50]	 <=	 RED;
		RGB_reg	[51]	 <=	 RED;
		RGB_reg	[52]	 <=	 RED;
		RGB_reg	[53]	 <=	 RED;
		RGB_reg	[54]	 <=	 RED;
		RGB_reg	[55]	 <=	 RED;
		RGB_reg	[56]	 <=	 RED;
		RGB_reg	[57]	 <=	 RED;
	    RGB_reg	[58]	 <=	 RED;
		RGB_reg	[59]	 <=	 RED;

		
		dis_cnt <= 0;
		hxd_cnt <= 0;
	end
	else if(mode == 3'd0)	begin
				//呼吸�?
		if(hxd_cnt == T_1ms - 1)	begin
			hxd_cnt <= 0;
			if(dis_cnt == T_cycle)	begin
				dis_cnt <= 0;
				dir = ~dir;
			end
			else
				dis_cnt <= dis_cnt + 1;
		end	
		else	begin
			hxd_cnt <= hxd_cnt + 1;
			if(hxd_cnt < dis_cnt * (T_1ms / T_cycle / hxd_light))	begin
				if(dir)	begin
                    RGB_reg	[0]	     <=	 RED; 
                    RGB_reg	[1]	     <=	 RED;
                    RGB_reg	[2]	     <=	 RED;
                    RGB_reg	[3]	     <=	 RED;
                    RGB_reg	[4]	     <=	 RED;
                    RGB_reg	[5]	     <=	 RED;
                    RGB_reg	[6]	     <=	 RED;
                    RGB_reg	[7]	     <=	 RED;
                    RGB_reg	[8]	     <=	 RED; 
                    RGB_reg	[9]	     <=	 RED;
                    RGB_reg	[10]	 <=	 RED;
                    RGB_reg	[11]	 <=	 RED;
                    RGB_reg	[12]	 <=	 RED;
                    RGB_reg	[13]	 <=	 RED;
                    RGB_reg	[14]	 <=	 RED;
                    RGB_reg	[15]	 <=	 RED;
                    RGB_reg	[16]	 <=	 RED; 
                    RGB_reg	[17]	 <=	 RED;
                    RGB_reg	[18]	 <=	 RED;
                    RGB_reg	[19]	 <=	 RED;
                    RGB_reg	[20]	 <=	 RED;
                    RGB_reg	[21]	 <=	 RED;
                    RGB_reg	[22]	 <=	 RED;
                    RGB_reg	[23]	 <=	 RED;
                    RGB_reg	[24]	 <=	 RED; 
                    RGB_reg	[25]	 <=	 RED;
                    RGB_reg	[26]	 <=	 RED;
                    RGB_reg	[27]	 <=	 RED;
                    RGB_reg	[28]	 <=	 RED;
                    RGB_reg	[29]	 <=	 RED;
                    RGB_reg	[30]	 <=	 RED;
                    RGB_reg	[31]	 <=	 RED;
                    RGB_reg	[32]	 <=	 RED; 
                    RGB_reg	[33]	 <=	 RED;
                    RGB_reg	[34]	 <=	 RED;
                    RGB_reg	[35]	 <=	 RED;
                    RGB_reg	[36]	 <=	 RED;
                    RGB_reg	[37]	 <=	 RED;
                    RGB_reg	[38]	 <=	 RED;
                    RGB_reg	[39]	 <=	 RED;
                    RGB_reg	[40]	 <=	 RED; 
                    RGB_reg	[41]	 <=	 RED;
                    RGB_reg	[42]	 <=	 RED;
                    RGB_reg	[43]	 <=	 RED;
                    RGB_reg	[44]	 <=	 RED;
                    RGB_reg	[45]	 <=	 RED;
                    RGB_reg	[46]	 <=	 RED;
                    RGB_reg	[47]	 <=	 RED;
                    RGB_reg	[48]	 <=	 RED; 
                    RGB_reg	[49]	 <=	 RED;
                    RGB_reg	[50]	 <=	 RED;
                    RGB_reg	[51]	 <=	 RED;
                    RGB_reg	[52]	 <=	 RED;
                    RGB_reg	[53]	 <=	 RED;
                    RGB_reg	[54]	 <=	 RED;
                    RGB_reg	[55]	 <=	 RED;
                    RGB_reg	[56]	 <=	 RED; 
                    RGB_reg	[57]	 <=	 RED;
                    RGB_reg	[58]	 <=	 RED;
                    RGB_reg	[59]	 <=	 RED;
				end
				else	begin
                    RGB_reg	[0]	     <=	 24'd0;
                    RGB_reg	[1]	     <=	 24'd0;
                    RGB_reg	[2]	     <=	 24'd0;
                    RGB_reg	[3]	     <=	 24'd0;
                    RGB_reg	[4]	     <=	 24'd0;
                    RGB_reg	[5]	     <=	 24'd0;
                    RGB_reg	[6]	     <=	 24'd0;
                    RGB_reg	[7]	     <=	 24'd0;
                    RGB_reg	[8]	     <=	 24'd0;
                    RGB_reg	[9]	     <=	 24'd0;
                    RGB_reg	[10]	 <=	 24'd0;
                    RGB_reg	[11]	 <=	 24'd0;
                    RGB_reg	[12]	 <=	 24'd0;
                    RGB_reg	[13]	 <=	 24'd0;
                    RGB_reg	[14]	 <=	 24'd0;
                    RGB_reg	[15]	 <=	 24'd0;
                    RGB_reg	[16]	 <=	 24'd0;
                    RGB_reg	[17]	 <=	 24'd0;
                    RGB_reg	[18]	 <=	 24'd0;
                    RGB_reg	[19]	 <=	 24'd0;
                    RGB_reg	[20]	 <=	 24'd0;
                    RGB_reg	[21]	 <=	 24'd0;
                    RGB_reg	[22]	 <=	 24'd0;
                    RGB_reg	[23]	 <=	 24'd0;
                    RGB_reg	[24]	 <=	 24'd0;
                    RGB_reg	[25]	 <=	 24'd0;
                    RGB_reg	[26]	 <=	 24'd0;
                    RGB_reg	[27]	 <=	 24'd0;
                    RGB_reg	[28]	 <=	 24'd0;
                    RGB_reg	[29]	 <=	 24'd0;
                    RGB_reg	[30]	 <=	 24'd0;
                    RGB_reg	[31]	 <=	 24'd0;
                    RGB_reg	[32]	 <=	 24'd0;
                    RGB_reg	[33]	 <=	 24'd0;
                    RGB_reg	[34]	 <=	 24'd0;
                    RGB_reg	[35]	 <=	 24'd0;
                    RGB_reg	[36]	 <=	 24'd0;
                    RGB_reg	[37]	 <=	 24'd0;
                    RGB_reg	[38]	 <=	 24'd0;
                    RGB_reg	[39]	 <=	 24'd0;
                    RGB_reg	[40]	 <=	 24'd0;
                    RGB_reg	[41]	 <=	 24'd0;
                    RGB_reg	[42]	 <=	 24'd0;
                    RGB_reg	[43]	 <=	 24'd0;
                    RGB_reg	[44]	 <=	 24'd0;
                    RGB_reg	[45]	 <=	 24'd0;
                    RGB_reg	[46]	 <=	 24'd0;
                    RGB_reg	[47]	 <=	 24'd0;
                    RGB_reg	[48]	 <=	 24'd0;
                    RGB_reg	[49]	 <=	 24'd0;
                    RGB_reg	[50]	 <=	 24'd0;
                    RGB_reg	[51]	 <=	 24'd0;
                    RGB_reg	[52]	 <=	 24'd0;
                    RGB_reg	[53]	 <=	 24'd0;
                    RGB_reg	[54]	 <=	 24'd0;
                    RGB_reg	[55]	 <=	 24'd0;
                    RGB_reg	[56]	 <=	 24'd0;
                    RGB_reg	[57]	 <=	 24'd0;
                    RGB_reg	[58]	 <=	 24'd0;
                    RGB_reg	[59]	 <=	 24'd0;
				end
			end
			else	begin
				if(!dir)	begin
                    RGB_reg	[0]	     <=	 RED; 
                    RGB_reg	[1]	     <=	 RED;
                    RGB_reg	[2]	     <=	 RED;
                    RGB_reg	[3]	     <=	 RED;
                    RGB_reg	[4]	     <=	 RED;
                    RGB_reg	[5]	     <=	 RED;
                    RGB_reg	[6]	     <=	 RED;
                    RGB_reg	[7]	     <=	 RED;
                    RGB_reg	[8]	     <=	 RED; 
                    RGB_reg	[9]	     <=	 RED;
                    RGB_reg	[10]	 <=	 RED;
                    RGB_reg	[11]	 <=	 RED;
                    RGB_reg	[12]	 <=	 RED;
                    RGB_reg	[13]	 <=	 RED;
                    RGB_reg	[14]	 <=	 RED;
                    RGB_reg	[15]	 <=	 RED;
                    RGB_reg	[16]	 <=	 RED; 
                    RGB_reg	[17]	 <=	 RED;
                    RGB_reg	[18]	 <=	 RED;
                    RGB_reg	[19]	 <=	 RED;
                    RGB_reg	[20]	 <=	 RED;
                    RGB_reg	[21]	 <=	 RED;
                    RGB_reg	[22]	 <=	 RED;
                    RGB_reg	[23]	 <=	 RED;
                    RGB_reg	[24]	 <=	 RED; 
                    RGB_reg	[25]	 <=	 RED;
                    RGB_reg	[26]	 <=	 RED;
                    RGB_reg	[27]	 <=	 RED;
                    RGB_reg	[28]	 <=	 RED;
                    RGB_reg	[29]	 <=	 RED;
                    RGB_reg	[30]	 <=	 RED;
                    RGB_reg	[31]	 <=	 RED;
                    RGB_reg	[32]	 <=	 RED; 
                    RGB_reg	[33]	 <=	 RED;
                    RGB_reg	[34]	 <=	 RED;
                    RGB_reg	[35]	 <=	 RED;
                    RGB_reg	[36]	 <=	 RED;
                    RGB_reg	[37]	 <=	 RED;
                    RGB_reg	[38]	 <=	 RED;
                    RGB_reg	[39]	 <=	 RED;
                    RGB_reg	[40]	 <=	 RED; 
                    RGB_reg	[41]	 <=	 RED;
                    RGB_reg	[42]	 <=	 RED;
                    RGB_reg	[43]	 <=	 RED;
                    RGB_reg	[44]	 <=	 RED;
                    RGB_reg	[45]	 <=	 RED;
                    RGB_reg	[46]	 <=	 RED;
                    RGB_reg	[47]	 <=	 RED;
                    RGB_reg	[48]	 <=	 RED; 
                    RGB_reg	[49]	 <=	 RED;
                    RGB_reg	[50]	 <=	 RED;
                    RGB_reg	[51]	 <=	 RED;
                    RGB_reg	[52]	 <=	 RED;
                    RGB_reg	[53]	 <=	 RED;
                    RGB_reg	[54]	 <=	 RED;
                    RGB_reg	[55]	 <=	 RED;
                    RGB_reg	[56]	 <=	 RED; 
                    RGB_reg	[57]	 <=	 RED;
                    RGB_reg	[58]	 <=	 RED;
                    RGB_reg	[59]	 <=	 RED;
				end
				else	begin
                    RGB_reg	[0]	     <=	 24'd0;
                    RGB_reg	[1]	     <=	 24'd0;
                    RGB_reg	[2]	     <=	 24'd0;
                    RGB_reg	[3]	     <=	 24'd0;
                    RGB_reg	[4]	     <=	 24'd0;
                    RGB_reg	[5]	     <=	 24'd0;
                    RGB_reg	[6]	     <=	 24'd0;
                    RGB_reg	[7]	     <=	 24'd0;
                    RGB_reg	[8]	     <=	 24'd0;
                    RGB_reg	[9]	     <=	 24'd0;
                    RGB_reg	[10]	 <=	 24'd0;
                    RGB_reg	[11]	 <=	 24'd0;
                    RGB_reg	[12]	 <=	 24'd0;
                    RGB_reg	[13]	 <=	 24'd0;
                    RGB_reg	[14]	 <=	 24'd0;
                    RGB_reg	[15]	 <=	 24'd0;
                    RGB_reg	[16]	 <=	 24'd0;
                    RGB_reg	[17]	 <=	 24'd0;
                    RGB_reg	[18]	 <=	 24'd0;
                    RGB_reg	[19]	 <=	 24'd0;
                    RGB_reg	[20]	 <=	 24'd0;
                    RGB_reg	[21]	 <=	 24'd0;
                    RGB_reg	[22]	 <=	 24'd0;
                    RGB_reg	[23]	 <=	 24'd0;
                    RGB_reg	[24]	 <=	 24'd0;
                    RGB_reg	[25]	 <=	 24'd0;
                    RGB_reg	[26]	 <=	 24'd0;
                    RGB_reg	[27]	 <=	 24'd0;
                    RGB_reg	[28]	 <=	 24'd0;
                    RGB_reg	[29]	 <=	 24'd0;
                    RGB_reg	[30]	 <=	 24'd0;
                    RGB_reg	[31]	 <=	 24'd0;
                    RGB_reg	[32]	 <=	 24'd0;
                    RGB_reg	[33]	 <=	 24'd0;
                    RGB_reg	[34]	 <=	 24'd0;
                    RGB_reg	[35]	 <=	 24'd0;
                    RGB_reg	[36]	 <=	 24'd0;
                    RGB_reg	[37]	 <=	 24'd0;
                    RGB_reg	[38]	 <=	 24'd0;
                    RGB_reg	[39]	 <=	 24'd0;
                    RGB_reg	[40]	 <=	 24'd0;
                    RGB_reg	[41]	 <=	 24'd0;
                    RGB_reg	[42]	 <=	 24'd0;
                    RGB_reg	[43]	 <=	 24'd0;
                    RGB_reg	[44]	 <=	 24'd0;
                    RGB_reg	[45]	 <=	 24'd0;
                    RGB_reg	[46]	 <=	 24'd0;
                    RGB_reg	[47]	 <=	 24'd0;
                    RGB_reg	[48]	 <=	 24'd0;
                    RGB_reg	[49]	 <=	 24'd0;
                    RGB_reg	[50]	 <=	 24'd0;
                    RGB_reg	[51]	 <=	 24'd0;
                    RGB_reg	[52]	 <=	 24'd0;
                    RGB_reg	[53]	 <=	 24'd0;
                    RGB_reg	[54]	 <=	 24'd0;
                    RGB_reg	[55]	 <=	 24'd0;
                    RGB_reg	[56]	 <=	 24'd0;
                    RGB_reg	[57]	 <=	 24'd0;
                    RGB_reg	[58]	 <=	 24'd0;
                    RGB_reg	[59]	 <=	 24'd0;
				end
			end
		end
	end
	else if(mode == 3'd1)	begin
				//呼吸�?
		if(hxd_cnt == T_1ms - 1)	begin
			hxd_cnt <= 0;
			if(dis_cnt == T_cycle)	begin
				dis_cnt <= 0;
				dir = ~dir;
			end
			else
				dis_cnt <= dis_cnt + 1;
		end	
		else	begin
			hxd_cnt <= hxd_cnt + 1;
			if(hxd_cnt < dis_cnt * (T_1ms / T_cycle / hxd_light))	begin
				if(dir)	begin
                    RGB_reg	[0]	     <=	 PURPLE; 
                    RGB_reg	[1]	     <=	 PURPLE;
                    RGB_reg	[2]	     <=	 PURPLE;
                    RGB_reg	[3]	     <=	 PURPLE;
                    RGB_reg	[4]	     <=	 PURPLE;
                    RGB_reg	[5]	     <=	 PURPLE;
                    RGB_reg	[6]	     <=	 PURPLE;
                    RGB_reg	[7]	     <=	 PURPLE;
                    RGB_reg	[8]	     <=	 PURPLE; 
                    RGB_reg	[9]	     <=	 PURPLE;
                    RGB_reg	[10]	 <=	 PURPLE;
                    RGB_reg	[11]	 <=	 PURPLE;
                    RGB_reg	[12]	 <=	 PURPLE;
                    RGB_reg	[13]	 <=	 PURPLE;
                    RGB_reg	[14]	 <=	 PURPLE;
                    RGB_reg	[15]	 <=	 PURPLE;
                    RGB_reg	[16]	 <=	 PURPLE; 
                    RGB_reg	[17]	 <=	 PURPLE;
                    RGB_reg	[18]	 <=	 PURPLE;
                    RGB_reg	[19]	 <=	 PURPLE;
                    RGB_reg	[20]	 <=	 PURPLE;
                    RGB_reg	[21]	 <=	 PURPLE;
                    RGB_reg	[22]	 <=	 PURPLE;
                    RGB_reg	[23]	 <=	 PURPLE;
                    RGB_reg	[24]	 <=	 PURPLE; 
                    RGB_reg	[25]	 <=	 PURPLE;
                    RGB_reg	[26]	 <=	 PURPLE;
                    RGB_reg	[27]	 <=	 PURPLE;
                    RGB_reg	[28]	 <=	 PURPLE;
                    RGB_reg	[29]	 <=	 PURPLE;
                    RGB_reg	[30]	 <=	 PURPLE;
                    RGB_reg	[31]	 <=	 PURPLE;
                    RGB_reg	[32]	 <=	 PURPLE; 
                    RGB_reg	[33]	 <=	 PURPLE;
                    RGB_reg	[34]	 <=	 PURPLE;
                    RGB_reg	[35]	 <=	 PURPLE;
                    RGB_reg	[36]	 <=	 PURPLE;
                    RGB_reg	[37]	 <=	 PURPLE;
                    RGB_reg	[38]	 <=	 PURPLE;
                    RGB_reg	[39]	 <=	 PURPLE;
                    RGB_reg	[40]	 <=	 PURPLE; 
                    RGB_reg	[41]	 <=	 PURPLE;
                    RGB_reg	[42]	 <=	 PURPLE;
                    RGB_reg	[43]	 <=	 PURPLE;
                    RGB_reg	[44]	 <=	 PURPLE;
                    RGB_reg	[45]	 <=	 PURPLE;
                    RGB_reg	[46]	 <=	 PURPLE;
                    RGB_reg	[47]	 <=	 PURPLE;
                    RGB_reg	[48]	 <=	 PURPLE; 
                    RGB_reg	[49]	 <=	 PURPLE;
                    RGB_reg	[50]	 <=	 PURPLE;
                    RGB_reg	[51]	 <=	 PURPLE;
                    RGB_reg	[52]	 <=	 PURPLE;
                    RGB_reg	[53]	 <=	 PURPLE;
                    RGB_reg	[54]	 <=	 PURPLE;
                    RGB_reg	[55]	 <=	 PURPLE;
                    RGB_reg	[56]	 <=	 PURPLE; 
                    RGB_reg	[57]	 <=	 PURPLE;
                    RGB_reg	[58]	 <=	 PURPLE;
                    RGB_reg	[59]	 <=	 PURPLE;
				end
				else	begin
                    RGB_reg	[0]	     <=	 24'd0;
                    RGB_reg	[1]	     <=	 24'd0;
                    RGB_reg	[2]	     <=	 24'd0;
                    RGB_reg	[3]	     <=	 24'd0;
                    RGB_reg	[4]	     <=	 24'd0;
                    RGB_reg	[5]	     <=	 24'd0;
                    RGB_reg	[6]	     <=	 24'd0;
                    RGB_reg	[7]	     <=	 24'd0;
                    RGB_reg	[8]	     <=	 24'd0;
                    RGB_reg	[9]	     <=	 24'd0;
                    RGB_reg	[10]	 <=	 24'd0;
                    RGB_reg	[11]	 <=	 24'd0;
                    RGB_reg	[12]	 <=	 24'd0;
                    RGB_reg	[13]	 <=	 24'd0;
                    RGB_reg	[14]	 <=	 24'd0;
                    RGB_reg	[15]	 <=	 24'd0;
                    RGB_reg	[16]	 <=	 24'd0;
                    RGB_reg	[17]	 <=	 24'd0;
                    RGB_reg	[18]	 <=	 24'd0;
                    RGB_reg	[19]	 <=	 24'd0;
                    RGB_reg	[20]	 <=	 24'd0;
                    RGB_reg	[21]	 <=	 24'd0;
                    RGB_reg	[22]	 <=	 24'd0;
                    RGB_reg	[23]	 <=	 24'd0;
                    RGB_reg	[24]	 <=	 24'd0;
                    RGB_reg	[25]	 <=	 24'd0;
                    RGB_reg	[26]	 <=	 24'd0;
                    RGB_reg	[27]	 <=	 24'd0;
                    RGB_reg	[28]	 <=	 24'd0;
                    RGB_reg	[29]	 <=	 24'd0;
                    RGB_reg	[30]	 <=	 24'd0;
                    RGB_reg	[31]	 <=	 24'd0;
                    RGB_reg	[32]	 <=	 24'd0;
                    RGB_reg	[33]	 <=	 24'd0;
                    RGB_reg	[34]	 <=	 24'd0;
                    RGB_reg	[35]	 <=	 24'd0;
                    RGB_reg	[36]	 <=	 24'd0;
                    RGB_reg	[37]	 <=	 24'd0;
                    RGB_reg	[38]	 <=	 24'd0;
                    RGB_reg	[39]	 <=	 24'd0;
                    RGB_reg	[40]	 <=	 24'd0;
                    RGB_reg	[41]	 <=	 24'd0;
                    RGB_reg	[42]	 <=	 24'd0;
                    RGB_reg	[43]	 <=	 24'd0;
                    RGB_reg	[44]	 <=	 24'd0;
                    RGB_reg	[45]	 <=	 24'd0;
                    RGB_reg	[46]	 <=	 24'd0;
                    RGB_reg	[47]	 <=	 24'd0;
                    RGB_reg	[48]	 <=	 24'd0;
                    RGB_reg	[49]	 <=	 24'd0;
                    RGB_reg	[50]	 <=	 24'd0;
                    RGB_reg	[51]	 <=	 24'd0;
                    RGB_reg	[52]	 <=	 24'd0;
                    RGB_reg	[53]	 <=	 24'd0;
                    RGB_reg	[54]	 <=	 24'd0;
                    RGB_reg	[55]	 <=	 24'd0;
                    RGB_reg	[56]	 <=	 24'd0;
                    RGB_reg	[57]	 <=	 24'd0;
                    RGB_reg	[58]	 <=	 24'd0;
                    RGB_reg	[59]	 <=	 24'd0;
				end
			end
			else	begin
				if(!dir)	begin
                    RGB_reg	[0]	     <=	 PURPLE; 
                    RGB_reg	[1]	     <=	 PURPLE;
                    RGB_reg	[2]	     <=	 PURPLE;
                    RGB_reg	[3]	     <=	 PURPLE;
                    RGB_reg	[4]	     <=	 PURPLE;
                    RGB_reg	[5]	     <=	 PURPLE;
                    RGB_reg	[6]	     <=	 PURPLE;
                    RGB_reg	[7]	     <=	 PURPLE;
                    RGB_reg	[8]	     <=	 PURPLE; 
                    RGB_reg	[9]	     <=	 PURPLE;
                    RGB_reg	[10]	 <=	 PURPLE;
                    RGB_reg	[11]	 <=	 PURPLE;
                    RGB_reg	[12]	 <=	 PURPLE;
                    RGB_reg	[13]	 <=	 PURPLE;
                    RGB_reg	[14]	 <=	 PURPLE;
                    RGB_reg	[15]	 <=	 PURPLE;
                    RGB_reg	[16]	 <=	 PURPLE; 
                    RGB_reg	[17]	 <=	 PURPLE;
                    RGB_reg	[18]	 <=	 PURPLE;
                    RGB_reg	[19]	 <=	 PURPLE;
                    RGB_reg	[20]	 <=	 PURPLE;
                    RGB_reg	[21]	 <=	 PURPLE;
                    RGB_reg	[22]	 <=	 PURPLE;
                    RGB_reg	[23]	 <=	 PURPLE;
                    RGB_reg	[24]	 <=	 PURPLE; 
                    RGB_reg	[25]	 <=	 PURPLE;
                    RGB_reg	[26]	 <=	 PURPLE;
                    RGB_reg	[27]	 <=	 PURPLE;
                    RGB_reg	[28]	 <=	 PURPLE;
                    RGB_reg	[29]	 <=	 PURPLE;
                    RGB_reg	[30]	 <=	 PURPLE;
                    RGB_reg	[31]	 <=	 PURPLE;
                    RGB_reg	[32]	 <=	 PURPLE; 
                    RGB_reg	[33]	 <=	 PURPLE;
                    RGB_reg	[34]	 <=	 PURPLE;
                    RGB_reg	[35]	 <=	 PURPLE;
                    RGB_reg	[36]	 <=	 PURPLE;
                    RGB_reg	[37]	 <=	 PURPLE;
                    RGB_reg	[38]	 <=	 PURPLE;
                    RGB_reg	[39]	 <=	 PURPLE;
                    RGB_reg	[40]	 <=	 PURPLE; 
                    RGB_reg	[41]	 <=	 PURPLE;
                    RGB_reg	[42]	 <=	 PURPLE;
                    RGB_reg	[43]	 <=	 PURPLE;
                    RGB_reg	[44]	 <=	 PURPLE;
                    RGB_reg	[45]	 <=	 PURPLE;
                    RGB_reg	[46]	 <=	 PURPLE;
                    RGB_reg	[47]	 <=	 PURPLE;
                    RGB_reg	[48]	 <=	 PURPLE; 
                    RGB_reg	[49]	 <=	 PURPLE;
                    RGB_reg	[50]	 <=	 PURPLE;
                    RGB_reg	[51]	 <=	 PURPLE;
                    RGB_reg	[52]	 <=	 PURPLE;
                    RGB_reg	[53]	 <=	 PURPLE;
                    RGB_reg	[54]	 <=	 PURPLE;
                    RGB_reg	[55]	 <=	 PURPLE;
                    RGB_reg	[56]	 <=	 PURPLE; 
                    RGB_reg	[57]	 <=	 PURPLE;
                    RGB_reg	[58]	 <=	 PURPLE;
                    RGB_reg	[59]	 <=	 PURPLE;
				end
				else	begin
                    RGB_reg	[0]	     <=	 24'd0;
                    RGB_reg	[1]	     <=	 24'd0;
                    RGB_reg	[2]	     <=	 24'd0;
                    RGB_reg	[3]	     <=	 24'd0;
                    RGB_reg	[4]	     <=	 24'd0;
                    RGB_reg	[5]	     <=	 24'd0;
                    RGB_reg	[6]	     <=	 24'd0;
                    RGB_reg	[7]	     <=	 24'd0;
                    RGB_reg	[8]	     <=	 24'd0;
                    RGB_reg	[9]	     <=	 24'd0;
                    RGB_reg	[10]	 <=	 24'd0;
                    RGB_reg	[11]	 <=	 24'd0;
                    RGB_reg	[12]	 <=	 24'd0;
                    RGB_reg	[13]	 <=	 24'd0;
                    RGB_reg	[14]	 <=	 24'd0;
                    RGB_reg	[15]	 <=	 24'd0;
                    RGB_reg	[16]	 <=	 24'd0;
                    RGB_reg	[17]	 <=	 24'd0;
                    RGB_reg	[18]	 <=	 24'd0;
                    RGB_reg	[19]	 <=	 24'd0;
                    RGB_reg	[20]	 <=	 24'd0;
                    RGB_reg	[21]	 <=	 24'd0;
                    RGB_reg	[22]	 <=	 24'd0;
                    RGB_reg	[23]	 <=	 24'd0;
                    RGB_reg	[24]	 <=	 24'd0;
                    RGB_reg	[25]	 <=	 24'd0;
                    RGB_reg	[26]	 <=	 24'd0;
                    RGB_reg	[27]	 <=	 24'd0;
                    RGB_reg	[28]	 <=	 24'd0;
                    RGB_reg	[29]	 <=	 24'd0;
                    RGB_reg	[30]	 <=	 24'd0;
                    RGB_reg	[31]	 <=	 24'd0;
                    RGB_reg	[32]	 <=	 24'd0;
                    RGB_reg	[33]	 <=	 24'd0;
                    RGB_reg	[34]	 <=	 24'd0;
                    RGB_reg	[35]	 <=	 24'd0;
                    RGB_reg	[36]	 <=	 24'd0;
                    RGB_reg	[37]	 <=	 24'd0;
                    RGB_reg	[38]	 <=	 24'd0;
                    RGB_reg	[39]	 <=	 24'd0;
                    RGB_reg	[40]	 <=	 24'd0;
                    RGB_reg	[41]	 <=	 24'd0;
                    RGB_reg	[42]	 <=	 24'd0;
                    RGB_reg	[43]	 <=	 24'd0;
                    RGB_reg	[44]	 <=	 24'd0;
                    RGB_reg	[45]	 <=	 24'd0;
                    RGB_reg	[46]	 <=	 24'd0;
                    RGB_reg	[47]	 <=	 24'd0;
                    RGB_reg	[48]	 <=	 24'd0;
                    RGB_reg	[49]	 <=	 24'd0;
                    RGB_reg	[50]	 <=	 24'd0;
                    RGB_reg	[51]	 <=	 24'd0;
                    RGB_reg	[52]	 <=	 24'd0;
                    RGB_reg	[53]	 <=	 24'd0;
                    RGB_reg	[54]	 <=	 24'd0;
                    RGB_reg	[55]	 <=	 24'd0;
                    RGB_reg	[56]	 <=	 24'd0;
                    RGB_reg	[57]	 <=	 24'd0;
                    RGB_reg	[58]	 <=	 24'd0;
                    RGB_reg	[59]	 <=	 24'd0;
				end
			end
		end
	end
    else if(mode == 3'd2)	begin 
		if(hxd_cnt == T_1ms - 1)	begin
			hxd_cnt <= 0;
			if(dis_cnt == T_cycle)	begin
				dis_cnt <= 0;
				dir = ~dir;
			end
			else
				dis_cnt <= dis_cnt + 1;
		end	
		else	begin
			hxd_cnt <= hxd_cnt + 1;
			if(hxd_cnt < dis_cnt * (T_1ms / T_cycle / hxd_light))	begin
				if(dir)	begin
                    RGB_reg	[0]	     <=	 YELLOW; 
                    RGB_reg	[1]	     <=	 YELLOW;
                    RGB_reg	[2]	     <=	 YELLOW;
                    RGB_reg	[3]	     <=	 YELLOW;
                    RGB_reg	[4]	     <=	 YELLOW;
                    RGB_reg	[5]	     <=	 YELLOW;
                    RGB_reg	[6]	     <=	 YELLOW;
                    RGB_reg	[7]	     <=	 YELLOW;
                    RGB_reg	[8]	     <=	 YELLOW; 
                    RGB_reg	[9]	     <=	 YELLOW;
                    RGB_reg	[10]	 <=	 YELLOW;
                    RGB_reg	[11]	 <=	 YELLOW;
                    RGB_reg	[12]	 <=	 YELLOW;
                    RGB_reg	[13]	 <=	 YELLOW;
                    RGB_reg	[14]	 <=	 YELLOW;
                    RGB_reg	[15]	 <=	 YELLOW;
                    RGB_reg	[16]	 <=	 YELLOW; 
                    RGB_reg	[17]	 <=	 YELLOW;
                    RGB_reg	[18]	 <=	 YELLOW;
                    RGB_reg	[19]	 <=	 YELLOW;
                    RGB_reg	[20]	 <=	 YELLOW;
                    RGB_reg	[21]	 <=	 YELLOW;
                    RGB_reg	[22]	 <=	 YELLOW;
                    RGB_reg	[23]	 <=	 YELLOW;
                    RGB_reg	[24]	 <=	 YELLOW; 
                    RGB_reg	[25]	 <=	 YELLOW;
                    RGB_reg	[26]	 <=	 YELLOW;
                    RGB_reg	[27]	 <=	 YELLOW;
                    RGB_reg	[28]	 <=	 YELLOW;
                    RGB_reg	[29]	 <=	 YELLOW;
                    RGB_reg	[30]	 <=	 YELLOW;
                    RGB_reg	[31]	 <=	 YELLOW;
                    RGB_reg	[32]	 <=	 YELLOW; 
                    RGB_reg	[33]	 <=	 YELLOW;
                    RGB_reg	[34]	 <=	 YELLOW;
                    RGB_reg	[35]	 <=	 YELLOW;
                    RGB_reg	[36]	 <=	 YELLOW;
                    RGB_reg	[37]	 <=	 YELLOW;
                    RGB_reg	[38]	 <=	 YELLOW;
                    RGB_reg	[39]	 <=	 YELLOW;
                    RGB_reg	[40]	 <=	 YELLOW; 
                    RGB_reg	[41]	 <=	 YELLOW;
                    RGB_reg	[42]	 <=	 YELLOW;
                    RGB_reg	[43]	 <=	 YELLOW;
                    RGB_reg	[44]	 <=	 YELLOW;
                    RGB_reg	[45]	 <=	 YELLOW;
                    RGB_reg	[46]	 <=	 YELLOW;
                    RGB_reg	[47]	 <=	 YELLOW;
                    RGB_reg	[48]	 <=	 YELLOW; 
                    RGB_reg	[49]	 <=	 YELLOW;
                    RGB_reg	[50]	 <=	 YELLOW;
                    RGB_reg	[51]	 <=	 YELLOW;
                    RGB_reg	[52]	 <=	 YELLOW;
                    RGB_reg	[53]	 <=	 YELLOW;
                    RGB_reg	[54]	 <=	 YELLOW;
                    RGB_reg	[55]	 <=	 YELLOW;
                    RGB_reg	[56]	 <=	 YELLOW; 
                    RGB_reg	[57]	 <=	 YELLOW;
                    RGB_reg	[58]	 <=	 YELLOW;
                    RGB_reg	[59]	 <=	 YELLOW;
				end
				else	begin
                    RGB_reg	[0]	     <=	 24'd0;
                    RGB_reg	[1]	     <=	 24'd0;
                    RGB_reg	[2]	     <=	 24'd0;
                    RGB_reg	[3]	     <=	 24'd0;
                    RGB_reg	[4]	     <=	 24'd0;
                    RGB_reg	[5]	     <=	 24'd0;
                    RGB_reg	[6]	     <=	 24'd0;
                    RGB_reg	[7]	     <=	 24'd0;
                    RGB_reg	[8]	     <=	 24'd0;
                    RGB_reg	[9]	     <=	 24'd0;
                    RGB_reg	[10]	 <=	 24'd0;
                    RGB_reg	[11]	 <=	 24'd0;
                    RGB_reg	[12]	 <=	 24'd0;
                    RGB_reg	[13]	 <=	 24'd0;
                    RGB_reg	[14]	 <=	 24'd0;
                    RGB_reg	[15]	 <=	 24'd0;
                    RGB_reg	[16]	 <=	 24'd0;
                    RGB_reg	[17]	 <=	 24'd0;
                    RGB_reg	[18]	 <=	 24'd0;
                    RGB_reg	[19]	 <=	 24'd0;
                    RGB_reg	[20]	 <=	 24'd0;
                    RGB_reg	[21]	 <=	 24'd0;
                    RGB_reg	[22]	 <=	 24'd0;
                    RGB_reg	[23]	 <=	 24'd0;
                    RGB_reg	[24]	 <=	 24'd0;
                    RGB_reg	[25]	 <=	 24'd0;
                    RGB_reg	[26]	 <=	 24'd0;
                    RGB_reg	[27]	 <=	 24'd0;
                    RGB_reg	[28]	 <=	 24'd0;
                    RGB_reg	[29]	 <=	 24'd0;
                    RGB_reg	[30]	 <=	 24'd0;
                    RGB_reg	[31]	 <=	 24'd0;
                    RGB_reg	[32]	 <=	 24'd0;
                    RGB_reg	[33]	 <=	 24'd0;
                    RGB_reg	[34]	 <=	 24'd0;
                    RGB_reg	[35]	 <=	 24'd0;
                    RGB_reg	[36]	 <=	 24'd0;
                    RGB_reg	[37]	 <=	 24'd0;
                    RGB_reg	[38]	 <=	 24'd0;
                    RGB_reg	[39]	 <=	 24'd0;
                    RGB_reg	[40]	 <=	 24'd0;
                    RGB_reg	[41]	 <=	 24'd0;
                    RGB_reg	[42]	 <=	 24'd0;
                    RGB_reg	[43]	 <=	 24'd0;
                    RGB_reg	[44]	 <=	 24'd0;
                    RGB_reg	[45]	 <=	 24'd0;
                    RGB_reg	[46]	 <=	 24'd0;
                    RGB_reg	[47]	 <=	 24'd0;
                    RGB_reg	[48]	 <=	 24'd0;
                    RGB_reg	[49]	 <=	 24'd0;
                    RGB_reg	[50]	 <=	 24'd0;
                    RGB_reg	[51]	 <=	 24'd0;
                    RGB_reg	[52]	 <=	 24'd0;
                    RGB_reg	[53]	 <=	 24'd0;
                    RGB_reg	[54]	 <=	 24'd0;
                    RGB_reg	[55]	 <=	 24'd0;
                    RGB_reg	[56]	 <=	 24'd0;
                    RGB_reg	[57]	 <=	 24'd0;
                    RGB_reg	[58]	 <=	 24'd0;
                    RGB_reg	[59]	 <=	 24'd0;
				end
			end
			else	begin
				if(!dir)	begin
                    RGB_reg	[0]	     <=	 YELLOW; 
                    RGB_reg	[1]	     <=	 YELLOW;
                    RGB_reg	[2]	     <=	 YELLOW;
                    RGB_reg	[3]	     <=	 YELLOW;
                    RGB_reg	[4]	     <=	 YELLOW;
                    RGB_reg	[5]	     <=	 YELLOW;
                    RGB_reg	[6]	     <=	 YELLOW;
                    RGB_reg	[7]	     <=	 YELLOW;
                    RGB_reg	[8]	     <=	 YELLOW; 
                    RGB_reg	[9]	     <=	 YELLOW;
                    RGB_reg	[10]	 <=	 YELLOW;
                    RGB_reg	[11]	 <=	 YELLOW;
                    RGB_reg	[12]	 <=	 YELLOW;
                    RGB_reg	[13]	 <=	 YELLOW;
                    RGB_reg	[14]	 <=	 YELLOW;
                    RGB_reg	[15]	 <=	 YELLOW;
                    RGB_reg	[16]	 <=	 YELLOW; 
                    RGB_reg	[17]	 <=	 YELLOW;
                    RGB_reg	[18]	 <=	 YELLOW;
                    RGB_reg	[19]	 <=	 YELLOW;
                    RGB_reg	[20]	 <=	 YELLOW;
                    RGB_reg	[21]	 <=	 YELLOW;
                    RGB_reg	[22]	 <=	 YELLOW;
                    RGB_reg	[23]	 <=	 YELLOW;
                    RGB_reg	[24]	 <=	 YELLOW; 
                    RGB_reg	[25]	 <=	 YELLOW;
                    RGB_reg	[26]	 <=	 YELLOW;
                    RGB_reg	[27]	 <=	 YELLOW;
                    RGB_reg	[28]	 <=	 YELLOW;
                    RGB_reg	[29]	 <=	 YELLOW;
                    RGB_reg	[30]	 <=	 YELLOW;
                    RGB_reg	[31]	 <=	 YELLOW;
                    RGB_reg	[32]	 <=	 YELLOW; 
                    RGB_reg	[33]	 <=	 YELLOW;
                    RGB_reg	[34]	 <=	 YELLOW;
                    RGB_reg	[35]	 <=	 YELLOW;
                    RGB_reg	[36]	 <=	 YELLOW;
                    RGB_reg	[37]	 <=	 YELLOW;
                    RGB_reg	[38]	 <=	 YELLOW;
                    RGB_reg	[39]	 <=	 YELLOW;
                    RGB_reg	[40]	 <=	 YELLOW; 
                    RGB_reg	[41]	 <=	 YELLOW;
                    RGB_reg	[42]	 <=	 YELLOW;
                    RGB_reg	[43]	 <=	 YELLOW;
                    RGB_reg	[44]	 <=	 YELLOW;
                    RGB_reg	[45]	 <=	 YELLOW;
                    RGB_reg	[46]	 <=	 YELLOW;
                    RGB_reg	[47]	 <=	 YELLOW;
                    RGB_reg	[48]	 <=	 YELLOW; 
                    RGB_reg	[49]	 <=	 YELLOW;
                    RGB_reg	[50]	 <=	 YELLOW;
                    RGB_reg	[51]	 <=	 YELLOW;
                    RGB_reg	[52]	 <=	 YELLOW;
                    RGB_reg	[53]	 <=	 YELLOW;
                    RGB_reg	[54]	 <=	 YELLOW;
                    RGB_reg	[55]	 <=	 YELLOW;
                    RGB_reg	[56]	 <=	 YELLOW; 
                    RGB_reg	[57]	 <=	 YELLOW;
                    RGB_reg	[58]	 <=	 YELLOW;
                    RGB_reg	[59]	 <=	 YELLOW;
				end
				else	begin
                    RGB_reg	[0]	     <=	 24'd0;
                    RGB_reg	[1]	     <=	 24'd0;
                    RGB_reg	[2]	     <=	 24'd0;
                    RGB_reg	[3]	     <=	 24'd0;
                    RGB_reg	[4]	     <=	 24'd0;
                    RGB_reg	[5]	     <=	 24'd0;
                    RGB_reg	[6]	     <=	 24'd0;
                    RGB_reg	[7]	     <=	 24'd0;
                    RGB_reg	[8]	     <=	 24'd0;
                    RGB_reg	[9]	     <=	 24'd0;
                    RGB_reg	[10]	 <=	 24'd0;
                    RGB_reg	[11]	 <=	 24'd0;
                    RGB_reg	[12]	 <=	 24'd0;
                    RGB_reg	[13]	 <=	 24'd0;
                    RGB_reg	[14]	 <=	 24'd0;
                    RGB_reg	[15]	 <=	 24'd0;
                    RGB_reg	[16]	 <=	 24'd0;
                    RGB_reg	[17]	 <=	 24'd0;
                    RGB_reg	[18]	 <=	 24'd0;
                    RGB_reg	[19]	 <=	 24'd0;
                    RGB_reg	[20]	 <=	 24'd0;
                    RGB_reg	[21]	 <=	 24'd0;
                    RGB_reg	[22]	 <=	 24'd0;
                    RGB_reg	[23]	 <=	 24'd0;
                    RGB_reg	[24]	 <=	 24'd0;
                    RGB_reg	[25]	 <=	 24'd0;
                    RGB_reg	[26]	 <=	 24'd0;
                    RGB_reg	[27]	 <=	 24'd0;
                    RGB_reg	[28]	 <=	 24'd0;
                    RGB_reg	[29]	 <=	 24'd0;
                    RGB_reg	[30]	 <=	 24'd0;
                    RGB_reg	[31]	 <=	 24'd0;
                    RGB_reg	[32]	 <=	 24'd0;
                    RGB_reg	[33]	 <=	 24'd0;
                    RGB_reg	[34]	 <=	 24'd0;
                    RGB_reg	[35]	 <=	 24'd0;
                    RGB_reg	[36]	 <=	 24'd0;
                    RGB_reg	[37]	 <=	 24'd0;
                    RGB_reg	[38]	 <=	 24'd0;
                    RGB_reg	[39]	 <=	 24'd0;
                    RGB_reg	[40]	 <=	 24'd0;
                    RGB_reg	[41]	 <=	 24'd0;
                    RGB_reg	[42]	 <=	 24'd0;
                    RGB_reg	[43]	 <=	 24'd0;
                    RGB_reg	[44]	 <=	 24'd0;
                    RGB_reg	[45]	 <=	 24'd0;
                    RGB_reg	[46]	 <=	 24'd0;
                    RGB_reg	[47]	 <=	 24'd0;
                    RGB_reg	[48]	 <=	 24'd0;
                    RGB_reg	[49]	 <=	 24'd0;
                    RGB_reg	[50]	 <=	 24'd0;
                    RGB_reg	[51]	 <=	 24'd0;
                    RGB_reg	[52]	 <=	 24'd0;
                    RGB_reg	[53]	 <=	 24'd0;
                    RGB_reg	[54]	 <=	 24'd0;
                    RGB_reg	[55]	 <=	 24'd0;
                    RGB_reg	[56]	 <=	 24'd0;
                    RGB_reg	[57]	 <=	 24'd0;
                    RGB_reg	[58]	 <=	 24'd0;
                    RGB_reg	[59]	 <=	 24'd0;
				end
			end
		end
	end
	else if(mode == 3'd3)    begin				
		if((cnt % 100) < LIGHT)	begin
			if(cnt < 1 * SPEED / 2 )	begin
				RGB_reg	[0]	    <=  RED; 
				RGB_reg	[1]	    <= 	ORANGE;
				RGB_reg	[2]	    <= 	YELLOW;
				RGB_reg	[3]	    <= 	GREEN;
				RGB_reg	[4]	    <= 	CYAN;
				RGB_reg	[5]	    <= 	BLUE;
				RGB_reg	[6]	    <= 	PURPLE;
				RGB_reg	[7]	    <= 	WHITE;
                RGB_reg	[8]	    <=  RED; 
				RGB_reg	[9]	    <= 	ORANGE;
				RGB_reg	[10]	<= 	YELLOW;
				RGB_reg	[11]	<= 	GREEN;
				RGB_reg	[12]	<= 	CYAN;
				RGB_reg	[13]	<= 	BLUE;
				RGB_reg	[14]	<= 	PURPLE;
				RGB_reg	[15]	<= 	WHITE;
                RGB_reg	[16]	<=  RED; 
				RGB_reg	[17]	<= 	ORANGE;
				RGB_reg	[18]	<= 	YELLOW;
				RGB_reg	[19]	<= 	GREEN;
				RGB_reg	[20]	<= 	CYAN;
				RGB_reg	[21]	<= 	BLUE;
				RGB_reg	[22]	<= 	PURPLE;
				RGB_reg	[23]	<= 	WHITE;
                RGB_reg	[24]	<=  RED; 
				RGB_reg	[25]	<= 	ORANGE;
				RGB_reg	[26]	<= 	YELLOW;
				RGB_reg	[27]	<= 	GREEN;
				RGB_reg	[28]	<= 	CYAN;
				RGB_reg	[29]	<= 	BLUE;
				RGB_reg	[30]	<= 	PURPLE;
				RGB_reg	[31]	<= 	WHITE;
                RGB_reg	[32]	<=  RED; 
				RGB_reg	[33]	<= 	ORANGE;
				RGB_reg	[34]	<= 	YELLOW;
				RGB_reg	[35]	<= 	GREEN;
				RGB_reg	[36]	<= 	CYAN;
				RGB_reg	[37]	<= 	BLUE;
				RGB_reg	[38]	<= 	PURPLE;
				RGB_reg	[39]	<= 	WHITE;
                RGB_reg	[40]	<=  RED; 
				RGB_reg	[41]	<= 	ORANGE;
				RGB_reg	[42]	<= 	YELLOW;
				RGB_reg	[43]	<= 	GREEN;
				RGB_reg	[44]	<= 	CYAN;
				RGB_reg	[45]	<= 	BLUE;
				RGB_reg	[46]	<= 	PURPLE;
				RGB_reg	[47]	<= 	WHITE;
                RGB_reg	[48]	<= 	CYAN;
				RGB_reg	[49]	<= 	BLUE;
				RGB_reg	[50]	<= 	PURPLE;
				RGB_reg	[51]	<= 	WHITE;
                RGB_reg	[52]	<=  RED; 
				RGB_reg	[53]	<= 	ORANGE;
				RGB_reg	[54]	<= 	YELLOW;
				RGB_reg	[55]	<= 	GREEN;
				RGB_reg	[56]	<= 	CYAN;
				RGB_reg	[57]	<= 	BLUE;
				RGB_reg	[58]	<= 	PURPLE;
				RGB_reg	[59]	<= 	WHITE;
			end
		end
		else begin
			RGB_reg	[0]	     <=	 24'd0;
            RGB_reg	[1]	     <=	 24'd0;
            RGB_reg	[2]	     <=	 24'd0;
            RGB_reg	[3]	     <=	 24'd0;
            RGB_reg	[4]	     <=	 24'd0;
            RGB_reg	[5]	     <=	 24'd0;
            RGB_reg	[6]	     <=	 24'd0;
            RGB_reg	[7]	     <=	 24'd0;
            RGB_reg	[8]	     <=	 24'd0;
            RGB_reg	[9]	     <=	 24'd0;
            RGB_reg	[10]	 <=	 24'd0;
            RGB_reg	[11]	 <=	 24'd0;
            RGB_reg	[12]	 <=	 24'd0;
            RGB_reg	[13]	 <=	 24'd0;
            RGB_reg	[14]	 <=	 24'd0;
            RGB_reg	[15]	 <=	 24'd0;
            RGB_reg	[16]	 <=	 24'd0;
            RGB_reg	[17]	 <=	 24'd0;
            RGB_reg	[18]	 <=	 24'd0;
            RGB_reg	[19]	 <=	 24'd0;
            RGB_reg	[20]	 <=	 24'd0;
            RGB_reg	[21]	 <=	 24'd0;
            RGB_reg	[22]	 <=	 24'd0;
            RGB_reg	[23]	 <=	 24'd0;
            RGB_reg	[24]	 <=	 24'd0;
            RGB_reg	[25]	 <=	 24'd0;
            RGB_reg	[26]	 <=	 24'd0;
            RGB_reg	[27]	 <=	 24'd0;
            RGB_reg	[28]	 <=	 24'd0;
            RGB_reg	[29]	 <=	 24'd0;
            RGB_reg	[30]	 <=	 24'd0;
            RGB_reg	[31]	 <=	 24'd0;
            RGB_reg	[32]	 <=	 24'd0;
            RGB_reg	[33]	 <=	 24'd0;
            RGB_reg	[34]	 <=	 24'd0;
            RGB_reg	[35]	 <=	 24'd0;
            RGB_reg	[36]	 <=	 24'd0;
            RGB_reg	[37]	 <=	 24'd0;
            RGB_reg	[38]	 <=	 24'd0;
            RGB_reg	[39]	 <=	 24'd0;
            RGB_reg	[40]	 <=	 24'd0;
            RGB_reg	[41]	 <=	 24'd0;
            RGB_reg	[42]	 <=	 24'd0;
            RGB_reg	[43]	 <=	 24'd0;
            RGB_reg	[44]	 <=	 24'd0;
            RGB_reg	[45]	 <=	 24'd0;
            RGB_reg	[46]	 <=	 24'd0;
            RGB_reg	[47]	 <=	 24'd0;
            RGB_reg	[48]	 <=	 24'd0;
            RGB_reg	[49]	 <=	 24'd0;
            RGB_reg	[50]	 <=	 24'd0;
            RGB_reg	[51]	 <=	 24'd0;
            RGB_reg	[52]	 <=	 24'd0;
            RGB_reg	[53]	 <=	 24'd0;
            RGB_reg	[54]	 <=	 24'd0;
            RGB_reg	[55]	 <=	 24'd0;
            RGB_reg	[56]	 <=	 24'd0;
            RGB_reg	[57]	 <=	 24'd0;
            RGB_reg	[58]	 <=	 24'd0;
            RGB_reg	[59]	 <=	 24'd0;
        end
	end
    else if(mode == 3'd4)    begin				//BLUE
	
			RGB_reg	[0]	     <=	 BLUE;
            RGB_reg	[1]	     <=	 BLUE;
            RGB_reg	[2]	     <=	 BLUE;
            RGB_reg	[3]	     <=	 BLUE;
            RGB_reg	[4]	     <=	 BLUE;
            RGB_reg	[5]	     <=	 BLUE;
            RGB_reg	[6]	     <=	 BLUE;
            RGB_reg	[7]	     <=	 BLUE;
            RGB_reg	[8]	     <=	 BLUE;
            RGB_reg	[9]	     <=	 BLUE;
            RGB_reg	[10]	 <=	 BLUE;
            RGB_reg	[11]	 <=	 BLUE;
            RGB_reg	[12]	 <=	 BLUE;
            RGB_reg	[13]	 <=	 BLUE;
            RGB_reg	[14]	 <=	 BLUE;
            RGB_reg	[15]	 <=	 BLUE;
            RGB_reg	[16]	 <=	 BLUE;
            RGB_reg	[17]	 <=	 BLUE;
            RGB_reg	[18]	 <=	 BLUE;
            RGB_reg	[19]	 <=	 BLUE;
            RGB_reg	[20]	 <=	 BLUE;
            RGB_reg	[21]	 <=	 BLUE;
            RGB_reg	[22]	 <=	 BLUE;
            RGB_reg	[23]	 <=	 BLUE;
            RGB_reg	[24]	 <=	 BLUE;
            RGB_reg	[25]	 <=	 BLUE;
            RGB_reg	[26]	 <=	 BLUE;
            RGB_reg	[27]	 <=	 BLUE;
            RGB_reg	[28]	 <=	 BLUE;
            RGB_reg	[29]	 <=	 BLUE;
            RGB_reg	[30]	 <=	 BLUE;
            RGB_reg	[31]	 <=	 BLUE;
            RGB_reg	[32]	 <=	 BLUE;
            RGB_reg	[33]	 <=	 BLUE;
            RGB_reg	[34]	 <=	 BLUE;
            RGB_reg	[35]	 <=	 BLUE;
            RGB_reg	[36]	 <=	 BLUE;
            RGB_reg	[37]	 <=	 BLUE;
            RGB_reg	[38]	 <=	 BLUE;
            RGB_reg	[39]	 <=	 BLUE;
            RGB_reg	[40]	 <=	 BLUE;
            RGB_reg	[41]	 <=	 BLUE;
            RGB_reg	[42]	 <=	 BLUE;
            RGB_reg	[43]	 <=	 BLUE;
            RGB_reg	[44]	 <=	 BLUE;
            RGB_reg	[45]	 <=	 BLUE;
            RGB_reg	[46]	 <=	 BLUE;
            RGB_reg	[47]	 <=	 BLUE;
            RGB_reg	[48]	 <=	 BLUE;
            RGB_reg	[49]	 <=	 BLUE;
            RGB_reg	[50]	 <=	 BLUE;
            RGB_reg	[51]	 <=	 BLUE;
            RGB_reg	[52]	 <=	 BLUE;
            RGB_reg	[53]	 <=	 BLUE;
            RGB_reg	[54]	 <=	 BLUE;
            RGB_reg	[55]	 <=	 BLUE;
            RGB_reg	[56]	 <=	 BLUE;
            RGB_reg	[57]	 <=	 BLUE;
            RGB_reg	[58]	 <=	 BLUE;
            RGB_reg	[59]	 <=	 BLUE;
	end
    else if(mode == 3'd5)    begin				//YELLOW
	
			RGB_reg	[0]	     <=	 YELLOW;
            RGB_reg	[1]	     <=	 YELLOW;
            RGB_reg	[2]	     <=	 YELLOW;
            RGB_reg	[3]	     <=	 YELLOW;
            RGB_reg	[4]	     <=	 YELLOW;
            RGB_reg	[5]	     <=	 YELLOW;
            RGB_reg	[6]	     <=	 YELLOW;
            RGB_reg	[7]	     <=	 YELLOW;
            RGB_reg	[8]	     <=	 YELLOW;
            RGB_reg	[9]	     <=	 YELLOW;
            RGB_reg	[10]	 <=	 YELLOW;
            RGB_reg	[11]	 <=	 YELLOW;
            RGB_reg	[12]	 <=	 YELLOW;
            RGB_reg	[13]	 <=	 YELLOW;
            RGB_reg	[14]	 <=	 YELLOW;
            RGB_reg	[15]	 <=	 YELLOW;
            RGB_reg	[16]	 <=	 YELLOW;
            RGB_reg	[17]	 <=	 YELLOW;
            RGB_reg	[18]	 <=	 YELLOW;
            RGB_reg	[19]	 <=	 YELLOW;
            RGB_reg	[20]	 <=	 YELLOW;
            RGB_reg	[21]	 <=	 YELLOW;
            RGB_reg	[22]	 <=	 YELLOW;
            RGB_reg	[23]	 <=	 YELLOW;
            RGB_reg	[24]	 <=	 YELLOW;
            RGB_reg	[25]	 <=	 YELLOW;
            RGB_reg	[26]	 <=	 YELLOW;
            RGB_reg	[27]	 <=	 YELLOW;
            RGB_reg	[28]	 <=	 YELLOW;
            RGB_reg	[29]	 <=	 YELLOW;
            RGB_reg	[30]	 <=	 YELLOW;
            RGB_reg	[31]	 <=	 YELLOW;
            RGB_reg	[32]	 <=	 YELLOW;
            RGB_reg	[33]	 <=	 YELLOW;
            RGB_reg	[34]	 <=	 YELLOW;
            RGB_reg	[35]	 <=	 YELLOW;
            RGB_reg	[36]	 <=	 YELLOW;
            RGB_reg	[37]	 <=	 YELLOW;
            RGB_reg	[38]	 <=	 YELLOW;
            RGB_reg	[39]	 <=	 YELLOW;
            RGB_reg	[40]	 <=	 YELLOW;
            RGB_reg	[41]	 <=	 YELLOW;
            RGB_reg	[42]	 <=	 YELLOW;
            RGB_reg	[43]	 <=	 YELLOW;
            RGB_reg	[44]	 <=	 YELLOW;
            RGB_reg	[45]	 <=	 YELLOW;
            RGB_reg	[46]	 <=	 YELLOW;
            RGB_reg	[47]	 <=	 YELLOW;
            RGB_reg	[48]	 <=	 YELLOW;
            RGB_reg	[49]	 <=	 YELLOW;
            RGB_reg	[50]	 <=	 YELLOW;
            RGB_reg	[51]	 <=	 YELLOW;
            RGB_reg	[52]	 <=	 YELLOW;
            RGB_reg	[53]	 <=	 YELLOW;
            RGB_reg	[54]	 <=	 YELLOW;
            RGB_reg	[55]	 <=	 YELLOW;
            RGB_reg	[56]	 <=	 YELLOW;
            RGB_reg	[57]	 <=	 YELLOW;
            RGB_reg	[58]	 <=	 YELLOW;
            RGB_reg	[59]	 <=	 YELLOW;
        
	end
end
   
//-------------------计数�?----------------------//
always@(posedge clk, negedge rst_n)	begin
	if(!rst_n)
		cnt <= 26'd0;
	else if( cnt == SPEED )
		cnt <= 26'd0;
	else 
		cnt <= cnt + 1;
end


//-------------------速度调节----------------------//
always@(*)	begin
	case(speed)
		2'b00 : SPEED <= 26'd50000000;
		2'b01 : SPEED <= 26'd30000000;
		2'b10 : SPEED <= 26'd15000000;
		2'b11 : SPEED <= 26'd1000000;
	default:	SPEED <= 26'd50000000;
	endcase
	
	case(speed)
		2'b00 : T_1ms <= 10000;
		2'b01 : T_1ms <= 50000;
		2'b10 : T_1ms <= 100000;
		2'b11 : T_1ms <= 200000;
	default:	T_1ms <= 10000;
	endcase
end

//-------------------亮度调节----------------------//
always@(*)	begin
	case(light)
		2'b00 : LIGHT <= 7'd10;
		2'b01 : LIGHT <= 7'd45;
		2'b10 : LIGHT <= 7'd75;
		2'b11 : LIGHT <= 7'd100;
		default : LIGHT <= 7'd10;
	endcase
	
	case(light)
		2'b00 : hxd_light <= 1;
		2'b01 : hxd_light <= 5;
		2'b10 : hxd_light <= 8;
		2'b11 : hxd_light <= 10;
		default : hxd_light <= 1;
	endcase
end

endmodule
