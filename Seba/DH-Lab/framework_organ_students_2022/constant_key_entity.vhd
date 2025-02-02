LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY constantkey IS
  PORT (
    reset      : IN std_logic;
    clk        : IN std_logic; -- 50MHz clokc
    scancode   : IN std_logic_vector(7 DOWNTO 0);
    byte_read  : IN std_logic;
    dig2, dig3 : OUT std_logic_vector(6 DOWNTO 0); -- show key pressed on display dig2 en dig3 (resp high & low).
    key        : OUT std_logic_vector(7 DOWNTO 0)    
    );
END constantkey;
