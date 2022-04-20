----------------------------------------------------------------------------------
-- Company: VUT BRNO - FEKT UREL
-- Engineer: Hana DAOVA, Tomas UCHYTIL, David ZIMNIOK
-- 
-- Create Date: 13.04.2022 17:05:28
-- Design Name: project
-- Module Name: UART_RX - Behavioral
-- Project Name: Running text on 7seg dispalys
-- Target Devices: nexys-a7-50t
-- Tool Versions: 
-- Description: Source code implements state machine to use data sended by serial port. For this purpose we need MAX232 circuit.
--              This source code was inspired by https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html. 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Circuit don't have reset signal for ensure validity of transmision.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_RX is
    Port ( clk : in STD_LOGIC;                                          -- clock used for synchronization (100 MHz)
           sig_tx : in STD_LOGIC;                                       -- input signal to the circuit
           out_pattern : out STD_LOGIC_VECTOR(7 downto 0);              -- output patter of recieved data
           out_sig : out STD_LOGIC);                                    -- signalization of sending data to output
end UART_RX;

architecture Behavioral of UART_RX is
    
    -- state names definition 
    type t_state is (   wait_state,                                     -- waiting for start bit
                        start_bit_rec,                                  -- check validity of start bit
                        data_rec,                                       -- recieving data to internal register
                        stop_bit_rec,                                   -- waiting for stop bit
                        wait_for_end);                                  -- wait half periode of UART clk for end of transmision
    signal s_state : t_state := wait_state;
    signal RX_data   : std_logic := '0';                                -- recieved 1 bit data
    signal r_on : std_logic := '0';                                     -- signal starting counter to count
    signal s_co : std_logic;                                            -- counter output with pulses defining 1/2 of periode of UART
    signal clk_count : std_logic;                                       -- defining that en signal is send twice to one state (checking validity)
    signal bit_index : integer range 0 to 7 := 0;                       -- count recieved bits
    signal in_reg : std_logic_vector(7 downto 0) := (others => '0');    -- input register for storing data

begin

    -- Clock enabling with frequency 1/2 baud rate. For our aplication we have set baudrate to 9600 so 100MHz/9600/2=5208 is g_MAX factor.
    clk_en0 : entity work.clock_enable
    generic map(
        g_MAX => 5208
    )
    port map(
        clk   => clk,
        reset => r_on,
        ce_o  => s_co
    );
        
    -- taking samples of input signal in each rising edge of master clock
    sampler : process(clk)
    begin
        if rising_edge(clk) then
            RX_data <= sig_tx;
        end if;    
    end process sampler;
    
    -- process evaluate data at input 
    reciever : process(clk)
    begin
        if rising_edge(clk) then
            case s_state is
                when wait_state =>
                    bit_index <= 0;
                    r_on <= '1';
                    out_sig <= '0';
                    clk_count <= '0';
                    if RX_data = '0' then
                        s_state <= start_bit_rec;
                    else
                        s_state <= wait_state;
                    end if;
                when start_bit_rec =>
                    r_on <= '0';
                    -- prevents causing long waiting for non valid start bit
                    if RX_data = '1' and clk_count = '0' then
                        clk_count <= '1';
                    elsif RX_data = '1' and clk_count = '1' then
                        s_state <= wait_state;
                    end if;
                    if s_co = '1' then
                        if RX_data = '0' then
                            clk_count <= '0';
                            s_state <= data_rec;
                        end if;
                    end if;
                when data_rec =>
                    if s_co = '1' then
                        clk_count <= not clk_count;
                        if bit_index < 7 and clk_count = '0' then
                            in_reg(bit_index) <= RX_data;
                            bit_index <= bit_index + 1;
                            s_state <= data_rec;
                        elsif  bit_index >= 7 then
                            bit_index <= 0;
                            clk_count <= '0';
                            s_state <= stop_bit_rec;
                        end if;
                    end if;
                when stop_bit_rec =>
                    out_sig <= '1';
                    if s_co = '1' and clk_count = '0' then
                        clk_count <= '1';
                        s_state <= stop_bit_rec;
                    elsif s_co = '1' and clk_count = '1' then
                        clk_count <= '0';
                        s_state <= wait_for_end;
                    end if;
                when wait_for_end =>
                    if s_co = '1' then
                        s_state <= wait_state;
                    end if;
                when others =>
                    s_state <= wait_state;  
            end case;
        end if;    
    end process reciever;
    
    out_pattern <= in_reg;


end Behavioral;