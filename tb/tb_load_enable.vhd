----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 16.04.2022 23:13:15
-- Design Name: project
-- Module Name: tb_load_enable - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Test of module load_enable.
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

entity tb_load_enable is
--  Port ( );
end tb_load_enable;

architecture Behavioral of tb_load_enable is

    constant c_CLK_100MHZ_PERIOD : time := 10 ns;
    
    -- loacal signals
    signal s_clk : STD_LOGIC;
    signal s_load : STD_LOGIC;
    signal s_reset : STD_LOGIC;
    signal s_enable_load : STD_LOGIC;
    signal s_out_reset : STD_LOGIC;  
    signal s_out_load : STD_LOGIC; 

begin

    uut_load_control: entity work.load_enable
    port map(
        clk => s_clk,
        load => s_load,
        reset => s_reset,
        enable_load => s_enable_load,
        out_reset => s_out_reset,
        out_load => s_out_load
    );
    
    -- clock generator
    p_clk_gen : process
    begin
        while now < 5000 ns loop
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
        wait for 3 ns;
        s_reset <= '0';
        wait for 40 ns;
        s_reset <= '1';
        wait for 40 ns;
        s_reset <= '0';
        wait for 40 ns;
        s_reset <= '1';
        wait;
    end process p_reset_gen;
    
    -- load signal generation
    p_load : process
    begin
        wait for 3 ns;
        s_load <= '0';
        wait for 20 ns;
        s_load <= '1';
        wait for 20 ns;
        s_load <= '0';
        wait for 20 ns;
        s_load <= '1';
        wait for 20 ns;
        s_load <= '0';
        wait for 20 ns;
        s_load <= '1';
        wait for 20 ns;
        s_load <= '0';
        wait for 20 ns;
        s_load <= '1';
        wait for 20 ns;
        wait;
    end process p_load;

    -- enable_load signal generation
    p_enabler : process
    begin
        wait for 3 ns;
        s_enable_load <= '0';
        wait for 80 ns;
        s_enable_load <= '1';
        wait;
    end process p_enabler;

end Behavioral;
