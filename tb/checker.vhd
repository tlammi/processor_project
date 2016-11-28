----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-27
-- File:    checker.vhd
-- Design:  Checker
----------------------------------------------------
-- Description:
-- Block used by test benches to refer the DUV's outputs to values in reference files.
-- Stops the simulation with assert once all of the references have been compared with block inputs
-- 
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-11-27  | Initial tests
----------------------------------------------------

library ieee;
ieee.std_logic_1164.all;
ieee.numeric_std.all;


entity checker is
begin
    generic(
        ref_file_path_g     : string    := "reference.txt"; -- Path to reference file
        output_file_path_g  : string    := "output.txt";    -- Path to log file.
        input_bus_width_g   : integer                       -- Input bus width (from DUV)
    );
    port(
        -- Clock signal for synchronizing with inputs
        -- Enable signal enables the functionality
        clk, enable_in : in std_logic;
        -- Set when the output matches the reference
        correct_out : out std_logic;
        -- Bus for inputting data from DUV
        input_bus : std_logic_vector(input_bus_width_g-1 downto 0)
    );
end checker;



architecture checker_arch of checker is
    -- File interface
    file ref_f : text open read_mode is ref_file_path_g;
    file output_f : text open write_mode is output_file_path_g;
    
begin
    
    compare_proc : process(clk, enable_in)
        variable inline_var : line;     -- Line from reference file
        variable ref_var    : integer;  -- Value from reference file
        variable is_num_var : boolean;  -- true, if read value is num, else false
    begin
        -- Functionality not enabled.
        -- Reset to initial state.
        if enable_in = '0' then
            correct_out <= '1';
        elsif clk'EVENT and clk = '1' then
        
            -- First iteration of reference file read
            is_num_var := false;
            while not endfile(ref_f) and not is_num_var loop
                readline(ref_f, inline_var);
                read(inline_var, ref_var, is_num_var);
            end loop;
            
            -- Reference file found
            if is_num_var then
                if ref_var = to_integer(signed(input_bus)) then
                    correct_out <= '1';
                else
                    correct_out <= '0';
                end if;
            -- End of File <=> simulation end
            else
                assert false report "Simulation ended" severity failure;
            end if;
        else
            -- nop
        end if;
            
    end process;
end checker_arch;
