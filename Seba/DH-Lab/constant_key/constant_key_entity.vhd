LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY constantkey IS
  PORT (
    reset                 : IN std_logic;
    clk                   : IN std_logic; -- 50MHz clock
    scancode              : IN std_logic_vector(7 DOWNTO 0);
    byte_read             : IN std_logic;
    dig2, dig3            : OUT std_logic_vector(6 DOWNTO 0); -- show key pressed on display dig2 en dig3 (resp high & low).
    key                   : OUT std_logic_vector(7 DOWNTO 0);
	  new_scancode_detected : OUT std_logic
    );
END constantkey;

ARCHITECTURE bhv OF constantkey IS
	SIGNAL cnt : std_logic := '0';

BEGIN
    -- detection of a new scancode; with BYTE_READ synchronization
	PROCESS(clk,reset)
	BEGIN
	IF reset='0' THEN
	  new_scancode_detected <= '0';
	  cnt <= '0';
	ELSIF rising_edge(clk) THEN
	  IF cnt = '0' THEN
		IF byte_read = '0' THEN
		  cnt <= '1';
		ELSE
		  new_scancode_detected <= '0';
				  cnt <= '0';
		END IF;
	  ELSIF cnt = '1' THEN
		IF byte_read = '1' THEN
		  new_scancode_detected <= '1';
		ELSE
		  new_scancode_detected <= '0';
		END IF;
			cnt <= '0';
	  END IF;
	END IF;
	END PROCESS;
	
	PROCESS(clk,reset)
	BE

END;