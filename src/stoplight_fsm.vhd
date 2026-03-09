--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2018 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : stoplight_fsm.vhd
--| AUTHOR(S)     : C3C Rushil Punukollu
--| CREATED       : 02/22/2018, Last Modified 06/24/2020 by Capt Dan Johnson
--| DESCRIPTION   : This module file implements solution for the HW stoplight example using 
--|				  : direct hardware mapping (registers and CL) for BINARY encoding.
--|               : Reset is asynchronous with a default state of yellow.
--|
--|					Inputs:  i_C 	 --> input to indicate a car is present
--|                          i_reset --> fsm reset
--|                          i_clk   --> slowed down clk
--|							 
--|					Outputs: o_R     --> red light output
--|							 o_Y	 --> yellow light output
--|							 o_G	 --> green light output
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : None
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

  
entity stoplight_fsm is
    Port ( i_C     : in  STD_LOGIC;
           i_reset : in  STD_LOGIC;
           i_clk   : in  STD_LOGIC;
           o_R     : out  STD_LOGIC;
           o_Y     : out  STD_LOGIC;
           o_G     : out  STD_LOGIC);
end stoplight_fsm;

architecture Behavioral of stoplight_fsm is

    signal f_Q      : std_logic_vector(1 downto 0) := "10";
    signal f_Q_next : std_logic_vector(1 downto 0) := "10";

begin

    register_proc : process (i_clk, i_reset)
    begin
        if i_reset = '1' then
            f_Q <= "10";
        elsif (rising_edge(i_clk)) then
            f_Q <= f_Q_next;
        end if;
    end process register_proc;

    f_Q_next(0) <= (not f_Q(1)) and i_C;
    f_Q_next(1) <= (not f_Q(1)) and f_Q(0) and (not i_C);

    o_G <= (not f_Q(1)) and f_Q(0);
    o_Y <= f_Q(1) and (not f_Q(0));
    o_R <= ((not f_Q(1)) and (not f_Q(0))) or (f_Q(1) and f_Q(0));

end Behavioral;
