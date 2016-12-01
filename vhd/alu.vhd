----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    alu.vhd
-- Design:  ALU for the processor
----------------------------------------------------
-- Description: This block handles the arithmetical
--              operations of the processor.
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-06  | Skeleton for the entity
----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity alu is
    generic(bit_width_g : integer);
    port(
        input0_in  :   in  std_logic_vector(bit_width_g-1 downto 0);
        input1_in  :   in  std_logic_vector(bit_width_g-1 downto 0);
    
        control_in :   in  std_logic_vector(bit_width_g-1 downto 0);
    
        output1_out  :   in std_logic_vector(bit_width_g-1 downto 0);
        output2_out  :   in std_logic_vector(bit_width_g-1 downto 0)
    );
end alu;



architecture structural of alu is
    -- Constants
    
    -- Components
    component adder_subtractor is
    generic(
        bit_width_g: integer
    );
    port(
        a_in        : in  std_logic_vector(bit_width_g-1 downto 0);
        b_in        : in  std_logic_vector(bit_width_g-1 downto 0);
        mode_in     : in  std_logic;
        result_out  : out std_logic_vector(bit_width_g-1 downto 0);
        overflow_out: out std_logic);
    end component;
    
    component multiplier is
    generic(
        input_bit_width_g       : integer;  -- Number of bits in input busses
        signed_mode_g         : boolean     -- Is signed mode used in the component
    );
    port(
        a_in        : in  std_logic_vector(input_bit_width_g-1 downto 0);
        b_in        : in  std_logic_vector(input_bit_width_g-1 downto 0);
        result_out  : out std_logic_vector((input_bit_width_g)*2-1 downto 0)
    );
    end component;

    
begin
    
end alu;