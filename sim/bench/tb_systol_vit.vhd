library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library viterbilib;
use viterbilib.viterbi_package.all;

entity tb_systol_vit is
  generic ( one_period   : Time := 50 ns;
            vector_test  : std_logic_vector(63 downto 0) := "0001101010110101100111010101111100011101010101001110100010011110";
            error_vector : std_logic_vector((2*tracelength)-1 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000");
    end entity;                                                                                                                             --
    
architecture struct of tb_systol_vit is
	signal s_clock     : std_logic;
	signal s_hclock    : std_logic;
	signal s_reset     : std_logic;
	signal s_data      : std_logic;
	signal s_conv_data : std_logic;
	signal s_err_data  : std_logic;
	signal test_data   : std_logic_vector(63 downto 0);
	signal out_decode  : std_logic;
	signal expect_code : std_logic;
	signal code_lat    : std_logic_vector(tracelength downto 0); 
begin       

	process
	begin
	s_reset <= '1';
	wait for one_period;
	s_reset <= '0';
	wait;
	end process;
	
	process
	begin
	s_clock <= '1';
	wait for one_period/2;
	s_clock <= '0';
	wait for one_period/2;
	end process;
	
	process
	begin
	s_hclock <= '0';
	wait for one_period;
	s_hclock <= '1';
	wait for one_period;
	end process;

	process(s_clock, s_reset)
	begin
	if s_reset = '1' then 
		test_data <= vector_test;
	elsif s_hclock'event and s_hclock = '1' then
		 for j in 63 downto 1 LOOP
                test_data(j) <= test_data(j-1);
            END LOOP;
                test_data(0) <= test_data(63);
	end if;
	end process;
    
    process(s_clock, s_reset)
	begin
	if s_reset = '1' then 
		code_lat <= (others => '0');
	elsif s_hclock'event and s_hclock = '1' then
		 for j in tracelength downto 1 LOOP
                code_lat(j) <= code_lat(j-1);
            END LOOP;
        code_lat(0) <= s_data;    
        expect_code <= code_lat(tracelength);
        assert out_decode = expect_code
        report "ERROR: FALSE DATA RECEIVED"
        severity warning;
   --     assert out_decode /= expect_code
   --     report "CORRECT DATA RECEIVED "
   --     severity note;
	end if;
	end process;
	

        

	s_data <= test_data(63);
	
	ENC : encoder_top
    port map (
        clock   => s_clock,
        reset   => s_reset,
        datain  => s_data,
        dataout => s_conv_data
		);
    
    ER : error_generator 
    generic map(error_vector => error_vector)
    port map(
        clock    => s_clock,
        reset    => s_reset,
        datain   => s_conv_data,
        dataout  => s_err_data
        );
        
    DUT : decoder_top
    port map(
        reset	 => s_reset,
		clock    => s_clock,
        datain   => s_err_data,
		dataout  => out_decode
        );
        

end architecture;       
