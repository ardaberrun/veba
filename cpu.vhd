-- vebaCPU 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;


entity cpu is
   port
   (
      clock         : 	      in   std_logic;
      data          :  	      in   std_logic_vector (7 downto 0); 
      alu_select    :         in   std_logic_vector(4 downto 0);
      write_address :         in   integer range 0 to 31;
      read_address  :         in   integer range 0 to 31;
      q		    :         out std_logic_vector (7 downto 0) 
      
   );
end entity;


architecture veba of cpu is

   type mem is array(0 to 31) of std_logic_vector(7 downto 0);
   signal ram_block : mem := (others => (others=>'0')); --ram
   signal reg1,reg2: std_logic_vector(7 downto 0); --registers


begin
   process (clock,data,alu_select)
   begin
	if rising_edge(clock) then
	    case(alu_select) is
		when "00000" => 
		      	null;
		when "00001" =>
            		reg1 <= data;					 
		when "00010" =>
			reg2 <= data;			
		when "00011" => 
            		ram_block(write_address) <= reg1;         	
		when "00100" =>
            		ram_block(write_address) <= reg2;        	
		when "00101" =>					
			reg1 <= reg2;
		when "00110" =>                     
			reg2 <= reg1;
		when "00111" =>
            		reg1 <= ram_block(read_address);         
		when "01000" =>
		      	reg2 <= ram_block(read_address);
		when "01001" =>
		      	ram_block(write_address) <= reg1 + reg2;
		when "01010" =>
		      	ram_block(write_address) <= reg1 - reg2;                 
		when "01011" =>
		      	ram_block(write_address) <= reg1 + data;
		when "01100" =>                    
			ram_block(write_address) <= reg2 + data;
		when "01101" =>
            		ram_block(write_address) <= reg1 + 1;
		when "01110" =>
		      	ram_block(write_address) <= reg2 + 1;
		when "01111" => 
			ram_block(write_address) <= reg1(6 downto 0) & '0'; 	--	left shift   => reg1 
		when "10000" =>		      
            		ram_block(write_address) <= '0' & reg1(7 downto 1);   	--	right shift  => reg1        
		when "10001" =>
		      	ram_block(write_address) <= reg1(6 downto 0) & reg1(7); --	rotate       => reg1
		when "10010" => 
            		ram_block(write_address) <= reg2(6 downto 0) & '0';     -- 	left shift   => reg2 
		when "10011" =>
            		ram_block(write_address) <= '0' & reg2(7 downto 1);     -- 	right shift  => reg2   
		when "10100" =>
		      	ram_block(write_address) <= reg2(6 downto 0) & reg2(7); --	rotate       => reg2
		when "10101" =>
		      	ram_block(write_address) <= not(reg1);
		when "10110" =>
		      	ram_block(write_address) <= not(reg2);
		when "10111" =>
		      	ram_block(write_address) <= reg1 and reg2;
		when "11000" =>
		      	ram_block(write_address) <= reg1 or reg2;
		when "11001" =>
		      	ram_block(write_address) <= reg1 xor reg2;
		when "11010" =>
		      	ram_block(write_address) <= reg1 xnor reg2;
		when "11011" =>
		      	q <= ram_block(read_address);			  
		when others => null ; 
		end case;      	
	end if;

   end process;
end architecture;




