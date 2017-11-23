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
use work.RSAParameters.all;

entity MemodC is
  Generic(
  	DATA_WIDTH : integer :=  W_BLOCK
  );
  Port (M : in std_logic_vector(DATA_WIDTH-1 downto 0);
        e : in std_logic_vector(DATA_WIDTH-1 downto 0);
        N : in std_logic_vector(DATA_WIDTH-1 downto 0);
        clk : in std_logic;
        rstn : in std_logic;
        BeginCalc : in std_logic;
        C : buffer std_logic_vector(DATA_WIDTH-1 downto 0);
        endRSA : out std_logic
     );
end MemodC;

architecture Behavioral of MemodC is
	component ABmodN is
        Generic(
          DATA_WIDTH : integer
        );
        Port ( clk : in std_logic;
               rstn : in std_logic;
               A : in std_logic_vector (DATA_WIDTH-1 downto 0);
               B : in std_logic_vector (DATA_WIDTH-1 downto 0);
               N : in std_logic_vector (DATA_WIDTH-1 downto 0);
               P : out std_logic_vector(DATA_WIDTH-1 downto 0);
               finished : out std_logic
        );
    end component;

--Internal counter
signal i : integer;

--Internal state machine
type lr_adder_state is (init, cc, cm, done);
signal state : lr_adder_state;

--Internal signals for ABmodN
signal A,B,P : std_logic_vector(DATA_WIDTH-1 downto 0);
signal resetAB, finishedAB : std_logic;

begin process(clk, rstn)
begin
if(rstn = '0') then
	state <= init;
	resetAB <= '0';--rstn;
	C <= (others => '0');
	i <= DATA_WIDTH-2;
	endRSA <= '0';
elsif(clk'event and clk = '1') then
	endRSA <= '0';
	if(state = init) then
		if(e(DATA_WIDTH-1) = '1') then
			C <= M;
		else
			C(0) <= '1';
		end if;
		state <= cc;
	elsif(state = cc) then
		A <= C;
		B <= C;
		resetAB <= '1';
		if(finishedAB = '1') then
			C <= P;
			resetAB <= '0';
			state <= cm;
		end if;
	elsif(state = cm) then
		if(e(i)='1') then
			A <= C;
			B <= M;
			resetAB <= '1';
			if(finishedAB ='1') then
				C <= P;
				resetAB <= '0';
				if(i>0) then
					i <= i-1;
					state <= cc; 
				else
					state <= done;
				end if;
			end if;
		else
			if(i>0) then
				i <= i-1;
				state <= cc; 
			else
				state <= done;
			end if;
		end if;
	elsif(state = done) then
		endRSA <= '1';
	end if;
end if;
end process;
blakely : ABmodN
	Generic map(
		DATA_WIDTH=>DATA_WIDTH
	)
	Port map(
		clk=>clk,
		A=>A,
		B=>B,
		N=>N,
		P=>P,
		rstn=>resetAB,
		finished=>finishedAB
	);
end Behavioral;
