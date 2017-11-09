----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.10.2017 11:01:16
-- Design Name: 
-- Module Name: Reg_A - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg_A is
  Port (data_in : in  std_logic_vector(31 downto 0);
        A : out std_logic_vector(127 downto 0);
        load_reg : in std_logic;
        data_ready : out std_logic;
        clk : in std_logic;
        rst : in std_logic);
end Reg_A;

architecture Behavioral of Reg_A is
signal shift_reg : std_logic_vector(127 downto 0);
signal i : integer;
begin
calc : process (clk,rst) is
begin
if(clk'event and clk = '1') then
    if(rst = '1') then
       A<= (others=>'0'); --reset A
       data_ready<= '0';
       shift_reg<= (others=>'0'); --reset shift_reg
       i<=0;
    else
       if(load_reg = '1') then
            shift_reg <= data_in & shift_reg(127 downto 32);
            i<=i+1;
            
       end if;
    end if;
end if;
if(i = 4) then
      data_ready <= '1';
      i<=0;
end if;
A <= shift_reg;
end process;

end Behavioral;

