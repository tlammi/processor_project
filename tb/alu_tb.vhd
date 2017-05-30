----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2017-04-08
-- File:    alu_tb.vhd
-- Design:  ALU for the processor
----------------------------------------------------
-- Description: This block handles the arithmetical
--              operations of the processor.
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2017-04-08  | Skeleton for the entity
----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb;


architecture testbench of alu_tb is
    -- Constants
    constant operand_width_c : integer := 8;
    constant ctrl_width_c : integer := 4;
    
    constant clock_period_ms : time := 10 ns;
    constant periods_before_start : integer := 4;
    
    
    -- Components
    
    component alu is
    generic(
        operand_width_g : integer;
        ctrl_width_g : integer
    );
    port(
        operand1_in : in std_logic_vector(operand_width_g-1 downto 0);
        operand2_in : in std_logic_vector(operand_width_g-1 downto 0);
        carry_in : in std_logic;
        ctrl_in : in std_logic_vector(ctrl_width_g-1 downto 0);
        
        result1_out : out std_logic_vector(operand_width_g-1 downto 0);
        result2_out : out std_logic_vector(operand_width_g-1 downto 0);
        carry_out : out std_logic
    );
    end component;
    
    
    -- Signals
    
    signal clk : std_logic := '0';
    signal rst_n : std_logic := '0';
    
    
    signal operand1_to_duv : std_logic_vector(operand_width_c-1 downto 0);
    signal operand2_to_duv : std_logic_vector(operand_width_c-1 downto 0);
    signal carry_to_duv : std_logic;
    signal ctrl_to_duv : std_logic_vector(ctrl_width_c-1 downto 0);
    
    signal result1_from_duv : std_logic_vector(operand_width_c-1 downto 0);
    signal result2_from_duv : std_logic_vector(operand_width_c-1 downto 0);
    signal carry_from_duv : std_logic;
    
    
    signal input1_integer_sig : integer range 0 to 2**operand_width_c-1;
    signal input2_integer_sig : integer range 0 to 2**operand_width_c-1;
    signal ctrl_integer_sig : integer range 0 to 2**ctrl_width_c-1;
    signal ctrl_increment_counter_int_sig : integer range 0 to 15;
    
    signal output_correct : std_logic;
    
begin

    -- DUV
    duv : alu
        generic map(
            operand_width_g => operand_width_c,
            ctrl_width_g => ctrl_width_c
        )
        port map(
            operand1_in => operand1_to_duv,
            operand2_in => operand2_to_duv,
            carry_in => carry_to_duv,
            ctrl_in => ctrl_to_duv,
            
            result1_out => result1_from_duv,
            result2_out => result2_from_duv,
            carry_out => carry_from_duv
        );
        
        
    -- Clk generation
    clk <= not clk after clock_period_ms / 2;
    -- Reset signal generation
    rst_n <= '1' after periods_before_start * clock_period_ms;
    
    operand1_to_duv <= std_logic_vector(to_unsigned(input1_integer_sig, operand_width_c));
    operand2_to_duv <= std_logic_vector(to_unsigned(input2_integer_sig, operand_width_c));
    ctrl_to_duv     <= std_logic_vector(to_unsigned(ctrl_integer_sig, ctrl_width_c));
    
    -- Process for generating DUV inputs
    -- Loops both values over and over again
    operand_in_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then
            input1_integer_sig <= 0;
            input2_integer_sig <= 0;
            carry_to_duv <= '0';
            
        elsif clk'event and clk = '1' then
        
            if input1_integer_sig = 2**operand_width_c-1 then
                
                input1_integer_sig <= 0;
                
                if input2_integer_sig = 2**operand_width_c-1 then
                    input2_integer_sig <= 0;
                else
                    input2_integer_sig <= input2_integer_sig + 1;
                end if;
            else
                input1_integer_sig <= input1_integer_sig + 1;
            end if;
        end if;
    end process operand_in_proc;
    
    
    
    
    -- Process for generating DUV control signal
    ctrl_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then

            ctrl_integer_sig <= 1;
            ctrl_increment_counter_int_sig <= 0;

        elsif clk'event and clk = '1' then
            -- Increment ctrl signal
            if (input1_integer_sig = 2**operand_width_c-1) and
                (input2_integer_sig = 2**operand_width_c-1) then
                ctrl_increment_counter_int_sig <= ctrl_increment_counter_int_sig + 1;
                ctrl_integer_sig <= ctrl_integer_sig + 1;
            end if;
        end if;
    end process ctrl_proc;
    
    
    
    
    --Process for checking if the ALU outpus are correct
    check_output_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then
            output_correct <= '1';
        elsif clk'event and clk = '1' then
            case ctrl_integer_sig is
                -- Add operation without carry bit
                when 1 =>
                    assert  std_logic_vector(
                            to_unsigned(input1_integer_sig, operand_width_c) +
                            to_unsigned(input2_integer_sig, operand_width_c)
                            )
                            =
                            result1_from_duv
                            report "Invalid output value!"
                            severity failure;
                -- Add operation with carry bit
                when 2 =>
                    if carry_to_duv = '0' then
                        assert  std_logic_vector(
                                to_unsigned(input1_integer_sig, operand_width_c) +
                                to_unsigned(input2_integer_sig, operand_width_c)
                                )
                                =
                                result1_from_duv
                                report "Invalid output value!"
                                severity failure;
                    else
                        assert  std_logic_vector(
                                to_unsigned(input1_integer_sig, operand_width_c) +
                                to_unsigned(input2_integer_sig, operand_width_c) +
                                1
                                )           
                                =
                                result1_from_duv
                                report "Invalid output value!"
                                severity failure;
                    end if;
                    
                when 3 =>
                    assert std_logic_vector(
                           to_unsigned(input1_integer_sig, operand_width_c)-
                           to_unsigned(input2_integer_sig, operand_width_c)
                           )
                           = result1_from_duv
                           report "Invalid output value!"
                           severity failure;
                when 4 =>
                    if carry_to_duv = '0' then
                        assert  std_logic_vector(
                                to_unsigned(input1_integer_sig, operand_width_c) -
                                to_unsigned(input2_integer_sig, operand_width_c)
                                )
                                =
                                result1_from_duv
                                report "Invalid output value!"
                                severity failure;
                    else
                        assert  std_logic_vector(
                                to_unsigned(input1_integer_sig, operand_width_c) -
                                to_unsigned(input2_integer_sig, operand_width_c) -
                                1
                                )           
                                =
                                result1_from_duv
                                report "Invalid output value!"
                                severity failure;
                    end if;
                 -- Bitwise and
                when 5 =>
                    assert result1_from_duv = (operand1_to_duv and operand2_to_duv)
                        report "Invalid output"
                        severity failure;
                        
                -- Bitwise or
                when 6 =>
                    assert result1_from_duv = (operand1_to_duv or operand2_to_duv)
                        report "Invalid output"
                        severity failure;
                          
                -- Bitwise xor
                when 7 => 
                    assert result1_from_duv = (operand1_to_duv xor operand2_to_duv)
                        report "Invalid output"
                        severity failure;
                
                -- One's complement
                when 8 => 
                    assert result1_from_duv = not operand1_to_duv
                        report "Invalid output"
                        severity failure;
                -- Two's complement
                when 9 =>
                    assert signed(result1_from_duv) = -signed(operand1_to_duv)
                        report "Invalid output"
                        severity failure;
                -- Increment operand 1
                when 10 =>
                    assert signed(result1_from_duv) = (signed(operand1_to_duv) + 1)
                        report "Invalid output"
                        severity failure;
                -- Decrement operand 2
                when 11 =>
                    assert signed(result1_from_duv) = (signed(operand1_to_duv) - 1)
                        report "Invalid output"
                        severity failure;
                -- Multiply inputs (unsigned)
                when 12 =>
                    assert unsigned(result2_from_duv & result1_from_duv) =
                        to_unsigned(input1_integer_sig * input2_integer_sig, 2*operand_width_c)
                        report "Invalid output"
                        severity failure;
                -- Multiply inputs (signed) 
                when 13 =>
                    assert signed(result2_from_duv & result1_from_duv) =
                        to_signed(input1_integer_sig, operand_width_c) *
                        to_signed(input2_integer_sig, operand_width_c);
                        report "Invalid output"
                        severity failure;
                -- Invalid code
                when others =>
                
            end case;
        end if;
    end process check_output_proc;

    -- Process for checking flag states
    check_flag_proc : process(clk, rst_n)
    begin
        if rst_n = '0' then
        elsif clk'event and clk = '1' then
            case ctrl_integer_sig is
                -- Adding without carry in
                when 1 =>
                    if input1_integer_sig + input2_integer_sig > 255 then
                        assert carry_from_duv = '1'
                               report "Invalid carry flag value"
                               severity failure;
                    end if;
                    
                -- Adding with carry in
                when 2 =>
                    if carry_to_duv = '1' then
                        if input1_integer_sig + input2_integer_sig > 254 then
                            assert carry_from_duv = '1'
                                   report "Invalid carry flag value"
                                   severity failure;
                        else
                            assert carry_from_duv = '0'
                                   report "Invalid carry flag value"
                                   severity failure;
                        end if;
                    else
                        if input1_integer_sig + input2_integer_sig > 255 then
                            assert carry_from_duv = '1'
                                   report "Invalid carry flag value"
                                   severity failure;
                        else
                            assert carry_from_duv = '0'
                                   report "Invalid carry flag value"
                                   severity failure;
                        end if;
                    end if;
                
                -- Subtracting without carry in
                when 3 =>
                    if input2_integer_sig > input1_integer_sig then
                        assert carry_from_duv = '1' report "Invalid carry flag value"
                            severity failure;
                    else
                        assert carry_from_duv = '0' report "Invalid carry flag value"
                            severity failure;
                    end if;

                -- Subtracting with carry in
                when 4 =>
                    if carry_to_duv = '1' then
                        if input2_integer_sig + 1 > input1_integer_sig then
                            assert carry_from_duv = '1' report "Invalid carry flag value"
                                severity failure;
                        else
                            assert carry_from_duv = '0' report "Invalid carry flag value"
                                severity failure;
                        end if;
                    else
                        if input2_integer_sig > input1_integer_sig then
                            assert carry_from_duv = '1' report "Invalid carry flag value"
                                severity failure;
                        else
                            assert carry_from_duv = '0' report "Invalid carry flag value"
                                severity failure;
                        end if;
                    end if;
                
                -- Bitwise and
                when 5 =>
                -- Bitwise or
                when 6 =>
                -- Bitwise xor
                when 7 => 
                -- One's complement
                when 8 => 
                when 9 => 
                when 10 => 
                when 11 =>
                when others =>
            end case;
        end if;
    end process check_flag_proc;
    
    
    -- Stops the simulation if all functionalities have been checked
    assert ctrl_increment_counter_int_sig /= 13 report "Simulation success" severity failure;

end testbench;