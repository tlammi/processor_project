----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    left_shifter.vhd
-- Design:  left shifter
----------------------------------------------------
-- Description: Left shifter block
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-25  | Initial structure
--  Toni Lammi  |   2016-11-27  | Added for loop for shifting
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity left_shifter is
    generic(bit_width_g: integer);
    port(
        -- Input data
        data_in : in std_logic_vector(bit_width_g-1 downto 0);
        -- Amount of shifting to be done
        shift_in : in std_logic_vector(bit_width_g-1 downto 0);
        -- Shifted output data
        data_out : out std_logic_vector(bit_width_g-1 downto 0)
    );
end left_shifter;

architecture rtl of left_shifter is
begin
    async_proc : process(data_in, shift_in)
        variable shift_var : integer;
    begin
        shift_var := to_integer(unsigned(shift_in));
        
        for index in 0 to bit_width_g-1 loop
            -- Inserting '0' for lower bits
            if index - shift_var < 0 then
                data_out(index) <= '0';
            else
                data_out(index) <= data_in(index-shift_var);
            end if;
        end loop;
    end process;
    
end rtl;