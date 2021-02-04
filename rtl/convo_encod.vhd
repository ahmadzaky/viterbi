library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library viterbilib;
use viterbilib.viterbi_package.all;

entity convo_encod is
    port(
        clock  : in  std_logic;
        reset  : in  std_logic;
        datain : in  std_logic;
        dataout: out std_logic_vector(1 downto 0)
        );
    end entity;
    
architecture rtl of convo_encod is

signal s_data0 : std_logic;
signal s_data1 : std_logic;
signal s_data2 : std_logic;
signal s_data3 : std_logic;

begin       
    
    i_shift_reg : shift_reg
    port map
    (   clock  => clock,
        reset  => reset,
        datain => datain,
        data0  => s_data0,
        data1  => s_data1,
        data2  => s_data2,
        data3  => s_data3
    );
    
    dataout(1) <= s_data0 xor s_data1 xor s_data2 xor s_data3;
    dataout(0) <= s_data0 xor s_data2 xor s_data3;
            
    
end architecture;       