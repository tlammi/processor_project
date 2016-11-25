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
port(
    input0  :   in  std_logic_vector();
    input1  :   in  std_logic_vector();
    
    control :   in  std_logic_vector();
    
    output  :   in std_logic_vector()
);
end alu;