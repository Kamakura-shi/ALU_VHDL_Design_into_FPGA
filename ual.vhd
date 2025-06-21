--================ ual.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- ETE 2025, Ecole de technologie superieure
-- ***** Ouali Hani ************
-- ***** OUAH76050108 ************
-- =============================================================
-- Description: 
--              Architecture RTL du UAL de N bits.
-- =============================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_misc.or_reduce;

ENTITY UAL IS
  GENERIC (N : integer := 32);
  PORT (ualControl : IN  std_logic_vector(3 DOWNTO 0);
        srcA, srcB : IN  std_logic_vector(N-1 DOWNTO 0);
        result     : OUT std_logic_vector(N-1 DOWNTO 0);
        cout, zero : OUT std_logic);
END UAL;

ARCHITECTURE rtl OF UAL IS
  SIGNAL operation                    : std_logic_vector(1 DOWNTO 0);
  SIGNAL op1, op2                     : std_logic;
  SIGNAL srcAMux, srcBMux, res, sum   : std_logic_vector(N-1 DOWNTO 0);
  SIGNAL somme                        : unsigned(N DOWNTO 0); -- to hold carry out
  SIGNAL slt                          : std_logic_vector(N-1 DOWNTO 0) := (others => '0');     -- no input carry
BEGIN

  -- Extraction des signaux de contrôle
  op1       <= ualControl(3);  -- Non utilisé
  op2       <= ualControl(2);
  operation <= ualControl(1 DOWNTO 0);

  -- Multiplexeurs pour inverser srcA et srcB selon op1 et op2
  srcAMux <= NOT srcA WHEN op1 = '1' ELSE srcA;
  srcBMux <= NOT srcB WHEN op2 = '1' ELSE srcB;

  -- Addition des deux opérandes avec retenue
  somme <= resize(unsigned(srcAMux), srcAMux'length + 1) + unsigned(srcBMux) + unsigned'("" & op2);
           
  -- SLT:
  slt(0) <= somme(N-1); 
  slt(N-1 DOWNTO 1) <= (others => '0');
  
           -- Sélecteur de l'opération
  PROCESS(operation, srcAMux, srcBMux, somme)
  BEGIN
    CASE operation IS
      WHEN "00" =>
        res <= srcAMux AND srcBMux;
      WHEN "01" =>
        res <= srcAMux OR srcBMux;
      WHEN "10" =>
        res <= std_logic_vector(somme(N-1 DOWNTO 0));
      WHEN "11" =>
        res <= slt;
      WHEN OTHERS =>
        res <= (others => '0'); -- x"00000000" WHEN OTHERS;
    END CASE;
  END PROCESS;

  -- Assignation des sorties
  result <= res;
  zero   <= (not or_reduce(res));
  cout   <= somme(N);
  sum    <= std_logic_vector(somme(N - 1 DOWNTO 0));

END rtl;
