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
            when '0' =>
                seg_o <= "48"; -- 0
      
            when '1' =>
                seg_o <= "49"; -- 1
  
            when '2' =>
                seg_o <= "50"; -- 2
  
            when '3' =>
                seg_o <= "51"; -- 3

            when '4' =>
                seg_o <= "52"; -- 4

            when '5' =>
                seg_o <= "53"; -- 5

            when '6' =>
                seg_o <= "54"; -- 6

            when '7' =>
                seg_o <= "55"; -- 7

            when '8' =>
                seg_o <= "56"; -- 8

            when '9' =>
                seg_o <= "57"; -- 9

            when 'A' =>
                seg_o <= "65"; -- A

            when 'B' =>
                seg_o <= "66"; -- B

            when 'C' =>
                seg_o <= "67"; -- C

            when 'D' =>
                seg_o <= "68"; -- D

            when 'E' =>
                seg_o <= "69"; -- E
				
		  when 'F' =>
	     	seg_o <= "70"; -- F
				
			when 'G' =>
				seg_o <= "71"; -- G
				
			when 'H' =>
				seg_o <= "72"; -- H
				
			when 'I' =>
				seg_o <= "73"; -- I
				
			when 'J' =>
				seg_o <= "74"; -- J
				
			when 'K' =>
				seg_o <= "75"; -- K
			
			when 'L' =>
				seg_o <= "76"; -- L
				
			when 'M' =>
				seg_o <= "77"; -- M
			
			when 'N' =>
				seg_o <= "78"; -- N
			
			when 'O' =>
				seg_o <= "79"; -- O
				
			when 'P' =>
				seg_o <= "80"; -- P
			
			when 'Q' =>
				seg_o <= "81"; -- Q
				
			when 'R' =>
				seg_o <= "82"; -- R
			
			when 'S' =>
				seg_o <= "83"; -- S
			
			when 'T' =>
				seg_o <= "84"; -- T
			
			when 'U' =>
				seg_o <= "85"; -- U
			
			when 'V' =>
				seg_o <= "86"; -- V
		
			when 'W' =>
				seg_o <= "87"; -- W
			
			when 'X' =>
				seg_o <= "88"; -- X
				
			when 'Y' =>
				seg_o <= "89"; -- Y
			
			when 'Z' =>
				seg_o <= "90"; -- Z
				
			when '!' =>
				seg_o <= "33"; -- !
			
			when '?' =>
				seg_o <= "63"; -- ?
				
			when '.' =>
				seg_o <= "46"; -- .
				
			when ',' =>
				seg_o <= "44"; -- ,
			
            when others =>
                seg_o <= "32"; -- " "
        end case;
    end process p_7seg_decoder;

end architecture Behavioral;
