with Participant; use Participant; 
with Liste_Generique;
with Ada.Text_IO;

package body Moteur_Jeu is 

function Choix_Coup(E : Etat) return Coup;

function Eval_Min_Max(E : Etat; P : Natural; C : Coup; J : Joueur)
        return Integer;

end Moteur_Jeu;
