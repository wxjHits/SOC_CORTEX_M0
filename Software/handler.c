#include "CortexM0_driver.h"

void NMIHandler(void) {
    ;
}

void HardFaultHandler(void) {
    ;
}

void MemManageHandler(void) {
    ;
}

void BusFaultHandler(void) {
    ;
}

void UsageFaultHandler(void) {
    ;
}

void SVCHandler(void) {
    ;
}

void DebugMonHandler(void) {
    ;
}

void PendSVHandler(void) {
    ;
}

void SysTickHandler(void) {
    Set_SysTick_CTRL(0);
    SCB->ICSR = SCB->ICSR | (1 << 25);
}


void UARTRXHandler(void) {
    uart_ClearRxIRQ(UART);
    LED_toggle(1);
}

void UARTTXHandler(void) {
    uart_ClearTxIRQ(UART);
    LED_toggle(2);
}

void UARTOVRHandler(void) {
    ;
}

//KEY INT

void KEY0(void){
    LED_toggle(0);
    photo();
    uint16_t x, y;
    for (x = 0; x < 240; x++)
        {
            for (y = 0; y < 320; y++) 
                LCD_Fast_DrawPoint(y, x, CAMERA->CAMERA_VALUE[x][y]);
        }
}

void KEY1(void){
    LED_toggle(1);
}


void KEY2(void){
    LED_toggle(2);
}

void KEY3(void){
    LED_toggle(3);
}

//Timer
void Timer_Handler(void){
    LED_toggle(7);
    printf("timer int occur!!!\n");
}






