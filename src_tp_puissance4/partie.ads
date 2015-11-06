with Liste_Generique, Participant;
with Ada.Text_IO;
use Participant;

generic
    type Etat is private;
    type Coup is private;
   
    -- Nom affichable du Joueur1
    Nom_Joueur1 : String;
    -- Nom affichable du Joueur2   
    Nom_Joueur2 : String;
    -- Calcule l'etat suivant en appliquant le coup
    with function Etat_Suivant(E : Etat; C : Coup) return Etat;
    -- Indique si l'etat courant est gagnant pour le joueur J
    with function Est_Gagnant(E : Etat; J : Joueur) return Boolean; 
    -- Indique si l'etat courant est un status quo (match nul)
    with function Est_Nul(E : Etat) return Boolean; 
    -- Fonction d'affichage de l'etat courant du jeu
    with procedure Affiche_Jeu(E : Etat);
    -- Affiche a l'ecran le coup passe en parametre
    with procedure Affiche_Coup(C : in Coup);   
    -- Retourne le prochaine coup joue par le joueur1
    with function Coup_Joueur1(E : Etat) return Coup;
    -- Retourne le prochaine coup joue par le joueur2   
    with function Coup_Joueur2(E : Etat) return Coup;   
    
package Partie is
   
   
    -- Joue une partie. 
    -- E : Etat initial
    -- J : Joueur qui commence
    procedure Joue_Partie(E : in out Etat; J : in Joueur);
   
end Partie;
