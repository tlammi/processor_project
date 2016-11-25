----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    alu.vhd
-- Design:  Multiplexer
----------------------------------------------------
-- Description: Multiplexer logic with custom bit width
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-21  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity multiplexer is
    generic(
        -- How many bits are used in select bus
        select_bus_width: integer;
        -- How wide are the input/output busses
        data_bus_width: integer
    );
    port(
        signals_in      : in  std_logic_vector((select_bus_width*select_bus_width-1)*data_bus_width-1  downto 0);
        select_bus      : in  std_logic_vector(select_bus_width-1 downto 0);
        signal_out      : out std_logic_vector(data_bus_width-1 downto 0);
    );
end multiplexer;


architecture rtl of multiplexer is
begin
    
end rtl;