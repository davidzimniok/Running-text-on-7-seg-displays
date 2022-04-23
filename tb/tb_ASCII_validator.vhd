----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 21.04.2022 13:57:43
-- Design Name: project
-- Module Name: tb_ASCII_validator - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Testbench created for test function of ASCII validator.
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

entity tb_ASCII_validator is
--  Port ( );
end tb_ASCII_validator;

architecture testbench of tb_ASCII_validator is

    -- local constant
    constant c_CLK_100MHZ_PERIOD : time := 10 ns;
    
    -- loacal signals
    signal s_clk : STD_LOGIC;
    signal s_load : STD_LOGIC;
    signal s_i_pattern : STD_LOGIC_VECTOR (7 downto 0);
    signal s_o_pattern : STD_LOGIC_VECTOR (7 downto 0);  

begin

    uut_validator: entity work.ASCII_validator
    port map(
        clk => s_clk,
        ce => '1', -- for simplier simulation circuit reacts to every clk signal
        in_pattern => s_i_pattern,
        out_pattern => s_o_pattern,
        load => s_load
    );
    
    -- clock generator
    p_clk_gen : process
    begin
        while now < 10000 ms loop
            s_clk <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
    -- fill register with data
    p_stimulus : process
    begin
        wait for 5 ns;
        s_i_pattern <= "00100000";  --space
        wait for 30 ns;
        s_i_pattern <= "00100110";  --ampersand
        wait for 30 ns;
        s_i_pattern <= "00100000";  --space
        wait for 30 ns;
        s_i_pattern <= "00101110";  --dot
        wait for 30 ns;
        s_i_pattern <= "00101100"; -- comma
        wait for 30 ns;
        s_i_pattern <= "00100001"; -- exclamation mark
        wait for 30 ns;
        s_i_pattern <= "00111111"; -- question mark
        wait for 30 ns;
        s_i_pattern <= "00111011"; -- semicolon
        wait for 30 ns;
        s_i_pattern <= "00110000"; -- zero
        wait for 30 ns;
        s_i_pattern <= "00111001"; -- nine
        wait for 30 ns;
        s_i_pattern <= "01000001"; -- capital A
        wait for 30 ns;
        s_i_pattern <= "01011010"; -- capital Z
        wait for 30 ns;
        s_i_pattern <= "01100001"; -- a
        wait for 30 ns;
        s_i_pattern <= "01111010"; -- z
        wait for 30 ns;
        wait;
    end process p_stimulus;


end testbench;
