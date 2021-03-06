----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    alu.vhd
-- Design:  Adder subtractor
----------------------------------------------------
-- Description: Adder subtractor block
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-21  | Initial structure
--  Toni Lammi  |   2016-12-03  | Splitted overflow to signed and unsigned overflow
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity adder_subtractor is
    generic(
        byte_width_g: integer
    );
    port(
        a_in        : in  std_logic_vector(byte_width_g-1 downto 0);
        b_in        : in  std_logic_vector(byte_width_g-1 downto 0);
        mode_in     : in  std_logic;
        result_out  : out std_logic_vector(byte_width_g-1 downto 0);
        signed_overflow_out     : out std_logic;
        unsigned_overflow_out   : out std_logic
    );
    
end adder_subtractor;


architecture functionality of adder_subtractor is
    component full_adder is
        port(
            a_in, b_in, c_in    : in std_logic;
            c_out, s_out        : out std_logic
        );
    end component;
    
    signal xor_result   : std_logic_vector(byte_width_g-1 downto 0); -- Results of xors before full adders
    signal carry        : std_logic_vector(byte_width_g downto 0); -- Carry nets between full adders
    signal output_buffer: std_logic_vector(byte_width_g-1 downto 0); -- Output buffer that connects full adder outputs to blocks output bus
begin
    -- Xor results
    gen_xors : for I in 0 to byte_width_g-1 generate
        xor_result(I) <= b_in(I) xor mode_in;
        result_out(I) <= output_buffer(I);
    end generate gen_xors;
    
    -- Mode to LSB carry in
    carry(0) <= mode_in;
    
    -- Full adders.
    gen_adders : for I in 0 to byte_width_g-1 generate
        fax : full_adder -- Full Adder X
            port map(
                a_in => a_in(I),
                b_in => xor_result(I),
                c_in => carry(I),
                c_out => carry(I+1),
                s_out => output_buffer(I)
            );
    end generate gen_adders;
    
    -- MSB carry out xorred with MSB-1 to indicate overflow in signed binary
    signed_overflow_out <= carry(byte_width_g) xor carry(byte_width_g-1);
    -- MSB carry out xorred with operation mode to indicate unsigned overflow
    unsigned_overflow_out <= carry(byte_width_g) xor mode_in;
    
end functionality;