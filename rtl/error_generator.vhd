library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library viterbilib;
use viterbilib.viterbi_package.all;

entity error_generator is
    generic(error_vector : std_logic_vector((2*tracelength)-1 downto 0));
    port(
        clock    : in  std_logic;
        reset    : in  std_logic;
        datain   : in  std_logic;
        dataout  : out std_logic
        );
    end entity;
    
architecture struct of error_generator is

signal error_register : std_logic_vector((2*tracelength)-1 downto 0);
signal data_error : std_logic;

begin       

    process(reset, clock)
    begin
        if reset = '1' then
            error_register <= error_vector;
        elsif clock'event and clock = '1' then
            for j in (2*tracelength)-1 downto 1 LOOP
                error_register(j) <= error_register(j-1);
            END LOOP;
                error_register(0) <= error_register((2*tracelength)-1);
        end if;
    end process;
     
    data_error <= error_register(15);
    dataout    <= data_error xor datain;
    
            

end architecture;       