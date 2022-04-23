----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 14.04.2022 16:50:38
-- Design Name: project
-- Module Name: data_top - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Connection between data register and UART module.
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

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           UART_TXD_IN : in STD_LOGIC;
           UART_RXD_OUT : out STD_LOGIC;
           SW : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR(7 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0));
end top;

architecture Behavioral of top is

signal shift : STD_LOGIC;                           -- frequency of shifting 
signal c_load : STD_LOGIC;                          -- command to load data
signal c_load2 : STD_LOGIC;                         -- command to load data after validation
signal pattern : STD_LOGIC_VECTOR(7 downto 0);      -- pattern loaded by serial input
signal p_load : STD_LOGIC;                          -- processed load signal
signal p_reset : STD_LOGIC;                         -- processed reset signal
signal p_pattern : STD_LOGIC_VECTOR(7 downto 0);    -- processed pattern loaded by serial input
signal out_pattern : STD_LOGIC_VECTOR(7 downto 0);    -- processed pattern loaded by serial input

begin

    -- Clock enabling for shifting command for register div factor is calculated 100e6*time between 2 shifts. - 0.5s = 50000000
    clk_shift : entity work.clock_enable
    generic map(
        g_MAX => 50000000
    )
    port map(
        clk   => CLK100MHZ,
        reset => p_reset,
        ce_o  => shift
    );
    
    circular_register : entity work.circ_register
    port map(
        clk => CLK100MHZ,
        ce => shift,
        load => p_load,
        reset => p_reset,
        i_pattern => p_pattern,
        o_pattern => out_pattern
    );
        
    uart_reciever : entity work.UART_RX
    port map(
        clk => CLK100MHZ,
        sig_tx => UART_TXD_IN,
        out_pattern => pattern,
        out_sig => c_load
    );
    
    load_enabler : entity work.load_enable
    port map(
        clk => CLK100MHZ,
        reset => BTNC,
        enable_load => SW,
        load => c_load2,
        out_reset => p_reset,
        out_load => p_load
    );
    
    ascii_validate : entity work.ASCII_validator
    port map(
        clk => CLK100MHZ,
        ce => c_load,
        in_pattern => pattern,
        out_pattern => p_pattern,
        load => c_load2
    );
    
    driver_seg_8 : entity work.driver_7seg_8digits
      port map(
          clk        => CLK100MHZ,
          reset      => p_reset
          enable => shift,
          data_i => character'val(out_pattern),

          seg_o(6) => CA,-- MAP DECIMAL POINT AND DISPLAY SEGMENTS
          seg_o(5) => CB,
          seg_o(4) => CC,
          seg_o(3) => CD,
          seg_o(2) => CE,
          seg_o(1) => CF,
          seg_o(0) => CG,
          dig_o => AN
      );
    
    UART_RXD_OUT <= UART_TXD_IN;

end Behavioral;
