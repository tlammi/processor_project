----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    half_adder.vhd
-- Design:  Half adder
----------------------------------------------------
-- Description: One bit half adder logic.
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-18  | Initial architecture
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity half_adder is
port(
    a_in    : in    std_logic;
    b_in    : in    std_logic;
    s_out   : out   std_logic;
    c_out   : out   std_logic
);
end half_adder;


architecture rtl of half_adder is
begin
    s_out <= a_in xor b_in;
    c_out <= a_in and b_in;
end rtl;