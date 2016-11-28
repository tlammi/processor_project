----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-28
-- File:    incrementer.vhd
-- Design:  Incrementer
----------------------------------------------------
-- Description: Increments input by one
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-28  | Initial structure
----------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


entity incrementer is
begin
    generic(
        bit_width_g : integer
    );
    port(
        operand_in  : in  std_logic_vector(bit_width_g-1 downto 0);
        operand_out : out std_logic_vector(bit_width_g-1 downto 0)
    );
end incrementer;


architecture rtl of incrementer is
begin
end rtl;