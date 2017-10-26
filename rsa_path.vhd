-- ************************************************************************
-- Filename: rsa_path.vhd
-- Name: RSA datapath
-- Description: Pipe dataflow through the design
-- This module descripes the datapath of the RSA module
-- ************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity rsa_path is
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
    result : out std_logic_vector(127 downto 0);
    dataOut  : out std_logic_vector(31 downto 0);
    eMSB     : out std_logic  -- MSB of the e register. Used for control of mux
    );
end rsa_path;

architecture Behavioral of rsa_path is
  signal Y_reg           : std_logic_vector(127 downto 0);
  signal X_reg           : std_logic_vector(127 downto 0);
  signal n_reg           : std_logic_vector(127 downto 0);
  signal e_reg           : std_logic_vector(127 downto 0);
  signal M_reg           : std_logic_vector(127 downto 0);
  signal P_reg           : std_logic_vector(127 downto 0);
  signal R_reg           : std_logic_vector(127 downto 0);
  signal Y_reg_shift_out : std_logic_vector(31 downto 0);
  signal X_reg_shift_out : std_logic_vector(31 downto 0);
  signal n_reg_shift_out : std_logic_vector(31 downto 0);

begin

  process(clk, resetN, Y_reg)
  begin
    if (resetN = '0') then
      Y_reg           <= (others => '0');
      Y_reg_shift_out <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (Y_reg_shift_en = '1') then
        Y_reg <= dataIn & Y_reg(127 downto 32);
      end if;
    end if;
    Y_reg_shift_out <= Y_reg(31 downto 0);
  end process;
 
  process(clk, resetN, X_reg)
  begin
    if (resetN = '0') then
      X_reg           <= (others => '0');
      X_reg_shift_out <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (X_reg_shift_en = '1') then
        X_reg <= Y_reg_shift_out & X_reg(127 downto 32);
      end if;
    end if;
    X_reg_shift_out <= X_reg(31 downto 0);
  end process;
  -- ************************************************************************
  -- Register N_reg
  -- ************************************************************************
  process(clk, resetN, n_reg)
  begin
    if (resetN = '0') then
      n_reg           <= (others => '0');
      n_reg_shift_out <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (n_reg_shift_en = '1') then
        n_reg <= X_reg_shift_out & n_reg(127 downto 32);
      end if;
    end if;
    n_reg_shift_out <= n_reg(31 downto 0);
  end process;
  -- ************************************************************************
  -- Register E_reg
  -- ************************************************************************
  eMSB <= e_reg(127);
  process(clk, resetN)
  begin
    if (resetN = '0') then
      e_reg <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (e_reg_shift_en = '1') then
        e_reg <= n_reg_shift_out & e_reg(127 downto 32);
      elsif (e_reg_shift_one_en = '1') then  --left shift
        e_reg <= e_reg(126 downto 0) & e_reg(127);
      end if;
    end if;
  end process;
  -- ************************************************************************
  -- Register M_reg
  -- ************************************************************************
 process(clk, resetN)
  begin
    if (resetN = '0') then
      M_reg <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (M_reg_shift_en = '1') then
        M_reg <= dataIn & M_reg(127 downto 32);
      end if;
    end if;
  end process;
  
  -- ************************************************************************
  -- Register P_reg
  -- ************************************************************************
  process(clk, resetN)
  begin
    if(resetN = '0') then
      P_reg <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (P_reg_load_en = '1') then
        P_reg <= result;
      end if;
    end if;
  end process;
  
  -- ************************************************************************
  -- Register R_reg
  -- ************************************************************************
  process(clk, resetN)
  begin
    if(resetN = '0') then
      R_reg   <= (others => '0');
      dataOut <= (others => '0');
    elsif (clk'event and clk = '1') then
      if (R_reg_load_en = '1') then
        R_reg <= result;
      elsif (R_reg_shift_en = '1') then
        dataOut <= R_reg(31 downto 0);
        R_reg   <= x"00000000" & R_reg(127 downto 32);
      end if;
    end if;
  end process;
end Behavioral;
