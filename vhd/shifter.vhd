----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    shifter.vhd
-- Design:  Shifter
----------------------------------------------------
-- Description: Left shifter block
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-25  | Initial structure
--  Toni Lammi  |   2016-11-27  | Added for loop for shifting
--  Toni Lammi  |   2016-11-30  | Changed the functionality to both ways
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity left_shifter is
    generic(bit_width_g: integer);
    port(
        -- Input data
        data_in : in std_logic_vector(bit_width_g-1 downto 0);
        -- Amount of shifting to be done. Negat. values mean right shift
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
        shift_var := to_integer(signed(shift_in));
        
        for index in 0 to bit_width_g-1 loop
            -- Inserting '0' for lower bits and higher bits
            if index - shift_var < 0 or index-shift_var >= bit_width_g then
                data_out(index) <= '0';
            -- The rest of the bits are shifted
            else
                data_out(index) <= data_in(index-shift_var);
            end if;
        end loop;
    end process;
    
end rtl;