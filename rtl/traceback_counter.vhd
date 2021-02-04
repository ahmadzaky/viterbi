library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library viterbilib;
use viterbilib.viterbi_package.all;

entity traceback_counter is
    port(
        reset	 : in  std_logic;
		clock    : in  std_logic;
		rute_vld : out std_logic
        );
    end entity;
    
architecture rtl of traceback_counter is


	signal count          : integer;

begin       
    
    process(reset, clock)
    begin
    if reset = '1' then
        count <= 0;
    elsif clock'event and clock = '1' then
        if count = tracelength-1 then
            count <= 0;
        else
            count <= count + 1;
        end if;
    end if;
    end process;
    
    rute_vld <= '1' when (count = tracelength-1) else '0';
    
end architecture;       