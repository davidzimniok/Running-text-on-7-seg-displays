----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2022 15:41:02
-- Design Name: 
-- Module Name: tb_clock_enable - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_clock_enable is
--  Port ( );
end tb_clock_enable;

architecture Behavioral of tb_clock_enable is

    constant c_CLK_100MHZ_PERIOD : time := 10 ns;

    signal s_clk : STD_LOGIC;
    signal s_ce_o : STD_LOGIC;
    signal s_reset : STD_LOGIC;

begin
    
    uut_clock_control: entity work.clock_enable
    generic map(
        g_MAX => 50000000
    )
    port map(
        clk => s_clk,
        reset => s_reset,
        ce_o => s_ce_o
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
        wait for 3 ns;
        s_reset <= '0';
        wait for 1500 ms;
        s_reset <= '1';
        wait for 10 ms;
        s_reset <= '0';
        wait;
    end process p_reset_gen;


end Behavioral;
