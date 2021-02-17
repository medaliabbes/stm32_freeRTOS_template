#ifndef __MAIN__
#define __MAIN__

#include "stm32f10x_rcc.h"
#include "stm32f10x_gpio.h"
#include "misc.h"
#include "system_stm32f10x.h"


void gpio_init(void);
void clock_enable(void);
void incriment_tick(void);
uint32_t get_tick(void);
void delay_ms(uint32_t delay);

#endif