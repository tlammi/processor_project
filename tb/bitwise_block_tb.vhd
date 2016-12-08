----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-28
-- File:    bitwise_block_tb.vhd
-- Design:  Bitwise Block Testbench
----------------------------------------------------
-- Description: Tests bitwise block
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-12-02  | Skeleton
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bitwise_block_tb is
begin
end bitwise_block_tb;

architecture testbench of bitwise_block_tb is
    -- Constants
    constant byte_width_c : integer := 8;
    constant clk_period_c : time := 10 ns;
    -- Signals
    signal clk : std_logic := '0';
    signal rst_n : std_logic := '0';
    
    signal operand_to_duv1 : std_logic_vector(byte_width_c-1 downto 0);
    signal operand_to_duv2 : std_logic_vector(byte_width_c-1 downto 0);
    signal operation_code_to_duv : std_logic_vector(2 downto 0);
    signal result_from_duv : std_logic_vector(byte_width_c-1 downto 0);
    -- Components
    component bitwise_block is
        generic(
            byte_width_g : integer
        );
        port(
            operand1_in : in std_logic_vector(byte_width_g-1 downto 0);
            operand2_in : in std_logic_vector(byte_width_g-1 downto 0);
            operation_select_in : in std_logic_vector(2 downto 0);
            
            result_out : out std_logic_vector(byte_width_g-1 downto 0)
        );
    end component;
begin
    
    clk <= not clk after clk_period_c/2;
    rst_n <= '1' after clk_period_c*4;
    
    duv : bitwise_block
        generic map(
            byte_width_g => byte_width_c
        )
        port map(
            operand1_in => operand_to_duv1,
            operand2_in => operand_to_duv2,
            operation_select_in => operation_code_to_duv,
            result_out => result_from_duv
        );
    
    input_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then
            operand_to_duv1 <= (others => '0');
            operand_to_duv2 <= (others => '0');
            operation_code_to_duv <= (0=>'1', others => '0');
            
        elsif clk'EVENT and clk = '1' then
            if unsigned(operand_to_duv1) < 255 then
                operand_to_duv1 <= std_logic_vector(unsigned(operand_to_duv1)+1);
                
            elsif unsigned(operand_to_duv2) < 255 then
                operand_to_duv1 <= (others => '0');
                operand_to_duv2 <= std_logic_vector(unsigned(operand_to_duv2)+1);
            
            elsif operation_code_to_duv /= "110" then
                operation_code_to_duv <= std_logic_vector(unsigned(operation_code_to_duv)+1);
                operand_to_duv1 <= (others => '0');
                operand_to_duv2 <= (others => '0');
            
            else
                assert false report "Simulation succesfull" severity failure;
            end if;
        end if;
    end process;
    
    checker_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then
        elsif clk'EVENT and clk = '1' then
            if operation_code_to_duv = "001" then
                assert result_from_duv = (operand_to_duv1 and operand_to_duv2) report "Invalid output" severity failure;
            elsif operation_code_to_duv = "010" then
                assert result_from_duv = (operand_to_duv1 nand operand_to_duv2) report "Invalid output" severity failure;
            elsif operation_code_to_duv = "011" then
                assert result_from_duv = (operand_to_duv1 nor operand_to_duv2) report "Invalid output" severity failure;
            elsif operation_code_to_duv = "100" then
                assert result_from_duv = (operand_to_duv1 or operand_to_duv2) report "Invalid output" severity failure;
            elsif operation_code_to_duv = "101" then
                assert result_from_duv = (operand_to_duv1 xor operand_to_duv2) report "Invalid output" severity failure;
            elsif operation_code_to_duv = "110" then
                assert result_from_duv = not operand_to_duv1 report "Invalid output" severity failure;
            end if;
        end if;
    end process;
end testbench;