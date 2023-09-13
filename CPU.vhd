library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;



entity CPU is 
	port (
			clk : in std_logic;
			rst : in std_logic;
			from_memory : in std_logic_vector(7 downto 0);
			to_memory : out std_logic_vector(7 downto 0);
			write_en : out std_logic;
			address : out std_logic_vector(7 downto 0)
	);
	
end CPU;



architecture arch of CPU is 



component control_unit is 
	port (
		
			clk 		: in std_logic;
			rst 		: in std_logic;
			CCR_Result  : in std_logic_vector(3 downto 0);
			IR 			: in std_logic_vector(7 downto 0);
			IR_Load 	: out std_logic;
			MAR_Load 	: out std_logic;
			PC_Load 	: out std_logic;
			PC_Inc 		: out std_logic;
			A_Load 		: out std_logic;
			B_Load 		: out std_logic;
			ALU_Sel 	: out std_logic_vector(2 downto 0);
			CCR_Load 	: out std_logic;
			BUS1_Sel 	: out std_logic_vector(1 downto 0);
			BUS2_Sel 	: out std_logic_vector(1 downto 0);
			write_en 	: out std_logic
	
	);
end component;


component data_path is
	port(
			--Input
			clk 		: in std_logic;
			rst 		: in std_logic;
			IR_Load 	: in std_logic;
			MAR_Load 	: in std_logic;
			PC_Load 	: in std_logic;
			PC_Inc 		: in std_logic;
			A_Load 		: in std_logic;
			B_Load 		: in std_logic;
			ALU_Sel 	: in std_logic_vector(2 downto 0);
			CCR_Load 	: in std_logic;
			BUS1_Sel 	: in std_logic_vector(1 downto 0);
			BUS2_Sel 	: in std_logic_vector(1 downto 0);
			from_memory : in std_logic_vector(7 downto 0);
			--Output
			IR 			: out std_logic_vector(7 downto 0);
			address 	: out std_logic_vector(7 downto 0);
			CCR_Result 	: out std_logic_vector(3 downto 0);
			to_memory 	: out std_logic_vector(7 downto 0)
	);
end component;

signal IR_Load    	:	std_logic;
signal IR 			:   std_logic_vector(7 downto 0);	
signal MAR_Load 	:	std_logic;
signal PC_Load 		:	std_logic;
signal PC_Inc 		:	std_logic;
signal A_Load 		:	std_logic;
signal B_Load 		:	std_logic;
signal ALU_Sel 		:	std_logic_vector(2 downto 0);
signal CCR_Load 	:	std_logic;
signal CCR_Result 	:   std_logic_vector(3 downto 0);	
signal BUS1_Sel 	:	std_logic_vector(1 downto 0);
signal BUS2_Sel 	:	std_logic_vector(1 downto 0);


begin

--Control Unit Port map
control_unit_module : control_unit port map 
				(
					clk 			=> clk,				
                    rst 		    => rst,
                    CCR_Result      => CCR_Result,
                    IR 			    => IR,
                    IR_Load 	    => IR_Load,
                    MAR_Load 	    => MAR_Load,
                    PC_Load 	    => PC_Load,
                    PC_Inc 		    => PC_Inc,
                    A_Load 		    => A_Load,
                    B_Load 		    => B_Load,
                    ALU_Sel 	    => ALU_Sel,
                    CCR_Load 	    => CCR_Load,
                    BUS1_Sel 	    => BUS1_Sel,
                    BUS2_Sel 	    => BUS2_Sel,
                    write_en 	    => write_en
);

--Data Path Port Map

data_path_module : data_path port Map

				(	--Input		
				    clk 		=>  clk,		
				    rst 		=>  rst, 		
				    IR_Load 	=>  IR_Load, 	
				    MAR_Load 	=>  MAR_Load, 	
				    PC_Load 	=>  PC_Load, 	
				    PC_Inc 		=>  PC_Inc, 		
				    A_Load 		=>  A_Load, 		
				    B_Load 		=>  B_Load, 		
				    ALU_Sel 	=>  ALU_Sel, 	
				    CCR_Load 	=>  CCR_Load, 	
				    BUS1_Sel 	=>  BUS1_Sel, 	
				    BUS2_Sel 	=>  BUS2_Sel, 	
				    from_memory =>  from_memory,
				    --Output         
			        IR 			=>  IR, 			
			        address 	=>  address, 	
                    CCR_Result 	=>  CCR_Result, 
					to_memory   =>  to_memory                                    
);

end architecture;					