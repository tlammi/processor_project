----------------------------------------------------
-- Project: processor
-- Author:  Toni Lammi
-- Date:    2016-11-28
-- File:    bitwise_block.vhd
-- Design:  Bitwise Block 
----------------------------------------------------
-- Description: Contains all bitwise operation blocks in ALU
----------------------------------------------------
-- $Log$
--  Author      |   Date        |   Info
--  Toni Lammi  |   2016-12-02  | Initial structure
----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


-- This block is used to connect all bitwise operations to ALU
-- The correct block is selected with operation_select_in
--  operation_select_in |   operation
--  000                 |   reserved
--  001                 |   and   
--  010                 |   nand
--  011                 |   nor
--  100                 |   or
--  101                 |   xor
--  110                 |   complement
--  111                 |   reserved
entity bitwise_block is
    generic( byte_width_g : integer);
    port(
        -- First operand
        operand1_in             : in std_logic_vector(byte_width_g-1 downto 0);
        -- Second operand
        operand2_in             : in std_logic_vector(byte_width_g-1 downto 0);
        -- Operation type
        operation_select_in     : in std_logic_vector(2 downto 0);
        -- Operation result
        result_out              : out std_logic_vector(byte_width_g-1 downto 0)
    );
end bitwise_block;


architecture structural of bitwise_block is
    -- Constants
    
    -- Signals
    signal before_components1    : std_logic_vector(byte_width_g-1 downto 0);
    signal before_components2    : std_logic_vector(byte_width_g-1 downto 0);
    
    signal and_result           : std_logic_vector(byte_width_g-1 downto 0);
    signal nand_result           : std_logic_vector(byte_width_g-1 downto 0);
    signal nor_result           : std_logic_vector(byte_width_g-1 downto 0);
    signal or_result           : std_logic_vector(byte_width_g-1 downto 0);
    signal xor_result           : std_logic_vector(byte_width_g-1 downto 0);
    signal complement_result           : std_logic_vector(byte_width_g-1 downto 0);
      
    -- Components
    component bitwise_ander is
        generic(byte_width_g : integer);
        port(
            data1_in : in std_logic_vector(byte_width_g-1 downto 0);
            data2_in : in std_logic_vector(byte_width_g-1 downto 0);
            data_out : out std_logic_vector(byte_width_g-1 downto 0)
        );
    end component;
    
    component bitwise_nander is
        generic(byte_width_g : integer);
        port(
            data1_in : in std_logic_vector(byte_width_g-1 downto 0);
            data2_in : in std_logic_vector(byte_width_g-1 downto 0);
            data_out : out std_logic_vector(byte_width_g-1 downto 0)
        );
    end component;
    
    component bitwise_orrer is
        generic(byte_width_g : integer);
        port(
            data1_in : in std_logic_vector(byte_width_g-1 downto 0);
            data2_in : in std_logic_vector(byte_width_g-1 downto 0);
            data_out : out std_logic_vector(byte_width_g-1 downto 0)
        );
    end component;
    
    component bitwise_norrer is
        generic(byte_width_g : integer);
        port(
            data1_in : in std_logic_vector(byte_width_g-1 downto 0);
            data2_in : in std_logic_vector(byte_width_g-1 downto 0);
            data_out : out std_logic_vector(byte_width_g-1 downto 0)
        );
    end component;
    
    component bitwise_xorrer is
        generic(byte_width_g : integer);
        port(
            data1_in : in std_logic_vector(byte_width_g-1 downto 0);
            data2_in : in std_logic_vector(byte_width_g-1 downto 0);
            data_out : out std_logic_vector(byte_width_g-1 downto 0)
        );
    end component;
    
    component bitwise_complementer is
        generic(byte_width_g: integer);
        port(
            data_in : in std_logic_vector(byte_width_g-1 downto 0);
            data_out : out std_logic_vector(byte_width_g-1 downto 0)
        );
    end component;
begin
    
    ander : bitwise_ander
        generic map(byte_width_g => byte_width_g)
        port map(
            data1_in => before_components1,
            data2_in => before_components2,
            data_out => and_result
        );
    
    nander : bitwise_nander
        generic map(byte_width_g => byte_width_g)
        port map(
            data1_in => before_components1,
            data2_in => before_components2,
            data_out => nand_result
        );
    
    norrer : bitwise_norrer
        generic map(byte_width_g => byte_width_g)
        port map(
            data1_in => before_components1,
            data2_in => before_components2,
            data_out => nor_result
        );
        
    orrer : bitwise_orrer
        generic map(byte_width_g => byte_width_g)
        port map(
            data1_in => before_components1,
            data2_in => before_components2,
            data_out => or_result
        );
        
    xorrer : bitwise_xorrer
        generic map(byte_width_g => byte_width_g)
        port map(
            data1_in => before_components1,
            data2_in => before_components2,
            data_out => xor_result
        );
        
    complementer : bitwise_complementer
        generic map(byte_width_g => byte_width_g)
        port map(
            data_in => before_components1,
            data_out => complement_result
        );
    
    before_components1 <= operand1_in;
    before_components2 <= operand2_in;
    
    -- Multiplexer after sub blocks
    -- that selects the wanted operation
    with operation_select_in select
        result_out <=   and_result when "001",
                        nand_result when "010",
                        nor_result when "011",
                        or_result when "100",
                        xor_result when "101",
                        complement_result when "110",
                        (others => '0') when others;
        

end structural;







