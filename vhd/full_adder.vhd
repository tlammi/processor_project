----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    full_adder.vhd
-- Design:  Full adder
----------------------------------------------------
-- Description: One bit full adder logic.
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-18  | Initial architecture
----------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;


entity full_adder is
port(
    a_in    : in    std_logic;
    b_in    : in    std_logic;
    c_in    : in    std_logic;
    
    s_out   : out   std_logic;
    c_out   : out   std_logic
);
end full_adder;


architecture rtl of full_adder is
    signal ab_xor, ab_xor_c_and, ab_and : std_logic;
begin
    -- Output
    ab_xor          <= a_in xor b_in;
    s_out           <= ab_xor xor c_in;
    -- Carry bit
    ab_xor_c_and    <= ab_xor and c_in;
    ab_and          <= a_in and b_in;
    c_out           <= ab_xor_c_and or ab_and;
end rtl;