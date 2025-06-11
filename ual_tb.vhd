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
  ALU32 : ENTITY work.UAL
    GENERIC MAP (N => TAILLE)
    PORT MAP (
      ualControl => ualControl,
      srcA       => srcA,
      srcB       => srcB,
      result     => result,
      cout       => cout,
      zero       => zero
    );

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
    -- Écrire l'en-tête une seule fois
    IF entete THEN
      write(ligneSortie, string'("<UALCtrl> <srcA> <srcB> <result> <zero> <cout> <resultUAL> <zeroUAL> <coutUAL> : <commentaire>"));
      writeline(fichierOut, ligneSortie);
      entete := false;
    END IF;

    -- Sauter les deux premières lignes du fichier d’entrée si besoin
    readline(fichierIn, ligneEntree);
    readline(fichierIn, ligneEntree);

    -- Parcourir les lignes
    WHILE NOT endfile(fichierIn) LOOP
      readline(fichierIn, ligneEntree);

      -- Lecture des valeurs
      hread(ligneEntree, vUAL, good);
      ASSERT good REPORT "Erreur de lecture de UALControl" SEVERITY error;
      hread(ligneEntree, vsrcA, good);
      ASSERT good REPORT "Erreur de lecture de srcA" SEVERITY error;
      hread(ligneEntree, vsrcB, good);
      ASSERT good REPORT "Erreur de lecture de srcB" SEVERITY error;
      hread(ligneEntree, vresult_attendu, good);
      ASSERT good REPORT "Erreur de lecture du resultat attendu" SEVERITY error;
      read(ligneEntree, vzero, good);
      ASSERT good REPORT "Erreur de lecture de zero attendu" SEVERITY error;
      read(ligneEntree, vcout, good);
      ASSERT good REPORT "Erreur de lecture de cout attendu" SEVERITY error;

      -- Appliquer les signaux
      ualControl      <= vUAL;
      srcA           <= vsrcA;
      srcB           <= vsrcB;
      result_attendu <= vresult_attendu; -- Ajouté
      zero_attendu   <= vzero;           -- Ajouté
      cout_attendu   <= vcout;           -- Ajouté

      WAIT FOR PERIODE;

      -- Écriture des résultats en hexadécimal
      ligneSortie := null;
      hwrite(ligneSortie, vUAL, left, 10);
      hwrite(ligneSortie, vsrcA, right, 10);
      hwrite(ligneSortie, vsrcB, right, 10);
      hwrite(ligneSortie, vresult_attendu, right, 12);
      write(ligneSortie, str(vzero), right, 6);
      write(ligneSortie, str(vcout), right, 6);
      hwrite(ligneSortie, result, right, 12);
      write(ligneSortie, str(zero), right, 6);
      write(ligneSortie, str(cout), right, 6);
      write(ligneSortie, string'(": "), right, 2);

      IF (result = vresult_attendu) AND (zero = vzero) AND (cout = vcout) THEN
        write(ligneSortie, string'("SUCCES"));
      ELSE
        write(ligneSortie, string'("ECHEC "));
      END IF;

      writeline(fichierOut, ligneSortie);
    END LOOP;

    WAIT;
  END PROCESS;

END UAL_tb_arc;
