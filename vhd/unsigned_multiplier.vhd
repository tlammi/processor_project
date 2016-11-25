----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    alu.vhd
-- Design:  Usigned binary multiplier
----------------------------------------------------
-- Description: Binary multiplier for unsigned binary
--              numbers with custom width.
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-22  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_vector.all;

entity unsigned_multiplier is
    generic(
        input_bit_width : integer;
    );
    port(
        a_in        : in  std_logic_vector(input_bit_width-1 downto 0);
        b_in        : in  std_logic_vector(input_bit_width-1 downto 0);
        result_out  : out std_logic_vector((input_bit_width)*2-1 downto 0);
    );
end unsigned_multiplier;

architecture functional of unsigned_multiplier is
begin
end unsigned_multiplier;