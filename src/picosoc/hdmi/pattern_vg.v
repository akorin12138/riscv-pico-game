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

module pattern_vg # (
    parameter                            COCLOR_DEPP=8, // number of bits per channel
    parameter                            X_BITS=13,
    parameter                            Y_BITS=13,
    parameter                            H_ACT = 12'd1280,
    parameter                            V_ACT = 12'd720
)(                                       
    input                                rstn, 
    input                                sys_clk,
    input                                pix_clk,
    input [X_BITS-1:0]                   act_x,
    input [Y_BITS-1:0]                   act_y,
    input                                vs_in, 
    input                                hs_in, 
    input                                de_in,
    
    output                                 we_i,
    input [31:0]                     ram_data_i,
    input [31:0]                     ram_addr_i,
    input [31:0]                 user_block_u_i,
    input [31:0]                 user_block_d_i,
    // input   [23:0]                       rgb_dat,
    output reg                           vs_out, 
    output reg                           hs_out, 
    output reg                           de_out,
    output wire [COCLOR_DEPP-1:0]         r_out, 
    output wire [COCLOR_DEPP-1:0]         g_out, 
    output wire [COCLOR_DEPP-1:0]         b_out
);

reg  [7:0] user_block[0:7];
reg  [5:0] block [0:3];
    always @(posedge sys_clk) begin
        user_block[0]<=user_block_u_i[7:0];
        user_block[1]<=user_block_u_i[15:8];
        user_block[2]<=user_block_u_i[23:16];
        user_block[3]<=user_block_u_i[31:24];
        user_block[4]<=user_block_d_i[7:0];
        user_block[5]<=user_block_d_i[15:8];
        user_block[6]<=user_block_d_i[23:16];
        user_block[7]<=user_block_d_i[31:24];
end

    reg vs_ind1;
    reg hs_ind1;
    reg ds_ind1;
   always @(posedge pix_clk)// delay VS HS DE signal
    begin
        vs_ind1 <= `UD vs_in;
        hs_ind1 <= `UD hs_in;
        ds_ind1 <= `UD de_in;
end
    always @(posedge pix_clk)// delay VS HS DE signal
    begin
        vs_out <= vs_ind1;
        hs_out <= hs_ind1;
        de_out <= ds_ind1;
end
//--------------------------------------------------------------------------    
   wire [7:0]  graph_mem;
   wire [11:0] RGB_x_i; 
   assign   RGB_x_i = act_x;
   wire [11:0] RGB_y_i;
   assign   RGB_y_i = act_y;

//    wire rst_n = rstn;
    reg[23:0] RGB_data_o;

    always @(*) begin
        block[0]<=6'b111111;
        block[1]<=6'b111111;
        block[2]<=6'b111111;
        block[3]<=6'b111111;
    end
    wire [9:0] p_x;
    assign p_x  =   act_x/6;//320
    wire [9:0] p_y;
    assign p_y  =   act_y/4;//270
   
    wire [16:0] pos;  
    assign pos=320*p_y+p_x;

    reg [23:0] block_color;

    wire [9:0] zero_offset_x;    
    assign zero_offset_x = (act_x%6);

    wire [9:0] zero_offset_y;        
    assign zero_offset_y = (act_y%4);

    // always @(posedge pix_clk) begin
    //     if(rstn==1'b0)begin
    //         block_color<=24'hffffff;
    //     end
    //     else
    //         block_color <= {{graph_mem[14:10],3'b0},{graph_mem[9:5],3'b0},{graph_mem[4:0],3'b0}};
    // end

    always @(posedge pix_clk) begin
        if(rstn==1'b0)begin
            RGB_data_o<=24'hffffff;
        end
        else
            RGB_data_o<=block_color*block[zero_offset_y][zero_offset_x];
    end
//////////////////////////////////////////////////////////

assign {r_out,g_out,b_out} =  RGB_data_o;

//test: ramip////////////////////////////////////////////
    reg rstn_1d;
    reg rstn_2d;
    always @(posedge sys_clk) begin
        rstn_1d <= rstn;
        rstn_2d <= rstn_1d;
    end
    reg [16:0] ramaddr;
    reg [7:0] ramdata;
    reg wr_en;
//可能没啥卵用，仿照例程：摄像头+DDR3///延时数据和使能//////
    always @(posedge sys_clk) begin
        ramdata[7:0] <= ram_data_i[7:0];
        wr_en <= ram_data_i[31];
    end
    always @(posedge sys_clk) begin
        begin
            if(wr_en)
                ramaddr[16:0] <= ram_addr_i[16:0];
            else
                ramaddr <= ramaddr;
        end
    end
//////////////////////rgb_index////////////////////////////
    always @(*) begin
        case (graph_mem)
              0: block_color <= 24'h0; 
              1: block_color <= 24'hFF0000;
              2: block_color <= 24'hFF9600;
              3: block_color <= 24'hFFFB00;
              4: block_color <= 24'h85FF00;
              5: block_color <= 24'h2BFF00;
              6: block_color <= 24'h00FF34;
              7: block_color <= 24'h00FF88;
              8: block_color <= 24'h00FFEE;
              9: block_color <= 24'h00E0FF;
             10: block_color <= 24'h007BFF;
             11: block_color <= 24'h3300FF;
             12: block_color <= 24'h8D00FF;
             13: block_color <= 24'hF200FF;
             14: block_color <= 24'hFF00B8;
             15: block_color <= 24'hFF005E;
             16: block_color <= 24'hFF0022;
             17: block_color <= 24'hFF1010;
             18: block_color <= 24'hFF6512;
             19: block_color <= 24'hFFB20F;
             20: block_color <= 24'hECFF12;
             21: block_color <= 24'hABFF15;
             22: block_color <= 24'h70FF0F;
             23: block_color <= 24'h48FF0E;
             24: block_color <= 24'h13FF0C;
             25: block_color <= 24'h0AFF59;
             26: block_color <= 24'h09FFDD;
             27: block_color <= 24'h10C1FF;
             28: block_color <= 24'h0C92FF;
             29: block_color <= 24'h0C53FF;
             30: block_color <= 24'h320DFF;
             31: block_color <= 24'hFF15D9;
             32: block_color <= 24'hFF2222;
             33: block_color <= 24'hFF771D;
             34: block_color <= 24'hFFCD21;
             35: block_color <= 24'hEDFF1D;
             36: block_color <= 24'h8EFF1E;
             37: block_color <= 24'h8EFF1E;
             38: block_color <= 24'h8EFF1E;
             39: block_color <= 24'h1CFF80;
             40: block_color <= 24'h1FFEFF;
             41: block_color <= 24'h1BD9FF;
             42: block_color <= 24'h1B99FF;
             43: block_color <= 24'h9717FF;
             44: block_color <= 24'hE311FF;
             45: block_color <= 24'hFF17D9;
             46: block_color <= 24'hFF187D;
             47: block_color <= 24'hFF1762;
             48: block_color <= 24'hFF2B2B;
             49: block_color <= 24'hFF6C2C;
             50: block_color <= 24'hFFB72E;
             51: block_color <= 24'hEAFF31;
             52: block_color <= 24'hA0FF2E;
             53: block_color <= 24'h49FF2F;
             54: block_color <= 24'h33FF58;
             55: block_color <= 24'h35FFA6;
             56: block_color <= 24'h34FFF6;
             57: block_color <= 24'h31A2FF;
             58: block_color <= 24'h2F4AFF;
             59: block_color <= 24'h4A2FFF;
             60: block_color <= 24'h9634FF;
             61: block_color <= 24'hE12EFF;
             62: block_color <= 24'hFF2AD2;
             63: block_color <= 24'hFF3261;
             64: block_color <= 24'hFF0000;
             65: block_color <= 24'hFF9600;
             66: block_color <= 24'hFFFB00;
             67: block_color <= 24'h85FF00;
             68: block_color <= 24'h2BFF00;
             69: block_color <= 24'h00FF34;
             70: block_color <= 24'h00FF88;
             71: block_color <= 24'h00FFEE;
             72: block_color <= 24'h00E0FF;
             73: block_color <= 24'h007BFF;
             74: block_color <= 24'h3300FF;
             75: block_color <= 24'h8D00FF;
             76: block_color <= 24'hF200FF;
             77: block_color <= 24'hFF00B8;
             78: block_color <= 24'hFF005E;
             79: block_color <= 24'hFF0022;
             80: block_color <= 24'hFF1010;
             81: block_color <= 24'hFF6512;
             82: block_color <= 24'hFFB20F;
             83: block_color <= 24'hECFF12;
             84: block_color <= 24'hABFF15;
             85: block_color <= 24'h70FF0F;
             86: block_color <= 24'h48FF0E;
             87: block_color <= 24'h13FF0C;
             88: block_color <= 24'h0AFF59;
             89: block_color <= 24'h09FFDD;
             90: block_color <= 24'h10C1FF;
             91: block_color <= 24'h0C92FF;
             92: block_color <= 24'h0C53FF;
             93: block_color <= 24'h320DFF;
             94: block_color <= 24'hFF15D9;
             95: block_color <= 24'hFF2222;
             96: block_color <= 24'hFF771D;
             97: block_color <= 24'hFFCD21;
             98: block_color <= 24'hEDFF1D;
             99: block_color <= 24'h8EFF1E;
            100: block_color <= 24'hFF3030;//俄罗斯方块/红
            101: block_color <= 24'hFF7F24;//橙色
            102: block_color <= 24'hFFFF00;//黄色
            103: block_color <= 24'h00FF00;//绿色
            104: block_color <= 24'h0000FF;//蓝色
            105: block_color <= 24'hA020F0;//紫色
            106: block_color <= 24'hFFC0CB;//粉色
            107: block_color <= 24'hE311FF;
            108: block_color <= 24'hFF17D9;
            109: block_color <= 24'hFF187D;
            110: block_color <= 24'hFF1762;
            111: block_color <= 24'hFF2B2B;
            112: block_color <= 24'hFF6C2C;
            113: block_color <= 24'hFFB72E;
            114: block_color <= 24'hEAFF31;
            115: block_color <= 24'hA0FF2E;
            116: block_color <= 24'h49FF2F;
            117: block_color <= 24'h33FF58;
            118: block_color <= 24'h35FFA6;
            119: block_color <= 24'h34FFF6;
            120: block_color <= 24'h31A2FF;
            121: block_color <= 24'h2F4AFF;
            122: block_color <= 24'h4A2FFF;
            123: block_color <= 24'h9634FF;
            124: block_color <= 24'hE12EFF;
            125: block_color <= 24'hFF2AD2;
            126: block_color <= 24'hFF3261;
            127: block_color <= 24'hFF0000;
            128: block_color <= 24'hFF9600;
            129: block_color <= 24'hFFFB00;
            130: block_color <= 24'h85FF00;
            131: block_color <= 24'h2BFF00;
            132: block_color <= 24'h00FF34;
            133: block_color <= 24'h00FF88;
            134: block_color <= 24'h00FFEE;
            135: block_color <= 24'h00E0FF;
            136: block_color <= 24'h007BFF;
            137: block_color <= 24'h3300FF;
            138: block_color <= 24'h8D00FF;
            139: block_color <= 24'hF200FF;
            140: block_color <= 24'hFF00B8;
            141: block_color <= 24'hFF005E;
            142: block_color <= 24'hFF0022;
            143: block_color <= 24'hFF1010;
            144: block_color <= 24'hFF6512;
            145: block_color <= 24'hFFB20F;
            146: block_color <= 24'hECFF12;
            147: block_color <= 24'hABFF15;
            148: block_color <= 24'h70FF0F;
            149: block_color <= 24'h48FF0E;
            150: block_color <= 24'h13FF0C;
            151: block_color <= 24'h0AFF59;
            152: block_color <= 24'h09FFDD;
            153: block_color <= 24'h10C1FF;
            154: block_color <= 24'h0C92FF;
            155: block_color <= 24'h0C53FF;
            156: block_color <= 24'h320DFF;
            157: block_color <= 24'hFF15D9;
            158: block_color <= 24'hFF2222;
            159: block_color <= 24'hFF771D;
            160: block_color <= 24'hFFCD21;
            161: block_color <= 24'hEDFF1D;
            162: block_color <= 24'h8EFF1E;
            163: block_color <= 24'h8EFF1E;
            164: block_color <= 24'h8EFF1E;
            165: block_color <= 24'h1CFF80;
            166: block_color <= 24'h1FFEFF;
            167: block_color <= 24'h1BD9FF;
            168: block_color <= 24'h1B99FF;
            169: block_color <= 24'h9717FF;
            170: block_color <= 24'hE311FF;
            171: block_color <= 24'hFF17D9;
            172: block_color <= 24'hFF187D;
            173: block_color <= 24'hFF1762;
            174: block_color <= 24'hFF2B2B;
            175: block_color <= 24'hFF6C2C;
            176: block_color <= 24'hFFB72E;
            177: block_color <= 24'hEAFF31;
            178: block_color <= 24'hA0FF2E;
            179: block_color <= 24'h49FF2F;
            180: block_color <= 24'h33FF58;
            181: block_color <= 24'h35FFA6;
            182: block_color <= 24'h34FFF6;
            183: block_color <= 24'h31A2FF;
            184: block_color <= 24'h2F4AFF;
            185: block_color <= 24'h4A2FFF;
            186: block_color <= 24'h9634FF;
            187: block_color <= 24'hE12EFF;
            188: block_color <= 24'hFF2AD2;
            189: block_color <= 24'hFF3261;
            190: block_color <= 24'hFF0000;
            191: block_color <= 24'hFF9600;
            192: block_color <= 24'hFFFB00;
            193: block_color <= 24'h85FF00;
            194: block_color <= 24'h2BFF00;
            195: block_color <= 24'h00FF34;
            196: block_color <= 24'h00FF88;
            197: block_color <= 24'h00FFEE;
            198: block_color <= 24'h00E0FF;
            199: block_color <= 24'h007BFF;
            200: block_color <= 24'h3300FF;
            201: block_color <= 24'h8D00FF;
            202: block_color <= 24'hF200FF;
            203: block_color <= 24'hFF00B8;
            204: block_color <= 24'hFF005E;
            205: block_color <= 24'hFF0022;
            206: block_color <= 24'hFF1010;
            207: block_color <= 24'hFF6512;
            208: block_color <= 24'hFFB20F;
            209: block_color <= 24'hECFF12;
            210: block_color <= 24'hABFF15;
            211: block_color <= 24'h70FF0F;
            212: block_color <= 24'h48FF0E;
            213: block_color <= 24'h13FF0C;
            214: block_color <= 24'h0AFF59;
            215: block_color <= 24'h09FFDD;
            216: block_color <= 24'h10C1FF;
            217: block_color <= 24'h0C92FF;
            218: block_color <= 24'h0C53FF;
            219: block_color <= 24'h320DFF;
            220: block_color <= 24'hFF15D9;
            221: block_color <= 24'hFF2222;
            222: block_color <= 24'hFF771D;
            223: block_color <= 24'hFFCD21;
            224: block_color <= 24'hEDFF1D;
            225: block_color <= 24'h8EFF1E;
            226: block_color <= 24'h8EFF1E;
            227: block_color <= 24'h8EFF1E;
            228: block_color <= 24'h1CFF80;
            229: block_color <= 24'h1FFEFF;
            230: block_color <= 24'h1BD9FF;
            231: block_color <= 24'h1B99FF;
            232: block_color <= 24'h9717FF;
            233: block_color <= 24'hE311FF;
            234: block_color <= 24'hFF17D9;
            235: block_color <= 24'hFF187D;
            236: block_color <= 24'hFF1762;
            237: block_color <= 24'hFF2B2B;
            238: block_color <= 24'hFF6C2C;
            239: block_color <= 24'hFFB72E;
            240: block_color <= 24'hEAFF31;
            241: block_color <= 24'hA0FF2E;
            242: block_color <= 24'h49FF2F;
            243: block_color <= 24'h33FF58;
            244: block_color <= 24'h35FFA6;
            245: block_color <= 24'h34FFF6;
            246: block_color <= 24'h31A2FF;
            247: block_color <= 24'h2F4AFF;
            248: block_color <= 24'h4A2FFF;
            249: block_color <= 24'h9634FF;
            250: block_color <= 24'hE12EFF;
            251: block_color <= 24'hFF2AD2;
            252: block_color <= 24'hFF3261;
            253: block_color <= 24'hFFF2F2;
            254: block_color <= 24'hFFF2F2;
            255: block_color <= 24'hFFF2F2;
            default: block_color <= 24'h0; 
        endcase
    end
//////////////////////////////////////////////////////////
playram ram1 (
  .wr_data(ramdata),    // input [7:0]
  .wr_addr(ramaddr),    // input [16:0]
  .wr_en(wr_en),        // input
  .wr_clk(sys_clk),      // input
  .wr_rst(~rstn),      // input
  .rd_addr(pos),    // input [16:0]
  .rd_data(graph_mem),    // output [7:0]
  .rd_clk(pix_clk),      // input
  .rd_rst(~rstn)       // input
);
endmodule
