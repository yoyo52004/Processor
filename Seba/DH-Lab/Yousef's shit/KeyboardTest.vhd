LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY keyboard IS
 GENERIC ( 
 clk_freq : INTEGER := 50000000; -- CLK Given on Manual NOT Necessary
 clk_board_freq : INTEGER := 20_000
);
PORT (
 -- These are actual variables given by board
 clk   : IN std_logic; -- 50MHz clokc
 reset : IN std_logic;
 kbclock : IN std_logic; -- low freq. clk (~ 20 kHz) from keyboard
 kbdata : IN std_logic; -- serial data from the keyboard
 dig0, dig1: OUT std_logic_vector(6 DOWNTO 0); -- shows the key pressed on display in Hex dig1 (upper 4 bits) dig0 (lower 4 bits)
 scancode : OUT std_logic_vector(7 DOWNTO 0);
 byte_read : OUT std_logic;
 key       : OUT std_logic_vector(7 DOWNTO 0)
 );
END keyboard;

ARCHITECTURE logic OF keyboard IS

 SIGNAL ps2_word : STD_LOGIC_VECTOR(10 DOWNTO 0); -- START + PARITY + CODE
 SIGNAL counter_idle : INTEGER RANGE 0 TO clk_freq/clk_board_freq; --counter to determine PS/2 is idle


BEGIN 

process(reset,clk)

BEGIN

 if reset='0' THEN -- sc1 board reset 
 elsif falling_edge(kbclock) then 
  ps2_word <= kbclock & ps2_word(10 DOWNTO 1);
  
 end if;

end process;

process(reset,clk)
BEGIN

IF reset='0' THEN -- sc1 board reset 
 ELSE IF  rising_edge(clk) then  ---- Need to sync with FPGA Clock  
  counter_idle <= 0;
  ELSE IF (counter_idle /= clk_freq/ clk_board_freq) THEN -- /= Means when it is not 
  counter_idle <= counter_idle + 1;  -- contiue skipping [ filtering ]   
 END IF;
 
  IF(counter_idle = clk_freq/clk_board_freq ) THEN  
        byte_read <= '1';                                   -- New SCANSCODE Available 
        ps2_word <= ps2_word(8 DOWNTO 1);                      --Formating for new SCANCODE
      ELSE                                                   -- STILL MIGHT Be Going
        byte_read <= '0';                                   -- so status bit will be not one  
      END IF;	 
END process;

END;



