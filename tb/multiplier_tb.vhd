----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    multiplier_tb.vhd
-- Design:  Binary multiplier
----------------------------------------------------
-- Description: Test bench for binary multiplier
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-27  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;


entity multiplier_tb is
begin
end multiplier_tb;

architecture testbench of multiplier_tb is
    -- Constants
    constant bit_width_c    : integer := 4;
    constant duv_delay_c    : integer := 0;
    constant clk_period_c   : time := 10 ns;
    
    -- Signals
    signal clk      : std_logic := '0';
    signal rst_n    : std_logic := '0';
    
    signal input_a1   : std_logic_vector(bit_width_c-1    downto 0);
    signal input_b1   : std_logic_vector(bit_width_c-1    downto 0);
    
    signal input_a2   : std_logic_vector(bit_width_c-1    downto 0);
    signal input_b2   : std_logic_vector(bit_width_c-1    downto 0);
    signal duv1_out   : std_logic_vector(bit_width_c*2-1  downto 0);
    signal duv2_out   : std_logic_vector(bit_width_c*2-1  downto 0);
    
    
    -- DUV
    component multiplier is
        generic(
            input_bit_width_g: integer;
            signed_mode_g: boolean
        );
        port(
            a_in : in std_logic_vector(input_bit_width_g-1 downto 0);
            b_in : in std_logic_vector(input_bit_width_g-1 downto 0);
            result_out : out std_logic_vector(input_bit_width_g*2-1 downto 0)
        );
    end component;
    
begin
    
    --Clock signal generation
    clk     <= not clk after clk_period_c/2;
    -- Reset initially cleared
    rst_n   <= '1' after clk_period_c/2 * 11;
    
    
    -- Design Under Verification
    duv1 : multiplier
        generic map(
            input_bit_width_g => bit_width_c,
            signed_mode_g => true
        )
        port map(
            a_in => input_a1,
            b_in => input_b1,
            result_out => duv1_out
        );
    duv2 : multiplier
        generic map(
            input_bit_width_g => bit_width_c,
            signed_mode_g => false
        )
        port map(
            a_in => input_a2,
            b_in => input_b2,
            result_out => duv2_out
        );
    -- Synchronous process for feeding inputs to DUVs' inputs
    input_proc : process(clk, rst_n)
        variable input_a_var : integer := 0;
        variable input_b_var : integer := 0;
    begin
        if rst_n = '0' then
            input_a1 <= (others => '0');
            input_b1 <= (others => '0');
            input_a2 <= (others => '0');
            input_b2 <= (others => '0');
            
        elsif clk'event and clk = '1' then
            input_a1 <= std_logic_vector(to_unsigned(input_a_var, bit_width_c));
            input_b1 <= std_logic_vector(to_unsigned(input_b_var, bit_width_c));
            input_a2 <= std_logic_vector(to_unsigned(input_a_var, bit_width_c));
            input_b2 <= std_logic_vector(to_unsigned(input_b_var, bit_width_c));
            
            -- Going through all variable b's values
            if input_b_var < 15 then
                input_b_var := input_b_var + 1;
            -- If b is at its max, reset b and increment a
            elsif input_a_var < 15 then
                input_a_var := input_a_var + 1;
                input_b_var := 0;
            -- both variables at max -> simulation passed
            else
                assert false report "Simulation success." severity failure;
            end if;
        end if;
    end process;
    
    -- Synchronous process for reading and checking DUVs' outputs
    checker_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then
            -- nop
        elsif clk'event and clk = '1' then
            assert to_integer(signed(input_a1)) * to_integer(signed(input_b1)) = to_integer(signed(duv1_out))
                report "Signed multiplier's inputs and outputs dont match" severity failure;
            assert to_integer(unsigned(input_a2)) * to_integer(unsigned(input_b2)) = to_integer(unsigned(duv2_out))
                report "Unsigned multiplier's inputs and outputs dont match" severity failure;
            
        end if;
    end process;
end testbench;