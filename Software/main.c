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
    
    LED_on(0);
    LED_on(1);
    LED_on(2);
    LED_on(3);
    
    KEY->KEY_INT_EN=0xf;
    NVIC_EnableIRQ(KEY0_IRQn);
    NVIC_EnableIRQ(KEY1_IRQn);
    NVIC_EnableIRQ(KEY2_IRQn);
    NVIC_EnableIRQ(KEY3_IRQn);

    TIMER_Init(0x2FAF080,0x0);
    NVIC_EnableIRQ(TIMER_IRQn);
    
    uart_init (UART, (50000000 / 115200), 1,1,0,0,0,0);
    while(1)
    {
        ;
    }
}

