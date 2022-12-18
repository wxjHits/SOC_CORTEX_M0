#include "CortexM0.h"
#include "systick.h"
#include "uart.h"
#include "camera.h"
#include "lcd.h"
#include "led.h"

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
    printf("uart_rx int occur!!!\n");
}

void UARTTXHandler(void) {
    uart_ClearTxIRQ(UART);
    LED_toggle(2);
    LCD_ShowString(0,0,240,320,"UARTTX_IRQn OCCURED!!!");
}

void UARTOVRHandler(void) {
    ;
}

//KEY INT

void KEY0(void){
    LED_toggle(0);
    photo();
    uint16_t x, y;
    for (x = 0; x < 240; x++){
        for (y = 0; y < 320; y++) 
            LCD_Fast_DrawPoint(y, x, CAMERA->CAMERA_VALUE[x][y]);
    }
}

void KEY1(void){
    LED_toggle(1);
    printf("KEY1 INTR OCCURED!\n");
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






