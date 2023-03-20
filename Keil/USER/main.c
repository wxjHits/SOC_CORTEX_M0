#include "CortexM0.h"
#include "led.h"
#include "systick.h"
#include "stdlib.h"

int main(void)
{   
    //先执行的是函数SystemInit();
    while(1)
    {
        //*(uint32_t*)(LED_BASE)=0x0000000f;
        LED_toggle(1);
        LED_toggle(3);
        //LED_toggle(1);
        delay_ms(500);
        //*(uint32_t*)(LED_BASE)=0x000000f0;
        //delay_ms(500);
    }
}
