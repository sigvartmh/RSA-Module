----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.10.2017 11:36:44
-- Design Name: 
-- Module Name: ABmodN_tb - Behavioral
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
use IEEE.std_logic_unsigned.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ABmodN_tb is
end ABmodN_tb;

architecture Behavioral of ABmodN_tb is

component ABmodN is
    Port ( clk : in std_logic;
           rst : in std_logic;
           endmod : out std_logic;
           A : in STD_LOGIC_VECTOR (127 downto 0);
           B : in STD_LOGIC_VECTOR (127 downto 0);
           N : in STD_LOGIC_VECTOR (127 downto 0);
           P : out STD_LOGIC_VECTOR (127 downto 0);
           num : out std_logic_vector(8 downto 0);
           start : in std_logic);
end component;

--signal startmod,Bk : std_logic;
signal clk,rst,endmod,start : std_logic;
signal A,N,P : std_logic_vector(127 downto 0);
signal B : std_logic_vector(127 downto 0);
signal num : std_logic_vector(8 downto 0);


begin
--uut: ABmodN port map(A=>A,Bk=>Bk,N=>N,P=>P,clk=>clk,rst=>rst,endmod=>endmod, startmod=>startmod);
uut: ABmodN port map(A=>A,B=>B,N=>N,P=>P,clk=>clk,rst=>rst,num=>num, endmod=>endmod,start=>start);

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
    
   -- P <= (others=>'0');
   -- P(0) <= '1';
    wait for 20 ns;
    rst <= '0';
    wait;
end process;

stimuli : process
begin
start<='0';
A <= std_logic_vector(to_unsigned(2635,128)); -- "10100"  --20
--Bk <= '0';
B <= std_logic_vector(to_unsigned(4896,128));
N <= std_logic_vector(to_unsigned(63250,128)); -- "10010001"  --145
wait until rst'event and rst = '0';
wait for 20 ns;
start<='1';
wait until endmod'event and endmod = '1';
start<='0';
end process;

end Behavioral;
