with Ada.Text_IO; 
with Ada.Integer_Text_IO;
with Puissance4;
with Participant;
with Partie;
with Liste_Generique;
with Moteur_Jeu;

use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Participant;

procedure Main2Joueurs is
   
   package MyPuissance4 is new Puissance4('X', 'O', '-',4,7,7);
   
   package MyMoteur_jeu is new Moteur_Jeu(MyPuissance4.Etat,
					  MyPuissance4.Coup, 
					  MyPuissance4.Etat_Suivant, 
					  MyPuissance4.Est_Gagnant,
					  MyPuissance4.Est_Nul,
					  MyPuissance4.Affiche_Coup,
					  MyPuissance4.Liste_Coups,
					  MyPuissance4.Coups_Possibles,
					  MyPuissance4.Eval,
					  2,
					  Joueur1);
use MyMoteur_jeu;
   -- definition d'une partie entre L'ordinateur en Joueur 1 et un humain en Joueur 2
   package MyPartie is new Partie(MyPuissance4.Etat,
				  MyPuissance4.Coup, 
				  "Pierre",
				  "Paul",
				  MyPuissance4.Etat_Suivant,
				  MyPuissance4.Est_Gagnant,
				  MyPuissance4.Est_Nul,
				  MyPuissance4.Affiche_Jeu,
				  MyPuissance4.Affiche_Coup,
				  --MyPuissance4.Coup_Joueur1,
				  MyMoteur_Jeu.Choix_Coup,
				  MyPuissance4.Coup_Joueur2);
   use MyPartie;
   
   P: MyPuissance4.Etat;

begin
   Put_Line("Puissance 4");
   Put_Line("");
   Put_Line("Joueur 1 : X"); 
   Put_Line("Joueur 2 : O");
   
   MyPuissance4.Initialiser(P);
   
   Joue_Partie(P, Joueur2);
end Main2Joueurs;
