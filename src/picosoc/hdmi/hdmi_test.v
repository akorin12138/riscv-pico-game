`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:Meyesemi 
// Engineer: Will
// 
// Create Date: 2023-01-29 20:31  
// Design Name:  
// Module Name: 
// Project Name: 
// Target Devices: Pango
// Tool Versions: 
// Description: 
//      
// Dependencies: 
// 
// Revision:
// Revision 1.0 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define UD #1

module hdmi_test(
    input wire        sys_clk       ,// input system clock 50MHz

    input     [23:0]  rgb_dat       ,
    
    output             rstn_out     ,
    output            iic_tx_scl    ,
    inout             iic_tx_sda    ,
    output            led_int       ,

    input      [3:0 ] mem_wstrb     ,
    input      [31:0] mem_wdata     ,
    input      [3:0 ] rgb_we        ,
    output     [23:0] rgb_dat_out   ,
//hdmi_out 
    output            pix_clk       ,//pixclk                           
    output            vs_out        , 
    output            hs_out        , 
    output            de_out        ,
    output     [7:0]  r_out         , 
    output     [7:0]  g_out         , 
    output     [7:0]  b_out         ,
    input             ram_sel       ,
    input [3:0 ]    ram_addr_i_we    ,
    input [3:0 ]    ram_data_i_we    ,
    input [3:0 ]    user_block_u_i_we,
    input [3:0 ]    user_block_d_i_we,
    output [31:0]           ram_addr_i,
    output [31:0]           ram_data_i,
    output [31:0]       user_block_u_i,
    output [31:0]       user_block_d_i
);

parameter   X_WIDTH = 4'd12;
parameter   Y_WIDTH = 4'd12;    


    wire [31:0]     ram_addr = ram_addr_i;          
    wire [31:0]     ram_data = ram_data_i;          
    wire [31:0] user_block_u = user_block_u_i;      
    wire [31:0] user_block_d = user_block_d_i;      
//MODE_1080p
    parameter V_TOTAL = 12'd1125;
    parameter V_FP = 12'd4;
    parameter V_BP = 12'd36;
    parameter V_SYNC = 12'd5;
    parameter V_ACT = 12'd1080;
    parameter H_TOTAL = 12'd2200;
    parameter H_FP = 12'd88;
    parameter H_BP = 12'd148;
    parameter H_SYNC = 12'd44;
    parameter H_ACT = 12'd1920;
    parameter HV_OFFSET = 12'd0;
//MODE_1024X768@60hz
    // parameter V_TOTAL = 12'd806;//
    // parameter V_FP = 12'd3;//
    // parameter V_BP = 12'd29;//
    // parameter V_SYNC = 12'd6;//
    // parameter V_ACT = 12'd768;//
    // parameter H_TOTAL = 12'd1344;//
    // parameter H_FP = 12'd24;//
    // parameter H_BP = 12'd160;//
    // parameter H_SYNC = 12'd136;//
    // parameter H_ACT = 12'd1024;//
    // parameter HV_OFFSET = 12'd0;
//MODE_640X480@60hz
    // parameter V_TOTAL = 12'd500;
    // parameter V_FP = 12'd1;
    // parameter V_BP = 12'd16;
    // parameter V_SYNC = 12'd3;
    // parameter V_ACT = 12'd480;
    // parameter H_TOTAL = 12'd840;
    // parameter H_FP = 12'd16;
    // parameter H_BP = 12'd120;
    // parameter H_SYNC = 12'd64;
    // parameter H_ACT = 12'd640;
    // parameter HV_OFFSET = 12'd0;

    wire                        pix_clk    ;
    wire                        cfg_clk    ;
    wire                        locked     ;
    wire                        rstn       ;
    wire                        init_over  ;
    reg  [15:0]                 rstn_1ms   ;
    wire [X_WIDTH - 1'b1:0]     act_x      ;
    wire [Y_WIDTH - 1'b1:0]     act_y      ;    
    wire                        hs         ;
    wire                        vs         ;
    wire                        de         ;
    reg  [3:0]              reset_delay_cnt;

    pll u_pll (
        .clkin1   (  sys_clk    ),//50MHz
        .clkout0  (  pix_clk    ),//148.5MHz
        .clkout1  (  cfg_clk    ),//10MHz
        .pll_lock (  locked     )
    );

    ms72xx_ctl ms72xx_ctl(
        .clk         (  cfg_clk    ), //input       clk,
        .rst_n       (  rstn_out   ), //input       rstn,
                                
        .init_over   (  init_over  ), //output      init_over,
        .iic_tx_scl  (  iic_tx_scl ), //output      iic_scl,
        .iic_tx_sda  (  iic_tx_sda ), //inout       iic_sda
        .iic_scl     (  iic_scl    ), //output      iic_scl,
        .iic_sda     (  iic_sda    )  //inout       iic_sda
    );
   assign    led_int    =     init_over;
    
    always @(posedge cfg_clk)//1ms
    begin
    	if(!locked)
    	    rstn_1ms <= 16'd0;
    	else
    	begin
    		if(rstn_1ms == 16'h2710)
    		    rstn_1ms <= rstn_1ms;
    		else
    		    rstn_1ms <= rstn_1ms + 1'b1;
    	end
    end
    assign rstn_out = (rstn_1ms == 16'h2710);
    wire we_i;
    sync_vg 
    #(
        .X_BITS               (  X_WIDTH              ), 
        .Y_BITS               (  Y_WIDTH              ),
        .V_TOTAL              (  V_TOTAL              ),//                        
        .V_FP                 (  V_FP                 ),//                        
        .V_BP                 (  V_BP                 ),//                        
        .V_SYNC               (  V_SYNC               ),//                        
        .V_ACT                (  V_ACT                ),//                        
        .H_TOTAL              (  H_TOTAL              ),//                        
        .H_FP                 (  H_FP                 ),//                        
        .H_BP                 (  H_BP                 ),//                        
        .H_SYNC               (  H_SYNC               ),//                        
        .H_ACT                (  H_ACT                ) //                        
 
    ) 
    sync_vg                                         
    (                                                 
        .clk                  (  pix_clk               ),//input                  clk,                                 
        .rstn                 (  rstn_out               ),//input                   rstn,                            
        .vs_out               (  vs                   ),//output reg              vs_out,                                                                                                                                      
        .hs_out               (  hs                   ),//output reg              hs_out,            
        .de_out               (  de                   ),//output reg              de_out,             
        .x_act                (  act_x                ),//output reg [X_BITS-1:0] x_out,             
        .y_act                (  act_y                ) //output reg [Y_BITS:0]   y_out,             
    );
    
    pattern_vg #(
        .COCLOR_DEPP          (  8                    ), // Bits per channel
        .X_BITS               (  X_WIDTH              ),
        .Y_BITS               (  Y_WIDTH              ),
        .H_ACT                (  H_ACT                ),
        .V_ACT                (  V_ACT                )
    ) 
    pattern_vg (    //Number of fractional bits for ramp pattern
        .rstn                 (  rstn_out             ),//input                         rstn,                                                     
        .pix_clk              (  pix_clk              ),//input                         clk_in,  
        .act_x                (  act_x                ),//input      [X_BITS-1:0]       x,   
        .act_y                (  act_y                ),//input      [Y_BITS-1:0]       y,   
        // input video timing
        .vs_in                (  vs                   ),//input                         vn_in                        
        .hs_in                (  hs                   ),//input                         hn_in,                           
        .de_in                (  de                   ),//input                         dn_in,
        // test pattern image output
        
        // .rgb_dat              (  rgb_dat              ),
        //------------------------------------------------------------
        .sys_clk              (sys_clk                ),
        .ram_data_i           (ram_data             ),
        .ram_addr_i           (ram_addr             ),
        .user_block_u_i       (user_block_u         ),
        .user_block_d_i       (user_block_d         ),
        .we_i                 (we_i            ),
        //------------------------------------------------------------
        .vs_out               (  vs_out               ),//output reg                    vn_out,                       
        .hs_out               (  hs_out               ),//output reg                    hn_out,                       
        .de_out               (  de_out               ),//output reg                    den_out,                      
        .r_out                (  r_out                ),//output reg [COCLOR_DEPP-1:0]  r_out,                      
        .g_out                (  g_out                ),//output reg [COCLOR_DEPP-1:0]  g_out,                       
        .b_out                (  b_out                ) //output reg [COCLOR_DEPP-1:0]  b_out   
    );


    // assign rgb_dat_out[23:16] = (rgb_we[0])? mem_wdata[23:16] : rgb_dat_out[23:16];
    // assign rgb_dat_out[15:8 ] = (rgb_we[1])? mem_wdata[15:8 ] : rgb_dat_out[15:8 ];
    // assign rgb_dat_out[7:0  ] = (rgb_we[2])? mem_wdata[7:0  ] : rgb_dat_out[7:0  ];

    assign   we_i = ram_sel;
    assign   ram_data_i[ 7:0 ] = ram_data_i_we[0] ? mem_wdata[ 7:0 ] : ram_data_i[ 7:0 ];
    assign   ram_data_i[15:8 ] = ram_data_i_we[1] ? mem_wdata[15:8 ] : ram_data_i[15:8 ];
    assign   ram_data_i[23:16] = ram_data_i_we[2] ? mem_wdata[23:16] : ram_data_i[23:16];
    assign   ram_data_i[31:24] = ram_data_i_we[3] ? mem_wdata[31:24] : ram_data_i[31:24];
    
    assign   ram_addr_i[ 7:0 ] = ram_addr_i_we[0] ? mem_wdata[ 7:0 ] : ram_addr_i[ 7:0 ];
    assign   ram_addr_i[15:8 ] = ram_addr_i_we[1] ? mem_wdata[15:8 ] : ram_addr_i[15:8 ];
    assign   ram_addr_i[23:16] = ram_addr_i_we[2] ? mem_wdata[23:16] : ram_addr_i[23:16];
    assign   ram_addr_i[31:24] = ram_addr_i_we[3] ? mem_wdata[31:24] : ram_addr_i[31:24];
    
    assign   user_block_u_i[ 7:0 ] = user_block_u_i_we[0] ? mem_wdata[ 7:0 ] : user_block_u_i[ 7:0 ];
    assign   user_block_u_i[15:8 ] = user_block_u_i_we[1] ? mem_wdata[15:8 ] : user_block_u_i[15:8 ];
    assign   user_block_u_i[23:16] = user_block_u_i_we[2] ? mem_wdata[23:16] : user_block_u_i[23:16];
    assign   user_block_u_i[31:24] = user_block_u_i_we[3] ? mem_wdata[31:24] : user_block_u_i[31:24];
    
    assign   user_block_d_i[ 7:0 ] = user_block_d_i_we[0] ? mem_wdata[ 7:0 ] : user_block_d_i[ 7:0 ];
    assign   user_block_d_i[15:8 ] = user_block_d_i_we[1] ? mem_wdata[15:8 ] : user_block_d_i[15:8 ];
    assign   user_block_d_i[23:16] = user_block_d_i_we[2] ? mem_wdata[23:16] : user_block_d_i[23:16];
    assign   user_block_d_i[31:24] = user_block_d_i_we[3] ? mem_wdata[31:24] : user_block_d_i[31:24];

endmodule
