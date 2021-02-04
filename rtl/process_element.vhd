library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


library viterbilib;
use viterbilib.viterbi_package.all;

entity process_element is
    port(
        clock        : in  std_logic;
        reset        : in  std_logic;
        present_state: in  pe_state;
        datain       : in  std_logic_vector(1 downto 0);
        distance_a   : in  std_logic_vector(tracelength-1 downto 0);
        rute_a       : in  std_logic_vector(tracelength-1 downto 0);
        distance_b   : in  std_logic_vector(tracelength-1 downto 0);
        rute_b       : in  std_logic_vector(tracelength-1 downto 0);
        distance_s0  : out std_logic_vector(tracelength-1 downto 0);
        rute_s0      : out std_logic_vector(tracelength-1 downto 0);
        distance_s1  : out std_logic_vector(tracelength-1 downto 0);
        rute_s1      : out std_logic_vector(tracelength-1 downto 0)
        );
    end entity;
    
architecture struct of process_element is

    signal s_distance_a0  : std_logic_vector(tracelength-1 downto 0);
    signal s_distance_b0  : std_logic_vector(tracelength-1 downto 0);
    signal s_distance_a1  : std_logic_vector(tracelength-1 downto 0);
    signal s_distance_b1  : std_logic_vector(tracelength-1 downto 0);
    signal s_rute_a0      : std_logic_vector(tracelength-1 downto 0);
    signal s_rute_a1      : std_logic_vector(tracelength-1 downto 0);
    signal s_rute_b0      : std_logic_vector(tracelength-1 downto 0);
    signal s_rute_b1      : std_logic_vector(tracelength-1 downto 0);
    signal weight_a0      : std_logic_vector(1 downto 0);
    signal weight_a1      : std_logic_vector(1 downto 0);
    signal weight_b0      : std_logic_vector(1 downto 0);
    signal weight_b1      : std_logic_vector(1 downto 0);
    signal min_s0    	  : std_logic_vector(tracelength-1 downto 0);
    signal min_rute_s0    : std_logic_vector(tracelength-1 downto 0);
    signal min_s1    	  : std_logic_vector(tracelength-1 downto 0);
    signal min_rute_s1    : std_logic_vector(tracelength-1 downto 0);

begin       

    weight_a0     <= "00" when (present_state = S0S1) else "11" when (present_state = S2S3) else "01" when (present_state = S4S5) else "10";
	weight_b1     <= weight_a0;	
	weight_a1     <= not weight_a0;	
	weight_b0	  <= weight_a1;

    A0 : sys_cell 
    port map(
        clock        => clock, 
        reset        => reset, 
        cell_inp     => '0', 
        cell_weight  => weight_a0, 
        data_i       => datain, 
        distance_i   => distance_a, 
        rute_i       => rute_a, 
        distance_o   => s_distance_a0, 
        rute_o       => s_rute_a0
        );
            
    A1 : sys_cell 
    port map(
        clock        => clock, 
        reset        => reset, 
        cell_inp     => '1', 
        cell_weight  => weight_a1, 
        data_i       => datain, 
        distance_i   => distance_a, 
        rute_i       => rute_a, 
        distance_o   => s_distance_a1, 
        rute_o       => s_rute_a1
        );
            
    B0 : sys_cell 
    port map(
        clock        => clock, 
        reset        => reset, 
        cell_inp     => '0', 
        cell_weight  => weight_b0, 
        data_i       => datain, 
        distance_i   => distance_b, 
        rute_i       => rute_b, 
        distance_o   => s_distance_b0, 
        rute_o       => s_rute_b0
        );
            
    B1 : sys_cell 
    port map(
        clock        => clock, 
        reset        => reset, 
        cell_inp     => '1', 
        cell_weight  => weight_b1, 
        data_i       => datain, 
        distance_i   => distance_b, 
        rute_i       => rute_b, 
        distance_o   => s_distance_b1, 
        rute_o       => s_rute_b1
        );
		
		
	CS0 : compare_select 
    port map(
        reset	   	 => reset,
		clock      	 => clock,
		distance_a 	 => s_distance_a0,
		distance_b 	 => s_distance_b0,
        rute_a     	 => s_rute_a0,
        rute_b     	 => s_rute_b0,
		distance_min => min_s0,
        rute_min     => min_rute_s0
        );
        
	CS1 : compare_select 
    port map(
        reset	   	 => reset,
		clock      	 => clock,
		distance_a 	 => s_distance_a1,
		distance_b 	 => s_distance_b1,
        rute_a     	 => s_rute_a1,
        rute_b     	 => s_rute_b1,
		distance_min => min_s1,
        rute_min     => min_rute_s1
        );
        
        
		 distance_s0     <= min_s0 when ((present_state = S0S1) or (present_state = S4S5)) else min_s1;
		 rute_s0	     <= min_rute_s0 when ((present_state = S0S1) or (present_state = S4S5)) else min_rute_s1;
		 distance_s1     <= min_s1 when ((present_state = S0S1) or (present_state = S4S5)) else min_s0;
		 rute_s1	     <= min_rute_s1 when ((present_state = S0S1) or (present_state = S4S5)) else min_rute_s0;
        

end architecture;       