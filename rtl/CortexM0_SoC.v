/****************************/
//作者:Wei Xuejing
//邮箱:2682152871@qq.com
//描述:SoC-design based on kernel--Cortex_M0
//时间:create 2022.09.20
/****************************/

module CortexM0_SoC (
        input	wire        clk         ,
        input	wire        RSTn        ,
        inout	wire        SWDIO       ,
        input	wire        SWCLK       ,

        // UART
        output  wire        TXD         ,
        input   wire        RXD         ,
        //KEYBOARD
        input   wire [3:0]  col         ,
        output  wire [3:0]  row         ,
        //LED
        output	wire [7:0]  OUTLED      ,
        //SPI
        output  wire        SPI_CLK     ,
        output  wire        SPI_CS      ,
        output  wire        SPI_MOSI    ,
        input   wire        SPI_MISO    ,
        //LCD
        output  wire        LCD_CS      ,
        output  wire        LCD_RS      ,
        output  wire        LCD_WR      ,
        output  wire        LCD_RD      ,
        output  wire        LCD_RST     ,
        output  wire        LCD_BL_CTR  ,
        output  wire [15:0] LCD_DATA    ,

        // CAMERA
        output  wire        CAMERA_PWDN ,
        output  wire        CAMERA_RST  ,
        output  wire        CAMERA_SCL  ,
        inout   wire        CAMERA_SDA  ,
        input   wire        CAMERA_PCLK ,
        input   wire        CAMERA_VSYNC,
        input   wire        CAMERA_HREF ,
        input   wire [7:0]  CAMERA_DATA

    );

    //------------------------------------------------------------------------------
    // DEBUG IOBUF
    //------------------------------------------------------------------------------
    wire oData_;

    wire SWDO;
    wire SWDOEN;
    wire SWDI;

    assign SWDI = SWDIO;
    assign SWDIO = (SWDOEN) ?  SWDO : 1'bz;

    //------------------------------------------------------------------------------
    // Interrupt
    //------------------------------------------------------------------------------
    wire            TXINT;
    wire            RXINT;
    wire            TXOVRINT;
    wire            RXOVRINT;
    wire            UARTINT;

    wire [3:0]GPIOINT;
    wire TIMERINT;

    wire [31:0] IRQ;
    assign IRQ = {24'b0,TIMERINT,GPIOINT,RXOVRINT,RXINT,TXINT};

    wire RXEV;
    assign RXEV = 1'b0;

    //------------------------------------------------------------------------------
    // AHB
    //------------------------------------------------------------------------------

    wire [31:0] HADDR;
    wire [ 2:0] HBURST;
    wire        HMASTLOCK;
    wire [ 3:0] HPROT;
    wire [ 2:0] HSIZE;
    wire [ 1:0] HTRANS;
    wire [31:0] HWDATA;
    wire        HWRITE;
    wire [31:0] HRDATA;
    wire        HRESP;
    wire        HMASTER;
    wire        HREADY;

    //------------------------------------------------------------------------------
    // RESET AND DEBUG
    //------------------------------------------------------------------------------

    wire SYSRESETREQ;
    reg cpuresetn;

    always @(posedge clk or negedge RSTn) begin
        if (~RSTn)
            cpuresetn <= 1'b0;
        else if (SYSRESETREQ)
            cpuresetn <= 1'b0;
        else
            cpuresetn <= 1'b1;
    end

    wire CDBGPWRUPREQ;
    reg CDBGPWRUPACK;

    always @(posedge clk or negedge RSTn) begin
        if (~RSTn)
            CDBGPWRUPACK <= 1'b0;
        else
            CDBGPWRUPACK <= CDBGPWRUPREQ;
    end


    //------------------------------------------------------------------------------
    // Instantiate Cortex-M0 processor logic level
    //------------------------------------------------------------------------------

    cortexm0ds_logic u_logic (

                         // System inputs
                         .FCLK           (clk),           //FREE running clock
                         .SCLK           (clk),           //system clock
                         .HCLK           (clk),           //AHB clock
                         .DCLK           (clk),           //Debug clock
                         .PORESETn       (RSTn),          //Power on reset
                         .HRESETn        (cpuresetn),     //AHB and System reset
                         .DBGRESETn      (RSTn),          //Debug Reset
                         .RSTBYPASS      (1'b0),          //Reset bypass
                         .SE             (1'b0),          // dummy scan enable port for synthesis

                         // Power management inputs
                         .SLEEPHOLDREQn  (1'b1),          // Sleep extension request from PMU
                         .WICENREQ       (1'b0),          // WIC enable request from PMU
                         .CDBGPWRUPACK   (CDBGPWRUPACK),  // Debug Power Up ACK from PMU

                         // Power management outputs
                         .CDBGPWRUPREQ   (CDBGPWRUPREQ),
                         .SYSRESETREQ    (SYSRESETREQ),

                         // System bus
                         .HADDR          (HADDR[31:0]),
                         .HTRANS         (HTRANS[1:0]),
                         .HSIZE          (HSIZE[2:0]),
                         .HBURST         (HBURST[2:0]),
                         .HPROT          (HPROT[3:0]),
                         .HMASTER        (HMASTER),
                         .HMASTLOCK      (HMASTLOCK),
                         .HWRITE         (HWRITE),
                         .HWDATA         (HWDATA[31:0]),
                         .HRDATA         (HRDATA[31:0]),
                         .HREADY         (HREADY),
                         .HRESP          (HRESP),

                         // Interrupts
                         .IRQ            (IRQ),          //Interrupt
                         .NMI            (1'b0),         //Watch dog interrupt
                         .IRQLATENCY     (8'h0),
                         .ECOREVNUM      (28'h0),

                         // Systick
                         .STCLKEN        (1'b0),
                         .STCALIB        (26'h0),

                         // Debug - JTAG or Serial wire
                         // Inputs
                         .nTRST          (1'b1),
                         .SWDITMS        (SWDI),
                         .SWCLKTCK       (SWCLK),
                         .TDI            (1'b0),
                         // Outputs
                         .SWDO           (SWDO),
                         .SWDOEN         (SWDOEN),

                         .DBGRESTART     (1'b0),

                         // Event communication
                         .RXEV           (RXEV),         // Generate event when a DMA operation completed.
                         .EDBGRQ         (1'b0)          // multi-core synchronous halt request
                     );

    //------------------------------------------------------------------------------
    // AHBlite Interconncet
    //------------------------------------------------------------------------------

    wire            HSEL_P0;
    wire    [31:0]  HADDR_P0;
    wire    [2:0]   HBURST_P0;
    wire            HMASTLOCK_P0;
    wire    [3:0]   HPROT_P0;
    wire    [2:0]   HSIZE_P0;
    wire    [1:0]   HTRANS_P0;
    wire    [31:0]  HWDATA_P0;
    wire            HWRITE_P0;
    wire            HREADY_P0;
    wire            HREADYOUT_P0;
    wire    [31:0]  HRDATA_P0;
    wire            HRESP_P0;

    wire            HSEL_P1;
    wire    [31:0]  HADDR_P1;
    wire    [2:0]   HBURST_P1;
    wire            HMASTLOCK_P1;
    wire    [3:0]   HPROT_P1;
    wire    [2:0]   HSIZE_P1;
    wire    [1:0]   HTRANS_P1;
    wire    [31:0]  HWDATA_P1;
    wire            HWRITE_P1;
    wire            HREADY_P1;
    wire            HREADYOUT_P1;
    wire    [31:0]  HRDATA_P1;
    wire            HRESP_P1;

    wire            HSEL_P2;
    wire    [31:0]  HADDR_P2;
    wire    [2:0]   HBURST_P2;
    wire            HMASTLOCK_P2;
    wire    [3:0]   HPROT_P2;
    wire    [2:0]   HSIZE_P2;
    wire    [1:0]   HTRANS_P2;
    wire    [31:0]  HWDATA_P2;
    wire            HWRITE_P2;
    wire            HREADY_P2;
    wire            HREADYOUT_P2;
    wire    [31:0]  HRDATA_P2;
    wire            HRESP_P2;

    wire            HSEL_P3;
    wire    [31:0]  HADDR_P3;
    wire    [2:0]   HBURST_P3;
    wire            HMASTLOCK_P3;
    wire    [3:0]   HPROT_P3;
    wire    [2:0]   HSIZE_P3;
    wire    [1:0]   HTRANS_P3;
    wire    [31:0]  HWDATA_P3;
    wire            HWRITE_P3;
    wire            HREADY_P3;
    wire            HREADYOUT_P3;
    wire    [31:0]  HRDATA_P3;
    wire            HRESP_P3;

    wire            HSEL_P4;
    wire    [31:0]  HADDR_P4;
    wire    [2:0]   HBURST_P4;
    wire            HMASTLOCK_P4;
    wire    [3:0]   HPROT_P4;
    wire    [2:0]   HSIZE_P4;
    wire    [1:0]   HTRANS_P4;
    wire    [31:0]  HWDATA_P4;
    wire            HWRITE_P4;
    wire            HREADY_P4;
    wire            HREADYOUT_P4;
    wire    [31:0]  HRDATA_P4;
    wire            HRESP_P4;

    AHBlite_Interconnect Interconncet(
                             .HCLK           (clk),
                             .HRESETn        (cpuresetn),

                             // CORE SIDE
                             .HADDR          (HADDR),
                             .HTRANS         (HTRANS),
                             .HSIZE          (HSIZE),
                             .HBURST         (HBURST),
                             .HPROT          (HPROT),
                             .HMASTLOCK      (HMASTLOCK),
                             .HWRITE         (HWRITE),
                             .HWDATA         (HWDATA),
                             .HRDATA         (HRDATA),
                             .HREADY         (HREADY),
                             .HRESP          (HRESP),

                             // P0
                             .HSEL_P0        (HSEL_P0),
                             .HADDR_P0       (HADDR_P0),
                             .HBURST_P0      (HBURST_P0),
                             .HMASTLOCK_P0   (HMASTLOCK_P0),
                             .HPROT_P0       (HPROT_P0),
                             .HSIZE_P0       (HSIZE_P0),
                             .HTRANS_P0      (HTRANS_P0),
                             .HWDATA_P0      (HWDATA_P0),
                             .HWRITE_P0      (HWRITE_P0),
                             .HREADY_P0      (HREADY_P0),
                             .HREADYOUT_P0   (HREADYOUT_P0),
                             .HRDATA_P0      (HRDATA_P0),
                             .HRESP_P0       (HRESP_P0),

                             // P1
                             .HSEL_P1        (HSEL_P1),
                             .HADDR_P1       (HADDR_P1),
                             .HBURST_P1      (HBURST_P1),
                             .HMASTLOCK_P1   (HMASTLOCK_P1),
                             .HPROT_P1       (HPROT_P1),
                             .HSIZE_P1       (HSIZE_P1),
                             .HTRANS_P1      (HTRANS_P1),
                             .HWDATA_P1      (HWDATA_P1),
                             .HWRITE_P1      (HWRITE_P1),
                             .HREADY_P1      (HREADY_P1),
                             .HREADYOUT_P1   (HREADYOUT_P1),
                             .HRDATA_P1      (HRDATA_P1),
                             .HRESP_P1       (HRESP_P1),

                             // P2
                             .HSEL_P2        (HSEL_P2),
                             .HADDR_P2       (HADDR_P2),
                             .HBURST_P2      (HBURST_P2),
                             .HMASTLOCK_P2   (HMASTLOCK_P2),
                             .HPROT_P2       (HPROT_P2),
                             .HSIZE_P2       (HSIZE_P2),
                             .HTRANS_P2      (HTRANS_P2),
                             .HWDATA_P2      (HWDATA_P2),
                             .HWRITE_P2      (HWRITE_P2),
                             .HREADY_P2      (HREADY_P2),
                             .HREADYOUT_P2   (HREADYOUT_P2),
                             .HRDATA_P2      (HRDATA_P2),
                             .HRESP_P2       (HRESP_P2),

                             // P3
                             .HSEL_P3        (HSEL_P3),
                             .HADDR_P3       (HADDR_P3),
                             .HBURST_P3      (HBURST_P3),
                             .HMASTLOCK_P3   (HMASTLOCK_P3),
                             .HPROT_P3       (HPROT_P3),
                             .HSIZE_P3       (HSIZE_P3),
                             .HTRANS_P3      (HTRANS_P3),
                             .HWDATA_P3      (HWDATA_P3),
                             .HWRITE_P3      (HWRITE_P3),
                             .HREADY_P3      (HREADY_P3),
                             .HREADYOUT_P3   (HREADYOUT_P3),
                             .HRDATA_P3      (HRDATA_P3),
                             .HRESP_P3       (HRESP_P3),

                             // P4
                             .HSEL_P4        (HSEL_P4),
                             .HADDR_P4       (HADDR_P4),
                             .HBURST_P4      (HBURST_P4),
                             .HMASTLOCK_P4   (HMASTLOCK_P4),
                             .HPROT_P4       (HPROT_P4),
                             .HSIZE_P4       (HSIZE_P4),
                             .HTRANS_P4      (HTRANS_P4),
                             .HWDATA_P4      (HWDATA_P4),
                             .HWRITE_P4      (HWRITE_P4),
                             .HREADY_P4      (HREADY_P4),
                             .HREADYOUT_P4   (HREADYOUT_P4),
                             .HRDATA_P4      (HRDATA_P4),
                             .HRESP_P4       (HRESP_P4)
                         );

    //------------------------------------------------------------------------------
    // AHB RAMCODE
    //------------------------------------------------------------------------------

    wire [31:0] RAMCODE_RDATA,RAMCODE_WDATA;
    wire [11:0] RAMCODE_WADDR;
    wire [11:0] RAMCODE_RADDR;
    wire [3:0]  RAMCODE_WRITE;

    AHBlite_Block_RAM RAMCODE_Interface(
                          /* Connect to Interconnect Port 0 */
                          .HCLK           (clk),
                          .HRESETn        (cpuresetn),
                          .HSEL           (HSEL_P0),
                          .HADDR          (HADDR_P0),
                          .HPROT          (HPROT_P0),
                          .HSIZE          (HSIZE_P0),
                          .HTRANS         (HTRANS_P0),
                          .HWDATA         (HWDATA_P0),
                          .HWRITE         (HWRITE_P0),
                          .HRDATA         (HRDATA_P0),
                          .HREADY         (HREADY_P0),
                          .HREADYOUT      (HREADYOUT_P0),
                          .HRESP          (HRESP_P0),
                          .BRAM_WRADDR    (RAMCODE_WADDR),
                          .BRAM_RDADDR    (RAMCODE_RADDR),
                          .BRAM_RDATA     (RAMCODE_RDATA),
                          .BRAM_WDATA     (RAMCODE_WDATA),
                          .BRAM_WRITE     (RAMCODE_WRITE)
                          /**********************************/
                      );

    //---------------------
    // AHB RAMDATA
    //------------------------------------------------------------------------------

    wire [31:0] RAMDATA_RDATA;
    wire [31:0] RAMDATA_WDATA;
    wire [11:0] RAMDATA_WADDR;
    wire [11:0] RAMDATA_RADDR;
    wire [3:0]  RAMDATA_WRITE;

    AHBlite_Block_RAM RAMDATA_Interface(
                          /* Connect to Interconnect Port 1 */
                          .HCLK		(clk),
                          .HRESETn	(cpuresetn),
                          .HSEL		(HSEL_P1/*Port 1*/),
                          .HADDR		(HADDR_P1/*Port 1*/),
                          .HPROT		(HPROT_P1/*Port 1*/),
                          .HSIZE		(HSIZE_P1/*Port 1*/),
                          .HTRANS		(HTRANS_P1/*Port 1*/),
                          .HWDATA		(HWDATA_P1/*Port 1*/),
                          .HWRITE		(HWRITE_P1/*Port 1*/),
                          .HRDATA		(HRDATA_P1/*Port 1*/),
                          .HREADY		(HREADY_P1/*Port 1*/),
                          .HREADYOUT	(HREADYOUT_P1/*Port 1*/),
                          .HRESP		(HRESP_P1/*Port 1*/),
                          .BRAM_WRADDR    (RAMDATA_WADDR),
                          .BRAM_RDADDR    (RAMDATA_RADDR),
                          .BRAM_WDATA     (RAMDATA_WDATA),
                          .BRAM_RDATA     (RAMDATA_RDATA),
                          .BRAM_WRITE     (RAMDATA_WRITE)

                          /**********************************/
                      );

    //------------------------------------------------------------------------------
    // RAM
    //------------------------------------------------------------------------------

    Block_RAM RAM_CODE(
                  .clka           (clk),
                  .addra          (RAMCODE_WADDR),
                  .addrb          (RAMCODE_RADDR),
                  .dina           (RAMCODE_WDATA),
                  .doutb          (RAMCODE_RDATA),
                  .wea            (RAMCODE_WRITE)
              );

    Block_RAM RAM_DATA(
                  .clka           (clk),
                  .addra          (RAMDATA_WADDR),
                  .addrb          (RAMDATA_RADDR),
                  .dina           (RAMDATA_WDATA),
                  .doutb          (RAMDATA_RDATA),
                  .wea            (RAMDATA_WRITE)
              );

    wire    [15:0]  PADDR;
    wire            PENABLE;
    wire            PWRITE;
    wire    [3:0]   PSTRB;
    wire    [2:0]   PPROT;
    wire    [31:0]  PWDATA;
    wire            PSEL;
    wire            APBACTIVE;
    wire    [31:0]  PRDATA;
    wire            PREADY;
    wire            PSLVERR;

    cmsdk_ahb_to_apb #(
                         .ADDRWIDTH                          (16),
                         .REGISTER_RDATA                     (1),
                         .REGISTER_WDATA                     (1)
                     )    ApbBridge  (
                         .HCLK                               (clk),
                         .HRESETn                            (cpuresetn),
                         .PCLKEN                             (1'b1),
                         .HSEL                               (HSEL_P2),
                         .HADDR                              (HADDR_P2),
                         .HTRANS                             (HTRANS_P2),
                         .HSIZE                              (HSIZE_P2),
                         .HPROT                              (HPROT_P2),
                         .HWRITE                             (HWRITE_P2),
                         .HREADY                             (HREADY_P2),
                         .HWDATA                             (HWDATA_P2),
                         .HREADYOUT                          (HREADYOUT_P2),
                         .HRDATA                             (HRDATA_P2),
                         .HRESP                              (HRESP_P2),
                         .PADDR                              (PADDR),
                         .PENABLE                            (PENABLE),
                         .PWRITE                             (PWRITE),
                         .PSTRB                              (PSTRB),
                         .PPROT                              (PPROT),
                         .PWDATA                             (PWDATA),
                         .PSEL                               (PSEL),
                         .APBACTIVE                          (APBACTIVE),
                         .PRDATA                             (PRDATA),
                         .PREADY                             (PREADY),
                         .PSLVERR                            (PSLVERR)
                     );

    //uart 0x40000000
    wire            PSEL_APBP0;
    wire            PREADY_APBP0;
    wire    [31:0]  PRDATA_APBP0;
    wire            PSLVERR_APBP0;
    //led 0x40001000
    wire            PSEL_APBP1;
    wire            PREADY_APBP1;
    wire    [31:0]  PRDATA_APBP1;
    wire            PSLVERR_APBP1;
    //key 0x40002000
    wire            PSEL_APBP2;
    wire            PREADY_APBP2;
    wire    [31:0]  PRDATA_APBP2;
    wire            PSLVERR_APBP2;
    //7_SEG 0x40003000
    wire            PSEL_APBP3;
    wire            PREADY_APBP3;
    wire    [31:0]  PRDATA_APBP3;
    wire            PSLVERR_APBP3;

    //SPI
    wire            PSEL_APBP4;
    wire            PREADY_APBP4;
    wire    [31:0]  PRDATA_APBP4;
    wire            PSLVERR_APBP4;

    //TIMER
    wire            PSEL_APBP5;
    wire            PREADY_APBP5;
    wire    [31:0]  PRDATA_APBP5;
    wire            PSLVERR_APBP5;

    wire            PSEL_APBP6;
    wire            PREADY_APBP6;
    wire    [31:0]  PRDATA_APBP6;
    wire            PSLVERR_APBP6;

    //PWM_DAC
    wire            PSEL_APBP7;
    wire            PREADY_APBP7;
    wire    [31:0]  PRDATA_APBP7;
    wire            PSLVERR_APBP7;

    cmsdk_apb_slave_mux #(
                            .PORT0_ENABLE                       (1),
                            .PORT1_ENABLE                       (1),
                            .PORT2_ENABLE                       (1),
                            .PORT3_ENABLE                       (1),
                            .PORT4_ENABLE                       (1),
                            .PORT5_ENABLE                       (1),
                            .PORT6_ENABLE                       (1),
                            .PORT7_ENABLE                       (1),
                            .PORT8_ENABLE                       (1),
                            .PORT9_ENABLE                       (1),
                            .PORT10_ENABLE                      (1),
                            .PORT11_ENABLE                      (1),
                            .PORT12_ENABLE                      (1),
                            .PORT13_ENABLE                      (1),
                            .PORT14_ENABLE                      (1),
                            .PORT15_ENABLE                      (1)
                        )   ApbSystem   (
                            .DECODE4BIT                         (PADDR[15:12]),
                            .PSEL                               (PSEL),

                            .PSEL0                              (PSEL_APBP0),
                            .PREADY0                            (PREADY_APBP0),
                            .PRDATA0                            (PRDATA_APBP0),
                            .PSLVERR0                           (PSLVERR_APBP0),

                            .PSEL1                              (PSEL_APBP1),
                            .PREADY1                            (PREADY_APBP1),
                            .PRDATA1                            (PRDATA_APBP1),
                            .PSLVERR1                           (PSLVERR_APBP1),

                            .PSEL2                              (PSEL_APBP2),
                            .PREADY2                            (PREADY_APBP2),
                            .PRDATA2                            (PRDATA_APBP2),
                            .PSLVERR2                           (PSLVERR_APBP2),

                            .PSEL3                              (PSEL_APBP3),
                            .PREADY3                            (PREADY_APBP3),
                            .PRDATA3                            (PRDATA_APBP3),
                            .PSLVERR3                           (PSLVERR_APBP3),

                            .PSEL4                              (PSEL_APBP4),
                            .PREADY4                            (PREADY_APBP4),
                            .PRDATA4                            (PRDATA_APBP4),
                            .PSLVERR4                           (PSLVERR_APBP4),

                            .PSEL5                              (),
                            .PREADY5                            (1'b1),
                            .PRDATA5                            (32'b0),
                            .PSLVERR5                           (1'b0),

                            .PSEL6                              (),
                            .PREADY6                            (1'b1),
                            .PRDATA6                            (32'b0),
                            .PSLVERR6                           (1'b0),

                            .PSEL7                              (),
                            .PREADY7                            (1'b1),
                            .PRDATA7                            (32'b0),
                            .PSLVERR7                           (1'b0),

                            .PSEL8                              (),
                            .PREADY8                            (1'b1),
                            .PRDATA8                            (32'b0),
                            .PSLVERR8                           (1'b0),

                            .PSEL9                              (),
                            .PREADY9                            (1'b1),
                            .PRDATA9                            (32'b0),
                            .PSLVERR9                           (1'b0),

                            .PSEL10                             (),
                            .PREADY10                           (1'b1),
                            .PRDATA10                           (32'b0),
                            .PSLVERR10                          (1'b0),

                            .PSEL11                             (),
                            .PREADY11                           (1'b1),
                            .PRDATA11                           (32'b0),
                            .PSLVERR11                          (1'b0),

                            .PSEL12                             (),
                            .PREADY12                           (1'b1),
                            .PRDATA12                           (32'b0),
                            .PSLVERR12                          (1'b0),

                            .PSEL13                             (),
                            .PREADY13                           (1'b1),
                            .PRDATA13                           (32'b0),
                            .PSLVERR13                          (1'b0),

                            .PSEL14                             (),
                            .PREADY14                           (1'b1),
                            .PRDATA14                           (32'b0),
                            .PSLVERR14                          (1'b0),

                            .PSEL15                             (),
                            .PREADY15                           (1'b1),
                            .PRDATA15                           (32'b0),
                            .PSLVERR15                          (1'b0),

                            .PREADY                             (PREADY),
                            .PRDATA                             (PRDATA),
                            .PSLVERR                            (PSLVERR)

                        );
    //------------------------------------------------------------------------------
    // APB0 UART
    //------------------------------------------------------------------------------
    wire TXEN;
    wire BAUDTICK;
    cmsdk_apb_uart UART(
                       .PCLK                               (clk),
                       .PCLKG                              (clk),
                       .PRESETn                            (cpuresetn),
                       .PSEL                               (PSEL_APBP0),
                       .PADDR                              (PADDR[11:2]),
                       .PENABLE                            (PENABLE),
                       .PWRITE                             (PWRITE),
                       .PWDATA                             (PWDATA),
                       .ECOREVNUM                          (4'b0),
                       .PRDATA                             (PRDATA_APBP0),
                       .PREADY                             (PREADY_APBP0),
                       .PSLVERR                            (PSLVERR_APBP0),

                       .RXD                                (RXD),
                       .TXD                                (TXD),
                       .TXEN                               (TXEN),
                       .BAUDTICK                           (BAUDTICK),
                       .TXINT                              (TXINT),
                       .RXINT                              (RXINT),
                       .TXOVRINT                           (TXOVRINT),
                       .RXOVRINT                           (RXOVRINT),
                       .UARTINT                            (UARTINT)
                   );

    //------------------------------------------------------------------------------
    // APB1 LED
    //------------------------------------------------------------------------------
    wire [7:0] LED;
    apb_led u_led(
                .PCLK                               (clk),
                .PCLKG                              (clk),
                .PRESETn                            (cpuresetn),
                .PSEL                               (PSEL_APBP1),
                .PADDR                              (PADDR[15:0]),
                .PENABLE                            (PENABLE),
                .PWRITE                             (PWRITE),
                .PWDATA                             (PWDATA),
                .ECOREVNUM                          (4'b0),
                .PRDATA                             (PRDATA_APBP1),
                .PREADY                             (PREADY_APBP1),
                .PSLVERR                            (PSLVERR_APBP1),
                .LED                                (LED)

            );
    assign OUTLED = LED;

    //APB2 KEY
    wire [15:0] keyboard_wire;
    wire [3:0] key_wire;
    apb_key u_apb_key (
                .PCLK			(clk),     // Clock
                .PCLKG		(clk),    // Gated Clock
                .PRESETn		(cpuresetn),  // Reset
                .PSEL			(PSEL_APBP2),     // Device select
                .PADDR		(PADDR[15:0]),    // Address
                .PENABLE		(PENABLE),  // Transfer control
                .PWRITE		(PWRITE),   // Write control
                .PWDATA		(PWDATA),   // Write data
                .ECOREVNUM	(4'b0),// Engineering-change-order revision bits
                .PRDATA		(PRDATA_APBP2),   // Read data
                .PREADY		(PREADY_APBP2),   // Device ready
                .PSLVERR		(PSLVERR_APBP2),  // Device error response

                .PORTIN		(key_wire),    //GPIO input
                .GPIOINT	(GPIOINT),   //GPIO Interrupt
                .COMBINT    (COMBINT)//Combined interrupt
            );

    key_filter  key0_filter(
                    .sys_clk     (clk),   //系统时钟50Mhz
                    .sys_rst_n   (RSTn),   //全局复位
                    .key_in      (keyboard_wire[0]),   //按键输入信号
                    .key_out     (key_wire[0])
                );
    key_filter  key1_filter(
                    .sys_clk     (clk),   //系统时钟50Mhz
                    .sys_rst_n   (RSTn),   //全局复位
                    .key_in      (keyboard_wire[1]),   //按键输入信号
                    .key_out     (key_wire[1])
                );
    key_filter  key2_filter(
                    .sys_clk     (clk),   //系统时钟50Mhz
                    .sys_rst_n   (RSTn),   //全局复位
                    .key_in      (keyboard_wire[2]),   //按键输入信号
                    .key_out     (key_wire[2])
                );
    key_filter  key3_filter(
                    .sys_clk     (clk),   //系统时钟50Mhz
                    .sys_rst_n   (RSTn),   //全局复位
                    .key_in      (keyboard_wire[3]),   //按键输入信号
                    .key_out     (key_wire[3])
                );

    keyboard_scan u_keyboard_scan(
                      .clk (clk),
                      .RSTn(RSTn),
                      .col (col),
                      .row (row),
                      .key (keyboard_wire)
                  );

    //APB3 TIMER
    apb_timer u_apb_timer (
                .PCLK     (clk),   // PCLK for timer operation
                .PCLKG    (clk),   // Gated clock
                .PRESETn  (cpuresetn),   // Reset

                .PSEL     (PSEL_APBP3),   // Device select
                .PADDR    (PADDR[15:0]),   // Address
                .PENABLE  (PENABLE),   // Transfer control
                .PWRITE   (PWRITE),   // Write control
                .PWDATA   (PWDATA),   // Write data
                .ECOREVNUM(4'b0),   // Engineering-change-order revision bits
                .PRDATA   (PRDATA_APBP3),   // Read data
                .PREADY   (PREADY_APBP3),   // Device ready
                .PSLVERR  (PSLVERR_APBP3),   // Device error response

                .PWM_out  (),   //PWM mode out
                .TIMERINT (TIMERINT)   // Timer interrupt output
        );

    //APB4 SPI
    apb_spi u_apb_spi(
                    .PCLK     (clk),   // PCLK for timer operation
                    .PCLKG    (clk),   // Gated clock
                    .PRESETn  (cpuresetn),   // Reset
                    .PSEL     (PSEL_APBP4),   // Device select
                    .PADDR    (PADDR[15:0]),   // Address
                    .PENABLE  (PENABLE),   // Transfer control
                    .PWRITE   (PWRITE),   // Write control
                    .PWDATA   (PWDATA),   // Write data
                    .ECOREVNUM(4'b0),   // Engineering-change-order revision bits
                    .PRDATA   (PRDATA_APBP4),   // Read data
                    .PREADY   (PREADY_APBP4),   // Device ready
                    .PSLVERR  (PSLVERR_APBP4),   // Device error response
                    .SPI_CLK  (SPI_CLK ),   //SPI clk
                    .SPI_CS   (SPI_CS  ),   //SPI cs
                    .SPI_MOSI (SPI_MOSI),   //SPI mosi
                    .SPI_MISO (SPI_MISO)    //SPI miso
    ); 
    //AHB4 LCD 0x5000_0000
    ahb_lcd lcd(
                .HCLK       (clk        ),
                .HRESETn    (cpuresetn  ),
                .HSEL       (HSEL_P4    ),
                .HADDR      (HADDR_P4   ),
                .HTRANS     (HTRANS_P4  ),
                .HSIZE      (HSIZE_P4   ),
                .HPROT      (HPROT_P4   ),
                .HWRITE     (HWRITE_P4  ),
                .HWDATA     (HWDATA_P4  ),
                .HREADY     (HREADY_P4  ),

                .HREADYOUT  (HREADYOUT_P4),
                .HRDATA     (HRDATA_P4  ),
                .HRESP      (HRESP_P4   ),

                .LCD_CS     (LCD_CS     ),
                .LCD_RS     (LCD_RS     ),
                .LCD_WR     (LCD_WR     ),
                .LCD_RD     (LCD_RD     ),
                .LCD_RST    (LCD_RST    ),
                .LCD_BL_CTR (LCD_BL_CTR ),
                .LCD_DATA   (LCD_DATA   )
            );


    //------------------------------------------------------------------------------
    // AHB DEFAULT SLAVE RESERVED FOR Camera
    //------------------------------------------------------------------------------
    wire    [15:0]    Camera_ADDR;
    wire    [31:0]    Camera_RDATA;
    wire              Camera_VALID;
    wire              Camera_READY;

    ahb_camera u_ahb_camera(
                   /* Connect to Interconnect Port 4 */
                   .HCLK                   (clk),
                   .HRESETn                (cpuresetn),
                   .HSEL                   (HSEL_P3    ),
                   .HADDR                  (HADDR_P3   ),
                   .HPROT                  (HPROT_P3   ),
                   .HSIZE                  (HSIZE_P3   ),
                   .HTRANS                 (HTRANS_P3  ),
                   .HWDATA                 (HWDATA_P3  ),
                   .HWRITE                 (HWRITE_P3  ),
                   .HRDATA                 (HRDATA_P3  ),
                   .HREADY                 (HREADY_P3  ),
                   .HREADYOUT              (HREADYOUT_P3),
                   .HRESP                  (HRESP_P3   ),

                   .ADDR                   (Camera_ADDR),
                   .RDATA                  (Camera_RDATA),
                   .DATA_VALID             (Camera_VALID),
                   .DATA_READY             (Camera_READY),

                   .PWDN                   (CAMERA_PWDN),
                   .RST                    (CAMERA_RST),
                   .CAMERA_SCL             (CAMERA_SCL),
                   .CAMERA_SDA             (CAMERA_SDA)
                   /**********************************/
               );

    //------------------------------------------------------------------------------
    // CAMERA
    //------------------------------------------------------------------------------

    CAMERA_Capture CAMERA(
                       .HCLK                           (clk),
                       .PCLK                           (CAMERA_PCLK),
                       .HRESETn                        (cpuresetn),
                       .DATA_VALID                     (Camera_VALID),
                       .DATA_READY                     (Camera_READY),
                       .DualRAM_RADDR                  (Camera_ADDR),
                       .DualRAM_RDATA                  (Camera_RDATA),
                       .Camera_idata                   (CAMERA_DATA),
                       .VSYNC                          (CAMERA_VSYNC),
                       .HREF                           (CAMERA_HREF),
                       .datavalid_test                 ()
                   );

endmodule
