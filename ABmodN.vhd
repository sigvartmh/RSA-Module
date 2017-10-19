----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.10.2017 10:26:55
-- Design Name: 
-- Module Name: ABmodN - Behavioral
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
use ieee.numeric_std.all;


entity ABmodN is
    Port ( clk : in std_logic;
           rst : in std_logic;
           endmod : out std_logic;
           startmod : in std_logic;
           A : in STD_LOGIC_VECTOR (127 downto 0);
           Bk : in STD_LOGIC;
           N : in STD_LOGIC_VECTOR (127 downto 0);
           P : inout STD_LOGIC_VECTOR (127 downto 0));
end ABmodN;

architecture Behavioral of ABmodN is
signal Ai : STD_LOGIC_VECTOR(127 downto 0);
signal Pi : STD_LOGIC_VECTOR(127 downto 0);
signal P1 : STD_LOGIC_VECTOR(127 downto 0);
signal P2 : STD_LOGIC_VECTOR(127 downto 0);
signal start : std_logic;
signal i : integer;

begin

AxBk : process (clk,start) is
begin
if(clk'event and clk = '1') then
   if(start = '0') then
       
    else
    Ai<= (others=>'0');
        if(Bk = '1') then
            Ai<=A;
        end if;

   end if;
end if;
end process;

sum : process (clk,start) is
begin
if(clk'event and clk = '1') then
   if(start = '0') then
       
    else
    
        P1<=P+P+Ai;

   end if;
end if;
end process;

mod1 : process (clk,start) is
begin
if(clk'event and clk = '1') then
   if(start = '0') then
       
    else
        P2<=P1;
        if(P1>=N) then
            P2<=P1-N;
        end if;

   end if;
end if;
end process;

mod2 : process (clk,start) is
begin
if(clk'event and clk = '1') then
   if(start = '0') then
       
    else
        P<=P2;
        if(P2>=N) then
            P<=P2-N;
        end if;

   end if;
end if;
end process;

strt : process(clk,rst) is
begin
if(clk'event and clk = '1') then
    if(rst = '1') then
       start<='0';
    else
        start<='1';
    end if;
end if;
end process;

end Behavioral;
