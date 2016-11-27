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
    
    signal input1   : std_logic_vector(bit_width-1    downto 0);
    signal input2   : std_logic_vector(bit_width-1    downto 0);
    signal output   : std_logic_vector(bit_width*2-1  downto 0);
    
    -- DUV
    component multiplier is
        generic(input_bit_width: integer);
        port(
            a_in : std_logic_vector(input_bit_width-1 downto 0);
            b_in : std_logic_vector(input_bit_width-1 downto 0);
            result_out : std_logic_vector(input_bit_width*2-1 downto 0)
        );
    end component;
    
    -- File interfaces
    file input_f    : text open read_mode is "multiplier_input.txt";
    file ref_f      : text open read_mode is "multiplier_ref.txt";
    
begin
    
    --Clock signal generation
    clk     := not clk after clk_period_c/2;
    -- Reset initially cleared
    rst_n   := '1' after clk_period_c * 5;
    
    
    -- Design Under Verification
    duv : multiplier
        generic map(input_bit_width => bit_width_c)
        port map(
            a_in => input1,
            b_in => input2,
            result_out => output
        );
    
    -- Synchronous process for reading inputs and feeding them to DUV's inputs
    input_proc : process(clk, rst_n)
            -- Input line variable
            variable inline_var is line;
            -- Variable that holds the first input
            variable input1_var is integer;
            -- Variable that holds the second input
            variable input2_var is integer;
            -- Variable that tells if the read characters
            -- represent a number
            variable is_num_var in boolean;
        begin
        -- Reset functionality
        if rst_n = '0' then:
            input1 <= (others => '0');
            input2 <= (others => '0');
        -- Rising clock edge
        elsif clk'EVENT and clk = '1' then
            is_num_var := false;
            -- Read lines until the first data line or EOF is found
            while not endfile(input_f) and not is_num_var loop
                readline(input_f, inline_var);
                read(inline_var, input1_var, is_num_var);
            end loop;

            -- Foud a data line
            if is_num_var then
                read(inline_var, input2_var, is_num_var);
                -- Invalid line in input file
                if not is_num_var then
                    assert false report "Invalid line in input file "& file'IMAGE(input_f) severity failure;
                else
                    -- Set the read data as DUV input------------------------------------------------------------------
                    input1 <= std_logic_vector(to_signed(input1_var, bit_width));
                    input2 <= std_logic_vector(to_signed(input2_var, bit_width));
                end if;
            -- EOF
            else
                report "Reached end of input file " & file'IMAGE(input_f);
            end if;
        else
            -- nop
        end if;
    end process;
    
    -- Synchronous process for reading DUV's outputs and comparing them with reference outputs.
    checker_proc : process(clk, rst_n)
        -- Value gained from DUV output
        variable output_var : integer;
        -- Line variable from reference file
        variable inline_var : line;
        -- Integer value from reference file
        variable reference_var : integer;
        -- Variable to check validity of reference values.
        variable is_num_var : boolean;
    begin
        if rst_n = '0' then:
            -- nop
        elsif clk'EVENT and clk = '1' then
            is_num_var := false;
            while not endfile(ref_f) and not is_num_var loop
                readline(ref_f, inline_var);
                read(inline_var, reference_var, is_num_var);
            end loop;
            
            -- Valid reference value
            if is_num_var then
                output_var := to_integer(signed(output), bit_width);
                assert output_var = reference_var report "Output and reference values don't match" severity failure;
            -- End of reference file found <=> simultion successful
            else
                assert false report "Simulation successful." severity failure;
            end if;
        else
            -- nop
        end if;

end testbench;