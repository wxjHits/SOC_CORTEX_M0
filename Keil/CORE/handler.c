#include "CortexM0.h"
#include "systick.h"
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
;
}

void UARTTXHandler(void) {
    ;
}

void UARTOVRHandler(void) {
    ;
}

//KEY INT

void KEY0(void){
    ;
}

void KEY1(void){
    ;
}


void KEY2(void){
    ;
}

void KEY3(void){
    ;
}

//Timer
void Timer_Handler(void){
    ;
}






