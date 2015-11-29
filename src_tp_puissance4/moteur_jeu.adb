with Participant; use Participant; 
with Liste_Generique;
with Ada.Text_IO;


package body Moteur_Jeu is 

--function Choix_Coup(E : Etat) return Coup;

	function Eval_Min_Max(E : Etat; P : Natural; J : Joueur)
	
	INFINITY : Integer := 9999;
	tmp : Integer;
	valMin : Integer;
	valMax : Integer;
	valFinale : Integer;
	Lsuiv : Liste_Coups.Liste;
	begin
	
		if (P=0) or else Est_Nul(J);
					or else Est_Gagnant(E,J);
						or else Est_Gagnant(E,Adversaire(J));
			then return Eval(E); --Evaluation dans le cas où la partie est finie
			-- ou le cas où on regarde l'état en cours
		end if;
		
	if(J = Joueur1) --On fait l'hypothèse que l'ordinateur est Joueur1
			
		valMax := -INFINITY;
		LcoupsPossibles : Liste_Coups.Liste := Coups_Possibles(E,J);
		while LcoupsPossibles.Suiv /= NULL loop;
			Choix_Coup(E);
			E := Etat_Suivant(Choix_Coup(E)); --on fait une simulation de coups pour chaque état successif du jeu
			--possibles
			tmp := Eval_Min_Max(E, P-1, Joueur2);
		
			if (tmp > valMax) then
				valMax := tmp;
			end if;
		
			Cancel_coup(Choix_Coup(E));
		
		Lsuiv := LcoupsPossibles.Suiv;
		Lsuiv := Lsuiv.Suiv;
		
		end loop;
		
		valFinale := valMax;
		
		return valFinale;
		
	end if;
		
	if (J = Joueur2) --On fait l'hypothèse que Joueur2 est l'adversaire de l'ordinateur
	
		valMin := INFINITY;
		LcoupsPossibles : Liste_Coups.Liste := Coups_Possibles(E,J);
		
		while LcoupsPossibles.Suiv /= NULL loop;
		
			Choix_Coup(E);
			E := Etat_Suivant(Choix_Coup(E));
			tmp := Eval_Min_Max(E, P-1, Joueur1);
				
			if (tmp < valMin) then
				valMin := tmp;
			end if;
			
			Cancel_coup(Choix_Coup(E));
			
		Lsuiv := LcoupsPossibles.Suiv;
		Lsuiv := Lsuiv.Suiv;
		
		end loop;
		
		valFinale := valMin;
		
		return valFinale;
		
	end if;
	
	end Eval_Min_Max;
	
        return Integer;

end Moteur_Jeu;
