#include "CortexM0.h"


/****************************UART*******************************/

 uint32_t  uart_init( UART_TypeDef * uart, uint32_t divider, uint32_t tx_en,
                           uint32_t rx_en, uint32_t tx_irq_en, uint32_t rx_irq_en, uint32_t tx_ovrirq_en, uint32_t rx_ovrirq_en);

  /**
   * @brief Returns whether the UART RX Buffer is Full.
   */

 uint32_t  uart_GetRxBufferFull( UART_TypeDef * uart);

  /**
   * @brief Returns whether the UART TX Buffer is Full.
   */

 uint32_t  uart_GetTxBufferFull( UART_TypeDef * uart);

  /**
   * @brief Sends a character to the UART TX Buffer.
   */


void  uart_SendChar( UART_TypeDef * uart, char txchar);

  /**
   * @brief Receives a character from the UART RX Buffer.
   */

extern char  uart_ReceiveChar(UART_TypeDef* uart);

  /**
   * @brief Returns UART Overrun status.
   */

extern uint32_t  uart_GetOverrunStatus( UART_TypeDef * uart);

  /**
   * @brief Clears UART Overrun status Returns new UART Overrun status.
   */

 extern uint32_t  uart_ClearOverrunStatus( UART_TypeDef * uart);

  /**
   * @brief Returns UART Baud rate Divider value.
   */

 extern uint32_t  uart_GetBaudDivider( UART_TypeDef * uart);

  /**
   * @brief Return UART TX Interrupt Status.
   */

 extern uint32_t  uart_GetTxIRQStatus( UART_TypeDef * uart);

  /**
   * @brief Return UART RX Interrupt Status.
   */

 extern uint32_t  uart_GetRxIRQStatus( UART_TypeDef * uart);

  /**
   * @brief Clear UART TX Interrupt request.
   */

 extern void  uart_ClearTxIRQ( UART_TypeDef * uart);

  /**
   * @brief Clear UART RX Interrupt request.
   */

 extern void  uart_ClearRxIRQ( UART_TypeDef* uart);

  /**
   * @brief Set CM3DS_MPS2 Timer for multi-shoot mode with internal clock
   */

 /**************************************SYSTICK*******************************************/

extern void delay(uint32_t time);
extern void Set_SysTick_CTRL(uint32_t ctrl);
extern void Set_SysTick_LOAD(uint32_t load);
extern uint32_t Read_SysTick_VALUE(void);
extern void Set_SysTick_VALUE(uint32_t value);
extern void Set_SysTick_CALIB(uint32_t calib);
extern uint32_t Timer_Ini(void);
extern uint8_t Timer_Stop(uint32_t *duration_t,uint32_t start_t);


//LED
void led_ctrl(uint8_t num,uint8_t on);
void LED_on(uint8_t num);
void LED_down(uint8_t num);
void LED_toggle(uint8_t num);

//KEY
uint32_t READ_KEY(void);


//TIMER
void TIMER_Init(uint32_t reload_value,uint32_t inverse_value);

//DELAY
void delay_ms (uint32_t time);

/**************************************LCD*******************************************/
void LCD_Init(void);									
void LCD_DisplayOn(void);													
void LCD_DisplayOff(void);													
void LCD_Clear(uint16_t Color);	 											
void LCD_SetCursor(uint16_t Xpos, uint16_t Ypos);							
void LCD_DrawPoint(uint16_t x,uint16_t y);									
void LCD_Fast_DrawPoint(uint16_t x,uint16_t y,uint16_t color);							
uint16_t  LCD_ReadPoint(uint16_t x,uint16_t y); 										
void LCD_Draw_Circle(uint16_t x0,uint16_t y0,uint8_t r);						 		
void LCD_DrawLine(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2);					
void LCD_DrawRectangle(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2);		   		
void LCD_Fill(uint16_t sx,uint16_t sy,uint16_t ex,uint16_t ey,uint16_t color);		   	
void LCD_Color_Fill(uint16_t sx,uint16_t sy,uint16_t ex,uint16_t ey,uint16_t *color);	
void LCD_ShowChar(uint16_t x,uint16_t y,uint8_t num,uint8_t mode);			
void LCD_ShowNum(uint16_t x,uint16_t y,uint32_t num,uint8_t len);  					
void LCD_ShowxNum(uint16_t x,uint16_t y,uint32_t num,uint8_t len,uint8_t mode);				
void LCD_ShowString(uint16_t x,uint16_t y,uint16_t width,uint16_t height,uint8_t *p);		
void LCD_WriteReg(uint16_t LCD_Reg, uint16_t LCD_RegValue);
uint16_t LCD_ReadReg(uint16_t LCD_Reg);
void Show_Str(uint16_t x, uint16_t y, uint16_t fc, uint16_t bc, uint8_t *str,uint8_t size,uint8_t mode);
void LCD_WriteRAM_Prepare(void);
void LCD_WriteRAM(uint16_t RGB_Code);
void LCD_SSD_BackLightSet(uint8_t pwm);							
void LCD_Scan_Dir(uint8_t dir);									
void LCD_Display_Dir(uint8_t dir);
void LCD_Set_Window(uint16_t sx,uint16_t sy,uint16_t width,uint16_t height);
void Gui_Drawbmp16(uint16_t x,uint16_t y,const unsigned char *p); //??40*40 QQ??
void LCD_WR_DATA( uint16_t data );


/*************************************CAMERA*******************************************/
void Set_CAMERA_SDA_W(void);
void Set_CAMERA_SDA_R(void);
void Set_CAMERA_SCL(void);
void Clr_CAMERA_SCL(void);
void Set_CAMERA_RST(void);
void Clr_CAMERA_RST(void);
void Set_CAMERA_PWDN(void);
void Clr_CAMERA_PWDN(void);
void Set_CAMERA_SDA(void);
uint32_t Read_CAMERA_SDA(void);
void Clr_CAMERA_SDA(void);
void CAMERA_Start(void);
void CAMERA_Stop(void);
void CAMERA_Waite(void);
void CAMERA_Write_Byte(uint8_t data);
void CAMERA_Command(uint8_t addr_h,uint8_t addr_l,uint8_t data);
void CAMERA_Data(uint8_t data);
void CAMERA_Initial(void);
uint32_t Read_CAMERA_DATA_STATE(void);
void Set_CAMERA_DATA_STATE(uint32_t state);
uint32_t Read_CAMERA_DATA_LEN(void);
uint8_t CAMERA_Read_Byte(void);
uint8_t CAMERA_Read_Reg(uint16_t reg);
uint8_t CAMERA_Focus_Init(void);
void CAMERA_Light_Mode(void);	
void CAMERA_Color_Saturation(void);
void CAMERA_Brightness(void);	
void CAMERA_Contrast(void);	
void CAMERA_Sharpness(void);	
uint8_t CAMERA_Focus_Constant(void);
void CAMERA_NA(void);
void photo(void);
