----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 16.04.2022 23:02:13
-- Design Name: project
-- Module Name: load_enable - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Control load mode.
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

entity load_enable is
    Port ( clk : in STD_LOGIC;          -- master clock
           reset : in STD_LOGIC;        -- reset signal from hardware input
           enable_load : in STD_LOGIC;  -- enable load mode from hardware input
           load : in STD_LOGIC;         -- load signal from UART input
           out_reset : out STD_LOGIC;   -- processed reset signla
           out_load : out STD_LOGIC);   -- processed load signal
end load_enable;

architecture Behavioral of load_enable is

signal last_load : STD_LOGIC := '0';
signal last_en : STD_LOGIC := '0';

begin

process(clk)
begin
    if rising_edge(clk) then
        if enable_load = '1' then
            if last_en = '0' then
                out_reset <= '1';
                last_en <= '1';
            else
                out_reset <= '0';
            end if;
            if load = '1' and last_load = '0' then
                out_load <= '1';
                last_load <= '1';
            elsif load = '0' then
                last_load <= '0';
            else
                out_load <= '0';
            end if;
        else
            last_en <= '0';
            out_reset <= reset;
            out_load <= '0';
        end if;
    end if;
end process;

end Behavioral;
