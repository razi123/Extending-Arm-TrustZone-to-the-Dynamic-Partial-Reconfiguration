----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2020 17:42:26
-- Design Name: 
-- Module Name: new_comp - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity awprot is
generic (
		-- Users to add parameters here
        C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 32
		-- User parameters ends
		-- Do not modify the parameters beyond this line.

);

    Port ( aclk_0	: in std_logic;
            aresetn_0	: in std_logic;
            M00_axi_0_awprot	: out std_logic_vector(2 downto 0);
            
            -- Ports of Axi Slave Bus Interface S00_AXI, LHS ports towards Interconnect
            
            M00_axi_0_awaddr	: out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            M00_axi_0_awvalid	: out std_logic;
            M00_axi_0_awready	: in std_logic;
            M00_axi_0_wdata	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            M00_axi_0_wstrb	: out std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            M00_axi_0_wvalid	: out std_logic;
            M00_axi_0_wready	: in std_logic;
            M00_axi_0_bresp	: in std_logic_vector(1 downto 0);
            M00_axi_0_bvalid	: in std_logic;
            M00_axi_0_bready	: out std_logic;
            M00_axi_0_araddr	: out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            M00_axi_0_arprot	: out std_logic_vector(2 downto 0);
            M00_axi_0_arvalid	: out std_logic;
            M00_axi_0_arready	: in std_logic;
            M00_axi_0_rdata	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            M00_axi_0_rresp	: in std_logic_vector(1 downto 0);
            M00_axi_0_rvalid	: in std_logic;
            M00_axi_0_rready	: out std_logic;
            
         -- RHS port to PRC
			S00_AXI_REG_0_AWPROT	: in std_logic_vector(2 downto 0);
			
            S00_AXI_REG_0_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
			S00_AXI_REG_0_AWVALID	: in std_logic;         
            S00_AXI_REG_0_AWREADY	: out std_logic ;
            S00_AXI_REG_0_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S00_AXI_REG_0_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            S00_AXI_REG_0_WVALID	: in std_logic;
            S00_AXI_REG_0_WREADY	: out std_logic;
            S00_AXI_REG_0_BRESP	: out std_logic_vector(1 downto 0);
            S00_AXI_REG_0_BVALID	: out std_logic;
            S00_AXI_REG_0_BREADY	: in std_logic;
            S00_AXI_REG_0_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            S00_AXI_REG_0_ARPROT	: in std_logic_vector(2 downto 0);
            S00_AXI_REG_0_ARVALID	: in std_logic;
            S00_AXI_REG_0_ARREADY	: out std_logic;
            S00_AXI_REG_0_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            S00_AXI_REG_0_RRESP	: out std_logic_vector(1 downto 0);
            S00_AXI_REG_0_RVALID	: out std_logic;
            S00_AXI_REG_0_RREADY	: in std_logic
            
            
            
--            M01_axi_0_awprot	: out std_logic_vector(2 downto 0);       
--            M01_axi_0_awaddr	: out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
--            M01_axi_0_awvalid	: out std_logic;
--            M01_axi_0_awready	: in std_logic;
--            M01_axi_0_wdata	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--            M01_axi_0_wstrb	: out std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
--            M01_axi_0_wvalid	: out std_logic;
--            M01_axi_0_wready	: in std_logic;
--            M01_axi_0_bresp	: in std_logic_vector(1 downto 0);
--            M01_axi_0_bvalid	: in std_logic;
--            M01_axi_0_bready	: out std_logic;
--            M01_axi_0_araddr	: out std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
--            M01_axi_0_arprot	: out std_logic_vector(2 downto 0);
--            M01_axi_0_arvalid	: out std_logic;
--            M01_axi_0_arready	: in std_logic;
--            M01_axi_0_rdata	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--            M01_axi_0_rresp	: in std_logic_vector(1 downto 0);
--            M01_axi_0_rvalid	: in std_logic;
--            M01_axi_0_rready	: out std_logic      
            
            );
end awprot;

architecture Behavioral of awprot is

signal error_signal :  std_logic;
signal axi_awready, axi_bvalid, axi_wready, aw_en : std_logic;
signal axi_bresp : std_logic_vector(1 downto 0);
signal axi_awaddr : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);


type state_type is (idle, valid, ready);
signal state : state_type;

begin

-- Undisturbed Read Signals
M00_axi_0_araddr <= S00_AXI_REG_0_ARADDR;	
M00_axi_0_arprot <= S00_AXI_REG_0_ARPROT ;
M00_axi_0_arvalid <= S00_AXI_REG_0_ARVALID; 
S00_AXI_REG_0_ARREADY <= M00_axi_0_arready; 
S00_AXI_REG_0_RDATA <= M00_axi_0_rdata ; 
S00_AXI_REG_0_RRESP <= M00_axi_0_rresp;
S00_AXI_REG_0_RVALID <= M00_axi_0_rvalid;
M00_axi_0_rready <= S00_AXI_REG_0_RREADY;   
--M00_axi_0_awprot <= S00_AXI_REG_0_AWPROT;


-- Error check condition 
error_signal <= '1' when (S00_AXI_REG_0_AWPROT(1)='1' and S00_AXI_REG_0_AWVALID='1') else '0';
--S00_AXI_REG_0_BRESP <= "11" when error_signal ='1' else  M00_axi_0_bresp;



process(aclk_0,aresetn_0)
begin
    if aresetn_0 = '0' then
        state <= idle;
    elsif(aclk_0'event and aclk_0 ='1') then
        case state is
            when idle => 
                if error_signal='1' then
                    state <= valid;
                end if;
            
            when valid =>
                state <= ready;
                
            when ready =>
                if S00_AXI_REG_0_BREADY = '1' then
                    state <= idle;
                end if;
       end case;
    end if;
 end process;
                     
             
                 
                 
                    
secure_write: process(aclk_0)
begin
if (error_signal = '0') then
  -- with face mask
  
    M00_axi_0_awaddr <= S00_AXI_REG_0_AWADDR;  
    M00_axi_0_awvalid <= S00_AXI_REG_0_AWVALID;
    S00_AXI_REG_0_AWREADY <= M00_axi_0_awready;  
    M00_axi_0_wdata <= S00_AXI_REG_0_WDATA;  
    M00_axi_0_wstrb <= S00_AXI_REG_0_WSTRB;
    M00_axi_0_wvalid <= S00_AXI_REG_0_WVALID ;   
    S00_AXI_REG_0_WREADY <= M00_axi_0_wready;
    
    S00_AXI_REG_0_BRESP <= M00_axi_0_bresp;
    S00_AXI_REG_0_BVALID <= M00_axi_0_bvalid; 
    M00_axi_0_bready <= S00_AXI_REG_0_BREADY;  

else  
-- without face mask

M00_axi_0_awaddr <= (others => '0');
M00_axi_0_awvalid <= '0';
S00_AXI_REG_0_AWREADY <= '0';  
M00_axi_0_wdata <=  (others => '0');  
M00_axi_0_wstrb <= "0000";
M00_axi_0_wvalid <='0';   
S00_AXI_REG_0_WREADY <='0';

S00_AXI_REG_0_BRESP <= "00";
S00_AXI_REG_0_BVALID <= '0'; 
M00_axi_0_bready <= '0';


case state is
        when idle => 
                   
        when valid =>
            S00_AXI_REG_0_BRESP <= "11";
            S00_AXI_REG_0_BVALID <= '1';
            S00_AXI_REG_0_AWREADY <= '1';
            S00_AXI_REG_0_WREADY <= '1';
      
        when ready =>
            S00_AXI_REG_0_BVALID <= '1';
            

   end case;
end if;
   

end process;


end Behavioral;
