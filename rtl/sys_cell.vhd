library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


library viterbilib;
use viterbilib.viterbi_package.all;

entity sys_cell is
    port(
        clock        : in  std_logic;
        reset        : in  std_logic;
        cell_inp     : in  std_logic;
        cell_weight  : in  std_logic_vector(1 downto 0);
        data_i       : in  std_logic_vector(1 downto 0);
        distance_i   : in  std_logic_vector(tracelength-1 downto 0);
        rute_i       : in  std_logic_vector(tracelength-1 downto 0);
        distance_o   : out std_logic_vector(tracelength-1 downto 0);
        rute_o       : out std_logic_vector(tracelength-1 downto 0)
        );
    end entity;
    
architecture struct of sys_cell is

begin       
    process(reset, clock)
    variable v_distance : std_logic_vector(tracelength-1 downto 0);
    variable hamming    : std_logic_vector(1 downto 0);
    begin
        if reset = '1' then
            v_distance := (others => '0');
            hamming    := (others => '0');
        elsif clock'event and clock = '1' then
            hamming    := cell_weight xor data_i;
            v_distance := distance_i;
            if hamming(1) = '1' then 
                v_distance := v_distance + 1;
            end if;
            if hamming(0) = '1' then 
                v_distance := v_distance + 1;
            end if;
        end if;
        distance_o  <= v_distance;
    end process;
    
    process(reset, clock)
    begin
        if reset = '1' then
            rute_o <= (others => 'Z');
        elsif clock'event and clock = '1' then
        for j in tracelength-1 downto 1 LOOP
                rute_o(j) <= rute_i(j-1);
            END LOOP;
                rute_o(0) <= cell_inp;
        end if;
    end process;
     
            

end architecture;       