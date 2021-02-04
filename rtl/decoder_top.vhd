library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library viterbilib;
use viterbilib.viterbi_package.all;

entity decoder_top is
    port(
        clock  : in  std_logic;
        reset  : in  std_logic;
        datain : in  std_logic;
        dataout: out std_logic);
    end entity;
    
architecture struct of decoder_top is
	signal s_clock          : std_logic;
	signal s_pardata        : std_logic_vector(1 downto 0); 
	signal distance_pe1_0   : std_logic_vector(tracelength-1 downto 0); 
	signal distance_pe1_1   : std_logic_vector(tracelength-1 downto 0); 
	signal rute_pe1_0       : std_logic_vector(tracelength-1 downto 0); 
	signal rute_pe1_1       : std_logic_vector(tracelength-1 downto 0); 
	signal distance_pe2_0   : std_logic_vector(tracelength-1 downto 0); 
	signal distance_pe2_1   : std_logic_vector(tracelength-1 downto 0); 
	signal rute_pe2_0       : std_logic_vector(tracelength-1 downto 0); 
	signal rute_pe2_1       : std_logic_vector(tracelength-1 downto 0); 
	signal distance_pe3_0   : std_logic_vector(tracelength-1 downto 0); 
	signal distance_pe3_1   : std_logic_vector(tracelength-1 downto 0); 
	signal rute_pe3_0       : std_logic_vector(tracelength-1 downto 0); 
	signal rute_pe3_1       : std_logic_vector(tracelength-1 downto 0); 
	signal distance_pe4_0   : std_logic_vector(tracelength-1 downto 0); 
	signal distance_pe4_1   : std_logic_vector(tracelength-1 downto 0); 
	signal rute_pe4_0       : std_logic_vector(tracelength-1 downto 0); 
	signal rute_pe4_1       : std_logic_vector(tracelength-1 downto 0); 
	signal s_distance_pe1_0 : std_logic_vector(tracelength-1 downto 0); 
	signal s_distance_pe1_1 : std_logic_vector(tracelength-1 downto 0); 
	signal s_rute_pe1_0     : std_logic_vector(tracelength-1 downto 0); 
	signal s_rute_pe1_1     : std_logic_vector(tracelength-1 downto 0); 
	signal s_distance_pe2_0 : std_logic_vector(tracelength-1 downto 0); 
	signal s_distance_pe2_1 : std_logic_vector(tracelength-1 downto 0); 
	signal s_rute_pe2_0     : std_logic_vector(tracelength-1 downto 0); 
	signal s_rute_pe2_1     : std_logic_vector(tracelength-1 downto 0); 
	signal s_distance_pe3_0 : std_logic_vector(tracelength-1 downto 0); 
	signal s_distance_pe3_1 : std_logic_vector(tracelength-1 downto 0); 
	signal s_rute_pe3_0     : std_logic_vector(tracelength-1 downto 0); 
	signal s_rute_pe3_1     : std_logic_vector(tracelength-1 downto 0); 
	signal s_distance_pe4_0 : std_logic_vector(tracelength-1 downto 0); 
	signal s_distance_pe4_1 : std_logic_vector(tracelength-1 downto 0); 
	signal s_rute_pe4_0     : std_logic_vector(tracelength-1 downto 0); 
	signal s_rute_pe4_1     : std_logic_vector(tracelength-1 downto 0); 
	signal best_rute_vld    : std_logic;
    signal pe1_state        : pe_state;
    signal pe2_state        : pe_state;
    signal pe3_state        : pe_state;
    signal pe4_state        : pe_state;
    signal nxt_pe1_state    : pe_state;
    signal nxt_pe2_state    : pe_state;
    signal nxt_pe3_state    : pe_state;
    signal nxt_pe4_state    : pe_state;
	
begin       

	nxt_pe1_state <= S4S5 when (pe1_state = S0S1) else S6S7 when (pe1_state = S4S5) else S2S3 when (pe1_state = S6S7) else S0S1;
	nxt_pe2_state <= S4S5 when (pe2_state = S6S7) else S6S7 when (pe2_state = S2S3) else S2S3 when (pe2_state = S0S1) else S0S1;
	nxt_pe3_state <= S4S5 when (pe3_state = S0S1) else S6S7 when (pe3_state = S4S5) else S2S3 when (pe3_state = S6S7) else S0S1;
	nxt_pe4_state <= S4S5 when (pe4_state = S6S7) else S6S7 when (pe4_state = S2S3) else S2S3 when (pe4_state = S0S1) else S0S1;
    
	
    process(reset, s_clock)
    begin
    if reset = '1' then
        pe1_state <= S2S3;
    elsif s_clock'event and s_clock = '1' then
        pe1_state <= nxt_pe1_state;
    end if;
    end process;
	
    process(reset, s_clock)
    begin
    if reset = '1' then
        pe2_state <= S6S7;
    elsif s_clock'event and s_clock = '1' then
        pe2_state <= nxt_pe2_state;
    end if;
    end process;
	
    process(reset, s_clock)
    begin
    if reset = '1' then
        pe3_state <= S4S5;
    elsif s_clock'event and s_clock = '1' then
        pe3_state <= nxt_pe3_state;
    end if;
    end process;
	
    process(reset, s_clock)
    begin
    if reset = '1' then
        pe4_state <= S0S1;
    elsif s_clock'event and s_clock = '1' then
        pe4_state <= nxt_pe4_state;
    end if;
    end process;


	SP : ser_par
    port map(
        reset	 => reset,
		clock    => clock,
        datain   => datain,
		dataout  => s_pardata
        );
        
    i_clkdiv : clock_divide
    port map(
        reset	 => reset,
		clock    => clock,
        clockout => s_clock
        );    
		
	TC : traceback_counter
    port map(
        reset	 => reset,
		clock    => s_clock,
		rute_vld => best_rute_vld
        );
        
    REG : bestrute_reg 
    port map(
        reset	 	   => reset,
		clock    	   => s_clock,
        rute_vld 	   => best_rute_vld,
		distance_pe1_0 => distance_pe1_0, 
		distance_pe1_1 => distance_pe1_1, 
		rute_pe1_0     => rute_pe1_0, 
		rute_pe1_1     => rute_pe1_1, 
		distance_pe2_0 => distance_pe2_0, 
		distance_pe2_1 => distance_pe2_1, 
		rute_pe2_0     => rute_pe2_0, 
		rute_pe2_1     => rute_pe2_1, 
		distance_pe3_0 => distance_pe3_0, 
		distance_pe3_1 => distance_pe3_1, 
		rute_pe3_0     => rute_pe3_0, 
		rute_pe3_1     => rute_pe3_1, 
		distance_pe4_0 => distance_pe4_0, 
		distance_pe4_1 => distance_pe4_1, 
		rute_pe4_0     => rute_pe4_0, 
		rute_pe4_1     => rute_pe4_1, 
		dataout  	   => dataout
        );
    
	process(reset, s_clock)
    begin
    if reset = '1' then
        s_distance_pe1_0 <= (others => '0');
        s_rute_pe1_0	 <= (others => '0');
        s_distance_pe1_1 <= (others => '0');
        s_rute_pe1_1	 <= (others => '0');
    elsif s_clock'event and s_clock = '1' then
        s_distance_pe1_0 <= distance_pe1_0;
        s_rute_pe1_0	 <= rute_pe1_0;
        s_distance_pe1_1 <= distance_pe1_1;
        s_rute_pe1_1	 <= rute_pe1_1;
    end if;
    end process;
	
	process(reset, s_clock)
    begin
    if reset = '1' then
        s_distance_pe2_0 <= (others => '0');
        s_rute_pe2_0	 <= (others => '0');
        s_distance_pe2_1 <= (others => '0');
        s_rute_pe2_1	 <= (others => '0');
    elsif s_clock'event and s_clock = '1' then
        s_distance_pe2_0 <= distance_pe2_0;
        s_rute_pe2_0	 <= rute_pe2_0;
        s_distance_pe2_1 <= distance_pe2_1;
        s_rute_pe2_1	 <= rute_pe2_1;
    end if;
    end process;
	
	process(reset, s_clock)
    begin
    if reset = '1' then
        s_distance_pe3_0 <= (others => '0');
        s_rute_pe3_0	 <= (others => '0');
        s_distance_pe3_1 <= (others => '0');
        s_rute_pe3_1	 <= (others => '0');
    elsif s_clock'event and s_clock = '1' then
        s_distance_pe3_0 <= distance_pe3_0;
        s_rute_pe3_0	 <= rute_pe3_0;
        s_distance_pe3_1 <= distance_pe3_1;
        s_rute_pe3_1	 <= rute_pe3_1;
    end if;
    end process;
	
	process(reset, s_clock)
    begin
    if reset = '1' then
        s_distance_pe4_0 <= (others => '0');
        s_rute_pe4_0	 <= (others => '0');
        s_distance_pe4_1 <= (others => '0');
        s_rute_pe4_1	 <= (others => '0');
    elsif s_clock'event and s_clock = '1' then
        s_distance_pe4_0 <= distance_pe4_0;
        s_rute_pe4_0	 <= rute_pe4_0;
        s_distance_pe4_1 <= distance_pe4_1;
        s_rute_pe4_1	 <= rute_pe4_1;
    end if;
    end process;

       
    
     PE1 : process_element  --s0s1, s4s5, s6s7, s2s3, s0s1
    port map(
        clock         => clock,
        reset         => reset,
        datain        => s_pardata,
        present_state => pe1_state,
        distance_a    => s_distance_pe4_0,
        rute_a        => s_rute_pe4_0,
        distance_b    => s_distance_pe1_1,
        rute_b        => s_rute_pe1_1,
        distance_s0   => distance_pe1_0,
        rute_s0       => rute_pe1_0,
        distance_s1   => distance_pe1_1,
        rute_s1       => rute_pe1_1
        );
			   
    
     PE2 : process_element  --s4s5, s0s1, s2s3, s6s7, s4s5
    port map(
        clock         => clock,
        reset         => reset,
        datain        => s_pardata,
        present_state => pe2_state,
        distance_a    => s_distance_pe1_0,
        rute_a        => s_rute_pe1_0,
        distance_b    => s_distance_pe4_1,
        rute_b        => s_rute_pe4_1,
        distance_s0   => distance_pe2_0,
        rute_s0       => rute_pe2_0,
        distance_s1   => distance_pe2_1,
        rute_s1       => rute_pe2_1
        );

    
     PE3 : process_element  --s6s7, s2s3, s0s1, s4s5, s6s7
    port map(
        clock         => clock,
        reset         => reset,
        datain        => s_pardata,
        present_state => pe3_state,
        distance_a    => s_distance_pe2_0,
        rute_a        => s_rute_pe2_0,
        distance_b    => s_distance_pe3_1,
        rute_b        => s_rute_pe3_1,
        distance_s0   => distance_pe3_0,
        rute_s0       => rute_pe3_0,
        distance_s1   => distance_pe3_1,
        rute_s1       => rute_pe3_1
        );

   
     PE4 : process_element  --s2s3, s6s7, s4s5, s0s1, s2s3
    port map(
        clock         => clock,
        reset         => reset,
        datain        => s_pardata,
        present_state => pe4_state,
        distance_a    => s_distance_pe3_0,
        rute_a        => s_rute_pe3_0,
        distance_b    => s_distance_pe2_1,
        rute_b        => s_rute_pe2_1,
        distance_s0   => distance_pe4_0,
        rute_s0       => rute_pe4_0,
        distance_s1   => distance_pe4_1,
        rute_s1       => rute_pe4_1
        );
        
end architecture;       