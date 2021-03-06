# Running text on 7-segment displays

### Team members

* Hana DAOVÁ, 230238
* Tomáš UCHYTIL, 230337
* David ZIMNIOK, 230354

### Table of contents

* [Project objectives](#objectives)
* [Hardware description](#hardware)
* [VHDL modules description and simulations](#modules)
* [TOP module description and simulations](#top)
* [Video](#video)
* [References](#references)

<a name="objectives"></a>

## Project objectives

The main objective of this project was creating modules which would be responsible for a running text on a 7-segment display of the Nexys A7 board. In order to achieve this goal we intended to use the UART RX module as a serial communication line between the computer and the display itself. We used the register as a memory in this communication process. Our aim was also to create an [ASCII validator](#validator) which would "translate" the 8 bit input data in ASCII format to characters from our table created to shwoing the data on 7-segment display.

![Displayed idea of the running text on 7-segment](images/7seg.gif)

<a name="hardware"></a>

## Hardware description

### Nexys A7 board

The Nexys A7 board uses the latest Artix-7™ Field Programmable Gate Array (FPGA) from Xilinx® company. The circuit contains a lot of ports such as USB or Ethernet, pins for external memories and many LEDs and switches used as simple user Input/Output. It also has several built-in components (a speaker amplifier, accelerometer, temperature sensor etc.) which makes it perfect to use for various designs. 

The board comes in 2 variants:
* Nexys A7-100T 
* Nexys A7-50T (which we are using)

The only difference between them is that the Artix-7 FPGA part in Nexys A7-100T is bigger than the one in Nexys A7-50T.

To supply the circuit, we need:
|             |Table 1: Nexys A7 power supplies.                                         |               |                     |
|-------------|-------------------------------------------------------------------------|---------------|---------------------|
|Supply	      |Circuits                                                                 |Device         |Current (max/typical)|
|3.3V	      |FPGA I/O, USB ports, Clocks, RAM I/O, Ethernet, SD slot, Sensors, Flash	|IC17: ADP2118  |3A/0.1 to 1.5A       |
|1.0V	      |FPGA Core	                                                            | IC22: ADP2118	|3A/ 0.2 to 1.3A      |
|1.8V	      |DDR2, FPGA Auxiliary and RAM                                            	|IC23: ADP2118	|0.8A/ 0.5A           |

The main power input limitation is set to 5.5VDC which is accordingly to Table 1 consecutively modified to needed supplies in the circuit.

![Nexys A7 board](images/nexys-a7-callout.png)

For our purposes, we used:
* **2**	    Power switch
* **6.**    FPGA programming done LED
* **13.**	The middle pushbutton as reset
* **18.**	The rightmost slide switch as editing text enable
* **19.**	The rightmost LED as a editing mode on indicator
* **21.**	Eight digit 7-seg display
* **25.**	Shared UART/JTAG USB port
* **27.**	Power-good LED
* **28.**	Xilinx Artix-7 FPGA


See the [full reference manual here](https://reference.digilentinc.com/reference/programmable-logic/nexys-a7/reference-manual).

<a name="modules"></a>

## VHDL modules description and simulations

### UART RX module

This module is responsible for communication with computer via serial line. For this purposes we can use implemented UART module in FPGA board. This option uses a bridge between standard USB connector which is used as power supply but also as a programmer and the UART chip. This option needs special driver installed at computer to translate UART packages to readable format for USB bridge on board.
The communication is defined by standard RS-232. For our application we set baudrate to 9600. Communication is divided to 3 phases in simplier version. First comes the start bit defined as voltage drop from logical 1 to logical 0. If there is no communication on the bus, logical 1 is on. The next bits come in as 8 bits of data coded to ASCII format from computer. The whole communication is terminated by sending stop bit - change from logical 0 to logical 1.
We used reference number 1 as inspiration and we have implemented clock enable mode instead of counting in every state. This is the best solution according to us since we have 1 module used more times in one project. 

[Source code for UART_RX module](src/UART_RX.vhd)        

[Source code for UART_RX module simulation](tb/tb_UART_RX.vhd)

#### Table with states for FSM
| placeholder | name of state | description                               |
|-------------|---------------|-------------------------------------------|
| A           | wait_state    | waiting for start bit                     |
| B           | start_bit_rec | verify start bit                          |
| C           | data_rec      | receiving data repeat 8 times (bit index) |
| D           | stop_bit_rec  | receive stop bit                          |
| E           | wait_for_end  | wait for half of period of baudrate       |

We have defined five states. What happens in every state is described in the table. Verification and sampling each data bit is done in half of the period of baud rate.

#### Transition table for FSM
| **INPUT VARIABLE** |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
|--------------------|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|
| sig_tx             | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  | 0  | 1  |
| s_co               | 0  | 0  | 1  | 1  | 0  | 0  | 1  | 1  | 0  | 0  | 1  | 1  | 0  | 0  | 1  | 1  |
| clk_count          | 0  | 0  | 0  | 0  | 1  | 1  | 1  | 1  | 0  | 0  | 0  | 0  | 1  | 1  | 1  | 1  |
| bit_index          | <7 | <7 | <7 | <7 | <7 | <7 | <7 | <7 | =7 | =7 | =7 | =7 | =7 | =7 | =7 | =7 |
| **STATE**          |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |    |
| A                  | B  | A  | B  | A  | B  | A  | B  | A  | B  | A  | B  | A  | B  | A  | B  | A  |
| B                  | B  | B  | C  | B  | B  | B  | C  | A  | B  | B  | C  | B  | B  | B  | C  | A  |
| C                  | C  | C  | C  | C  | C  | C  | C  | C  | C  | C  | D  | D  | C  | C  | D  | D  |
| D                  | D  | D  | D  | D  | D  | D  | E  | E  | D  | D  | D  | D  | D  | D  | E  | E  |
| E                  | E  | E  | A  | A  | E  | E  | A  | A  | E  | E  | A  | A  | E  | E  | A  | A  |

#### Output variables and internal signal changes for FSM
| state\out var | out_pattern | out_sig | r_on | clk_count  | bit_index   | note                                                                      |
|---------------|-------------|---------|------|------------|-------------|---------------------------------------------------------------------------|
| wait_state    | in_reg      | 0       | 1    | 0          | 0           |                                                                           |
| start_bit_rec | in_reg      | 0       | 0    | ~clk_count | 0           | at transition clk_count is set to 0 and inversion is set only if sig_tx=1 |
| data_rec      | in_reg      | 0       | 0    | ~clk_count | bit_index+1 | at transition clk_count is set to 0                                       |
| stop_bit_rec  | in_reg      | 1       | 0    | ~clk_count | 0           |                                                                           |
| wait_for_end  | in_reg      | 1       | 0    | x          | 0           |                                                                           |

Signal named as out_pattern is 8bit output of received data. Data in this register are changed continuosly, and their validity is signalized by out_sig signal. Clk_count signal is a one bit counter and at every transition is set to zero. Bit_index variable is an integer in range from 0 to 7 and points to actual position of received data. R_on signal starts local timer to count - frequency is half of baudrate.

#### Transition diagram for FSM
![Transition diagram for FSM](schematics/schematic_UART.png)

#### Receiving a non valid start bit (is shorter than excepted)
![Reset of top module](simulations/UART_RX/uartrx_recievenoise.png)
note: this situation can happen if there is some noise on serial bus or when we set wrong baud rate

#### Receiving 1 valid ASCII character with changing states
![Reset of top module](simulations/UART_RX/uartrx_recieve1ASCIIchar.png)
note: this simulation shows exact function of each state

#### Receiving 4 valid ASCII characters
![Reset of top module](simulations/UART_RX/uartrx_recieve4ASCIIchars.png)
note: this simulation shows function of receiving string (more than 1 character in one transmission)

#### Unconnected cable (logical 0 at input - continuously) and its connection
![Reset of top module](simulations/UART_RX/uartrx_unconectedcable.png)
note: this simulation shows what happens if we have continuously logical 0 at input which means that RS232 cable is unconnected, and what happens if we connect out device to the bus and set logical 1 from transimtter to indicate calm state and ready to communicate with receiver

### Circular register module
    
This module connects 8 simple PISO registers. Each register is used for one bit weight. When we initialize this circuit, all registers are filled with zeros and register at position 5 is filled with 1's. This is ASCII code for white space. Resetting the module has a similar effect. When loading data to register, we load synchronously to all 8 registers always to the same position. After this process, the stored data position index is incremented. For rotating register we use VHDL command 'ror'. This command rotates register to right. So data from 0 position will be in at position 31 (for 32 characters register).

[Source code for circular register module](src/circ_register.vhd)        

[Source code for circular register module simulation](tb/tb_circ_register.vhd)

#### Principial scheme of PISO register (1 bit weight)
![PISO register](schematics/schematic_reg.png) 

#### Normal function of register
![normal function](simulations/circ_reg/circreg_all.png)   
note: While loading, value is changed from 01hex to 22hex. This is caused by owerflow of bit index counter. So if we load more than 32 characters, register starts overwriting older data. Resetting the module causes loading white space ASCII value to all registers.

#### Detail of loading data to the register
![detail loading function](simulations/circ_reg/circreg_load.png)   
note: Loaded data are numbers from 0 to 36. When signal 'load' goes to logical 0 register starts shifting.                 

#### Detail of shifting data on the register
![detail shifting function](simulations/circ_reg/circreg_1cyc.png)     
    
### Clock enable module

Module used from computer excercises. This module simply counts up rising edges of clock signal, and when we reach number set by generic constant (could be changed from top module), circuit generates one clock long impulse which is used in another circuits for short enabling function for one clock period. So we don't need any clock divider but we generate short pulses after x clocks periods. 

[Source code for clock_enable module](src/clock_enable.vhd)        

[Source code for clock_enable module simulation](tb/tb_clock_enable.vhd)

#### Simulation of clock enable module used in top module (period is 0,5s)
![Schematic of top](simulations/clock_enable/function.png)
note: when reset is in high local, counter is set to zero and whole function of circuit is deactivated till reset reaches low value

### Load enable module

Simple sequentional circuit which we can descibe via truth table.

[Source code for load_enable module](src/load_enable.vhd)        

[Source code for load_enable module simulation](tb/tb_load_enable.vhd)

#### Truth table

| clk                             | reset | load | last_load | enable_load | last_en | out_reset | out_load |
|---------------------------------|-------|------|-----------|-------------|---------|-----------|----------|
| ![arrow](images/eq_uparrow.png) |   0   |   x  |     x     |      x      |    x    |     0     |     0    |
| ![arrow](images/eq_uparrow.png) |   1   |   x  |     x     |      x      |    x    |     1     |     0    |
| ![arrow](images/eq_uparrow.png) |   x   |   1  |     0     |      1      |    0    |     1     |     1    |
| ![arrow](images/eq_uparrow.png) |   x   |   1  |     0     |      1      |    1    |     0     |     1    |
| ![arrow](images/eq_uparrow.png) |   x   |   x  |     x     |      1      |    0    |     1     |     0    |
| ![arrow](images/eq_uparrow.png) |   x   |   x  |     x     |      1      |    1    |     0     |     0    |

#### Simulation of work
![simulation of work](simulations/load_enabler/load_enabler.png) 
note: another states are impossible due to output combinations and another circuits combinational logics

<a name="validator"></a>

### ASCII validator module

Module test with clock signal validity of ASCII character and if the character exists in our table created for decode binary data to 7-segment display signals. Module is created also to identify uppercase letters and to convert lowercase to uppercase. It can recognize numbers, dot, comma, question mark, exclation mark and white space too. Other characters are filtered out. The validity is shown by load signal at output. If bit array is valid signal will go to logic one and copy load signal from UART_RX. If not signal will be at 0. 

[Source code for ASCII validator module](src/ASCII_validator.vhd)        

[Source code for ASCII validator module simulation](tb/tb_ASCII_validator.vhd)

#### Simulation of work
![simulation of work](simulations/ASCII_validator/ascii_validator.png) 

### Display driver module

When enable signal is present, module takes input value, shifts previous values to left and discards leftmost one. Then input value is converted to 7-seg code. When no value is currently being received, it multiplexes and updates all 8 digits.

[Source code for display driver module](src/driver_7seg_8digits.vhd)

#### Simulation of work
![simulation of work](simulations/display_driver/display_driver_testbench_result.png)

[Source code for display driver module simulation](tb/tb_display_driver.vhd)

<a name="top"></a>

## TOP module description and simulations

Top module was divided to two parts. First part is responsible for data storing to register from serial input and for shifting register operations. At the output of this module are 8 bits representing ASCII character. Second part is responsible for communication with 7-segment display.

![Schematic of top](schematics/schematic_top.png)

[Source code for top module](src/top.vhd)

[Constraints file](src/nexys-a7-50t.xdc)

### Part of top responsible for data operations

This part was created from module of circular register (responsible for storing data), UART_RX module (responsible for communication with computer via RS232 line) - this module has own clock divider set to speed 9600 bauds, clock_enable module (clock for shifting register defining when register shifts data to left) and load_enable module (responsible for elimination of unwanted states as reset during loading data). For more information about function of these modules please see [VHDL modules description and simulations](#modules). In this caption you also can find source codes and simulations of each modules.  

[Source code for simulations below](tb/tb_data_top.vhd)

#### Loading data without enabling it by hardware switch
![Load data without enable](simulations/top/top_loadwithoutenable.png)
note: If you don't enable the loading, data are not stored to the register. This is secured by load_enable module. In this mode reset is passed to the reset inputs of each modules. 

#### Loading data with enabling it by hardware switch
![Load dat with enable](simulations/top/top_loadwithenable.png)
note: After enabling data storing data at serial input are loaded to the register. When this switch is in the on position all reset signals are supressed. At the out pattern from register is the first ASCII char and shifting of the register is not interrupted. For loading data this is not problem because counter of bit index is not connected with shifting. Before loading data for loading from zero position is recommended reset of circuit, but this is provided by load_enabler. 

#### Reseting the circuit
![Reset of top module](simulations/top/top_reset.png)
note: When reset is pressed and load mode is disabled, all registers (memory) are set to the ASCII char of white space. 

#### Complete function of the circuit
![Whole function of data part of top](simulations/top/top_function.png)
note: After storing the data to the register data are shifted on the output pattern controlled by ce signal from clock_enable module every 500ms.

### Final version of top
On real hardware we have noticed some problems with loading data via serial line. We have tried many options as flipping bit order or remove some modules. Unfortunately the problem is in UART module. Since we were not able to find the mistake without osciloscope and proper data analysis, it was impossible for is to fix it all till the deadline. We could say, that the problem may be in timing or in data acquisition in FSM. Because this is not main topic of our project, and proper function was confirmed via simulations in final version, we filled data register with static data. However for proper function we need only serial data stream, so the module could be easily replaced with debugged module from another application.

<a name="video"></a>

## Video

Link to our video-presentation of this project: [https://www.youtube.com/watch?v=ChD-Qw4JAwo](https://www.youtube.com/watch?v=ChD-Qw4JAwo)

<a name="references"></a>

## References

1. Merrick, R. (2018, December 22). UART, serial port, RS-232 interface. UART in VHDL and Verilog for an FPGA. Retrieved April 18, 2022, from [https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html](https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html) 
2. Frýza, T. (2018). Template for 7-segment display decoder. 7-segment display decoder. Retrieved April 18, 2022, from [https://www.edaplayground.com/x/Vdpu](https://www.edaplayground.com/x/Vdpu) 
3. Wikimedia Foundation. (2022, February 14). RS-232. Wikipedia. Retrieved April 18, 2022, from [https://en.wikipedia.org/wiki/RS-232](https://en.wikipedia.org/wiki/RS-232)
4. Letterising the Seven Segment Display – fyr.io. (2018, March 8). Fyr.Io. Retrieved April 19, 2022, from [https://fyr.io/2018/03/08/letterising-the-seven-segment-display](https://fyr.io/2018/03/08/letterising-the-seven-segment-display/)
5. Nexys A7™ FPGA Board Reference Manual - DIGILENT (2019, July 10). DIGILENT refference. Retrieved May 4, 2022, from [https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual) 
