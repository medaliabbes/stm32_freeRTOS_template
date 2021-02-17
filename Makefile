# path to STM32F103 standard peripheral library
STD_PERIPH_LIBS ?= /home/dali/Bureau/stm23f103/STM32F10x_StdPeriph_Lib_V3.5.0
FREE_RTOS_PORT ?= ./FreeRTOS/Source/portable/GCC/ARM_CM3
FREE_RTOS_SOURCE ?= ./FreeRTOS/Source

# list of source files
SOURCES  = main.c  system_stm32f10x.c startup_stm32f10x_md.s  
SOURCES += $(FREE_RTOS_PORT)/port.c
SOURCES += $(FREE_RTOS_SOURCE)/croutine.c
SOURCES += $(FREE_RTOS_SOURCE)/event_groups.c
SOURCES += $(FREE_RTOS_SOURCE)/list.c
SOURCES += $(FREE_RTOS_SOURCE)/queue.c
SOURCES += $(FREE_RTOS_SOURCE)/stream_buffer.c
SOURCES += $(FREE_RTOS_SOURCE)/tasks.c
SOURCES += $(FREE_RTOS_SOURCE)/timers.c
SOURCES += $(FREE_RTOS_SOURCE)/portable/MemMang/heap_3.c
SOURCES += $(STD_PERIPH_LIBS)/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_rcc.c
SOURCES += $(STD_PERIPH_LIBS)/Libraries/STM32F10x_StdPeriph_Driver/src/stm32f10x_gpio.c

SOURCES += $(STD_PERIPH_LIBS)/Libraries/STM32F10x_StdPeriph_Driver/src/misc.c


# name for output binary files
PROJECT ?= freeRTOS_template

# compiler, objcopy (should be in PATH)
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy

# path to st-flash (or should be specified in PATH)
ST_FLASH ?= st-flash
RTOS_INC ?= /home/dali/Bureau/freertos/FreeRTOS/Source
# specify compiler flags

CFLAGS  = -g -O2 -Wall
CFLAGS += -T$(STD_PERIPH_LIBS)/Project/STM32F10x_StdPeriph_Template/TrueSTUDIO/STM3210B-EVAL/stm32_flash.ld
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -specs=nano.specs -specs=nosys.specs -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER
CFLAGS += -Wl,--gc-sections
CFLAGS += -I.
CFLAGS += -I$(STD_PERIPH_LIBS)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x/
CFLAGS += -I$(STD_PERIPH_LIBS)/Libraries/CMSIS/CM3/CoreSupport
CFLAGS += -I$(STD_PERIPH_LIBS)/Libraries/STM32F10x_StdPeriph_Driver/inc
CFLAGS += -I$(RTOS_INC)/include/
CFLAGS += -I$(FREE_RTOS_PORT)/


OBJS = $(SOURCES:.c=.o)

all: $(PROJECT).elf

# compile
$(PROJECT).elf: $(SOURCES)
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJECT).elf $(PROJECT).hex
	$(OBJCOPY) -O binary $(PROJECT).elf $(PROJECT).bin

# remove binary files
clean:
	rm -f *.o *.elf *.hex *.bin

# flash
burn:
	 $(ST_FLASH) write $(PROJECT).bin 0x8000000
