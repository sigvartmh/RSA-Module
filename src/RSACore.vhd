library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.RSAParameters.all;

entity RSACore is
    port(
        Clk : in std_logic;
        Resetn : in std_logic;
        InitRsa : in std_logic;
        StartRsa : in std_logic;
        DataIn : in std_logic_vector (W_DATA-1 downto 0);
        DataOut : out std_logic_vector (W_DATA-1 downto 0);
        CoreFinished : out std_logic
        );
end RSACore;

architecture Behavioral of RSACore is
component MemodC is
  Generic(
  	DATA_WIDTH : integer
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
end component;

component FSM is
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
end component;

type state_type is (wait_state, load_e, load_n, load_m, BeginRSA, RSA_push_out);
signal rsa_state: state_type;

signal e : std_logic_vector(W_BLOCK-1 downto 0);
signal N : std_logic_vector(W_BLOCK-1 downto 0);
signal M : std_logic_vector(W_BLOCK-1 downto 0);
signal C : std_logic_vector(W_BLOCK-1 downto 0);

signal RSA_finished : std_logic;
signal resetn_bin_add, calc : std_logic;
signal count : integer;

begin
    finite_state_machine : FSM
    Generic map(
     WORD_WIDTH=>W_DATA,
     DATA_WIDTH=>W_BLOCK
    )
    Port map (
       clk=> clk,
       reset_n=>resetn,
       start_rsa=>startrsa,
       init_rsa=>initrsa,
       core_finished=>CoreFinished,
       data_in=>datain,
       data_out=>dataout,
       rstn_bin_add=> resetn_bin_add,
        M_buf=>M,
        N_buf=>N,
        e_buf=>e,
        --BeginCalc => calc,
        C_buf => C,
       RSA_finished => RSA_finished
 );   

    lr_bin_adder : MemodC
    Generic map(
         DATA_WIDTH=>W_BLOCK
     )
     Port map (
           clk=> clk,
            rstn=>resetn_bin_add,
            M=>M,
            N=>N,
            e=>e,
            BeginCalc => calc,
            C => C,
           endRSA => RSA_finished
     );       
end Behavioral;
