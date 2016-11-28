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
--  Toni Lammi  |   2016-11-28  | Added functionality for unsigned multiplication operations
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
    generic(
        input_bit_width_g       : integer;  -- Number of bits in input busses
        signed_mode_g         : boolean     -- Is signed mode used in the component
    );
    port(
        a_in        : in  std_logic_vector(input_bit_width_g-1 downto 0);
        b_in        : in  std_logic_vector(input_bit_width_g-1 downto 0);
        result_out  : out std_logic_vector((input_bit_width_g)*2-1 downto 0)
    );
end multiplier;

architecture functional of multiplier is
begin
    multip_proc : process(a_in, b_in)
        variable input_var1 : integer;
        variable input_var2 : integer;
        variable output_var : integer;
    begin
        if signed_mode_g then
            input_var1 := to_integer(signed(a_in));
            input_var2 := to_integer(signed(b_in));
        else
            input_var1 := to_integer(unsigned(a_in));
            input_var2 := to_integer(unsigned(b_in));
        end if;
        output_var := input_var1 * input_var2;
        result_out <= std_logic_vector(to_signed(output_var, input_bit_width_g*2));
    end process;
end functional;