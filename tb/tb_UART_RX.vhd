----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 16.04.2022 20:38:23
-- Design Name: project
-- Module Name: tb_UART_RX - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Testbench created for test function of recieving UART signals.
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

entity tb_UART_RX is
--  Port ( );
end tb_UART_RX;

architecture testbench of tb_UART_RX is

    -- local constant
    constant c_CLK_100MHZ_PERIOD : time := 10 ns;
    
    -- loacal signals
    signal s_clk : STD_LOGIC;
    signal s_in : STD_LOGIC;
    signal s_out_pattern : STD_LOGIC_VECTOR (7 downto 0);
    signal s_out_sig : STD_LOGIC;  

begin
    
    uut_uart_rx_module : entity work.UART_RX
    port map(
        clk => s_clk,
        sig_tx => s_in,
        out_pattern => s_out_pattern,
        out_sig => s_out_sig    
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
        wait;
    end process p_stimulus;
    
end testbench;
