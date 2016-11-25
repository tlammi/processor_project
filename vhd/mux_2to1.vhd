----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    alu.vhd
-- Design:  2 to 1 multiplexer
----------------------------------------------------
-- Description: Multiplexer logic with custom bit width
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-21  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux_2to1 is
    generic(
        bit_width: integer
    );
    port(
        sel_clear_in    : in std_logic_vector(bit_width-1 downto 0);
        sel_set_in      : in std_logic_vector(bit_width-1 downto 0);
        sel_in          : in std_logic;
        data_out        : out std_logic_vector(bit_width-1 downto 0)
    );
end mux_2to1;

architecture rtl of mux_2to1 is
begin
    data_out <= sel_set_in when (sel_in = '1') else sel_clear_in;
end rtl;