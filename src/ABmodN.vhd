library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

use work.RSAParameters.all;

entity ABmodN is
    Generic(
      DATA_WIDTH : integer :=  W_BLOCK
    );
    Port ( clk : in std_logic;
           rstn : in std_logic;
           A : in std_logic_vector (DATA_WIDTH-1 downto 0);
           B : in std_logic_vector (DATA_WIDTH-1 downto 0);
           N : in std_logic_vector (DATA_WIDTH-1 downto 0);
           P : out std_logic_vector(DATA_WIDTH-1 downto 0);
           finished : out std_logic
    );
end ABmodN;

architecture Behavioural of ABmodN is

--Internal for temporary storing the computed value
signal temp : std_logic_vector(DATA_WIDTH+1 downto 0);
--Internal signal for computation
signal i : integer;

type calc_state is (init, add, sub, done);
signal state : calc_state;

begin process (clk,rstn) is
begin
if(rstn = '0') then
    temp <= (others=>'0'); -- reset internal register
    --P <= (others=>'0'); -- reset 
    i <= 0; -- reset i
    finished <= '0';
    state <= add;
elsif(clk'event and clk = '1') then
    finished <= '0';
    if (state = add) then
        if (A(DATA_WIDTH-1-i) = '1') then
          temp <= temp + temp + B; 
        else
          temp <= temp+temp;
        end if;
        state <= sub;
    elsif(state = sub) then
        if(temp >= N) then
          temp<= temp-N;
        else
          if(i < DATA_WIDTH-1) then
            state <= add;
            i <= i+1;
          else
            state <= done;
          end if;
        end if;
    elsif(state = done) then
        P <= temp(DATA_WIDTH-1 downto 0);
        finished <= '1';
    end if;
end if;
end process;

end Behavioural;
