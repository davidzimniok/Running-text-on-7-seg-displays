----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 13.04.2022 17:59:33
-- Design Name: project
-- Module Name: tb_circ_register - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Project is modified for running text on LCD display with HD44780.
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

entity tb_circ_register is
--  Port ( );
end tb_circ_register;

architecture testbench of tb_circ_register is

    -- local constant
    constant c_CLK_100MHZ_PERIOD : time := 10 ns;
    
    -- loacal signals
    signal s_clk : STD_LOGIC;
    signal s_load : STD_LOGIC;
    signal s_reset : STD_LOGIC;
    signal s_i_pattern : STD_LOGIC_VECTOR (7 downto 0);
    signal s_o_pattern : STD_LOGIC_VECTOR (7 downto 0);  

begin

    uut_circ_register: entity work.circ_register
    port map(
        clk => s_clk,
        ce => '1', -- for simplier simulation
        load => s_load,
        reset => s_reset,
        i_pattern => s_i_pattern,
        o_pattern => s_o_pattern
    );

    p_clk_gen : process
    begin
        while now < 750 ns loop -- 75 periods of 100MHz clock
            s_clk <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;
    
   p_reset_gen : process
    begin
        s_reset <= '1';
        wait for 2 ns;
        s_reset <= '0';
        wait;
    end process p_reset_gen;
    
    p_stimulus : process
    begin
        wait for 2 ns;
        s_i_pattern <= "00000001";
        s_load <= '1';
        wait for 10 ns;
        s_i_pattern <= "00000010";
        wait for 10 ns;
        s_i_pattern <= "00000011";
        wait for 10 ns;
        s_i_pattern <= "00000100";
        wait for 10 ns;
        s_i_pattern <= "00000101";
        wait for 10 ns;
        s_i_pattern <= "00000110";
        wait for 10 ns;
        s_i_pattern <= "00000111";
        wait for 10 ns;
        s_i_pattern <= "00001000";
        wait for 10 ns;
        s_i_pattern <= "00001001";
        wait for 10 ns;
        s_i_pattern <= "00001010";
        wait for 10 ns;
        s_i_pattern <= "00001011";
        wait for 10 ns;
        s_i_pattern <= "00001100";
        wait for 10 ns;
        s_i_pattern <= "00001101";
        wait for 10 ns;
        s_i_pattern <= "00001110";
        wait for 10 ns;
        s_i_pattern <= "00001111";
        wait for 10 ns;
        s_i_pattern <= "00010000";
        wait for 10 ns;
        s_i_pattern <= "00010001";
        wait for 10 ns;
        s_i_pattern <= "00010010";
        wait for 10 ns;
        s_i_pattern <= "00010011";
        wait for 10 ns;
        s_i_pattern <= "00010100";
        wait for 10 ns;
        s_i_pattern <= "00010101";
        wait for 10 ns;
        s_i_pattern <= "00010111";
        wait for 10 ns;
        s_i_pattern <= "00011000";
        wait for 10 ns;
        s_i_pattern <= "00011001";
        wait for 10 ns;
        s_i_pattern <= "00011010";
        wait for 10 ns;
        s_i_pattern <= "00011011";
        wait for 10 ns;
        s_i_pattern <= "00011100";
        wait for 10 ns;
        s_i_pattern <= "00011101";
        wait for 10 ns;
        s_i_pattern <= "00011110";
        s_load <= '1';
        wait for 10 ns;
        s_i_pattern <= "00011111";
        wait for 10 ns;
        s_i_pattern <= "00100000";
        wait for 10 ns;
        s_i_pattern <= "00100001";
        wait for 10 ns;
        s_i_pattern <= "00100010";
        wait for 10 ns;
        s_i_pattern <= "00100011";
        wait for 10 ns;
        s_i_pattern <= "00100100";
        wait for 10 ns;
        s_load <= '0';
        wait for 10 ns;
        wait;
    end process p_stimulus;
    



end testbench;

