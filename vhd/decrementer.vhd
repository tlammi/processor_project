----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-28
-- File:    decrementer.vhd
-- Design:  Decrementer
----------------------------------------------------
-- Description: Decrements input by one
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-12-03  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity decrementer is
    generic(byte_width_g : integer);
    port(
        operand_in : in std_logic_vector(byte_width_g-1 downto 0);
        operand_out: out std_logic_vector(byte_width_g-1 downto 0)
    );
end decrementer;


architecture rtl of decrementer is
    -- Signals
    signal comp_and_ladder  : std_logic_vector(byte_width_g-3 downto 0);
    signal or_ladder        : std_logic_vector(byte_width_g-3 downto 0);
begin
    GEN_LADDERS: for index in 0 to byte_width_g-3 generate
        GEN_LSBS: if index = 0 generate
            comp_and_ladder(index) <= (not operand_in(index)) and (not operand_in(index+1));
            or_ladder(index) <= operand_in(index)  or operand_in(index+1);
        end generate GEN_LSBS;
        
        GEN_REST: if index > 0 generate
            comp_and_ladder(index) <= comp_and_ladder(index-1) and not operand_in(index+2);
            or_ladder(index) <= or_ladder(index-1) or operand_in(index+2);
        end generate GEN_REST;
    end generate GEN_LADDERS;
    
    GEN_OUTPUTS : for index in 0 to byte_width_g generate
        GEN_0 : if index = 0 generate
            operand_out(index) <= not operand_in(index);
        end generate GEN_0;
        GEN_1 : if index = 1 generate
            operand_out(index) <= operand_in(index) xnor operand_in(index-1);
        end generate GEN_1;
        GEN_REST : if index > 1 generate
            operand_out(index) <=   ((not operand_in(index)) and comp_and_ladder(index-2)) or
                                    (operand_in(index) and or_ladder(index-2));
        end generate GEN_REST;
    end generate GEN_OUTPUTS;
end rtl;