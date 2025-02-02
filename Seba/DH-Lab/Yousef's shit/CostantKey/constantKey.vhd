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

ARCHITECTURE bhv OF constantkey IS

signal new_scancode_detected : boolean := false;
signal temp_key: std_logic_vector(7 DOWNTO 0);
signal old_byte_read: std_logic;
 TYPE states IS(waiting,pressing,break);
 SIGNAL state : states;

BEGIN

-- detection of a new scancode; with BYTE_READ synchronization
  PROCESS(clk,reset) --byte_read_synchronization
  BEGIN

    IF reset='0'THEN
  -- some other variables must be reset
    new_scancode_detected<=false;

   ELSIF rising_edge(clk) THEN
   IF ( new_scancode_detected = false and  byte_read = '1' ) THEN 
      new_scancode_detected<= true;       
      ELSIF (new_scancode_detected = true and  byte_read = '1') THEN 
	   new_scancode_detected<= true;
      END IF;
    END IF;
  END PROCESS;
   
  PROCESS(clk,reset) -- Process for evaluating the state machine
    BEGIN
	
  IF reset = '0' THEN 
   state <=  waiting;
   
   ELSIF rising_edge(clk) THEN 
   
    CASE state IS 
	
WHEN waiting =>
	IF  (new_scancode_detected) THEN 
	key <= ( others =>'0');
	state<=pressing;
    	ELSE 
	state<=waiting;
	key <= ( others =>'0');
	END IF; --- At Waiting GO Pressed if n_s_d = 1 or STAY at Waiting
	
	WHEN pressing => 
        IF  ( (new_scancode_detected) and ( scancode = "11110000" ) ) THEN
	key <= ( others =>'0');
	state<=break;
	ELSE 
	state<=pressing;
	key <= scancode;
	END IF; --- At Pressing GO to Break if n_s_d = 1 and SCANSCODE = F0
	
	WHEN break => 
	IF (new_scancode_detected) THEN 
	key <= ( others =>'0');
	state<=waiting;
	ELSE 
	key <= ( others =>'0');
	state <= break;	
	END IF; --- At BREAK GO to Waiting if n_s_d = 1 a
	
	WHEN OTHERS =>
	  state <= waiting;
	  key<= ( others=> '0');
	  
	END CASE;
	
	END IF;
	
  END PROCESS;
 
END;
	