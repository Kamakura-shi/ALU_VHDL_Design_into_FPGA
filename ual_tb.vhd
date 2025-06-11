--================ alu.vhd =================================
-- ELE344 Conception et architecture de processeurs
-- AUTOMNE 2018, Ecole de technologie superieure
-- ***** Nom et Prénom ************
-- ***** Code permanent ************
-- =============================================================
-- Description: 
--             Testbench du UAL a 32 bits.
-- =============================================================
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.ALL;
USE WORK.txt_util.ALL;

ENTITY UAL_tb IS
  GENERIC (TAILLE : integer := 32);
END UAL_tb;

ARCHITECTURE UAL_tb_arc OF UAL_tb IS

  SIGNAL srcA, srcB             : std_logic_vector (TAILLE-1 DOWNTO 0);
  SIGNAL ualControl             : std_logic_vector (3 DOWNTO 0);
  SIGNAL cout, cout_attendu     : std_logic;
  SIGNAL result, result_attendu : std_logic_vector (TAILLE-1 DOWNTO 0);
  SIGNAL zero, zero_attendu     : std_logic;
  SIGNAL OpType                 : string(1 TO 3);

  CONSTANT PERIODE : time := 20 ns;

BEGIN
  ALU32 : ENTITY work.                   -- À compléter (instancier l'UAL)
    
------------------------------------------------------------------
    PROCESS(ualControl)
    BEGIN
      CASE ualControl IS
        WHEN X"0"   => OpType <= "AND";  -- Operation ET logique
        WHEN X"1"   => OpType <= "OR ";  -- Operation OU logique
        WHEN X"2"   => OpType <= "ADD";  -- Operation ADD logique
        WHEN X"6"   => OpType <= "SUB";  -- Operation SUB logique
        WHEN X"7"   => OpType <= "SLT";  -- Operation ET logique
        WHEN OTHERS => OpType <= "---";  -- Illegal
      END CASE;
    END PROCESS;

------------------------------------------------------------------                           
  PROCESS

    FILE fichierIn  : text OPEN read_mode IS "ual_entrees.txt";
    FILE fichierOut : text OPEN write_mode IS "ual_sorties.txt";

    VARIABLE vsrcA, vsrcB, vresult_attendu : std_logic_vector (TAILLE-1 DOWNTO 0);
    VARIABLE vUAL                          : std_logic_vector (3 DOWNTO 0);
    VARIABLE vzero, vcout                  : std_logic;
    VARIABLE ligneEntree, ligneSortie      : line;
    VARIABLE good                          : boolean;
    VARIABLE entete                        : boolean := true;
  BEGIN
    -- À compléter 
    -- Le testbench doit contenir la Détection des erreurs pour Result, zero et cout
    IF entete THEN
      write(ligneSortie, string'("<ualCtrl> < srcA > < srcB >  < Résultat > < Résultat_UAL > < zero > < cout >: <commentaire>"));
      writeline(fichierOut, ligneSortie);
      entete := false;
    END IF;

    IF NOT(endfile(fichierIn)) THEN
      readline(fichierIn, ligneEntree);
      hread(ligneEntree, vUAL, good);
      ASSERT good REPORT "Erreur de lecture de l'operande UALcontrol" SEVERITY error;


      -- À compléter 


      writeline(fichierOut, ligneSortie);

    END PROCESS;
END UAL_tb_arc;
