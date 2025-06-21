-- ======================== adder_rtl.vhd ============================
-- ELE343 Conception des systemes ordines
-- HIVER 2017, Ecole de technologie superieure
-- ============================================================================
-- Description: Architecture rtl de l'entity adder
--              Utilise l'operateur d'addition "+" defini dans
--              le paquetage numeric_std
-- ============================================================================

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ARCHITECTURE rtl OF adder IS
  SIGNAL retenueSomme : unsigned(N DOWNTO 0);
BEGIN
  -- La taille de l'operande est augmente de un bit avec la fonction resize 
  -- pour qu'elle soit identique a celle du signal retenueSomme
  -- Le bit le plus significatif de retenueSomme contient la retenue de sortie
  retenueSomme <= resize(unsigned(a), a'length+1) + unsigned(b) + unsigned'("" & retenuein);
  somme        <= std_logic_vector(retenueSomme(n-1 DOWNTO 0));
  retenueout   <= retenueSomme(n);
END rtl;
