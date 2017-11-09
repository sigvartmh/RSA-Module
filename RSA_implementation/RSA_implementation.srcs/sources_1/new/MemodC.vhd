----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2017 10:43:01
-- Design Name: 
-- Module Name: MemodC - Behavioral
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

entity MemodC is
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
end MemodC;

architecture Behavioral of MemodC is

signal i : integer;
signal startAB : std_logic;
signal endmod : std_logic;
signal boucle : std_logic;

signal A,B,P : std_logic_vector(127 downto 0);
signal temp : STD_LOGIC_VECTOR(127 downto 0);
signal num : std_logic_vector(8 downto 0);
signal resetAB : std_logic;

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

begin

uut: ABmodN port map(A=>A,B=>B,N=>N,P=>P,clk=>clk,rst=>resetAB,num=>num, endmod=>endmod,start=>startAB);

process(clk,rst,endmod)
begin
 if(endmod = '1')then 
     startAB <= '0';               
 end if;               
if(clk'event and clk = '1') then
if(resetAB = '1')then
resetAB<='0';
end if ;
endAB<=endmod;
startmod<=startAB;
    if(rst = '1') then
        C <= (others=>'0'); -- reset C
        i <= 128; -- reset i
        startAB<='0';
        boucle <='0';
        pos <= "00";
        resetAB<='1';
    else
        if(startRSA = '1') then
             if(i = 128) then
                if(e(i-1) = '1') then
                    temp<=M;
                else
                    temp<= (others=>'0');
                    temp(0)<='1';
                end if;
                i<=i-1;
             
             else --(i!=127)
             
             if(startAB = '0' and endmod = '0') then
                 if(boucle = '0') then
                     pos <= "01";
                     A<=temp;
                     B<=temp;
                     startAB <= '1';
                     boucle <= '1';
                     
                 else --(boucle == 1)
                  pos <= "10";                    
                     if(e(i-1) = '1' ) then                        
                         A<=temp;
                         B<=M;  
                         startAB <= '1';
                          pos <= "11";
                     end if;
                     i<=i-1;
                     boucle <= '0';
                 end if;
             end if;
             
             if(endmod = '1')then 
                  resetAB<='1';
                 --startAB <= '0';
                 temp<=P;           
             end if;
             
             ---if(i=0) then
             -- endRSA<='1';
             --end if;
                
             end if;
              C<=temp;
        end if;
       
    end if;
     numC <= std_logic_vector(to_unsigned(i,9));
end if;
end process;

EOF : process(clk,rst)
begin

--if(clk'event and clk = '1') then
if(rst = '1') then
  endRSA<='0';
else
if(i=0 and startAB = '0' and pos = "01") then
    endRSA<='1';
end if;

end if;
--end if;
end process;


end Behavioral;
