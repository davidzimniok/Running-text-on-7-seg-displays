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
        letter : in  integer;
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
            when '48' =>
                seg_o <= "0000001"; -- 0
      
            when '49' =>
                seg_o <= "1001111"; -- 1
  
            when '50' =>
                seg_o <= "0010010"; -- 2

            when '51' =>
                seg_o <= "0000110"; -- 3

            when '52' =>
                seg_o <= "1001100"; -- 4

            when '53' =>
                seg_o <= "0100100"; -- 5

            when '54' =>
                seg_o <= "0100000"; -- 6

            when '55' =>
                seg_o <= "0001111"; -- 7

            when '56' =>
                seg_o <= "0000000"; -- 8

            when '57' =>
                seg_o <= "0000100"; -- 9

            when '65' =>
                seg_o <= "0001000"; -- A

            when '66' =>
                seg_o <= "1100000"; -- b

            when '67' =>
                seg_o <= "1110010"; -- C

            when '68' =>
                seg_o <= "1000010"; -- d

            when '69' =>
                seg_o <= "0110000"; -- E
				
			when '70' =>
				seg_o <= "0111000"; -- F
				
			when '71' =>
				seg_o <= "0100001"; -- G
				
			when '72' =>
				seg_o <= "1001000"; -- H
				
			when '73' =>
				seg_o <= "1111001"; -- I
				
			when '74' =>
				seg_o <= "1000011"; -- J
				
			when '75' =>
				seg_o <= "1111000"; -- K
			
			when '76' =>
				seg_o <= "1110001"; -- L
				
			when '77' =>
				seg_o <= "0101010"; -- M
			
			when '78' =>
				seg_o <= "1101010"; -- N
			
			when '79' =>
				seg_o <= "1100010"; -- O
				
			when '80' =>
				seg_o <= "0011000"; -- P
			
			when '81' =>
				seg_o <= "0001100"; -- Q
				
			when '82' =>
				seg_o <= "1111010"; -- R
			
			when '83' =>
				seg_o <= "1101100"; -- S
			
			when '84' =>
				seg_o <= "1110000"; -- T
			
			when '85' =>
				seg_o <= "1100011"; -- U
			
			when '86' =>
				seg_o <= "1000001"; -- V
		
			when '87' =>
				seg_o <= "1000000"; -- W
			
			when '88' =>
				seg_o <= "1001000"; -- X
				
			when '89' =>
				seg_o <= "1000100"; -- Y
			
			when '90' =>
				seg_o <= "1011010"; -- Z
				
			when '33' =>
				seg_o <= "0010100"; -- !
			
			when '63' =>
				seg_o <= "0011010"; -- ?
				
			when '46' =>
				seg_o <= "1110011"; -- .
				
			when '44' =>
				seg_o <= "1100111"; -- ,
			
            when others =>
                seg_o <= "1111111"; -- " "
        end case;
    end process p_7seg_decoder;

end architecture Behavioral;
