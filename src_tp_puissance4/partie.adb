with liste_generique; 
with Ada.Text_IO; use Ada.Text_IO;
with Participant; use Participant;
with main2joueurs;
	
	package body Partie is
	--Einit : Etat;
   -- Joue une partie. 
    -- E : Etat initial
    -- J : Joueur qui commence
    procedure Joue_Partie(E : in out Etat; J : in Joueur) is
	Coup1, Coup2 : Coup;
	JBis : Joueur;
	begin
		while Est_Gagnant(E,J) = false or Est_Nul(E) = false loop
			Affiche_Jeu(E);
				if (J=Joueur1) then		
					Put("It's time for "); Put(Nom_Joueur1); Put_Line(" to play");
					Put_Line("Select the Column number where you want to play");

					Coup1 := Coup_Joueur1(E); --Le joueur 1 joue en premier
					Affiche_Coup(Coup1); --Affiche le coup du Joueur 1
					E := Etat_Suivant(E,Coup1); -- On determine le nouvel etat avec le coup joue
					JBis := Joueur2;
				else	
					Put("It's time for "); Put(Nom_Joueur2); Put_Line(" to play");
					Put_Line("Select the Column number where you want to play");
					Coup2 := Coup_Joueur2(E);
					Affiche_Coup(Coup2);
					E := Etat_Suivant(E,Coup2);
					JBis := Joueur1;
				end if; 
			if Est_Gagnant(E,J) or Est_Gagnant(E,JBis) then
				if (J=Joueur1) then
					Put_Line("Joueur 1 a gagné!"); 
					exit;
				else 	
					Put_Line("Joueur 2 a gagné!");
					exit;
				end if;
				
			elsif Est_Nul(E) then
				Put_Line("Match Nul !");
				exit;
			else
				Put_Line("CA JOUE ENCORE");
				Joue_Partie(E, JBis);
			end if;
		end loop;

    end Joue_Partie;
end Partie;
