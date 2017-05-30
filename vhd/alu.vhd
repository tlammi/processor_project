----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2017-04-08
-- File:    alu.vhd
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

entity alu is
    generic(
        operand_width_g : integer := 8;
        ctrl_width_g : integer := 4
    );
    port(
        operand1_in : in std_logic_vector(operand_width_g - 1 downto 0);
        operand2_in : in std_logic_vector(operand_width_g - 1 downto 0);
        
        carry_in : in std_logic;
        
        ctrl_in : in std_logic_vector(ctrl_width_g - 1 downto 0);
        
        result1_out : out std_logic_vector(operand_width_g - 1 downto 0);
        result2_out : out std_logic_vector(operand_width_g - 1 downto 0);
        
        carry_out : out std_logic
        
    );
end alu;



architecture rtl of alu is
    -- Constants
    constant ctrl_ADD_c : integer := 1; -- Add operands
    constant ctrl_ADC_c : integer := 2; -- Add operands with carry
    constant ctrl_SUB_c : integer := 3; -- Subtract operand 2 from operand 1
    constant ctrl_SBC_c : integer := 4; -- Subtract operand 2 from operand 1 with carry
    constant ctrl_AND_c : integer := 5; -- Bitwise and among operands
    constant ctrl_OR_c  : integer := 6; -- Bitwise or among operands
    constant ctrl_XOR_c : integer := 7; -- Bitwise xor among operands
    constant ctrl_COM_c : integer := 8; -- One's complement from operand1
    constant ctrl_NEG_c : integer := 9; -- Two's complement from operand1
    constant ctrl_INC_c : integer := 10; -- Increment operand1 by one
    constant ctrl_DEC_c : integer := 11; -- Decrement operand1 by one
    constant ctrl_MUL_c : integer := 12; -- Multiply inputs to outputs (unsigned)
    constant ctrl_MULS_c : integer := 13; -- Multiply inputs to outputs (signed)
    
    -- Signals
    signal ctrl_integer_sig : integer range 0 to 2**ctrl_width_g-1;
begin
    -- Ctrl signal to integer for easier comparison
    ctrl_integer_sig <= to_integer(unsigned(ctrl_in));
    
    arith_proc : process(ctrl_integer_sig, operand1_in, operand2_in, carry_in)
        variable result_var : std_logic_vector(operand_width_g downto 0);
        variable mult_res_var : std_logic_vector(2*operand_width_g-1 downto 0);
    begin
        -- Initially carry_out is '0'
        carry_out <= '0';
        -- Initially the outputs are 0
        result2_out <= (others => '0');
        result1_out <= (others => '0');
        
        case ctrl_integer_sig is
            -- Simple addition
            when ctrl_ADD_c =>
                result_var := std_logic_vector(signed('0' & operand1_in) + signed( '0' & operand2_in));
                result1_out <= result_var(operand_width_g-1 downto 0);
                carry_out <= result_var(operand_width_g);
            
            -- Addition with carry in
            when ctrl_ADC_c =>
                if carry_in = '1' then
                    result_var := std_logic_vector(signed('0' & operand1_in)+
                                    signed( '0' & operand2_in) +
                                    to_signed(1, operand_width_g+1));
                else 
                    result_var := std_logic_vector(signed('0' & operand1_in)+
                                    signed( '0' & operand2_in));
                end if;
                result1_out <= result_var(operand_width_g-1 downto 0);
                carry_out <= result_var(operand_width_g);
            
            -- Subtract operand2 from operand1
            when ctrl_SUB_c =>
                result_var := std_logic_vector(signed('0'&operand1_in) - signed('0'&operand2_in));
                carry_out <= result_var(operand_width_g);
                result1_out <= result_var(operand_width_g-1 downto 0);
                
            when ctrl_SBC_c =>
                if carry_in = '1' then
                    result_var := std_logic_vector(signed('0'&operand1_in)
                                            -signed('0'&operand2_in)-1);
                else
                    result_var := std_logic_vector(signed('0'&operand1_in) -
                                            signed('0'&operand2_in));
                end if;
                carry_out <= result_var(operand_width_g);
                result1_out <= result_var(operand_width_g-1 downto 0);
            
            -- Bitwise and
            when ctrl_AND_c =>
                for i in 0 to operand_width_g-1 loop
                    result1_out(i) <= operand1_in(i) and operand2_in(i);
                end loop;
            
            -- Bitwise or
            when ctrl_OR_c =>
                for i in 0 to operand_width_g-1 loop
                    result1_out(i) <= operand1_in(i) or operand2_in(i);
                end loop;

            -- Bitwise xor
            when ctrl_XOR_c =>
                for i in 0 to operand_width_g-1 loop
                    result1_out(i) <= operand1_in(i) xor operand2_in(i);
                end loop;
                
            -- Inverted bits from operand1_in to result1_out
            when ctrl_COM_c =>
                --for i in 0 to operand_width_g-1 loop
                --    result1_out(i) <= not operand1_in(i);
                --end loop;
                result1_out <= not operand1_in;
                
            -- Two's complement of operand1_in to result1_out
            when ctrl_NEG_c =>
                result1_out <= std_logic_vector(-signed(operand1_in));
                
            when ctrl_INC_c =>
                result1_out <= std_logic_vector(signed(operand1_in) + 1 );
            when ctrl_DEC_c =>
                result1_out <= std_logic_vector(signed(operand1_in) - 1 );
                
            when ctrl_MUL_c =>
                mult_res_var := std_logic_vector(unsigned(operand1_in) *
                                            unsigned(operand2_in));
                result2_out <= mult_res_var(2*operand_width_g-1 downto operand_width_g);
                result1_out <= mult_res_var(operand_width_g-1 downto 0);
                
            when ctrl_MULS_c =>
                mult_res_var := std_logic_vector(signed(operand1_in) *
                                                signed(operand2_in));
                result2_out <= mult_res_var(2*operand_width_g-1 downto operand_width_g);
                result1_out <= mult_res_var(operand_width_g-1 downto 0);
                
            when others =>
        end case;
    end process arith_proc;
    
    
end rtl;