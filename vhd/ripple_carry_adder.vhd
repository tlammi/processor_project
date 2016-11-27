----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    ripple_carry_adder.vhd
-- Design:  Half adder
----------------------------------------------------
-- Description: Ripple carry adder with custom bit width
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-21  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ripple_carry_adder is
    generic(
        bit_width_g : integer
    );
    port(
        a_in        : in    std_logic_vector(bit_width_g-1 downto 0);
        b_in        : in    std_logic_vector(bit_width_g-1 downto 0);
        sum_out     : out   std_logic_vector(bit_width_g-1 downto 0);
        overflow_out: out   std_logic
    );
end ripple_carry_adder;


architecture structural of ripple_carry_adder is
    -- Half adder for LSB's
    component half_adder is
        port(
            a_in    : in  std_logic;
            b_in    : in  std_logic;
            c_out   : out std_logic;
            s_out   : out std_logic
        );
    end component;
    -- Full adders for higher bits
    component full_adder is
        port(
            a_in    : in  std_logic;
            b_in    : in  std_logic;
            c_in    : in  std_logic;
            s_out   : out std_logic;
            c_out   : out std_logic
        );
    end component;
    
    signal carry : std_logic_vector(bit_width_g-1 downto 0);
    
begin

    assert bit_width_g > 2 report "Bit width too low!" severity failure;
    -- Half adder for LSB's
    ha1: half_adder
        port map(
            a_in => a_in(0),
            b_in => b_in(0),
            
            c_out => carry(0),
            s_out => sum_out
        );
    -- Full adder from bit 1 to bit_width_g-1
    gen_full_adders for I in 1 to bit_width_g-1 generate
        fax: full_adder
            port map(
                a_in  => a_in(I),
                b_in  => b_in(I),
                c_in  => carry(I-1),
                c_out => carry(I),
                s_out => sum_out(I)
            );
    end generate gen_full_adders;
        
    -- Overflow indicator output from last full adder.
    overflow_out <= carry(bit_width_g-1);

end structural;