----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    multiplier.vhd
-- Design:  Binary multiplier
----------------------------------------------------
-- Description: Binary multiplier for binary
--              numbers with custom width.
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-22  | Initial structure
--  Toni Lammi  |   2016-11-27  | Fixed syntax and compiled the design
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
    generic(
        input_bit_width : integer
    );
    port(
        a_in        : in  std_logic_vector(input_bit_width-1 downto 0);
        b_in        : in  std_logic_vector(input_bit_width-1 downto 0);
        result_out  : out std_logic_vector((input_bit_width)*2-1 downto 0)
    );
end multiplier;

architecture functional of multiplier is
begin
    multip_proc : process(a_in, b_in)
        variable input_var1 : integer;
        variable input_var2 : integer;
        variable output_var : integer;
    begin
        input_var1 := to_integer(signed(a_in));
        input_var2 := to_integer(signed(b_in));
        output_var := input_var1 * input_var2;
        result_out <= std_logic_vector(to_signed(output_var, input_bit_width*2));
    end process;
end functional;