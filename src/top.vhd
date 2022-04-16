----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 14.04.2022 16:50:38
-- Design Name: project
-- Module Name: top - Behavioral
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

entity top is
    Port ( CLK_100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           JA : in STD_LOGIC;
           SW : in STD_LOGIC;
           LED : out STD_LOGIC_VECTOR(7 downto 0));
end top;

architecture Behavioral of top is

signal shift : STD_LOGIC;                           -- frequency of shifting 
signal c_load : STD_LOGIC;                          -- command to load data
signal pattern : STD_LOGIC_VECTOR(7 downto 0);      -- pattern loaded by serial input
signal p_load : STD_LOGIC;                          -- processed load signal
signal p_reset : STD_LOGIC;                         -- processed reset signal

begin

    -- Clock enabling for shifting command for register div factor is calculated 100e6*time between 2 shifts. - 0.5s = 50000000
    clk_shift : entity work.clock_enable
    generic map(
        g_MAX => 50000000
    )
    port map(
        clk   => CLK_100MHZ,
        reset => p_reset,
        ce_o  => shift
    );
    
    circular_register : entity work.circ_register
    port map(
        clk => CLK_100MHZ,
        ce => shift,
        load => p_load,
        reset => p_reset,
        i_pattern => pattern,
        o_pattern(0) => LED(0),
        o_pattern(1) => LED(1),
        o_pattern(2) => LED(2),
        o_pattern(3) => LED(3),
        o_pattern(4) => LED(4),
        o_pattern(5) => LED(5),
        o_pattern(6) => LED(6),
        o_pattern(7) => LED(7)
    );
        
    uart_reciever : entity work.UART_RX
    port map(
        clk => CLK_100MHZ,
        sig_tx => JA,
        out_pattern => pattern,
        out_sig => c_load
    );
    
    load_enabler : entity work.load_enable
    port map(
        clk => CLK_100MHZ,
        reset => BTNC,
        enable_load => SW,
        load => c_load,
        out_reset => p_reset,
        out_load => p_load
    );

end Behavioral;
