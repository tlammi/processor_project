----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-28
-- File:    bitwise_xorrer.vhd
-- Design:  Bitwise Xorrer
----------------------------------------------------
-- Description: Takes custom width byte and outputs its complement
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-12-01  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity bitwise_complementer is
    generic(byte_width_g : integer);
    port(
        data_in : in  std_logic_vector(byte_width_g downto 0);
        
        data_out : out std_logic_vector(byte_width_g downto 0)
    );
end bitwise_complementer;



architecture rtl of bitwise_complementer is

begin
    gen_anders : for I in 0 to byte_width_g - 1 generate
        data_out(I) <= not data1_in(I);
    end generate gen_anders;
end rtl;