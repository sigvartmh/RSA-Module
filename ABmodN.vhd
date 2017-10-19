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
           A : in STD_LOGIC_VECTOR (127 downto 0);
           B : in STD_LOGIC_VECTOR (127 downto 0);
           N : in STD_LOGIC_VECTOR (127 downto 0);
           P : out STD_LOGIC_VECTOR (127 downto 0);
           num : out std_logic_vector(8 downto 0);
           start : in std_logic);
end ABmodN;

architecture Behavioral of ABmodN is
signal temp : STD_LOGIC_VECTOR(127 downto 0);
signal i : integer;
signal k : integer;

begin

calc : process (clk,rst) is
begin
if(clk'event and clk = '1') then
    if(rst = '1') then
        temp <= (others=>'0');
        P <= (others=>'0'); -- reset p
        i <= 0; -- reset i
    else
        
    if(start = '1') then
        
        -- P = 2*P + A*b(128-1-i);
      --  P <= P+P; -- *2 left shift
         if temp < N then
        if(i<128) then
             if (B(127-i) = '1') then
                  temp <= temp + temp + A;
             else
                   temp <= temp+temp;
             end if;
             
             if(temp >= N) then
                   temp<=temp-N;
             end if;
                     
             if(temp >= N) then
                   temp<=temp-N;
             end if;
            
                 P <= temp;
                 i<= i+1;
        end if;
        end if;
        
       if(temp >= N) then
              temp<=temp-N;

       end if;
        
                
        if(temp >= N) then
              temp<=temp-N;
        end if;
        
        
        
        num <= std_logic_vector(to_unsigned(i,9));
        -- end of loop
        
        if(i = 128) then
           
            i <= 0;
        end if;
    end if;
    end if;
end if;
end process;

EOF : process(clk,rst)
begin

if(clk'event and clk = '1') then
if(rst = '1') then
        endmod <= '0';
        k <= 0;
else
if(i>0)then
    k<=1;
end if;

if((k = 1)and(i=0)) then
 endmod <= '1';
  k <= 0;
end if;

end if;
end if;
end process;

end Behavioral;
