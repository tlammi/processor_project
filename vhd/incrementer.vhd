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
--  Toni Lammi  |   2016-12-01  | Initial structure
----------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


entity incrementer is
    generic(
        byte_width_g : integer
    );
    port(
        operand_in  : in  std_logic_vector(byte_width_g-1 downto 0);
        operand_out : out std_logic_vector(byte_width_g-1 downto 0)
    );
end incrementer;

architecture rtl of incrementer is
    -- Signal bus that contains an AND-ladder of inputs excluding the MSB
    -- i.e. {[(x(0)x(1))x(2)]x(3)}...
    signal and_ladder           : std_logic_vector(byte_width_g-3 downto 0);
    -- Similar as above except that this is made of input complements and operation is or
    signal comp_or_ladder      : std_logic_vector(byte_width_g-3 downto 0);
-- An output bit is set when corresponding input bit is set and not all lower bits are set
-- or when all lower bits are set and the corresponding input bit is cleared.
-- z(i) = x'(i)AND(x(j)) + x(i)(NAND(x(j))), where i is corresponding index and j all lower indexes
begin

    assert byte_width_g >= 4 report "byte_width_g too small. Should be atleast 4!" severity failure;
    
    -- Generate "and" and "complement or" busses. byte_width_g-3 since the MSB's are not needed here
    GEN_LADDERS : for index in 0 to byte_width_g-3 generate
        -- Lowest bits
        GEN_LSB_AND :if index = 0 generate
        
            and_ladder(0)       <= operand_in(0) and operand_in(1);
            comp_or_ladder(0)  <= (not operand_in(0)) or (not operand_in(1));
            
        end generate GEN_LSB_AND;
        
        -- The rest
        GEN_REST : if index > 0 generate
            and_ladder(index) <= and_ladder(index-1) and operand_in(index+1);
            comp_or_ladder(index) <= comp_or_ladder(index-1) or (not operand_in(index+1));
        end generate GEN_REST;
    
    end generate GEN_LADDERS;
    
    -- Connect outputs to architecture
    GEN_OUTPUTS : for index in 0 to byte_width_g-1 generate
    
        GEN_0 : if index = 0 generate
            operand_out(index) <= not operand_in(index);
        end generate GEN_0;
    
        GEN_1 : if index = 1 generate
            operand_out(index) <= operand_in(index) xor operand_in(index-1);
        end generate GEN_1;
        
        GEN_REST : if index > 1 generate
            -- z(i) <= x'(i)[AND(x'(j))] + x(i)[OR(x'(j))], where j is all indexes lower than i.
            operand_out(index) <= ((not operand_in(index)) and and_ladder(index-2))
                                    or (operand_in(index) and comp_or_ladder(index-2));
        end generate GEN_REST;
    
    end generate GEN_OUTPUTS;
    
end rtl;