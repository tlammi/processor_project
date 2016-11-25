----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-06
-- File:    mux_2to1_tb.vhd
-- Design:  2 to 1 multiplexer testbench
----------------------------------------------------
-- Description: Multiplexer logic test bench
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-23  | Initial testbench
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2to1_tb is
begin
end mux_2to1_tb;

architecture behaviorial of mux_2to1_tb is
    component mux_2to1 is
        generic(bit_width: integer);
        port(
            sel_clear_in : in std_logic_vector(bit_width-1 downto 0);
            sel_set_in   : in std_logic_vector(bit_width-1 downto 0);
            sel_in       : in std_logic;
            data_out     : out std_logic_vector(bit_width-1 downto 0)
        );
    end component;
    
    constant tb_bit_width : integer := 8;
    constant clk_period : time := 2 ns;
    
    signal signal1_var : unsigned(tb_bit_width-1 downto 0) := (others => '0');
    signal signal2_var : unsigned(tb_bit_width-1 downto 0) := (others => '1');
    
    signal signal1_in : std_logic_vector(tb_bit_width-1 downto 0) := "00000000";
    signal signal2_in : std_logic_vector(tb_bit_width-1 downto 0) := "11111111";
    signal signal_out : std_logic_vector(tb_bit_width-1 downto 0);
    signal sel : std_logic;
    
    signal clk : std_logic := '0';
    
begin
    duv : mux_2to1
        generic map(bit_width => tb_bit_width)
        port map(
            sel_clear_in => signal1_in,
            sel_set_in => signal2_in,
            data_out => signal_out,
            sel_in => sel
        );
        
    -- Clock signal
    clk_proc : process
    begin
        clk<= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    -- Process for assertions
    test_proc : process(clk)
    begin
    if(clk'EVENT and clk = '1') then
        -- Vary the input selection signal
        if( sel = '1') then
            assert signal2_in = signal_out report "Failure" severity failure;
            sel <= '0';
        else
            assert signal1_in = signal_out report "Failure" severity failure;
            sel <= '1';
        end if;
        
        --Check for simulation end
        if (signal1_var = "11111111") or (signal2_var = "00000000") then
            assert 1 /= 1 report "Success" severity failure;
        else
            -- Increment/Decrement values
            signal1_var <= signal1_var +1;
            signal1_in <= std_logic_vector(signal1_var);
            signal2_var <= signal2_var -1;
            signal2_in <= std_logic_vector(signal2_var);
        end if;
    end if;
  end process;
end behaviorial;









