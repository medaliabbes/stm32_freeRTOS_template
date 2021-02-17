#include "main.h"
#include "FreeRTOS.h"
#include "task.h"

volatile uint32_t uTick = 0;

TaskHandle_t task1_handler = NULL;
TaskHandle_t task2_handler = NULL;

void task1(void *p)
{
    while(1)
    {
     GPIO_WriteBit(GPIOC,GPIO_Pin_13,1);
     vTaskDelay(500);
     GPIO_WriteBit(GPIOC,GPIO_Pin_13,0);
     vTaskDelay(500);         
    }
}
  
void task2(void *p)
{
    while(1)
    {
     GPIO_WriteBit(GPIOC,GPIO_Pin_14,0);
     vTaskDelay(500);
     GPIO_WriteBit(GPIOC,GPIO_Pin_14,1);
     vTaskDelay(500);         
    }
}

int main(void)
{   
    SystemInit(); // set clock to 72Mhz
    /* timers clock = 72Mhz if the hclk = 72Mhz*/
    SysTick_Config(71999);//(72Mhz/1000Hz) -1 ====> system interrupt every 1ms
    clock_enable();
    gpio_init();
    
    GPIO_WriteBit(GPIOC,GPIO_Pin_13,1);//led off
    
    xTaskCreate((TaskFunction_t)task1,"task1",100,(void*)0,1,&task1_handler);
    xTaskCreate((TaskFunction_t)task2,"task2",100,(void*)0,1,&task2_handler);
    vTaskStartScheduler();
   
    while(1)
    {
    
    }

}


void gpio_init(void)
{

    /*led init*/
    GPIO_WriteBit(GPIOC,GPIO_Pin_14,1);
    GPIO_InitTypeDef led; 
    led.GPIO_Pin = GPIO_Pin_13|GPIO_Pin_14;
    led.GPIO_Speed = GPIO_Speed_10MHz;
    led.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(GPIOC,&led);  
}



void clock_enable(void)
{
    /****enable clock for led GPIOC********/
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC,ENABLE);
    /*****enable clock for spi pins and adc pin GPIOA*****/
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA,ENABLE);
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO,ENABLE);

    /*****enable clock for timer 3*****/
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM3,ENABLE);
    /*****enable spi1 clock********/
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_SPI1,ENABLE);
    /******enable clock for adc*******/
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1,ENABLE);
    /******enable clock for dma1********/
    RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1,ENABLE);
}

void incriment_tick(void)
{
    uTick++;
}

void delay_ms(uint32_t delay)
{
    uint32_t st = get_tick();
    while(get_tick()-st<delay);
}

uint32_t get_tick(void)
{
    return uTick;
}

/**system interrupt handler**/
/*
void SysTick_Handler(void)
{
   incriment_tick(); 
}
*/