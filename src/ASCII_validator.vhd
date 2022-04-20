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

signal loaded_data : integer;

begin

    validator: process(clk, ce)
    begin
        if rising_edge(clk) then
            if ce = '1' then
                -- convert ascii binary data to decimal number
                loaded_data <= to_integer(unsigned(in_pattern));
                if (loaded_data < 91) and (loaded_data > 64) then
                    out_pattern <= std_logic_vector(to_unsigned(loaded_data,out_pattern'length));
                    load <= '1';
                elsif (loaded_data < 123) and (loaded_data > 96) then
                    loaded_data <= loaded_data - 32;
                    out_pattern <= std_logic_vector(to_unsigned(loaded_data,out_pattern'length));
                    load <= '1';
                elsif (loaded_data = 33) or (loaded_data = 63) or (loaded_data = 46) or (loaded_data = 44) or (loaded_data = 32) then
                    loaded_data <= loaded_data;
                    out_pattern <= std_logic_vector(to_unsigned(loaded_data,out_pattern'length));
                    load <= '1';
                elsif (loaded_data < 47) and (loaded_data > 58) then
                    loaded_data <= loaded_data;
                    out_pattern <= std_logic_vector(to_unsigned(loaded_data,out_pattern'length));
                    load <= '1';
                else
                    load <= '0';
                end if;
            else
                load <= '0';
            end if;
        end if;
    end process validator;

end Behavioral;
