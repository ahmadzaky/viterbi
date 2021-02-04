library IEEE;
    use IEEE.STD_LOGIC_1164.all;


package viterbi_package is


type pe_state is (S0S1, S2S3, S4S5, S6S7);
constant tracelength : integer := 32;
  

component shift_reg
    port(
        clock  : in  std_logic;
        reset  : in  std_logic;
        datain : in  std_logic;
        data0  : out std_logic;
        data1  : out std_logic;
        data2  : out std_logic;
        data3  : out std_logic
        );
    end component;
	
	component convo_encod
    port(
        clock  : in  std_logic;
        reset  : in  std_logic;
        datain : in  std_logic;
        dataout: out std_logic_vector(1 downto 0)
        );
    end component;
	
	component clock_divide
    port(
        reset	 : in  std_logic;
		clock    : in  std_logic;
        clockout : out std_logic
        );
    end component;
	
	component par_ser
    port(
        reset	 : in  std_logic;
		clock    : in  std_logic;
		half_clk : in  std_logic;
        datain   : in  std_logic_vector(1 downto 0);
		dataout  : out std_logic
        );
    end component;
	
	component encoder_top
    port(
        clock  : in  std_logic;
        reset  : in  std_logic;
        datain : in  std_logic;
        dataout: out std_logic);
    end component;
	
    component ser_par
    port(
        reset	 : in  std_logic;
		clock    : in  std_logic;
        datain   : in  std_logic;
		dataout  : out std_logic_vector(1 downto 0)
        );
    end component;
	
    component sys_cell
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
    end component;
    
    component process_element
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
    end component;
    
    component decoder_top is
    port(
        clock  : in  std_logic;
        reset  : in  std_logic;
        datain : in  std_logic;
        dataout: out std_logic);
    end component;
    
    component error_generator
    generic(error_vector : std_logic_vector((2*tracelength)-1 downto 0));
    port(
        clock    : in  std_logic;
        reset    : in  std_logic;
        datain   : in  std_logic;
        dataout  : out std_logic
        );
    end component;
	
		component compare_select is
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
    end component;
	
	component traceback_counter is
    port(
        reset	 : in  std_logic;
		clock    : in  std_logic;
		rute_vld : out std_logic
        );
    end component;
	
	component bestrute_reg is
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
    end component;
    
end viterbi_package;