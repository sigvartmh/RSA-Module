----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2017 10:43:01
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
    Generic(
        DATA_WIDTH : integer :=  W_BLOCK;
        WORD_WIDTH : integer :=  W_DATA
    );
    Port (
        clk : in std_logic;
        Reset_n : in std_logic;
        Start_RSA : in std_logic;
        Init_RSA : in std_logic;
        rstn_bin_add : out std_logic;
        RSA_finished : in std_logic;
        Core_Finished : out std_logic;
        M_buf : buffer std_logic_vector(DATA_WIDTH-1 downto 0);
        e_buf : buffer std_logic_vector(DATA_WIDTH-1 downto 0);
        N_buf : buffer std_logic_vector(DATA_WIDTH-1 downto 0);
        C_buf : in std_logic_vector(DATA_WIDTH-1 downto 0);
        Data_Out : out std_logic_vector (WORD_WIDTH-1 downto 0);
        Data_In : in std_logic_vector (WORD_WIDTH-1 downto 0)
    );
end FSM;

architecture Behavioral of FSM is
type state_type is (init, load_e, load_n, load_m, BeginRSA, RSA_push_out);
signal rsa_state: state_type;
signal counter : integer;
signal c_temp : std_logic_vector(DATA_WIDTH-1 downto 0);
begin process(Clk, Reset_n)
    begin
    if (Reset_n = '0') then
        Core_Finished <= '1';
        e_buf <= (others => '0');
        n_buf <= (others => '0');
        M_buf <= (others => '0');
        c_temp <= (others => '0');
        
        rsa_state <= init;      
        
        rstn_bin_add <= '0';
        counter <= 0;
    elsif (Clk'event and Clk = '1') then
        Core_Finished <= '1';
        case rsa_state is
            when init =>
                if(Init_Rsa = '1') then
                    Core_Finished <= '0';
                    e_buf(WORD_WIDTH*4 - 1 downto WORD_WIDTH*3) <= Data_In; --read part 1 of e
                    counter <= 1;
                    rsa_state <= load_e;
                elsif(Start_Rsa = '1') then
                    Core_Finished <= '0';
                    counter <= 1;
                    M_buf(WORD_WIDTH*4 - 1 downto WORD_WIDTH*3) <= Data_In; -- read part 1 of m
                    rsa_state <= load_m;
                end if;            
            when load_e =>
                Core_Finished <= '0';
                if(counter < 4) then
                    e_buf <= Data_In & e_buf(WORD_WIDTH*4 - 1 downto WORD_WIDTH); --read part 2-4 of e
                    counter <= counter + 1;
                else
                    N_buf(WORD_WIDTH*4 - 1 downto WORD_WIDTH*3) <= Data_In; --read part 1 of n
                    counter <= 1;
                    rsa_state <= load_n;
                end if;
            when load_n =>
                if(counter < 4) then
                    Core_Finished <= '0';
                    N_buf <= Data_In & n_buf(WORD_WIDTH*4 - 1 downto WORD_WIDTH); --read part 2-4 f n
                    counter <= counter + 1;                    
                else                    
                    Core_Finished <= '1';
                    counter <= 0;
                    rsa_state <= init;
                end if;       
            when load_m =>
                Core_Finished <= '0';
                if(counter < 4) then
                    M_buf <= Data_In & M_buf(WORD_WIDTH*4 - 1 downto WORD_WIDTH);
                    counter <= counter + 1;
                else
                    counter <= 0;
                    rsa_state <= BeginRSA;
                end if;           
            when BeginRSA =>
                Core_Finished <= '0';
                rstn_bin_add <= '1';
                if(RSA_finished = '1') then
                    c_temp <= C_buf;
                    rstn_bin_add <= '0';
                    rsa_state <= RSA_push_out;
                end if;           
            when RSA_push_out =>
                Core_Finished <= '1';
                if(counter < 4) then
                    Data_Out <= c_temp(WORD_WIDTH-1 downto 0);
                    c_temp <= (others => '0');
                    c_temp(WORD_WIDTH*3 - 1 downto 0) <= c_temp(WORD_WIDTH*4 - 1 downto WORD_WIDTH);
                    counter <= counter + 1;
                else
                    counter <= 0;
                    rsa_state <= init;
                end if;                    
        end case;
    end if;
end process;
end Behavioral;