module AHBlite_Decoder
#(
    /*RAMCODE enable parameter*/
    parameter Port0_en = 1,
    /************************/

    /*RAMDATA enable parameter*/
    parameter Port1_en = 1,
    /************************/

    /*WaterLight enable parameter*/
    parameter Port2_en = 1,
    /************************/

    /*UART enable parameter*/
    parameter Port3_en=1,
    /************************/

    /*GPIO enable parameter*/
    parameter Port4_en=1
    /************************/

    
)(
    input [31:0] HADDR,

    /*RAMCODE OUTPUT SELECTION SIGNAL*/
    output wire P0_HSEL,

    /*WaterLight OUTPUT SELECTION SIGNAL*/
    output wire P1_HSEL,

    /*RAMDATA OUTPUT SELECTION SIGNAL*/
    output wire P2_HSEL,

    /*UART OUTPUT SELECTION SIGNAL*/
    output wire P3_HSEL,       

    /*UART OUTPUT SELECTION SIGNAL*/
    output wire P4_HSEL  
);

//RAMCODE-----------------------------------

//0x00000000-0x0000ffff
/*Insert RAMCODE decoder code there*/
assign P0_HSEL = (HADDR[31:16] == 16'h0000) ? Port0_en : 1'd0;
/***********************************/

//RAMDATA-----------------------------
//0X20000000-0X2000FFFF
/*Insert RAMDATA decoder code there*/
assign P1_HSEL = (HADDR[31:16] == 16'h2000) ? Port1_en : 1'b0;
/***********************************/

//AHB_TO_APB_BRIDGE-----------------------------
//0X40000000
/*Insert WaterLight decoder code there*/
assign P2_HSEL = (HADDR[31:16] == 16'h4000) ? Port2_en : 1'd0;
/***********************************/

//0X40010000 CAMERA
//0X40010000-0X4004FFFF CAMERA-Cache
//0X40050000 CAMERA-Config
/*Insert UART decoder code there*/
assign P3_HSEL = (  HADDR[31:16] == 16'h4001||
                    HADDR[31:16] == 16'h4002||
                    HADDR[31:16] == 16'h4003||
                    HADDR[31:16] == 16'h4004||
                    HADDR[31:16] == 16'h4005) ? Port3_en : 1'd0;
/***********************************/

//0x50000000 LCD
assign P4_HSEL = (HADDR[31:16] == 16'h5000) ? Port4_en : 1'd0;
/***********************************/

endmodule