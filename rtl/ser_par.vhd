library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ser_par is
    port(
        reset	 : in  std_logic;
		clock    : in  std_logic;
        datain   : in  std_logic;
		dataout  : out std_logic_vector(1 downto 0)
        );
    end entity;
    
architecture rtl of ser_par is

signal s_clock : std_logic;
signal buff_1  : std_logic_vector(1 downto 0);
signal buff_2  : std_logic_vector(1 downto 0);

begin       
    
    process(reset, clock)
    begin
    if reset = '1' then
        s_clock <= '1';
    elsif clock'event and clock = '1' then 
        s_clock <= not s_clock;
    end if;
    end process;
    
    
    process(reset, clock)
	begin
	if reset = '1' then
		buff_1 <= "00";
	elsif clock'event and clock = '1' then
		buff_1(0) <= datain;
		buff_1(1) <= buff_1(0);
	end if;
	end process;
    
    process(reset, s_clock)
	begin
	if reset = '1' then
		buff_2 <= "00";
	elsif s_clock'event and s_clock = '1' then
		buff_2 <= buff_1;
	end if;
	end process;
    
    process(reset, clock)
	begin
	if reset = '1' then
		dataout <= "00";
	elsif clock'event and clock = '1' then
		dataout <= buff_2;
	end if;
	end process;
	
end architecture;       