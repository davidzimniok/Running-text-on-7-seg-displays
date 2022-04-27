------------------------------------------------------------
--
-- 8-digit 7-segment display driver testbench.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2022-Present Tomas Uchytil
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------
entity tb_driver_7seg_8digits is
    -- Entity of testbench is always empty
end entity tb_driver_7seg_8digits;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------
architecture testbench of tb_driver_7seg_8digits is

    -- Local constants
    constant c_CLK_100MHZ_PERIOD : time := 10 ns;

    -- Local signals
    signal s_clk_100MHz : std_logic;
    signal s_reset : std_logic;
    signal s_en : std_logic;
    -- ADD OTHER SIGNALS ACCORDING TO DRIVER_7SEG_4DIGITS ENTITY
    signal s_data_i : character;
    signal s_seg_o   : std_logic_vector(6 downto 0);
    signal s_dig_o   : std_logic_vector(7 downto 0);
begin
    -- Connecting testbench signals with driver_7seg_4digits
    -- entity (Unit Under Test)
    -- MAP I/O PORTS FROM ENTITY TO LOCAL SIGNALS
    uut_driver_7seg_8digits : entity work.driver_7seg_8digits
        port map(
            clk => s_clk_100MHz,
            reset => s_reset,
            data_i => s_data_i,
            seg_o => s_seg_o,
            dig_o => s_dig_o,
            enable => s_en
        );

    --------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 7500 ns loop -- 75 periods of 100MHz clock
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    --------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------
    -- WRITE YOUR CODE HERE AND ACTIVATE RESET FOR A WHILE
    p_reset_gen : process
    begin
        s_reset <= '0';
        wait for 28 ns;
        
        s_reset <='1';
        wait for 153 ns;
        
        s_reset <= '0';
        
        wait;
    
    end process p_reset_gen;
    --------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------
    -- WRITE YOUR CODE HERE AND TEST INPUT VALUE "3.142"
    p_stimulus : process
    begin
    wait for 80 ns;
    s_data_i <= 'T';	
    s_en <= '1';
    wait for 10 ns;
    s_en <= '0';
    wait for 300 ns;
    s_data_i <= 'T';	
    s_en <= '1';
    wait for 10 ns;
    s_en <= '0';
    wait for 500 ns;
    s_data_i <= 'E';
    s_en <= '1';
    wait for 10 ns;
    s_en <= '0';
    wait for 500 ns;
    s_data_i <= 'S';
    s_en <= '1';
    wait for 8 ns;
    s_en <= '0';
    wait for 500 ns;
    s_data_i <= 'T';
    s_en <= '1';
    wait for 10 ns;
    s_en <= '0';
    
    report "stimulus process finished" severity note;
    wait;
    end process p_stimulus;

end architecture testbench;
