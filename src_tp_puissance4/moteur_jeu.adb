with Participant; use Participant; 
with Liste_Generique;
with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;


package body Moteur_Jeu is 

    function Choix_Coup(E : Etat) return Coup is 
		LCoups_Possible : Liste_Coups.Liste;
		LCoups_Max : Liste_Coups.Liste;
		Coup_Retourne : Coup;
		It_Possible : Liste_Coups.Iterateur;
		It_Max : Liste_Coups.Iterateur;
		Val_Max : Integer ; -- Poids le plus elevé
		Val_Tmp : Integer ; 
		Profondeur : Natural := P;
		TailleDeListe : Integer;
   		type Numero is range 0 .. 100;
    	package Choix_Coup is new Ada.Numerics.Discrete_Random (Numero);
    	use Choix_Coup;    -- Rend Generator, Reset et Random visibles
    	A : Numero;
    	G : Generator;

	begin

		-- On recupere la liste de coups possible à l'état E pour le joueur joueurMoteur
		LCoups_Possible := Coups_Possibles(E,JoueurMoteur);
		-- On lui associe un iterateur
		It_Possible := Liste_Coups.Creer_Iterateur(LCoups_Possible);
		
		Val_Max := Eval_Min_Max(E,Profondeur, JoueurMoteur); --Liste_Coups.Element_Courant(It_Possible),
		Liste_Coups.Insere_Tete(Liste_Coups.Element_Courant(It_Max), LCoups_Max);
		TailleDeListe := 1; 

		while Liste_Coups.A_Suivant(It_Possible) loop
			Val_Tmp := Eval_Min_Max(E,Profondeur, JoueurMoteur); --Liste_Coups.Element_Courant(It_Possible),
			if Val_Tmp > Val_Max then
				Val_Max := Val_Tmp;
				Liste_Coups.Libere_Iterateur(It_Possible);
				Liste_Coups.Insere_Tete(Liste_Coups.Element_Courant(It_Possible), LCoups_Max);	
				TailleDeListe := 1 ;	
			elsif Val_Tmp = Val_Max then
				Liste_Coups.Insere_Tete(Liste_Coups.Element_Courant(It_Possible), LCoups_Max);
				TailleDeListe:= TailleDeListe + 1;
			end if;
			Liste_Coups.Suivant(It_Possible);
		end loop;
	
		Reset (G);          -- Initialise le générateur (à faire une seule fois)
    	A := Random (G);    -- Tire un nombre au hasard entre 0 et 100
    	--Ada.Text_IO.Put_Line ("Le numéro est: " & Numero'Image (A));
		Coup_Retourne := Liste_Coups.Element_Courant(It_Possible);


		Liste_Coups.Libere_Iterateur(It_Possible);
		Liste_Coups.Libere_Liste(LCoups_Possible);
		Liste_Coups.Libere_Iterateur(It_Max);
		Liste_Coups.Libere_Liste(LCoups_Max);		
		return Coup_Retourne;		
	end Choix_Coup;

	function Eval_Min_Max(E : Etat; P : Natural; J : Joueur) return Integer is
	
	INFINITY : Integer := 9999;
	tmp : Integer;
	valMin : Integer;
	valMax : Integer;
	valFinale : Integer:=0;
	Lsuiv : Liste_Coups.Liste;
	LcoupsPossibles : Liste_Coups.Liste;
	It_Possible : Liste_Coups.Iterateur;
	CoupJoue : Coup;	
	Et : Etat := E;
	EtActuel : Etat := E;

	begin
	
		--if (P=0) or else Est_Nul(J)
		--			or else Est_Gagnant(E,J)
		--				or else Est_Gagnant(E,Adversaire(J))
		--	then --Eval(E) --Evaluation dans le cas où la partie est finie
			-- ou le cas où on regarde l'état en cours
		--end if;
		
	if(J = Joueur1) --On fait l'hypothèse que l'ordinateur est Joueur1
		then	
		valMax := -INFINITY;
		LcoupsPossibles := Coups_Possibles(E,J);
		It_Possible := Liste_Coups.Creer_Iterateur(LcoupsPossibles); --added
		--while LcoupsPossibles.Suiv /= NULL loop

		while Liste_Coups.A_Suivant(It_Possible) loop
			--Choix_Coup(E);
			--E := Etat_Suivant(E, Choix_Coup(E)); --on fait une simulation de coups pour chaque état successif du jeu
			CoupJoue := Liste_Coups.Element_Courant(It_Possible);
			Et := Etat_Suivant(Et, CoupJoue);
			--possibles
			tmp := Eval_Min_Max(Et, P-1, Joueur2);
		
			if (tmp > valMax) then
				valMax := tmp;
			end if;
		
			--Cancel_coup(CoupJoue);
			Et := EtActuel;
		
		--Lsuiv := LcoupsPossibles.Suiv;
		--Lsuiv := Lsuiv.Suiv;
		--It_suivant := Liste_Coups.Suivant(It_Possible);
		
		
		end loop;
		
		valFinale := valMax;
		
		return valFinale;
		
	end if;
		
	if (J = Joueur2) --On fait l'hypothèse que Joueur2 est l'adversaire de l'ordinateur
		then
		valMin := INFINITY;
		LcoupsPossibles := Coups_Possibles(E,J);
		It_Possible := Liste_Coups.Creer_Iterateur(LcoupsPossibles);

		while Liste_Coups.A_Suivant(It_Possible) loop
		
			CoupJoue := Liste_Coups.Element_Courant(It_Possible);
			Et := Etat_Suivant(Et, CoupJoue);
			tmp := Eval_Min_Max(E, P-1, Joueur1);
				
			if (tmp < valMin) then
				valMin := tmp;
			end if;
			
			--Cancel_coup(CoupJoue);
			Et := EtActuel;
			
		--Lsuiv := LcoupsPossibles.Suiv;
		--Lsuiv := Lsuiv.Suiv;
		
		end loop;
		
		valFinale := valMin;
		
		return valFinale;
		
	end if;
        return valFinale;	
	end Eval_Min_Max;
	

end Moteur_Jeu;
