module TOP(
	input	    clk  ,
	input 	    rst_n,
	input [2:0] MODE ,		//模式选择
	input [1:0] SPEED,		//速度调节
	input [1:0] LIGHT,		//亮度调节
	
	output 	RZ_data
);
//-------------------------------//
wire 	tx_en;
wire 	tx_done;
wire 	[23:0]	RGB;

wire [1439:0] RGB_reg;
wire [2:0] mode;
wire [1:0] speed;
wire [1:0] light;
parameter en = 1;

assign mode = MODE;
assign speed = SPEED;
assign light = LIGHT;
//-------------------------------//
RGB_Control		RGB_Control_inst0(
	.clk			(clk),
	.rst_n		(rst_n),
	.tx_done		(tx_done),
	.rgb_reg 	( RGB_reg[1439:0]),
	.tx_en		(tx_en),	
	.RGB			(RGB)
);
//-------------------------------//
RZ_Code			RZ_Code_inst1(
	.clk			(clk),
	.rst_n		(rst_n),
	.RGB			(RGB),
	.tx_en		(tx_en),	
	.tx_done		(tx_done),
	.RZ_data		(RZ_data)
);
//-------------------------------//
color_ctrl color_ctrl_inst(
	.clk			(clk),
	.rst_n		(rst_n),
	.mode			(mode[2:0]),
	.speed		(speed[1:0]),
	.light		(light[1:0]),
	.rgb_reg 	( RGB_reg[1439:0])
);

endmodule
