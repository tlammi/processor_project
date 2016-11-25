----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    half_adder_tb.vhd
-- Design:  Half adder test bench
----------------------------------------------------
-- Description: One bit half adder logic Testbench
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-18  | Initial tests
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity half_adder_tb is
end half_adder_tb;

architecture testbench of half_adder_tb is

    component half_adder is
    port(
        a_in  : in  std_logic;
        b_in  : in  std_logic;
        c_out : out std_logic;
        s_out : out std_logic
    );
    end component;
    
    signal a_in : std_logic := '0';
    signal b_in : std_logic := '0';
    signal c_out : std_logic;
    signal s_out : std_logic;
    
begin
    
    duv : half_adder
        port map(
            a_in => a_in,
            b_in => b_in,
            c_out => c_out,
            s_out => s_out
        );
        
    async_proc: process
    begin
        wait for 7 ns;
        assert s_out = '0' report "Failure" severity failure;
        assert c_out = '0' report "Failure" severity failure;
        a_in <= '1';
        wait for 3 ns;
        assert s_out = '1' report "Failure" severity failure;
        assert c_out = '0' report "Failure" severity failure;
        a_in <= '0';
        b_in <= '1';
        wait for 3 ns;
        assert s_out = '1' report "Failure" severity failure;
        assert c_out = '0' report "Failure" severity failure;
        a_in <= '1';
        wait for 3 ns;
        assert s_out = '0' report "Failure" severity failure;
        assert c_out = '1' report "Failure" severity failure;
        
        assert 1/=1 report "Simulation success." severity failure;
    end process;
end testbench;


