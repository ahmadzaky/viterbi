library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library viterbilib;
use viterbilib.viterbi_package.all;

entity compare_select is
    port(
        reset	   	 : in  std_logic;
		clock      	 : in  std_logic;
		distance_a 	 : in  std_logic_vector(tracelength-1 downto 0);
		distance_b 	 : in  std_logic_vector(tracelength-1 downto 0);
        rute_a     	 : in  std_logic_vector(tracelength-1 downto 0);
        rute_b     	 : in  std_logic_vector(tracelength-1 downto 0);
		distance_min : out std_logic_vector(tracelength-1 downto 0);
        rute_min     : out std_logic_vector(tracelength-1 downto 0)
        );
    end entity;
    
architecture rtl of compare_select is

begin       

        process(reset, clock)
        begin
        if reset = '1' then 
            distance_min  	<= (others =>'0');
            rute_min 		<= (others =>'0');
        elsif clock'event and clock = '1' then 
            if distance_a < distance_b then
               distance_min <= distance_a;
               rute_min     <= rute_a; 
            else
               distance_min <= distance_b;
               rute_min     <= rute_b; 
            end if;
        end if;
        end process;
    
end architecture;       