----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    alu.vhd
-- Design:  Full adder testbench
----------------------------------------------------
-- Description: One bit full adder logic testbench
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-23  | Initial tests
----------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;

entity full_adder_tb is
begin
end full_adder_tb;

--procedure check_failure (a_in : in std_logic;
--                        b_in : in std_logic;
--                        c_in : in std_logic;
--                        c_out : in std_logic;
--                        s_out : in std_logic) is
--begin
--    assert s_out = ((a_in xor b_in) xor c_in) report "Failure" severity failure;
--    assert c_out = (a_in and b_in) or (c_in and a_in) or (c_in and b_in)
--        report "Failure" severity failure;
--end check_failure;


architecture behaviorial of full_adder_tb is

    component full_adder is
        port(
            a_in :  in  std_logic;
            b_in :  in  std_logic;
            c_in :  in  std_logic;
            s_out : out std_logic;
            c_out : out std_logic
        );
    end component;
    signal a_in : std_logic := '0';
    signal b_in : std_logic := '0';
    signal c_in : std_logic := '0';
    signal c_out : std_logic;
    signal s_out : std_logic;
    
begin
    duv : full_adder port map(
        a_in => a_in,
        b_in => b_in,
        c_in => c_in,
        c_out => c_out,
        s_out => s_out);
    
    async_proc :process
    begin
    wait for 3 ns;
    assert s_out = ((a_in xor b_in) xor c_in) report "Failure" severity failure;
    assert c_out = ((a_in and b_in) or (c_in and a_in) or (c_in and b_in))
        report "Failure" severity failure;
    a_in <= '1';
    wait for 3 ns;
    assert s_out = ((a_in xor b_in) xor c_in) report "Failure" severity failure;
    assert c_out = ((a_in and b_in) or (c_in and a_in) or (c_in and b_in))
        report "Failure" severity failure;
    a_in <= '0';
    b_in <= '1';
    wait for 3 ns;
    assert s_out = ((a_in xor b_in) xor c_in) report "Failure" severity failure;
    assert c_out = ((a_in and b_in) or (c_in and a_in) or (c_in and b_in))
        report "Failure" severity failure;
    a_in <= '1';
    wait for 3 ns;
    assert s_out = ((a_in xor b_in) xor c_in) report "Failure" severity failure;
    assert c_out = ((a_in and b_in) or (c_in and a_in) or (c_in and b_in))
        report "Failure" severity failure;
    a_in <= '0';
    b_in <= '0';
    c_in <= '1';
    wait for 3 ns;
    assert s_out = ((a_in xor b_in) xor c_in) report "Failure" severity failure;
    assert c_out = ((a_in and b_in) or (c_in and a_in) or (c_in and b_in))
        report "Failure" severity failure;
    a_in <= '1';
    wait for 3 ns;
    assert s_out = ((a_in xor b_in) xor c_in) report "Failure" severity failure;
    assert c_out = ((a_in and b_in) or (c_in and a_in) or (c_in and b_in))
        report "Failure" severity failure;
    a_in <= '0';
    b_in <= '1';
    wait for 3 ns;
    assert s_out = ((a_in xor b_in) xor c_in) report "Failure" severity failure;
    assert c_out = ((a_in and b_in) or (c_in and a_in) or (c_in and b_in))
        report "Failure" severity failure;
    a_in <= '1';
    wait for 3 ns;
    assert s_out = ((a_in xor b_in) xor c_in) report "Failure" severity failure;
    assert c_out = ((a_in and b_in) or (c_in and a_in) or (c_in and b_in))
        report "Failure" severity failure;
    assert 1 /= 1 report "Success" severity failure;
    end process;
    
end behaviorial;