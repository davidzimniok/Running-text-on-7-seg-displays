# Running text on 7-seg displays (after consultation modified to LCD display)

### Team members

* Hana DAOVÁ, 230238 (responsible for xxx)
* Tomáš UCHYTIL, 230337 (responsible for LCD driver)
* David ZIMNIOK, 230354 (responsible for comumnication with PC and data register)

### Table of contents

* [Project objectives](#objectives)
* [Hardware description](#hardware)
* [VHDL modules description and simulations](#modules)
* [TOP module description and simulations](#top)
* [Video](#video)
* [References](#references)

<a name="objectives"></a>

## Project objectives

Write your text here.

<a name="hardware"></a>

## Hardware description

Write your text here.

<a name="modules"></a>

## VHDL modules description and simulations

###UART RX module
This module is responsible for comunication with computer via serial line. For this purposes we can use implemented UART module in FPGA board. This option uses UART bridge between standard USB connector which is used as power suply but also as a programmer. This option needs installed special driver at computer to translate UART packages to readable format for USB bridge on board. We wanted something more universal, what could work with standard serial port. So we have found circuit MAX232 (see [Hardware description](#hardware)). 
The comunication is defined by standard RS-232. For our aplication we set baudrate to 115200. Comunication is divided to 3 phases in simplier version. First cames start bit defined as voltage drop from logical 1 to logical 0. When there is no communication on the bus we can measure logical 1. After start bit cames 8 bits of data coded to ASCII format from computer. Communication is terminated by sending stop bit - change from logical 0 to logical 1.
Because this communiction is periodical, only transmitted data are different, the best soulution is to implement finite state machine.  

**table with states for FSM**
| placeholder | name of state | description                               |
|-------------|---------------|-------------------------------------------|
| A           | wait_state    | waiting for start bit                     |
| B           | start_bit_rec | verify start bit                          |
| C           | data_rec      | recieving data repeat 8 times (bit index) |
| D           | stop_bit_rec  | recieve stop bit                          |
| E           | wait_for_end  | wait for half of period of baudrate       |

**transition table for FSM**
| **INPUT VARIABLE** |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|--------------------|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|
| sig_tx             | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  |
| s_co               | 0  | 0  | 1  | 1  | 0  | 0  | 1  | 1  | 0  | 0  | 1  | 1  | 0  | 0  | 1  | 1  |
| clk_count          | 0  | 0  | 0  | 0  | 1  | 1  | 1  | 1  | 0  | 0  | 0  | 0  | 1  | 1  | 1  | 1  |
| bit_index          | <7 | <7 | <7 | <7 | <7 | <7 | <7 | <7 | =7 | =7 | =7 | =7 | =7 | =7 | =7 | =7 |
| **STATE**          |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
| A                  | B  | A  | B  | A  | B  | A  | B  | A  | B  | A  | B  | A  | B  | A  | B  | A  |
| B                  | B  | B  | C  | A  | B  | B  | C  | A  | B  | B  | C  | A  | B  | B  | C  | A  |
| C                  | C  | C  | C  | C  | C  | C  | C  | C  | D  | D  | D  | D  | D  | D  | D  | D  |
| D                  | D  | D  | D  | D  | D  | D  | E  | E  | D  | D  | D  | D  | D  | D  | E  | E  |
| E                  | E  | E  | A  | A  | E  | E  | A  | A  | E  | E  | A  | A  | E  | E  | A  | A  |

**output variables and internal signal changes for FSM**
| state\out var | out_pattern | out_sig | r_on | clk_count  | bit_index   | note                                                                      |
|---------------|-------------|---------|------|------------|-------------|---------------------------------------------------------------------------|
| wait_state    | in_reg      | 0       | 1    | 0          | 0           |                                                                           |
| start_bit_rec | in_reg      | 0       | 0    | ~clk_count | 0           | at transition clk_count is set to 0 and inversion is set only if sig_tx=1 |
| data_rec      | in_reg      | 0       | 0    | ~clk_count | bit_index+1 | at transition clk_count is set to 0                                       |
| stop_bit_rec  | in_reg      | 1       | 0    | ~clk_count | 0           |                                                                           |
| wait_for_end  | in_reg      | 1       | 0    | x          | 0           |                                                                           |

###Circular register module

###Clock enable module

###Load enable module

<a name="top"></a>

## TOP module description and simulations

Top module was divided to two parts. First part is responsible for data storing to register from serial input and for shifting register operations. At the output of this module are 8 bits representing ASCII character. Second part is responsible for comunication with LCD driver (Hitachi HD44780 or simillar). 

### Part of top responsible for data operations

This part was created from module of circular register (responsible for storing data), UART_RX module (responsible for comunication with computer via RS232 line) - this module have own clock divider set to speed 115200 bauds, clock_enable module (clock for shifting register defining when rester shifts data to left) and load_enable module (responsible for elimination of unwanted states as reset during loading data). For more information about function of these modules please see [VHDL modules description and simulations](#modules). In this caption you also can find source codes and simulations of each modules.  

**Connection diagram**
![Schematic of top](schematics/schematic_top.png)

**Loading data without enabling it by hardware switch**
![Schematic of top](simulations/top/top_loadwithoutenable.png)
note: If you don't enable loading data are not stored to the register. This is secured by load_enable module. In this mode reset is passed to the reset inputs of each modules. 

**Loading data with enabling it by hardware switch**
![Schematic of top](simulations/top/top_loadwithenable.png)
note: After enabling data storing data at serial input are loaded to the register. When this switch is in the on position all reset signals are supressed. At the out pattern from register is the first ASCII char and shifting of the register is not interupted. For loading data this is not problem because counter of bit index is not connected with shifting. Before loading data for loading from zero position is recomended reset of circuit, but this is provided by load_enabler. 

**Reseting the circuit**
![Schematic of top](simulations/top/top_reset.png)
note: When reset is pressed and load mode is disabled, all registers (memory) is set to the ASCII char of white space. 

**Complete function of the circuit**
![Schematic of top](simulations/top/top_function.png)
note: After storing the data to the register data are shifted on the output pattern controlled by ce signal from clock_enable module every 500ms.

<a name="video"></a>

## Video

Write your text here

<a name="references"></a>

## References

1. Merrick, R. (2018, December 22). UART, serial port, RS-232 interface. UART in VHDL and Verilog for an FPGA. Retrieved April 18, 2022, from https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html 
2. Frýza, T. (2018). Template for 7-segment display decoder. 7-segment display decoder. Retrieved April 18, 2022, from https://www.edaplayground.com/x/Vdpu 
3. Wikimedia Foundation. (2022, February 14). RS-232. Wikipedia. Retrieved April 18, 2022, from https://en.wikipedia.org/wiki/RS-232 
