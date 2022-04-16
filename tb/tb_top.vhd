----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 16.04.2022 23:31:36
-- Design Name: project
-- Module Name: tb_top - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Testbench for top module.
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

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is

constant c_CLK_100MHZ_PERIOD : time := 10 ns;
signal s_clk : STD_LOGIC;
signal s_reset : STD_LOGIC;
signal s_in : STD_LOGIC;
signal s_en : STD_LOGIC;

begin

    uut_top : entity work.top
    port map(
        CLK_100MHZ => s_clk,
        BTNC => s_reset,
        JA => s_in,
        SW => s_en
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
    
   -- reset signal generation
   p_reset_gen : process
    begin
        s_reset <= '1';
        wait for 5 us;
        s_reset <= '0';
        wait for 1.5 ms;
        s_reset <= '1';
        wait for 1 ms;
        s_reset <= '0';
        wait;
    end process p_reset_gen;

   -- enable signal generation
   p_enable_gen : process
    begin
        s_en <= '0';
        wait for 5 us;
        s_en <= '1';
        wait for 1.2 ms;
        s_en <= '0';
        wait;
    end process p_enable_gen;
 
    -- simulation of serial comunication for baudrate 115200 is T=8.681us
    p_stimulus : process
    begin
        s_in <= '1'; -- nothing at input (RS-232)
        wait for 10 us;
        s_in <= '0'; -- noise at input wire (non valid start bit)
        wait for 2 us;
        s_in <= '1';
        wait for 10 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '0'; -- send V in ascii (01010110) first LSB
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '0'; -- send H in ascii (01001000) first LSB
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '0'; -- send D in ascii (01000100) first LSB
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '0'; -- send L in ascii (01001100) first LSB
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '0'; -- send ' ' in ascii (001000000) first LSB
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '0'; -- send P in ascii (01010000) first LSB
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '0'; -- send R in ascii (01010010) first LSB
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '1'; -- send O in ascii (01001111) first LSB
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '0'; -- send J in ascii (01001010) first LSB
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '1'; -- send E in ascii (01000101) first LSB
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '1'; -- send C in ascii (01000011) first LSB
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        s_in <= '0'; -- valid start bit
        wait for 8.681 us;
        s_in <= '0'; -- send T in ascii (01010100) first LSB
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; 
        wait for 8.681 us;
        s_in <= '0'; 
        wait for 8.681 us;
        s_in <= '1'; -- stop bit 
        wait for 8.681 us;
        wait;
    end process p_stimulus;

end Behavioral;
