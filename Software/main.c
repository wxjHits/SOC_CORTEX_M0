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
    KEY->KEY_INT_EN=0xf;
    NVIC_EnableIRQ(KEY0_IRQn);
    NVIC_EnableIRQ(KEY1_IRQn);
    NVIC_EnableIRQ(KEY2_IRQn);
    NVIC_EnableIRQ(KEY3_IRQn);
    
//    TIMER_Init(0x2FAF080,0x0);
//    NVIC_EnableIRQ(TIMER_IRQn);

//    uart_init (UART, (50000000 / 115200), 1,1,0,0,0,0);
    
    char* p;
    p="to be,or not to be?that is a question!";
    LCD_Init();
    LCD_ShowString(0,0,240,320,p);
    
    CAMERA_Initial();
    while(1)
    {
//        scanf("recieve:%s",p);
        ;
    }
}

