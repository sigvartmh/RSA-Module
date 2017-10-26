----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/26/2017 10:50:23 AM
-- Design Name: 
-- Module Name: rsa_path_tb - Behavioral
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

entity rsa_path_tb is
end rsa_path_tb;

architecture Behavioral of rsa_path_tb is

component rsa_path is
  port (
    clk    : in std_logic;
    resetN : in std_logic;

    -- Data input interface
    dataIn        : in std_logic_vector(31 downto 0);
    result        : in std_logic_vector(127 downto 0);

    -- Control inputs
    Y_reg_shift_en     : in std_logic;
    X_reg_shift_en     : in std_logic;
    n_reg_shift_en     : in std_logic;
    e_reg_shift_en     : in std_logic;  -- Shifts 32 bits to right
    e_reg_shift_one_en : in std_logic;  -- Shifts one bit to left
    M_reg_shift_en     : in std_logic;
    R_reg_load_en      : in std_logic;
    R_reg_shift_en     : in std_logic;
    P_reg_load_en      : in std_logic;


    -- Data output
    resultOut   : out std_logic_vector(127 downto 0);
    dataOut     : out std_logic_vector(31 downto 0);
    eMSB        : out std_logic  -- MSB of the e register. Used for control of mux
    );
end rsa_path;

signal Clk, ResetN, Y_reg_shift_en, X_reg_shift_en, n_reg_shift_en, e_reg_shift_en : std_logic;
signal e_reg_shift_one_en, M_reg_shift_en, R_reg_load_en, R_reg_shift_en, P_reg_load_en : std_logic;
signal dataOut, dataIn : std_logic_vector(31 downto 0);

begin
  uut: rsa_path port map(
    Clk=>clk, 
    ResetN=>resetN,
    Y_reg_shift_en=>Y_reg_shift_en,
    X_reg_shift_en=>X_reg_shift_en,
    n_reg_shift_en=>n_reg_shift_en,
    e_reg_shift_en=>e_reg_shift_en,
    e_reg_shift_one_en=>e_reg_shift_one_en,
    M_reg_shift_en=>M_reg_shift_en,
    R_reg_load_en=>R_reg_load_en,
    R_reg_shift_en=>P_reg_load_en,
    dataIn=>dataIn,
    dataOut=>dataOut
  );
  -- Generates a 50MHz Clk
  CLKGEN: process is
  begin
    Clk <= '1';
    wait for 10 ns;
    Clk <= '0';
    wait for 10 ns;
  end process;

  -- Resetn generator
  RSTGEN: process is
  begin
    Resetn <= '0';
    wait for 20 ns;
    Resetn <= '1';
    wait;
  end process;
 
  SIM: process
  begin
      if (Resetn = '0') then
        DataIn          <= (others => '0');
        Y_reg_shift_en  <= (others => '0');
        X_reg_shift_en  <= (others => '0');
        n_reg_shift_en  <= (others => '0');
        e_reg_shift_en  <= (others => '0');
        e_reg_shift_one_en  <= (others => '0');
        M_reg_shift_en  <= (others => '0');
        R_reg_load_en   <= (others => '0');
        R_reg_shift_en  <= (others => '0');
      elsif (Clk'event and Clk='1') then
        DataIn <= 0x819DC6B270DF64F3;
      end if;
  end process;
end Behavioral;
