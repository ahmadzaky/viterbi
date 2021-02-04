library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library viterbilib;
use viterbilib.viterbi_package.all;

entity encoder_top is
    port(
        clock  : in  std_logic;
        reset  : in  std_logic;
        datain : in  std_logic;
        dataout: out std_logic);
    end entity;
    
architecture struct of encoder_top is
	signal s_clock   : std_logic;
	signal s_pardata : std_logic_vector(1 downto 0); 
	
begin       

	i_clkdiv : clock_divide
    port map(
        reset	 => reset,
		clock    => clock,
        clockout => s_clock
        );
	
	i_cnvlt : convo_encod
    port map(
        clock   => s_clock,
        reset   => reset,
        datain  => datain,
        dataout => s_pardata
        );
	
	i_par_ser : par_ser
    port map(
        reset	 => reset,
		clock    => clock,
		half_clk => s_clock,
        datain   => s_pardata,
		dataout  => dataout
        );

end architecture;       
