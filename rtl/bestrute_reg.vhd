library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library viterbilib;
use viterbilib.viterbi_package.all;

entity bestrute_reg is
    port(
        reset	 	   : in  std_logic;
		clock    	   : in  std_logic;
        rute_vld 	   : in  std_logic;
		distance_pe1_0 : in  std_logic_vector(tracelength-1 downto 0); 
		distance_pe1_1 : in  std_logic_vector(tracelength-1 downto 0); 
		rute_pe1_0     : in  std_logic_vector(tracelength-1 downto 0); 
		rute_pe1_1     : in  std_logic_vector(tracelength-1 downto 0); 
		distance_pe2_0 : in  std_logic_vector(tracelength-1 downto 0); 
		distance_pe2_1 : in  std_logic_vector(tracelength-1 downto 0); 
		rute_pe2_0     : in  std_logic_vector(tracelength-1 downto 0); 
		rute_pe2_1     : in  std_logic_vector(tracelength-1 downto 0); 
		distance_pe3_0 : in  std_logic_vector(tracelength-1 downto 0); 
		distance_pe3_1 : in  std_logic_vector(tracelength-1 downto 0); 
		rute_pe3_0     : in  std_logic_vector(tracelength-1 downto 0); 
		rute_pe3_1     : in  std_logic_vector(tracelength-1 downto 0); 
		distance_pe4_0 : in  std_logic_vector(tracelength-1 downto 0); 
		distance_pe4_1 : in  std_logic_vector(tracelength-1 downto 0); 
		rute_pe4_0     : in  std_logic_vector(tracelength-1 downto 0); 
		rute_pe4_1     : in  std_logic_vector(tracelength-1 downto 0); 
		dataout  	   : out std_logic
        );
    end entity;
    
architecture rtl of bestrute_reg is


	signal best_rute      : std_logic_vector(tracelength-1 downto 0); 

begin       
    
    process(reset, clock)
    begin
    if reset = '1' then
        best_rute <= (others => '0');
    elsif clock'event and clock = '1' then
        if rute_vld = '1' then
            if (distance_pe1_0 <= distance_pe1_1) and (distance_pe1_0 <= distance_pe2_0) and (distance_pe1_0 <= distance_pe2_1) and (distance_pe1_0 <= distance_pe3_0)
                and (distance_pe1_0 <= distance_pe3_1) and (distance_pe1_0 <= distance_pe4_0) and (distance_pe1_0 <= distance_pe4_1) then
            best_rute <= rute_pe1_0;
            elsif (distance_pe1_1 <= distance_pe1_0) and (distance_pe1_1 <= distance_pe2_0) and (distance_pe1_1 <= distance_pe2_1) and (distance_pe1_1 <= distance_pe3_0)
                and (distance_pe1_1 <= distance_pe3_1) and (distance_pe1_1 <= distance_pe4_0) and (distance_pe1_1 <= distance_pe4_1) then
            best_rute <= rute_pe1_1;
            elsif (distance_pe2_0 <= distance_pe2_0) and (distance_pe2_0 <= distance_pe1_1) and (distance_pe2_0 <= distance_pe2_1) and (distance_pe2_0 <= distance_pe3_0)
                and (distance_pe2_0 <= distance_pe3_1) and (distance_pe2_0 <= distance_pe4_0) and (distance_pe2_0 <= distance_pe4_1) then
            best_rute <= rute_pe2_0;
            elsif (distance_pe2_1 <= distance_pe1_0) and (distance_pe2_1 <= distance_pe1_1) and (distance_pe2_1 <= distance_pe2_0) and (distance_pe2_1 <= distance_pe3_0)
                and (distance_pe2_1 <= distance_pe3_1) and (distance_pe2_1 <= distance_pe4_0) and (distance_pe2_1 <= distance_pe4_1) then
            best_rute <= rute_pe2_1;
            elsif (distance_pe3_0 <= distance_pe1_0) and (distance_pe3_0 <= distance_pe1_1) and (distance_pe3_0 <= distance_pe2_0) and (distance_pe3_0 <= distance_pe2_1)
                and (distance_pe3_0 <= distance_pe3_1) and (distance_pe3_0 <= distance_pe4_0) and (distance_pe3_0 <= distance_pe4_1) then
            best_rute <= rute_pe3_0;
            elsif (distance_pe3_1 <= distance_pe1_0) and (distance_pe3_1 <= distance_pe1_1) and (distance_pe3_1 <= distance_pe2_0) and (distance_pe3_1 <= distance_pe2_1)
                and (distance_pe3_1 <= distance_pe3_0) and (distance_pe3_1 <= distance_pe4_0) and (distance_pe3_1 <= distance_pe4_1) then
            best_rute <= rute_pe3_1;
            elsif (distance_pe4_0 <= distance_pe1_0) and (distance_pe4_0 <= distance_pe1_1) and (distance_pe4_0 <= distance_pe2_0) and (distance_pe4_0 <= distance_pe2_1)
                and (distance_pe4_0 <= distance_pe3_0) and (distance_pe4_0 <= distance_pe3_1) and (distance_pe4_0 <= distance_pe4_1) then
            best_rute <= rute_pe4_0;
            elsif (distance_pe4_1 <= distance_pe1_0) and (distance_pe4_1 <= distance_pe1_1) and (distance_pe4_1 <= distance_pe2_0) and (distance_pe4_1 <= distance_pe2_1)
                and (distance_pe4_1 <= distance_pe3_0) and (distance_pe4_1 <= distance_pe3_1) and (distance_pe4_1 <= distance_pe4_0) then
            best_rute <= rute_pe4_1;
            end if;
        else
         for j in tracelength-1 downto 1 LOOP
                best_rute(j) <= best_rute(j-1);
            END LOOP;
                best_rute(0) <= best_rute(tracelength-1);
        end if;
    end if;
    end process;
    
    dataout <= best_rute(tracelength-1);
	
end architecture;       