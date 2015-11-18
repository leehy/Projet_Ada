with liste_generique; 
with Ada.Text_IO; use Ada.Text_IO;
with Participant; use Participant;
	
	package body Partie is
   -- Joue une partie. 
    -- E : Etat initial
    -- J : Joueur qui commence
    procedure Joue_Partie(E : in out Etat; J : in Joueur) is
	
	Coup1, Coup2 : Coup;
	JBis : Joueur;
	
	begin
	--T'as pas besoin d'initialiser car ça se fait deja dans le main2joueur 

	--Initialiser(E); --On initialise la table de jeu.	
	--Put_line("Choisissez la colonne dans laquelle vous voulez jouer");
	--loop Get(C.numColumn); -- Le placement va definir le coup joue
		--exit when (C < boardGameWidth - 1 or else C > 1);
	--end loop;
	if (J=Joueur1) then
		Coup1 := Coup_Joueur1(E); --Le joueur 1 joue en premier
		Affiche_Coup(Coup1); --Affiche le coup du Joueur 1
		E := Etat_Suivant(E,Coup1); -- On determine le nouvel etat avec le coup joue
	
	else	Coup2 := Coup_Joueur2(E);
		Affiche_Coup(Coup2);
		E := Etat_Suivant(E,Coup2);
	end if; 
	
	Affiche_Jeu(E); --On affiche le nouveau quadrillage du jeu

	
	if Est_Gagnant(E,J) then
	
		Put("Le joueur ");
		if (J=Joueur1) then
			Put("1"); else Put("2");
		end if;
			Put("a gagné!");
	end if;
	
	if Est_Nul(E) then
		Put("Match Nul!");
	end if;
	
	if (J=Joueur1) then JBis := Joueur2;
	else JBis := Joueur1;
	end if;
	
	Joue_Partie(E, JBis);

    end Joue_Partie;
end Partie;
