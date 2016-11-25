----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    alu.vhd
-- Design:  Register bank
----------------------------------------------------
-- Description: Custom bit width register bank
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-21  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity register_bank is
    generic(
        bit_width : integer;
        reset_val : std_logic_vector := (others => '0')
    );
    port(
        clk             : in std_logic;
        rst_n           : in std_logic;
        wen_in          : in std_logic;
        next_state_in   : in  std_logic_vector(bit_width-1 downto 0);
        curr_state_out  : out std_logic_vector(bit_width-1 downto 0)
    );
end register_bank;


architecture rtl of register_bank is
    component mux_2to1 is
        generic(
            mux_bit_width
        );
        port(
            sel_clear_in    : in  std_logic_vector(mux_bit_width-1 downto 0);
            sel_set_in      : in  std_logic_vector(mux_bit_width-1 downto 0);
            sel_in          : in  std_logic;
            data_out        : out std_logic_vector(mux_bit_width-1 downto 0)
        );
        
    signal flipflop_out  : std_logic_vector(bit_width-1 downto 0);
    signal flipflop_in   : std_logic_vector(bit_width-1 downto 0);
    
begin
    mux: mux_2to1
        generic map(
            mux_bit_width => bit_width
        )
        port map(
            sel_clear_in    => flipflop_out;
            sel_set_in      => next_state_in;
            sel_in          => wen_in;
            data_out        => flipflop_in
        );
    
    sync_proc: process(clk, rst_n)
    begin
        if(rst_n = '0') then
            flipflop_out <= reset_val;
        elsif(clk'event and clk = '1') then
            flipflop_out <= flipflop_in;
    end process;
    curr_state_out <= flipflop_out;
    
end rtl;