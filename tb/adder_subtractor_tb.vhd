----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    adder_subtractor_tb.vhd
-- Design:  Adder subtractor Testbench
----------------------------------------------------
-- Description: Adder subtractor testbench
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-21  | Made file
--  Toni Lammi  |   2016-12-02  | Wrote input block
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_subtractor_tb is
begin
end adder_subtractor_tb;


architecture testbench of adder_subtractor_tb is
    -- Constants
        constant byte_width_c : integer := 8;
        constant clk_period_c : time := 10 ns;
    -- Signals
        signal clk : std_logic := '0';
        signal rst_n : std_logic := '0';
        
        signal to_duv1 : std_logic_vector(byte_width_c-1 downto 0);
        signal to_duv2 : std_logic_vector(byte_width_c-1 downto 0);
        signal from_duv : std_logic_vector(byte_width_c-1 downto 0);
        signal do_subtract : std_logic;
        signal signed_overflow_from_duv : std_logic;
        signal unsigned_overflow_from_duv : std_logic;
    
    -- Components
    component adder_subtractor is
        generic(
            byte_width_g : integer
        );
        port(
            a_in : in std_logic_vector(byte_width_g-1 downto 0);
            b_in : in std_logic_vector(byte_width_g-1 downto 0);
            mode_in : in std_logic;
            
            result_out : out std_logic_vector(byte_width_g-1 downto 0);
            signed_overflow_out : out std_logic;
            unsigned_overflow_out : out std_logic
            
        );
    end component;
begin
    -- Synchronization signal generation
    clk <= not clk after clk_period_c/2;
    rst_n <= '1' after clk_period_c*5;
    
    duv : adder_subtractor
        generic map(
            byte_width_g => byte_width_c
        )
        port map(
            a_in => to_duv1,
            b_in => to_duv2,
            mode_in => do_subtract,
            result_out => from_duv,
            signed_overflow_out => signed_overflow_from_duv,
            unsigned_overflow_out => unsigned_overflow_from_duv
        );
    
    input_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then
            to_duv1 <= (others => '0');
            to_duv2 <= (others => '0');
            do_subtract <= '0';
        elsif clk'EVENT and clk = '1' then
        
            -- Iterate a_in from 0 to max
            if to_duv1 /= "11111111" then
                to_duv1 <= std_logic_vector(unsigned(to_duv1)+1);
                
            -- If max has been reached, a_in <= 0 and increment b_in by one
            elsif to_duv2 /= "11111111" then
                to_duv1 <= (others => '0');
                to_duv2 <= std_logic_vector(unsigned(to_duv2)+1);
                
            elsif do_subtract = '0' then
                do_subtract <= '1';
                to_duv1 <= (others => '0');
                to_duv2 <= (others => '0');
            else
                assert false report "Simulation success" severity failure;
            end if;
        end if;
    end process;
    
    -- Process that checks operation result
    check_output_proc : process(clk, rst_n)
    begin
    if rst_n = '0' then
        -- nop
    elsif clk'EVENT and clk = '1' then
        -- Check add
        if do_subtract = '0' then
            assert unsigned(to_duv1) + unsigned(to_duv2) = unsigned(from_duv) report "Output doesn't match the inputs!" severity failure;
        -- Check subtract
        else
            assert unsigned(to_duv1) - unsigned(to_duv2) = unsigned(from_duv) report "Output doesn't match the inputs!" severity failure;
        end if;
    end if;
    end process;
    
    -- Process that checks overflow bit functionality
    check_overflow_bit_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then
            -- nop
        elsif clk'EVENT and clk = '1' then
            -- Check adding
            if do_subtract = '0' then
                -- Check unsigned overflow
                if to_integer(unsigned(to_duv1)) + to_integer(unsigned(to_duv2)) > 255 then
                    assert unsigned_overflow_from_duv = '1' report "Unsigned overflow not set." severity failure;
                else
                    assert unsigned_overflow_from_duv = '0' report "Unsigned overflow should be clear" severity failure;
                end if;
                -- Check signed overflow
                if to_integer(signed(to_duv1)) + to_integer(signed(to_duv2)) > 127 or to_integer(signed(to_duv1)) + to_integer(signed(to_duv2)) < -128 then
                    assert signed_overflow_from_duv = '1' report "Signed overflow not set." severity failure;
                else
                    assert signed_overflow_from_duv = '0' report "Signed overflow not clear" severity failure;
                end if;
            -- Check subtracting
            else
                 -- Check unsigned overflow
                if to_integer(unsigned(to_duv1)) - to_integer(unsigned(to_duv2)) < 0 then
                    assert unsigned_overflow_from_duv = '1' report "Unsigned overflow not set." severity failure;
                else
                    assert unsigned_overflow_from_duv = '0' report "Unsigned overflow should be clear" severity failure;
                end if;
                -- Check signed overflow
                if to_integer(signed(to_duv1)) - to_integer(signed(to_duv2)) > 127 or to_integer(signed(to_duv1)) - to_integer(signed(to_duv2)) < -128 then
                    assert signed_overflow_from_duv = '1' report "Signed overflow not set." severity failure;
                else
                    assert signed_overflow_from_duv = '0' report "Signed overflow not clear" severity failure;
                end if;
            end if;
        end if;
    end process;
    
end testbench;