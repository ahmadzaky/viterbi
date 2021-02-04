library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity par_ser is
    port(
        reset	 : in  std_logic;
		clock    : in  std_logic;
		half_clk : in  std_logic;
        datain   : in  std_logic_vector(1 downto 0);
		dataout  : out std_logic
        );
    end entity;
    
architecture rtl of par_ser is

signal buff : std_logic_vector(1 downto 0);

begin       

    process(reset, clock)
	begin
	if reset = '1' then
		buff <= "00";
	elsif clock'event and clock = '1' then
		if half_clk = '1' then 
			buff <= datain;
		elsif half_clk = '0' then
			buff(1) <= buff(0);
		end if;
	end if;
	end process;
    
	dataout <= buff(1);
    
end architecture;       