with Participant; use Participant; 
with Liste_Generique;
with Ada.Text_IO;

generic
    type Etat is private;
    type Coup is private;

    -- Calcule l'etat suivant en appliquant le coup
    with function Etat_Suivant(E : Etat; C : Coup) return Etat;
    -- Indique si l'etat courant est gagnant pour J
    with function Est_Gagnant(E : Etat; J : Joueur) return Boolean; 
    -- Indique si l'etat courant est un status quo (match nul)
    with function Est_Nul(E : Etat) return Boolean; 

    -- Affiche a l'ecran le coup passe en parametre
    with procedure Affiche_Coup(C : in Coup);
    -- Implantation d'un package de liste de coups
    with package Liste_Coups is new Liste_Generique(Coup, Affiche_Coup); 
    -- Retourne la liste des coups possibles pour J a partir de l'etat 
    with function Coups_Possibles(E : Etat; J : Joueur)
            return Liste_Coups.Liste; 
    -- Evaluation statique du jeu du point de vue de l'ordinateur
    with function Eval(E : Etat) return Integer;   
    -- Profondeur de recherche du coup
    P : Natural;
    -- Indique le joueur interprete par le moteur
    JoueurMoteur : Joueur;
    
package Moteur_Jeu is
    
    -- Choix du prochain coup par l'ordinateur. 
    -- E : l'etat actuel du jeu;
    -- P : profondeur a laquelle la selection doit s'effetuer
    function Choix_Coup(E : Etat) return Coup;
   
private 
    -- Evaluation d'un coup a partir d'un etat donne
    -- E : Etat courant
    -- P : profondeur a laquelle cette evaluation doit etre realisee
    -- C : Coup a evaluer
    -- J : Joueur qui realise le coup
    function Eval_Min_Max(E : Etat; P : Natural; C : Coup; J : Joueur)
        return Integer;
   
end Moteur_Jeu;
