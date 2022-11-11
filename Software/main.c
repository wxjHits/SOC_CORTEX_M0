#include "CortexM0_driver.h"

void my_delay(uint32_t time)
{
   for(int i=0;i<time;i++)
    {
       for(int j=0;j<800;j++)
          ;
     }
}

int main(void) 
{       
    uint8_t* p;
    p="to be,or not to be?that is a question!";
    SPI_Init(100);
    uint8_t spi_sr ;
    spi_sr=SPI_Flash_ReadSR();
    uint16_t flash_id;
    flash_id=SPI_Flash_ReadID();
    
    //SPI_Flash_Erase_Sector(0);
    //SPI_Flash_Write_Page(p,0,30);
    SPI_Flash_Erase_Chip();
    
    uint8_t* spi_rx_buffer;
    SPI_Flash_Read(spi_rx_buffer,6,30);
    
    KEY->KEY_INT_EN=0xf;
    NVIC_EnableIRQ(KEY0_IRQn);
    NVIC_EnableIRQ(KEY1_IRQn);
    NVIC_EnableIRQ(KEY2_IRQn);
    NVIC_EnableIRQ(KEY3_IRQn);
    
//    TIMER_Init(0x2FAF080,0x0);
//    NVIC_EnableIRQ(TIMER_IRQn);

    uart_init (UART, (50000000 / 115200), 1,1,0,0,0,0);
    
    printf("spi_sr=%x,flash_id=%x\n",spi_sr,flash_id);
    printf("p=%s\n",p);
    printf("spi_rx_buffer=%s\n",spi_rx_buffer);
    LCD_Init();
    //LCD_ShowString(0,0,240,320,p);
    LCD_ShowString(0,0,240,320,spi_rx_buffer);
//    
//    CAMERA_Initial();
    while(1)
    {
//        scanf("recieve:%s",p);
    }
}
