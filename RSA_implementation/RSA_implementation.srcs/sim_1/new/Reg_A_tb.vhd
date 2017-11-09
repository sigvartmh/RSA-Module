----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2017 11:20:23
-- Design Name: 
-- Module Name: Reg_A_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg_A_tb is
--  Port ( );
end Reg_A_tb;

architecture Behavioral of Reg_A_tb is

component Reg_A is
  Port (data_in : in  std_logic_vector(31 downto 0);
      A : out std_logic_vector(127 downto 0);
      load_reg : in std_logic;
      data_ready : out std_logic;
      clk : in std_logic;
      rst : in std_logic);
end component;

signal load_reg,clk,rst,data_ready : std_logic;
signal data_in : std_logic_vector(31 downto 0);
signal A : std_logic_vector(127 downto 0);
signal i : integer;

begin
uut: Reg_A port map(load_reg=>load_reg,clk=>clk,rst=>rst,data_ready=>data_ready,data_in=>data_in,A=>A);

clockgen : process
begin
    clk<='1';
    wait for 2 ns;
    clk<='0';
    wait for 2 ns;
end process;

reset : process
begin
    rst <= '1';

    wait for 19 ns;
    rst <= '0';
    wait;
end process;

load : process
begin
load_reg<='0';
wait until rst'event and rst='0';
load_reg<='1';

wait until data_ready'event and data_ready='1';
load_reg<='0';


wait;
end process;

stimuli : process
begin
i<=0;
wait until rst'event and rst='0';


loop
wait until CLK'event and CLK='1';
    case i is
    when 0 =>
        data_in<=(others=>'1');
        i<=i+1;
    when 1 =>
        data_in<=(others=>'0');
        i<=i+1;
    when 2 =>
        data_in<=(others=>'1');
        i<=i+1;
    when others =>
        data_in<=(others=>'0');
        --i<=0;
end case;
end loop;

end process;


end Behavioral;
