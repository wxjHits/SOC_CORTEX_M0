#include <stdint.h>
#include <stdio.h>

/*
 * ==========================================================================
 * ---------- Interrupt Number Definition -----------------------------------
 * ==========================================================================
 */

typedef enum IRQn
{
/******  Cortex-M3 Processor Exceptions Numbers ***************************************************/
  NonMaskableInt_IRQn           = -14,    /*!<  2 Cortex-M3 Non Maskable Interrupt                        */
  HardFault_IRQn                = -13,    /*!<  3 Cortex-M3 Hard Fault Interrupt                          */
  MemoryManagement_IRQn         = -12,    /*!<  4 Cortex-M3 Memory Management Interrupt            */
  BusFault_IRQn                 = -11,    /*!<  5 Cortex-M3 Bus Fault Interrupt                    */
  UsageFault_IRQn               = -10,    /*!<  6 Cortex-M3 Usage Fault Interrupt                  */
  SVCall_IRQn                   = -5,     /*!< 11 Cortex-M3 SV Call Interrupt                      */
  DebugMonitor_IRQn             = -4,     /*!< 12 Cortex-M3 Debug Monitor Interrupt                */
  PendSV_IRQn                   = -2,     /*!< 14 Cortex-M3 Pend SV Interrupt                      */
  SysTick_IRQn                  = -1,     /*!< 15 Cortex-M3 System Tick Interrupt                  */

/******  CM3DS_MPS2 Specific Interrupt Numbers *******************************************************/
  UARTTX_IRQn                   = 0,       /* UART 0 RX and TX Combined Interrupt   */
  UARTRX_IRQn                   = 1,       /* Undefined                             */
  UARTOVR_IRQn                  = 2,       /* UART 1 RX and TX Combined Interrupt   */
  KEY0_IRQn                     = 3,
  KEY1_IRQn                     = 4,
  KEY2_IRQn                     = 5,
  KEY3_IRQn                     = 6,
  TIMER_IRQn                    = 7
} IRQn_Type;

/*
 * ==========================================================================
 * ----------- Processor and Core Peripheral Section ------------------------
 * ==========================================================================
 */

/* Configuration of the Cortex-M3 Processor and Core Peripherals */
#define __CM3_REV                 0x0000    /*!< Core Revision r2p1                             */
#define __NVIC_PRIO_BITS          3         /*!< Number of Bits used for Priority Levels        */
#define __Vendor_SysTickConfig    0         /*!< Set to 1 if different SysTick Config is used   */
#define __MPU_PRESENT             1         /*!< MPU present or not                             */

#include "core_cm0.h"

/*------------- Universal Asynchronous Receiver Transmitter (UART) -----------*/
typedef struct
{
  __IO   uint32_t  DATA;          /*!< Offset: 0x000 Data Register    (R/W) */
  __IO   uint32_t  STATE;         /*!< Offset: 0x004 Status Register  (R/W) */
  __IO   uint32_t  CTRL;          /*!< Offset: 0x008 Control Register (R/W) */
  union {
    __I    uint32_t  INTSTATUS;   /*!< Offset: 0x00C Interrupt Status Register (R/ ) */
    __O    uint32_t  INTCLEAR;    /*!< Offset: 0x00C Interrupt Clear Register ( /W) */
    };
  __IO   uint32_t  BAUDDIV;       /*!< Offset: 0x010 Baudrate Divider Register (R/W) */

}  UART_TypeDef;

/*  UART DATA Register Definitions */
#define  UART_DATA_Pos               0                                            /*!<  UART_DATA_Pos: DATA Position */
#define  UART_DATA_Msk              (0xFFul <<  UART_DATA_Pos)               /*!<  UART DATA: DATA Mask */

#define  UART_STATE_RXOR_Pos         3                                            /*!<  UART STATE: RXOR Position */
#define  UART_STATE_RXOR_Msk         (0x1ul <<  UART_STATE_RXOR_Pos)         /*!<  UART STATE: RXOR Mask */

#define  UART_STATE_TXOR_Pos         2                                            /*!<  UART STATE: TXOR Position */
#define  UART_STATE_TXOR_Msk         (0x1ul <<  UART_STATE_TXOR_Pos)         /*!<  UART STATE: TXOR Mask */

#define  UART_STATE_RXBF_Pos         1                                            /*!<  UART STATE: RXBF Position */
#define  UART_STATE_RXBF_Msk         (0x1ul <<  UART_STATE_RXBF_Pos)         /*!<  UART STATE: RXBF Mask */

#define  UART_STATE_TXBF_Pos         0                                            /*!<  UART STATE: TXBF Position */
#define  UART_STATE_TXBF_Msk         (0x1ul <<  UART_STATE_TXBF_Pos )        /*!<  UART STATE: TXBF Mask */

#define  UART_CTRL_HSTM_Pos          6                                            /*!<  UART CTRL: HSTM Position */
#define  UART_CTRL_HSTM_Msk          (0x01ul <<  UART_CTRL_HSTM_Pos)         /*!<  UART CTRL: HSTM Mask */

#define  UART_CTRL_RXORIRQEN_Pos     5                                            /*!<  UART CTRL: RXORIRQEN Position */
#define  UART_CTRL_RXORIRQEN_Msk     (0x01ul <<  UART_CTRL_RXORIRQEN_Pos)    /*!<  UART CTRL: RXORIRQEN Mask */

#define  UART_CTRL_TXORIRQEN_Pos     4                                            /*!<  UART CTRL: TXORIRQEN Position */
#define  UART_CTRL_TXORIRQEN_Msk     (0x01ul <<  UART_CTRL_TXORIRQEN_Pos)    /*!<  UART CTRL: TXORIRQEN Mask */

#define  UART_CTRL_RXIRQEN_Pos       3                                            /*!<  UART CTRL: RXIRQEN Position */
#define  UART_CTRL_RXIRQEN_Msk       (0x01ul <<  UART_CTRL_RXIRQEN_Pos)      /*!<  UART CTRL: RXIRQEN Mask */

#define  UART_CTRL_TXIRQEN_Pos       2                                            /*!<  UART CTRL: TXIRQEN Position */
#define  UART_CTRL_TXIRQEN_Msk       (0x01ul <<  UART_CTRL_TXIRQEN_Pos)      /*!<  UART CTRL: TXIRQEN Mask */

#define  UART_CTRL_RXEN_Pos          1                                            /*!<  UART CTRL: RXEN Position */
#define  UART_CTRL_RXEN_Msk          (0x01ul <<  UART_CTRL_RXEN_Pos)         /*!<  UART CTRL: RXEN Mask */

#define  UART_CTRL_TXEN_Pos          0                                            /*!<  UART CTRL: TXEN Position */
#define  UART_CTRL_TXEN_Msk          (0x01ul <<  UART_CTRL_TXEN_Pos)         /*!<  UART CTRL: TXEN Mask */

#define  UART_INTSTATUS_RXORIRQ_Pos  3                                            /*!<  UART CTRL: RXORIRQ Position */
#define  UART_CTRL_RXORIRQ_Msk       (0x01ul <<  UART_INTSTATUS_RXORIRQ_Pos) /*!<  UART CTRL: RXORIRQ Mask */

#define  UART_CTRL_TXORIRQ_Pos       2                                            /*!<  UART CTRL: TXORIRQ Position */
#define  UART_CTRL_TXORIRQ_Msk       (0x01ul <<  UART_CTRL_TXORIRQ_Pos)      /*!<  UART CTRL: TXORIRQ Mask */

#define  UART_CTRL_RXIRQ_Pos         1                                            /*!<  UART CTRL: RXIRQ Position */
#define  UART_CTRL_RXIRQ_Msk         (0x01ul <<  UART_CTRL_RXIRQ_Pos)        /*!<  UART CTRL: RXIRQ Mask */

#define  UART_CTRL_TXIRQ_Pos         0                                            /*!<  UART CTRL: TXIRQ Position */
#define  UART_CTRL_TXIRQ_Msk         (0x01ul <<  UART_CTRL_TXIRQ_Pos)        /*!<  UART CTRL: TXIRQ Mask */

#define  UART_BAUDDIV_Pos            0                                            /*!<  UART BAUDDIV: BAUDDIV Position */
#define  UART_BAUDDIV_Msk            (0xFFFFFul <<  UART_BAUDDIV_Pos)        /*!<  UART BAUDDIV: BAUDDIV Mask */

/******************************************************************************/
/*                         Peripheral memory map                              */
/******************************************************************************/
/* Peripheral and SRAM base address */
#define APB_BASE         (0x40000000UL)
#define UART_BASE        (APB_BASE)

/******************************************************************************/
/*                         Peripheral declaration                             */
/******************************************************************************/
#define UART             ((UART_TypeDef*) UART_BASE)          

//LED
#define LED_BASE         (APB_BASE+0x1000)

//APB KEY INT
//BASE_ADDR 0x40002000
// 0x000 RW    Data read
// 0x004 RW    Interrupt Enable Set
// 0x008 R     Interrupt Status
#define KEY_BASE         (APB_BASE+0x2000)
typedef struct{
    volatile uint32_t DATA_READ;
    volatile uint32_t KEY_INT_EN;
    volatile uint32_t KEY_INT_STATE;
}KEYType;

#define KEY   ((KEYType*)KEY_BASE)

//TIMER
// BASE_ADDR:0x40003000
// 0x00 RW    CTRL[1:0]
//              [2] PWM_out Enable
//              [1] Timer Interrupt Enable
//              [0] Enable
// 0x04 RW    Current Value[31:0]
// 0x08 RW    Reload Value[31:0]
// 0x0C R/Wc  Timer Interrupt
//            [0] Interrupt, right 1 to clear
// 0x10 RW    INVERSE Value[31:0]
//-------------------------------------
#define TIMER_BASE         (APB_BASE+0x3000)
typedef struct{
    volatile uint32_t TIMER_CTRL;
    volatile uint32_t CURRENT_VALUE;
    volatile uint32_t RELOAD_VALUE;
    volatile uint32_t CLR_INT;
    volatile uint32_t INVERSE_VALUE;
}TIMERType;
#define TIMER   ((TIMERType*)TIMER_BASE)

// SPI 
// BASE_ADDR:0x40004000
// 0x00 RW   [0]   SPI_CS
// 0x04 RW   [7:0] CLK_DIV
// 0x08 RW   [7:0] DATA_TX
// 0x0C RW   [0]   TX_REQ
// 0x10 R    [7:0] DATA_RX
// 0x14 R    [0]   SPI_READY
#define SPI_BASE         (APB_BASE+0x4000)
typedef struct{
    volatile uint32_t SPI_CS;
    volatile uint32_t SPI_CLK_DIV;
    volatile uint32_t SPI_DATA_TX;
    volatile uint32_t SPI_TX_REQ;
    volatile uint32_t SPI_DATA_RX;
    volatile uint32_t SPI_READY;
}SPIType;

#define SPI   ((SPIType*)SPI_BASE)
//LCD
/**********************************************/
/*   LCD_CS           0X5000_0000             */
/*   LCD_RS           0X5000_0004             */
/*   LCD_WR           0X5000_0008             */
/*   LCD_RD           0X5000_000C             */
/*   LCD_RST          0X5000_0010             */
/*   LCD_BL_CTR       0X5000_0014             */
/*   LCD_DATA         0X5000_0018             */
/**********************************************/
#define LCD_BASE         (0x50000000UL)
typedef struct {
    volatile uint32_t LCD_CS; 
    volatile uint32_t LCD_RS; 
    volatile uint32_t LCD_WR; 
    volatile uint32_t LCD_RD; 
    volatile uint32_t LCD_RST;
    volatile uint32_t LCD_BL_CTR;
    volatile uint32_t LCD_DATA;
}LCDType;
#define LCD              ((LCDType        *) LCD_BASE    )

typedef struct  
{										    
	uint16_t width;			
	uint16_t height;			
	uint16_t id;				
	uint8_t  dir;			
	uint16_t wramcmd;		
	uint16_t setxcmd;		
	uint16_t setycmd;		
}_lcd_dev; 
extern _lcd_dev lcddev;

extern uint16_t  POINT_COLOR;  
extern uint16_t  BACK_COLOR; 
//      BASIC SIGNAL SET AND CLEAR
#define LCD_CS_SET         (LCD->LCD_CS        = 1) 	 
#define LCD_RS_SET         (LCD->LCD_RS        = 1) 
#define LCD_WR_SET         (LCD->LCD_WR        = 1) 
#define LCD_RD_SET         (LCD->LCD_RD        = 1) 
#define LCD_RST_SET        (LCD->LCD_RST       = 1)
#define LCD_BL_CTR_SET     (LCD->LCD_BL_CTR    = 1)
     
#define LCD_CS_CLR         (LCD->LCD_CS        = 0) 	 
#define LCD_RS_CLR         (LCD->LCD_RS        = 0) 
#define LCD_WR_CLR         (LCD->LCD_WR        = 0) 
#define LCD_RD_CLR         (LCD->LCD_RD        = 0) 
#define LCD_RST_CLR        (LCD->LCD_RST       = 0)
#define LCD_BL_CTR_CLR     (LCD->LCD_BL_CTR    = 0)

//      SCANNING DIRECTION
#define L2R_U2D  0 // LEFT TO RIGHT, UP TO DOWN
#define L2R_D2U  1 // LEFT TO RIGHT, DOWN TO UP
#define R2L_U2D  2 // RIGHT TO LEFT, UP TO DOWN
#define R2L_D2U  3 // RIGHT TO LEFT, DOWN TO UP

#define U2D_L2R  4 // UP TO DOWN, LEFT TO RIGHT
#define U2D_R2L  5 // UP TO DOWN, RIGHT TO LEFT
#define D2U_L2R  6 // DOWN TO UP, LEFT TO RIGHT
#define D2U_R2L  7 // DOWN TO UP, RIGHT TO LEFT

#define DFT_SCAN_DIR    L2R_U2D // DEFAULT

//  PEN COLOR
#define WHITE         	 0xFFFF
#define BLACK         	 0x0000	  
#define BLUE         	 0x001F  
#define BRED             0XF81F
#define GRED 			 0XFFE0
#define GBLUE			 0X07FF
#define RED           	 0xF800
#define MAGENTA       	 0xF81F
#define GREEN         	 0x07E0
#define CYAN          	 0x7FFF
#define YELLOW        	 0xFFE0
#define BROWN 			 0XBC40 
#define BRRED 			 0XFC07 
#define GRAY  			 0X8430 

//  GUI COLOR ( COLOR OF PANEL )
#define DARKBLUE      	 0X01CF	
#define LIGHTBLUE      	 0X7D7C	 
#define GRAYBLUE       	 0X5458 


#define LIGHTGREEN     	 0X841F 
#define LGRAY 			 0XC618 // BACKGROUND COLOR OF WINDOW

#define LGRAYBLUE        0XA651 // MIDDLE LAYER COLOR
#define LBBLUE           0X2B12 // COLOR OF SWITCHED

//  LCD RESOLUTION
#define SSD_HOR_RESOLUTION		800		// LCD HORIZON RESOLUTION
#define SSD_VER_RESOLUTION		480		// LCD VERTICAL RESOLUTION

//  LCD DRIVING PARAMETER
#define SSD_HOR_PULSE_WIDTH		1		
#define SSD_HOR_BACK_PORCH		46		
#define SSD_HOR_FRONT_PORCH		210		

#define SSD_VER_PULSE_WIDTH		1		
#define SSD_VER_BACK_PORCH		23		
#define SSD_VER_FRONT_PORCH		22		

//  AUTO CALCULATE
#define SSD_HT	(SSD_HOR_RESOLUTION+SSD_HOR_BACK_PORCH+SSD_HOR_FRONT_PORCH)
#define SSD_HPS	(SSD_HOR_BACK_PORCH)
#define SSD_VT 	(SSD_VER_RESOLUTION+SSD_VER_BACK_PORCH+SSD_VER_FRONT_PORCH)
#define SSD_VPS (SSD_VER_BACK_PORCH)

// CAMERA
//CAMERA CONFIG DEF
typedef struct{
    volatile uint32_t CAMERA_CONFIG_RST;
    volatile uint32_t CAMERA_CONFIG_PWDN;
    volatile uint32_t CAMERA_CONFIG_SCL;
    volatile uint32_t CAMERA_CONFIG_SDAO;
    volatile uint32_t CAMERA_CONFIG_SDAI;
    volatile uint32_t CAMERA_CONFIG_SDAOEN;
    volatile uint32_t CAMERA_DATA_STATE;
}CAMERA_CONFIGType;

#define CAMERA_CONFIG_BASE 0x40050000UL
#define CAMERA_CONFIG ((CAMERA_CONFIGType *)CAMERA_CONFIG_BASE)

//CAMERA DEF
typedef struct{
    volatile uint16_t CAMERA_VALUE[240][320];
}CAMERAType;

#define CAMERA_BASE 0x40010000UL
#define CAMERA ((CAMERAType *)CAMERA_BASE)
