`timescale 1ns / 1ps
module spi_control(
    input clk,              //板载50Mhz时钟信号
    input rstn,
    output [7:0] ledout,       //板上八个LED灯亮，指示正常工作状态以及第四个接收到byte
    output spi_clk,         //SPI通讯时钟线
    output spi_cs,          //SPI通讯片选信号线
    output spi_mosi,        //SPI通讯写端口
    input spi_miso,         //SPI通讯读端口


    output led1,
    output led2,
    output led3,
    output led4,
    output led5,
    output led6,
    output led7,
    output led8,
    output [9:0] ctrl
    );

reg [7:0] data_out; 
reg [7:0] data_in1;    //接收到的数据，八位的字节
reg [7:0] data_in2;
reg [7:0] data_in3;
reg [7:0] data_in4;
reg [7:0] data_in5;
reg [7:0] data_in6;
reg sclk=1;          //SPI通讯时钟线  
reg smosi=1;           //SPI通讯写
reg smiso=0;           //SPI通讯读
reg scs;                //SPI通讯片选信号
reg [9:0] cnt_clk_6us=0;
reg clk_6us=1;
reg [15:0] cnt_1020us=0;
reg clk_1020us=0;
reg [7:0] led_set=0;
reg trig=1;
reg [3:0] count_for_trig=0;
reg [7:0] count_trig=0;


// ps2pll u_pll (
//   .clkin1(clk),        // input
//   .pll_lock(),    // output
//   .clkout0(clki)       // output
// );
assign clki = clk;
//定义两个时钟，周期分别为6us和1020us
always @(posedge clki)
begin
        if(cnt_clk_6us == 10'b00_1001_0110-1) begin     //产生6us信号
            cnt_clk_6us <= 0;
            clk_6us <= ~clk_6us;   //按位取反
        end
        else
            cnt_clk_6us <= cnt_clk_6us + 1;


            if(cnt_1020us == 16'b0110_0011_1001_1100-1) begin    //周期1020us
            cnt_1020us <= 0;
            clk_1020us <= ~clk_1020us;  
        end
        else
            cnt_1020us <= cnt_1020us + 1;


end


//每10ms读取一次数据，定义一个reg trig作为一个中间变量，比CS信号提前6us，波形完全一样
always @( posedge clk_1020us)
begin
led_set<=data_in1;
count_for_trig<=count_for_trig+1;
    if (count_for_trig==4'b0001)
    trig<=0;
    else if (count_for_trig==4'b0010)
    trig<=1;
    else    if (count_for_trig==4'b1010)
    count_for_trig<=4'b0000;
end


//   控制信号
reg [1:0] left_y ;
reg [1:0] left_x ;
reg [1:0] L1     ;
reg [1:0] R1     ;
reg [1:0] R2     ;
reg [1:0] L2     ;
reg [1:0] Right_down ;
reg [1:0] Right_up ;
reg [1:0] Right_left ;
reg [1:0] Right_right ;


always @(posedge scs)    //每10ms跟新一次PWM输出和电机驱动状态
begin

 left_y <= 0;
 left_x <= 0; 
 L1     <= 0;
 R1     <= 0;
 R2     <= 0;
 L2     <= 0;
 Right_down <= 0;
 Right_up <= 0;
 Right_left <= 0;
 Right_right <= 0;


    if (data_in1[4]==0)    //control pwm1           //UP
    left_y <= 2'd 2;//0000 0010
    else if(data_in1[6]==0)                          //DOWN
    left_y <= 2'd 1;
    else 
    left_y <= 0;

    if (data_in1[7]==0)    //control pwm2              //LEFT
    left_x <= 2'd 2;
    else if(data_in1[5]==0)                             //
    left_x <= 2'd 1;
    else 
    left_x <= 0;

    if (data_in2[2]==0)    //control pwm3  1.48ms控制360度舵机     //L1
    L1 <= 1 ;
    if(data_in2[3]==0)                                        //R1
    R1 <= 1;

    if (data_in2[6]==0)    //control pwm4                          //X
    Right_down <= 1;
    if(data_in2[4]==0)                                         //∆
    Right_up <= 1;

    if (data_in2[0]==0)        //control pwm5                      //L2
    L2 <= 1;
    if(data_in2[1]==0)                                         //R2
    R2 <= 1;

    if (data_in2[7]==0)        //control pwm6                      //□
    Right_left <= 1;
    if(data_in2[5]==0)
    Right_right <= 1;                                                      //○


/*if((data_in4>126)&(data_in4<132)) 
 begin
    left_y <=0 ;
 end
 else if ((data_in4<127)|(data_in4>132))      //检测左摇杆Y方向是否拨动                       
    begin
        if (data_in4<123)  //前进
            begin
            left_y <=2 ; 
            end
           else if(data_in4>132) //后退
                    begin
                    left_y <=1 ;
                    end
    end


if((data_in3>126)&(data_in3<132)) 
 begin
    left_x <=0 ;
 end
 else if ((data_in3<127)|(data_in3>132))      //检测左摇杆X方向是否拨动                       
    begin
        if (data_in3<123)  //前进
            begin
            left_x <=2 ; 
            end
           else if(data_in3>132) //后退
                    begin
                    left_x <=1 ;
                    end
    end



*/
end





always @(negedge clk_6us)
begin
    if (trig==0)
    begin
    scs<=0;
    count_trig<=count_trig+1;
    //spi_clk波形产生
            if ((0<count_trig)&(count_trig<17))   //byte1
            sclk<=~sclk;
            else if ((19<count_trig)&(count_trig<36))  //byte2
            sclk<=~sclk;
            else if ((38<count_trig)&(count_trig<55))  //byte3
            sclk<=~sclk;
            else if ((57<count_trig)&(count_trig<74))  //byte4
            sclk<=~sclk;
            else if ((76<count_trig)&(count_trig<93))  //byte5
            sclk<=~sclk;
            else if ((95<count_trig)&(count_trig<112))  //byte6
            sclk<=~sclk;
            else if ((114<count_trig)&(count_trig<131))  //byte7
            sclk<=~sclk;
            else if ((133<count_trig)&(count_trig<150))  //byte8
            sclk<=~sclk;
            else if ((152<count_trig)&(count_trig<169))  //byte9
            sclk<=~sclk;

    ///mosi波形产生///
    if (count_trig<2)
        smosi<=1;
    else if ((20<count_trig)&(count_trig<23))
        smosi<=1;
    else if ((30<count_trig)&(count_trig<33))
        smosi<=1;
    else 
        smosi<=0;


    //读取miso



        if (count_trig==58)    //读byte4
        data_in1[0]<=spi_miso;
    else if (count_trig==60)
        data_in1[1]<=spi_miso;
    else if (count_trig==62)
        data_in1[2]<=spi_miso;
    else if (count_trig==64)
        data_in1[3]<=spi_miso;
    else if (count_trig==66)
        data_in1[4]<=spi_miso;
    else if (count_trig==68)
        data_in1[5]<=spi_miso;
    else if (count_trig==70)
        data_in1[6]<=spi_miso;
    else if (count_trig==72)
        data_in1[7]<=spi_miso;  


    if (count_trig==77)    //读byte5
        data_in2[0]<=spi_miso;
    else if (count_trig==79)
        data_in2[1]<=spi_miso;
    else if (count_trig==81)
        data_in2[2]<=spi_miso;
    else if (count_trig==83)
        data_in2[3]<=spi_miso;
    else if (count_trig==85)
        data_in2[4]<=spi_miso;
    else if (count_trig==87)
        data_in2[5]<=spi_miso;
    else if (count_trig==89)
        data_in2[6]<=spi_miso;
    else if (count_trig==91)
        data_in2[7]<=spi_miso;  

    if (count_trig==96)    //读byte6
        data_in3[0]<=spi_miso;
    else if (count_trig==98)
        data_in3[1]<=spi_miso;
    else if (count_trig==100)
        data_in3[2]<=spi_miso;
    else if (count_trig==102)
        data_in3[3]<=spi_miso;
    else if (count_trig==104)
        data_in3[4]<=spi_miso;
    else if (count_trig==106)
        data_in3[5]<=spi_miso;
    else if (count_trig==108)
        data_in3[6]<=spi_miso;
    else if (count_trig==110)
        data_in3[7]<=spi_miso;  

        if (count_trig==115)    //读byte7
        data_in4[0]<=spi_miso;
    else if (count_trig==117)
        data_in4[1]<=spi_miso;
    else if (count_trig==119)
        data_in4[2]<=spi_miso;
    else if (count_trig==121)
        data_in4[3]<=spi_miso;
    else if (count_trig==123)
        data_in4[4]<=spi_miso;
    else if (count_trig==125)
        data_in4[5]<=spi_miso;
    else if (count_trig==127)
        data_in4[6]<=spi_miso;
    else if (count_trig==129)
        data_in4[7]<=spi_miso;

                if (count_trig==134)    //读byte8
        data_in5[0]<=spi_miso;
    else if (count_trig==136)
        data_in5[1]<=spi_miso;
    else if (count_trig==138)
        data_in5[2]<=spi_miso;
    else if (count_trig==140)
        data_in5[3]<=spi_miso;
    else if (count_trig==142)
        data_in5[4]<=spi_miso;
    else if (count_trig==144)
        data_in5[5]<=spi_miso;
    else if (count_trig==146)
        data_in5[6]<=spi_miso;
    else if (count_trig==148)
        data_in5[7]<=spi_miso;


    if (count_trig==153)    //读byte9
        data_in6[0]<=spi_miso;
    else if (count_trig==155)
        data_in6[1]<=spi_miso;
    else if (count_trig==157)
        data_in6[2]<=spi_miso;
    else if (count_trig==159)
        data_in6[3]<=spi_miso;
    else if (count_trig==161)
        data_in6[4]<=spi_miso;
    else if (count_trig==163)
        data_in6[5]<=spi_miso;
    else if (count_trig==165)
        data_in6[6]<=spi_miso;
    else if (count_trig==167)
        data_in6[7]<=spi_miso;  
    end

    else if(trig==1)
        begin
        scs<=1;
        sclk<=1;
        count_trig<=0;
        end


end


assign led1 = (left_x == 2'd 2);
assign led2 = (left_x == 2'd 1);
assign led3 = (left_y == 2'd 2);
assign led4 = (left_y == 2'd 1);
assign led5 = (Right_down == 1);
assign led6 = (Right_left == 1);
assign led7 = (Right_right == 1);
assign led8 = (Right_up == 1);




assign ledout = led_set;
assign spi_clk=sclk;
assign spi_cs=scs;
assign spi_mosi=smosi;

assign ctrl={left_y,left_x,Right_down,Right_up,Right_left,Right_right,L1,R1,L2,R2};

endmodule
