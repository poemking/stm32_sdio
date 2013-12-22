#======================================================================#
#Output files
EXECUTABLE=stm32_sdio.elf
BIN_IMAGE=stm32_sdio.bin

#======================================================================#
#Cross Compiler
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

#======================================================================#
#Flags
CFLAGS=-g -mlittle-endian -mthumb
CFLAGS+=-mcpu=cortex-m4
CFLAGS+=-mfpu=fpv4-sp-d16 -mfloat-abi=softfp
CFLAGS+=-ffreestanding -nostdlib -Wall

CFLAGS+=-D USE_STDPERIPH_DRIVER\
	-D STM32F40XX \
	-D __FPU_PRESENT=1 \
	-D ARM_MATH_CM4

CFLAGS+=-I./
CFLAGS+=-I./Program/
CFLAGS+=-I./Fatfs/

#======================================================================#
#Libraries

#Stm32 libraries
ST_LIB=./Libraries/STM32F4xx_StdPeriph_Driver

#CMSIS libraries
CFLAGS+=-I./Libraries/CMSIS/

#StdPeriph includes
CFLAGS+=-I$(ST_LIB)/inc

#======================================================================#
#Source code
SRC=./Libraries/CMSIS/system_stm32f4xx.c

#StdPeriph
SRC+=$(ST_LIB)/src/misc.c \
        $(ST_LIB)/src/stm32f4xx_rcc.c \
        $(ST_LIB)/src/stm32f4xx_dma.c \
        $(ST_LIB)/src/stm32f4xx_flash.c \
        $(ST_LIB)/src/stm32f4xx_gpio.c \
        $(ST_LIB)/src/stm32f4xx_usart.c \
        $(ST_LIB)/src/stm32f4xx_tim.c\
        $(ST_LIB)/src/stm32f4xx_spi.c\
        $(ST_LIB)/src/stm32f4xx_i2c.c\
	$(ST_LIB)/src/stm32f4xx_sdio.c

#Fatfs
SRC+=./Fatfs/cc932.c\
	./Fatfs/ccsbcs.c\
	./Fatfs/diskio.c\
	./Fatfs/ff.c\
	./Fatfs/syscall.c\
	./Fatfs/unicode.c\
	./Fatfs/cc936.c\
	./Fatfs/cc949.c\
	./Fatfs/cc950.c\


#Major programs
SRC+=./Program/experiment_stm32f4.c\
	./Program/experiment_stm32f4_it.c\
	./Program/module_rs232.c\
	./Program/stm32f4_delay.c\
	./Program/stm32f4_sdio.c\
	./Program/stm32f4_system.c\
	./Program/stm32f4_usart.c

#======================================================================#
#STM32 startup file
STARTUP=./Libraries/CMSIS/startup_stm32f4xx.s

#======================================================================#
#Make rules

#Make all
all:$(BIN_IMAGE)

$(BIN_IMAGE):$(EXECUTABLE)
	$(OBJCOPY) -O binary $^ $@

STARTUP_OBJ = startup_stm32f4xx.o 

$(STARTUP_OBJ): $(STARTUP) 
	$(CC) $(CFLAGS) $^ -c $(STARTUP)

$(EXECUTABLE):$(SRC) $(STARTUP_OBJ)
	$(CC) $(CFLAGS) $^ -o $@

#Make clean
clean:
	rm -rf $(EXECUTABLE)
	rm -rf $(BIN_IMAGE)
#Make flash
flash:
	st-flash write $(BIN_IMAGE) 0x8000000

#======================================================================
.PHONY:all clean flash
