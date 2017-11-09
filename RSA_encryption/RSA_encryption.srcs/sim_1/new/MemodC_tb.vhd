----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2017 11:42:04
-- Design Name: 
-- Module Name: MemodC_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MemodC_tb is
end MemodC_tb;

architecture Behavioral of MemodC_tb is

component MemodC is
  Port (M : in std_logic_vector(127 downto 0);
      e : in std_logic_vector(127 downto 0);
      N : in std_logic_vector(127 downto 0);
      C : out std_logic_vector(127 downto 0);
      startRSA : in std_logic;
      endRSA : out std_logic;
      clk : in std_logic;
      rst : in std_logic;
      endAB : out std_logic;
      pos : buffer std_logic_vector(1 downto 0);
      startmod : out std_logic;
      numC : out std_logic_vector(8 downto 0));
end component;

signal clk,rst,startRSA,endRSA,endAB,startmod : std_logic;
signal e,N,C,M : std_logic_vector (127 downto 0);
signal pos : std_logic_vector(1 downto 0);
signal numC : std_logic_vector(8 downto 0);


begin

uut: MemodC
    port map (
        clk=>clk,
        rst=>rst,
        startRSA=>startRSA,
        endRSA=>endRSA,
        e=>e,
        N=>N,
        C=>C,
        M=>M,
        endAB=>endAB,
        pos=>pos,
        startmod=>startmod,numC=>numC);
--((128+4)*(128+4))*4ns = 69696ns

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
    
    wait for 20 ns;
    rst <= '0';
    wait;
end process;

stimuli : process
begin
startRSA<='0';
--e <=(others=>'1');
e <= std_logic_vector(to_unsigned(2635,128)); -- "10100"  --20
M <= std_logic_vector(to_unsigned(4896,128));
N <= std_logic_vector(to_unsigned(63250,128)); -- "10010001"  --145
wait until rst'event and rst = '0';
wait for 20 ns;
startRSA<='1';
wait until endRSA'event and endRSA = '1';
startRSA<='0';
end process;




--modend : process
--begin
--endmod<='0';
--wait until startRSA'event and startRSA = '1';
--wait for 20 ns;
--loop 
--endmod<='1';
--wait for 4 ns;
--endmod<='0';
--wait for 100 ns;
--end loop;

--end process;

end Behavioral;
