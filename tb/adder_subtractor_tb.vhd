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
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity adder_subtractor is
    generic(
        bit_width: integer
    );
    port(
        a_in        : in  std_logic_vector(bit_width-1 downto 0);
        b_in        : in  std_logic_vector(bit_width-1 downto 0);
        mode_in     : in  std_logic;
        result_out  : out std_logic_vector(bit_width-1 downto 0);
        overflow_out: out std_logic
    );
    
end adder_subtractor;


architecture functionality of adder_subtractor is
    component full_adder is
        port(
            a_in, b_in, c_in    : std_logic;
            c_out, s_out        : std_logic
        );
    end component;
    
    signal xor_result   : std_logic_vector(bit_width-1 downto 0);
    signal carry        : std_logic_vector(bit_width downto 0);
begin
    -- Xor results
    for I in 0 to bit_width-1 loop
        xor_result(I) <= b_in(I) xor mode_in;
    end loop;
    
    -- Mode to LSB carry in
    carry(0) <= mode_in;
    
    -- Full adders.
    gen_adders for I in 0 to bit_width-1 generate
        fax : full_adder -- Full Adder X
            port map(
                a_in => a_in(I),
                b_in => xor_result(I),
                c_in => carry(I),
                c_out => carry(I+1),
                s_out => result_out(I)
            );
    end generate gen_adders;
    
    -- MSB carry out to overflow indicator output
    overflow_out <= carry(bit_width);
    
end functionality;