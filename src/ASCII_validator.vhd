----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 04/20/2022 01:53:53 PM
-- Design Name: project
-- Module Name: ASCII_validator - Behavioral
-- Module Name: UART_RX - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Validate if character is in table used for conversion from char to 7seg signals
--
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ASCII_validator is
    Port ( clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           in_pattern : in STD_LOGIC_VECTOR (7 downto 0);
           out_pattern : out STD_LOGIC_VECTOR (7 downto 0);
           load : out STD_LOGIC);
end ASCII_validator;

architecture Behavioral of ASCII_validator is

begin

    validator: process(clk)
    variable loaded_data : integer := 0;
    begin
        if ce = '1' then
            -- convert ascii binary data to decimal number
            loaded_data := to_integer(unsigned(in_pattern));
	    -- check if letter on input is capital letter
            if (loaded_data < 91) and (loaded_data > 64) then
                out_pattern <= std_logic_vector(to_unsigned(loaded_data,out_pattern'length));
                load <= '1';
	    -- check if letter on input is lowercase and then conver to uppercase
            elsif (loaded_data < 123) and (loaded_data > 96) then
                loaded_data := loaded_data - 32;
                out_pattern <= std_logic_vector(to_unsigned(loaded_data,out_pattern'length));
                load <= '1';
	    -- check if on input is dot, question mark, space, exclamation mark or comma
            elsif (loaded_data = 33) or (loaded_data = 63) or (loaded_data = 46) or (loaded_data = 44) or (loaded_data = 32) then
                out_pattern <= std_logic_vector(to_unsigned(loaded_data,out_pattern'length));
                load <= '1';
	    -- check if on input is number character
            elsif (loaded_data < 58) and (loaded_data > 47) then
                out_pattern <= std_logic_vector(to_unsigned(loaded_data,out_pattern'length));
                load <= '1';
            else
                load <= '0';
            end if;
        else
            load <= '0';
        end if;
    end process validator;

end Behavioral;
