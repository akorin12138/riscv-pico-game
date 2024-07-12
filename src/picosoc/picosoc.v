
/*
*  PicoSoC - A simple example SoC using PicoRV32
*
*  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
*
*  Permission to use, copy, modify, and/or distribute this software for any
*  purpose with or without fee is hereby granted, provided that the above
*  copyright notice and this permission notice appear in all copies.
*
*  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
*  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
*  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
*  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
*  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
*  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
*  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*
*/

module picosoc (
    //    input  sys_clk,
    input  resetn,
    //interrupt--随便给几个不要的io，找不到把有关中断的删了也行
    input  irq_5,
    input  irq_6,
    input  irq_7,
    //uart
    output ser_tx,
    input  ser_rx,
    //ps2手柄
    output spi_clk,         //SPI通讯时钟线
    output spi_cs,          //SPI通讯片选信号线
    output spi_mosi,        //SPI通讯写端口
    input  spi_miso,        //SPI通讯读端口
    //test用，流水灯
    output [7:0] led,

    //hdmitest_port
    input  wire       sys_clk,     // input system clock 50MHz    
    output            rstn_out,
    output            iic_tx_scl,
    inout             iic_tx_sda,
    output            led_int,
    //hdmi_out 
    output            pix_clk,     //pixclk                           
    output            vs_out,
    output            hs_out,
    output            de_out,
    output      [7:0] r_out,
    output      [7:0] g_out,
    output      [7:0] b_out,
    //RGB
    output            RZ_data,
    //SOUND
    output      [6:0] sound_out
);
    wire        mem_valid  /* synthesis syn_keep = 1 */;
    wire        mem_instr  /* synthesis syn_keep = 1 */;
    wire        mem_ready  /* synthesis syn_keep = 1 */;
    wire [31:0] mem_addr  /* synthesis syn_keep = 1 */;
    wire [31:0] mem_wdata  /* synthesis syn_keep = 1 */;
    wire [ 3:0] mem_wstrb  /* synthesis syn_keep = 1 */;
    wire [31:0] mem_rdata  /* synthesis syn_keep = 1 */;
    //clk && rst-----------------------------------------------------------------------------
    wire        sys_clk;
    wire        pll_lock;

    //assign sys_clk = sys_clk;
    // Gowin_rPLL u_pll(//80m
    //                .clkin   (sys_clk ),
    //                .lock (pll_lock),
    //                .clkout  (sys_clk)
    //            );

    wire        reset_n0;
    reg         reset_n  /* synthesis syn_maxfan=3 */;
    reg  [ 5:0] reset_cnt = 0;
    wire        resetn0 = &reset_cnt;

    always @(posedge sys_clk) begin
        reset_cnt <= reset_cnt + !resetn0;
    end

    assign reset_n0 = resetn0 && resetn;

    always @(posedge sys_clk) begin
        reset_n <= reset_n0;
    end
    //core------------------------------------------------------------------------------------
    parameter integer MEM_WORDS = 4096;
    parameter [31:0] STACKADDR = (4 * MEM_WORDS);
    parameter [31:0] PROGADDR_RESET = 32'h0000_4000;

    reg [31:0] irq;
    always @* begin
        irq    = 0;
        irq[5] = ~irq_5;
        irq[6] = ~irq_6;
        irq[7] = ~irq_7;
    end

    picorv32 #(
        .STACKADDR(STACKADDR),
        .PROGADDR_RESET(PROGADDR_RESET),
        .PROGADDR_IRQ(32'h0000_0000),
        .BARREL_SHIFTER(1),
        .COMPRESSED_ISA(1),
        .ENABLE_MUL(1),
        .ENABLE_DIV(1),
        .ENABLE_IRQ(1),
        .ENABLE_IRQ_QREGS(0)
    ) cpu (
        .clk      (sys_clk),
        .resetn   (reset_n),
        .mem_valid(mem_valid),
        .mem_instr(mem_instr),
        .mem_ready(mem_ready),
        .mem_addr (mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .mem_rdata(mem_rdata),
        .irq      (irq)
    );
    //cmd-------------------------------------------------------------------------------------
    parameter integer CMD_NUM = 24576;
    parameter [31:0] perp_addr = (4 * CMD_NUM);  //32'h18000
    reg        ram_ready;
    reg [31:0] ram_rdata;
    //0-1023 sram, 1024-8191 cmd
    reg [31:0] memory    [0:CMD_NUM-1]  /* synthesis syn_ramstyle = "block_ram" */;
    initial begin
        $readmemh("D:/Hummingbird/HBird-workspace/pico_test_1/Debug/ram.hex", memory, 4096);
    end

    wire ram_en;
    assign ram_en = mem_valid && !mem_ready && mem_addr < perp_addr;

    always @(posedge sys_clk) begin
        ram_ready <= 0;
        if (ram_en) ram_ready <= 1;
    end

    always @(posedge sys_clk) begin
        if (ram_en) ram_rdata <= memory[mem_addr>>2];
    end

    always @(posedge sys_clk) begin
        if (ram_en) begin
            if (mem_wstrb[0]) memory[mem_addr>>2][7:0] <= mem_wdata[7:0];
            if (mem_wstrb[1]) memory[mem_addr>>2][15:8] <= mem_wdata[15:8];
            if (mem_wstrb[2]) memory[mem_addr>>2][23:16] <= mem_wdata[23:16];
            if (mem_wstrb[3]) memory[mem_addr>>2][31:24] <= mem_wdata[31:24];
        end
    end
    //UART------------------------------------------------------------------------------------
    wire        simpleuart_reg_div_sel = mem_valid && (mem_addr == perp_addr);
    wire [31:0] simpleuart_reg_div_do;

    wire        simpleuart_reg_dat_sel = mem_valid && (mem_addr == (perp_addr + 32'h10))  /* synthesis syn_keep = 1 */;
    wire [31:0] simpleuart_reg_dat_do  /* synthesis syn_keep = 1 */;
    wire        simpleuart_reg_dat_wait;


    simpleuart simpleuart (
        .clk   (sys_clk),
        .resetn(reset_n),

        .ser_tx(ser_tx),
        .ser_rx(ser_rx),

        .reg_div_we(simpleuart_reg_div_sel ? mem_wstrb : 4'b0000),
        .reg_div_di(mem_wdata),
        .reg_div_do(simpleuart_reg_div_do),

        .reg_dat_we  (simpleuart_reg_dat_sel ? mem_wstrb[0] : 1'b0),
        .reg_dat_re  (simpleuart_reg_dat_sel && !mem_wstrb),
        .reg_dat_di  (mem_wdata),
        .reg_dat_do  (simpleuart_reg_dat_do),
        .reg_dat_wait(simpleuart_reg_dat_wait)
    );
    //GPIO-------------------------------------------------------------------------------------
    wire        gpio_out_sel = mem_valid && (mem_addr == (perp_addr + 32'h20));
    wire [31:0] gpio_out_data;

    wire        gpio_in_sel = mem_valid && (mem_addr == (perp_addr + 32'h30));
    wire [31:0] gpio_in_data;

    gpio gpio (
        .clk   (sys_clk),
        .resetn(reset_n),

        .gpio_data    (mem_wdata),
        .gpio_out_we  (gpio_out_sel ? mem_wstrb : 4'b0000),
        .gpio_out_data(gpio_out_data),

        .ex_data     (32'haa55),
        .gpio_in_we  (gpio_in_sel ? 4'b1111 : 4'b0000),  //just 32bit
        .gpio_in_data(gpio_in_data)
    );
    //hdmi_test 设定的地址为8000 0050
    wire        rgb_dat_sel_out = mem_valid && (mem_addr == (perp_addr + 32'h40));
    wire        rgb_dat_sel_in = mem_valid && (mem_addr == (perp_addr + 32'h50));
    wire [23:0] rgb_dat_in;
    wire [23:0] rgb_dat_out;

    wire  [31:0] ram_addr_i;
    wire  [31:0] ram_data_i;
    wire  [31:0] user_block_u_i;
    wire  [31:0] user_block_d_i;
    wire        ram_addr_i_sel = mem_valid && (mem_addr == (perp_addr + 32'h60));
    wire        ram_data_i_sel = mem_valid && (mem_addr == (perp_addr + 32'h70));
    wire        user_block_u_i_sel = mem_valid && (mem_addr == (perp_addr + 32'h80));
    wire        user_block_d_i_sel = mem_valid && (mem_addr == (perp_addr + 32'h90));
    // assign r_out =  rgb_dat[23:16];
    // assign g_out =  rgb_dat[15:8];
    // assign b_out =  rgb_dat[7:0];
    hdmi_test hdmi (
        .sys_clk        (sys_clk),
        .rstn_out       (rstn_out),
        .iic_tx_scl     (iic_tx_scl),
        .iic_tx_sda     (iic_tx_sda),
        .led_int        (led_int),
        .pix_clk        (pix_clk),
        .vs_out         (vs_out),
        .hs_out         (hs_out),
        .de_out         (de_out),

        .mem_wdata      (mem_wdata),
        .rgb_we         (rgb_dat_sel_out ? mem_wstrb : 4'b0000),
        .rgb_dat_out    (rgb_dat_out),

        // .rgb_dat        (rgb_dat_in),

        .r_out                (r_out),
        .g_out                (g_out),
        .b_out                (b_out),

        .ram_sel              (ram_data_i_sel),
        .ram_addr_i_we        (ram_addr_i_sel ? mem_wstrb : 4'b0000),
        .ram_data_i_we        (ram_data_i_sel ? mem_wstrb : 4'b0000),
        .user_block_u_i_we    (user_block_u_i_sel ? mem_wstrb : 4'b0000),
        .user_block_d_i_we    (user_block_d_i_sel ? mem_wstrb : 4'b0000),
        .mem_wstrb            (mem_wstrb),
        .ram_addr_i           (ram_addr_i),
        .ram_data_i           (ram_data_i),
        .user_block_u_i       (user_block_u_i),
        .user_block_d_i       (user_block_d_i)
    );
    //ps2
     wire        ps2ctrl_sel = mem_valid && (mem_addr == (perp_addr + 32'h100));
     wire  [9:0] ps2ctrl;
     wire  [9:0] ps2dat;
     wire  spiclk;//OUT
     wire  cs;//OUT
     wire  cmd;//OUT
     wire   led1;
     wire   led2;
     wire   led3;
     wire   led4;
     wire   led5;
     wire   led6;
     wire   led7;
     wire   led8;
     wire  [7:0] ledout;
    spi_control spi_inst(
        .clk             (sys_clk),
        .rstn            (resetn),
        .spi_clk         (spiclk),//clk
        .spi_cs          (cs),//cs
        .spi_mosi        (cmd),//cmd
        .spi_miso        (spi_miso),//dat
        .led1            (led1),
        .led2            (led2),
        .led3            (led3),
        .led4            (led4),
        .led5            (led5),
        .led6            (led6),
        .led7            (led7),
        .led8            (led8),
        .ledout          (),
        .ctrl            ()
    );
    assign spi_clk = spiclk;
    assign spi_cs = cs;
    assign spi_mosi = cmd;
    // assign spi_miso = dat;
    //  assign ps2ctrl = ledout;
    //-----------------------------RGB-------------------------------------------------------------
    wire rgbdata_sel =  mem_valid && (mem_addr == (perp_addr + 32'h110));
    reg [2:0] MODE =0;
    reg [1:0] SPEED=1;
    reg [1:0] LIGHT = 0;
    wire [7:0] rgbdata;
    assign rgbdata = (rgbdata_sel & (mem_wstrb[0])) ? mem_wdata[7:0] : rgbdata;
    always @(posedge sys_clk) begin
        MODE    <= rgbdata[2:0];
        SPEED   <= rgbdata[4:3];
        LIGHT   <= rgbdata[6:5];
    end
    TOP  RGB_inst(
            .clk     (sys_clk   ),
            .rst_n   (rstn_out ),
            .MODE    (MODE  ),
            .SPEED   (SPEED ),
            .LIGHT   (LIGHT ),
            .RZ_data    (RZ_data)
    );
    //------------------------------SOUND----------------------------------------------------------
    wire [6:0] sound;
    wire sound_sel =  mem_valid && (mem_addr == (perp_addr + 32'h120));
    assign sound = (sound_sel & (mem_wstrb[0])) ? mem_wdata[6:0] : sound;
    assign sound_out[6:0] = sound[6:0];
    //---------------------------------------------------------------------------------------------
    assign ps2ctrl = {led2,led1,led4,led3,led5,led6,led7,led8};
    //BUS Control Signal---------------------------------------------------------------------------
    assign mem_ready = ram_ready || sound_sel || rgbdata_sel || ps2ctrl_sel || ram_addr_i_sel || ram_data_i_sel ||
     user_block_u_i_sel || user_block_d_i_sel || rgb_dat_sel_out || rgb_dat_sel_in ||
      simpleuart_reg_div_sel || (simpleuart_reg_dat_sel && !simpleuart_reg_dat_wait) || gpio_out_sel || gpio_in_sel;

    assign mem_rdata = ram_ready ? ram_rdata : ram_addr_i_sel ? ram_addr_i : ram_data_i_sel ? ram_data_i :
     rgbdata_sel ? rgbdata : sound_sel ? sound : user_block_u_i_sel ? user_block_u_i : user_block_d_i_sel ? user_block_d_i :
      ps2ctrl_sel? ps2ctrl : rgb_dat_sel_out ? rgb_dat_out : rgb_dat_sel_in ? rgb_dat_in :
       simpleuart_reg_div_sel ? simpleuart_reg_div_do : simpleuart_reg_dat_sel ? simpleuart_reg_dat_do :
        gpio_out_sel ? gpio_out_data : gpio_in_sel ? gpio_in_data : 32'h0000_0000;

    //assign led       = (gpio_out_sel) ? gpio_out_data[7:0] : led;
    // assign led       = (rstn_out) ? 8'b1010_1010 : 8'b0 ;
assign led[0] = led1;
assign led[1] = led2;
assign led[2] = led3;
assign led[3] = led4;
assign led[4] = led5;
assign led[5] = led6;
assign led[6] = led7;
assign led[7] = led8;
// assign led = ledout;
endmodule


