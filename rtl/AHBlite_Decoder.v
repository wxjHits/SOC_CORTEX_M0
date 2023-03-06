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

//
//0X40000000
assign P2_HSEL = (HADDR[31:16] == 16'h4000) ? Port2_en : 1'd0;
/***********************************/

//
assign P3_HSEL = 0;
/***********************************/

//
assign P4_HSEL = 0;
/***********************************/

endmodule