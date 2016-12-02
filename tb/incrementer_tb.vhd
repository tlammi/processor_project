----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-28
-- File:    incrementer_tb.vhd
-- Design:  Incrementer TB
----------------------------------------------------
-- Description: Tests incrementer block
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-12-02  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity incrementer_tb is
end incrementer_tb;

architecture testbench of incrementer_tb is
    -- Constants
    constant byte_width_c : integer := 8;
    constant clk_period_c : time := 10 ns;
    
    -- Signals
    
    signal clk      : std_logic := '0';
    signal rst_n    : std_logic := '0';
    
    signal to_duv   : std_logic_vector(byte_width_c-1 downto 0);
    signal from_duv : std_logic_vector(byte_width_c-1 downto 0);
    
    -- Components
    component incrementer is
        generic(
            byte_width_g : integer
        );
        port(
            operand_in  : in  std_logic_vector(byte_width_g-1 downto 0);
            operand_out : out std_logic_vector(byte_width_g-1 downto 0)
        );
    end component;
    
begin

    clk <= not clk after clk_period_c;
    rst_n <= '1' after 10*clk_period_c;
    
    duv : incrementer
        generic map(
            byte_width_g => byte_width_c
        )
        port map(
            operand_in => to_duv,
            operand_out => from_duv
        );
        
    input_proc : process(clk, rst_n)
    begin
        -- Initialize input to 0
        if rst_n = '0' then
            to_duv <= (others => '0');
        elsif clk'EVENT and clk = '1' then
            to_duv <= std_logic_vector(unsigned(to_duv)+1);
        end if;
    end process;

    checker_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then
        elsif clk'EVENT and clk = '1' then
            assert to_integer(unsigned(from_duv)) /= 0 report "Simulation success" severity failure;
            assert unsigned(from_duv) = (unsigned(to_duv) +1) report "Invalid output" severity failure;
        end if;
    end process;
    
end testbench;