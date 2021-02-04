library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity clock_divide is
    port(
        reset	 : in  std_logic;
		clock    : in  std_logic;
        clockout : out std_logic
        );
    end entity;
    
architecture rtl of clock_divide is

signal s_clk : std_logic;

begin       

    process(reset, clock)
	begin
	if reset = '1' then
		s_clk <= '0';
	elsif clock'event and clock = '1' then
		s_clk <= not s_clk;
	end if;
	end process;
    
	clockout <= s_clk;
    
end architecture;       