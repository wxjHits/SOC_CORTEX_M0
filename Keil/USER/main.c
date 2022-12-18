#include "CortexM0.h"
#include "camera.h"
#include "uart.h"
#include "led.h"
#include "lcd.h"
#include "key.h"
#include "timer.h"
#include "spi_flash.h"
#include "systick.h"

int main(void)
{   
    //先执行的是函数SystemInit();
    uart_init (UART, (50000000 / 115200), 1,1,0,0,0,0);
    SPI_Init(100);
    LCD_Init();
    KEY_INIT(0xf);
    CAMERA_Initial();
    TIMER_Init(50000000,0,1);
    
    printf("/**************************test start!**************************/\n");
    uint8_t* p;
    p="to be,or not to be?that is a question!";
    
    uint8_t spi_sr ;
    spi_sr=SPI_Flash_ReadSR();
    uint16_t flash_id;
    flash_id=SPI_Flash_ReadID();
    SPI_Flash_Erase_Sector(0);
    SPI_Flash_Write_Page(p,0,30);
    //SPI_Flash_Erase_Chip();
    uint8_t* spi_rx_buffer;
    SPI_Flash_Read(spi_rx_buffer,6,30);
    printf("spi_sr=%x,flash_id=%x\n",spi_sr,flash_id);
    printf("p=%s\n",p);
    printf("spi_rx_buffer=%s\n",spi_rx_buffer);
    
    LCD_ShowString(0,0,240,320,p);
    LCD_ShowString(0,0,240,320,spi_rx_buffer);
    
    while(1)
    {
        //printf("spi_rx_buffer=%s\n",p);
        delay_ms(1000);
    }
}
