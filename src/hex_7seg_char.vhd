------------------------------------------------------------
--
-- Template for 7-segment display decoder.
-- Nexys A7-50T, Vivado v2020.1, EDA Playground
--
-- Copyright (c) 2018-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Entity declaration for seven7-segment display decoder
------------------------------------------------------------
entity hex_7seg is
    port(
        letter : in  character;
        seg_o : out std_logic_vector(7 - 1 downto 0)
    );
end entity hex_7seg;

------------------------------------------------------------
-- Architecture body for seven-segment display decoder
------------------------------------------------------------
architecture Behavioral of hex_7seg is
begin
    --------------------------------------------------------
    -- p_7seg_decoder:
    -- A combinational process for 7-segment display (Common
    -- Anode) decoder. Any time "hex_i" is changed, the process
    -- is "executed". Output pin seg_o(6) controls segment A,
    -- seg_o(5) segment B, etc.
    --       segment A
    --        | segment B
    --        |  | segment C
    --        +-+|  |   ...   segment G
    --          ||+-+          |
    --          |||            |
    -- seg_o = "0000001"-------+
    --------------------------------------------------------
    p_7seg_decoder : process(letter )
    begin
        case letter is
            when '0' =>
                seg_o <= "0000001"; -- 0
            when '1' =>
                seg_o <= "1001111"; -- 1

            -- WRITE YOUR CODE HERE
            when '2' =>
                seg_o <= "0010010"; -- 2

            when '3' =>
                seg_o <= "0000110"; -- 3

            when '4' =>
                seg_o <= "1001100"; -- 4

            when '5' =>
                seg_o <= "0100100"; -- 5

            when '6' =>
                seg_o <= "0100000"; -- 6

            when '7' =>
                seg_o <= "0001111"; -- 7

            when '8' =>
                seg_o <= "0000000"; -- 8

            -- WRITE YOUR CODE HERE
            when '9' =>
                seg_o <= "0000100"; -- 9

            when 'A' =>
                seg_o <= "0001000"; -- A

            when 'B' =>
                seg_o <= "1100000"; -- b

            when 'C' =>
                seg_o <= "1110010"; -- C

            when 'D' =>
                seg_o <= "1000010"; -- d

            when 'E' =>
                seg_o <= "0110000"; -- E
				
			when 'F' =>
				seg_o <= "0111000"; -- F
				
			when 'G' =>
				seg_o <= "0100001"; -- G
				
			when 'H' =>
				seg_o <= "1001000"; -- H
				
			when 'I' =>
				seg_o <= "1111001"; -- I
				
			when 'J' =>
				seg_o <= "1000011"; -- J
				
			when 'K' =>
				seg_o <= "1111000"; -- K
			
			when 'L' =>
				seg_o <= "1110001"; -- L
				
			when 'M' =>
				seg_o <= "0101010"; -- M
			
			when 'N' =>
				seg_o <= "1101010"; -- N
			
			when 'O' =>
				seg_o <= "1100010"; -- O
				
			when 'P' =>
				seg_o <= "0011000"; -- P
			
			when 'Q' =>
				seg_o <= "0001100"; -- Q
				
			when 'R' =>
				seg_o <= "1111010"; -- R
			
			when 'S' =>
				seg_o <= "1101100"; -- S
			
			when 'T' =>
				seg_o <= "1110000"; -- T
			
			when 'U' =>
				seg_o <= "1100011"; -- U
			
			when 'V' =>
				seg_o <= "1000001"; -- V
		
			when 'W' =>
				seg_o <= "1000000"; -- W
			
			when 'X' =>
				seg_o <= "1001000"; -- X
				
			when 'Y' =>
				seg_o <= "1000100"; -- Y
			
			when 'Z' =>
				seg_o <= "1011010"; -- Z
				
			when '!' =>
				seg_o <= "0010100"; -- !
			
			when '?' =>
				seg_o <= "0011010"; -- ?
				
			when '.' =>
				seg_o <= "1110011"; -- .
				
			when ',' =>
				seg_o <= "1100111"; -- ,
			
            when others =>
                seg_o <= "1111111"; -- " "
        end case;
    end process p_7seg_decoder;

end architecture Behavioral;
