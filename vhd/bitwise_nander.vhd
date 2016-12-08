----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-28
-- File:    bitwise_nander.vhd
-- Design:  Bitwise Nander
----------------------------------------------------
-- Description: Takes two custom width bytes and performs a bitwise nand to them
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-12-01  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity bitwise_nander is
    generic(byte_width_g : integer);
    port(
        data1_in : in  std_logic_vector(byte_width_g-1 downto 0);
        data2_in : in  std_logic_vector(byte_width_g-1 downto 0);
        
        data_out : out std_logic_vector(byte_width_g-1 downto 0)
    );
end bitwise_nander;



architecture rtl of bitwise_nander is

begin
    gen_anders : for I in 0 to byte_width_g - 1 generate
        data_out(I) <= data1_in(I) nand data2_in(I);
    end generate gen_anders;
end rtl;