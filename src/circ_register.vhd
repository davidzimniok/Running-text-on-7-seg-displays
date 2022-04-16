----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 13.04.2022 17:05:28
-- Design Name: project
-- Module Name: circ_register - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Circular register used for storing data for display.
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

entity circ_register is
    Port ( clk : in STD_LOGIC;                                  -- main clock synchronization
           ce : in STD_LOGIC;                                   -- clock enable used for slow down the function
           load : in STD_LOGIC;                                 -- signal used for loading data
           reset : in STD_LOGIC;                                -- reset signal for delete all data from registers
           i_pattern : in STD_LOGIC_VECTOR (7 downto 0);        -- input pattern - one letter in 8 bits
           o_pattern : out STD_LOGIC_VECTOR (7 downto 0));      -- output patter for display driver
end circ_register;

architecture Behavioral of circ_register is

-- define signals representig paralel registers with recieved data default size is 25
signal temp0: UNSIGNED(31 downto 0) := (others => '0');
signal temp1: UNSIGNED(31 downto 0) := (others => '0');
signal temp2: UNSIGNED(31 downto 0) := (others => '0');
signal temp3: UNSIGNED(31 downto 0) := (others => '0');
signal temp4: UNSIGNED(31 downto 0) := (others => '0');
signal temp5: UNSIGNED(31 downto 0) := (others => '1');
signal temp6: UNSIGNED(31 downto 0) := (others => '0');
signal temp7: UNSIGNED(31 downto 0) := (others => '0');
-- signal for saving data to register (position of actual data bit)
signal s_cnt_local : UNSIGNED(4 downto 0) := (others => '0');

begin

-- process with clk and reset on sensitivity list controlling register shift
process(clk, reset)
    begin
        if reset='1' then                   -- reset all registers to 0s
            temp0 <= (others => '0');
            temp1 <= (others => '0');
            temp2 <= (others => '0');
            temp3 <= (others => '0');
            temp4 <= (others => '0');
            temp5 <= (others => '1');
            temp6 <= (others => '0');
            temp7 <= (others => '0');
            s_cnt_local <= (others => '0');
        end if;
        if rising_edge(clk) then
            if load='1' then            -- load data to register
                temp0(TO_INTEGER(s_cnt_local)) <= i_pattern(0);
                temp1(TO_INTEGER(s_cnt_local)) <= i_pattern(1);
                temp2(TO_INTEGER(s_cnt_local)) <= i_pattern(2);
                temp3(TO_INTEGER(s_cnt_local)) <= i_pattern(3);
                temp4(TO_INTEGER(s_cnt_local)) <= i_pattern(4);
                temp5(TO_INTEGER(s_cnt_local)) <= i_pattern(5);
                temp6(TO_INTEGER(s_cnt_local)) <= i_pattern(6);
                temp7(TO_INTEGER(s_cnt_local)) <= i_pattern(7);       
                s_cnt_local <= s_cnt_local + 1;          
            elsif ce='1' then
                -- rotate registers to left
                temp0 <= temp0 ror 1;
                temp1 <= temp1 ror 1;
                temp2 <= temp2 ror 1;
                temp3 <= temp3 ror 1;
                temp4 <= temp4 ror 1;
                temp5 <= temp5 ror 1;
                temp6 <= temp6 ror 1;
                temp7 <= temp7 ror 1;
            end if;
        end if;
end process;

-- connect first bit of register to output of circuit
o_pattern(0) <= temp0(0);
o_pattern(1) <= temp1(0);
o_pattern(2) <= temp2(0);
o_pattern(3) <= temp3(0);
o_pattern(4) <= temp4(0);
o_pattern(5) <= temp5(0);
o_pattern(6) <= temp6(0);
o_pattern(7) <= temp7(0);

end Behavioral;