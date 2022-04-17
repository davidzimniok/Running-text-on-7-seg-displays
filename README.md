# Running text on 7-seg displays (after consultation modified to LCD display)

### Team members

* Hana DAOVÁ, 230238 (responsible for xxx)
* Tomáš UCHYTIL, 230337 (responsible for LCD driver)
* David ZIMNIOK, 230354 (responsible for comunication with PC and data register)

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

Write your text here.

<a name="top"></a>

## TOP module description and simulations

Top module was divided to two parts. First part is responsible for data storing to register from serial input and for shifting register operations. At the output of this module are 8 bits representing ASCII character. Second part is responsible for comunication with LCD driver (Hitachi HD44780 or simillar). 

### Part of top responsible for data operations

![Schematic of top](schematics/schematic_top.png)

<a name="video"></a>

## Video

Write your text here

<a name="references"></a>

## References

1. Write your text here.