with Participant; use Participant;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;
with Liste_Generique ;

generic 
	
	signPlayer1 : Character;
	signPlayer2 : Character;
	signEmptyCase : Character;
	nbCheckersToWin : Integer;
	boardGameWidth : Integer;
	boardGameHeight : Integer;
	

package puissance4 is 

	type Etat is private;

	type CelluleC is record
		-- Signe du coup (soit signPlayer1, soit signPlayer2, soit signEmptyCase)
		Sign : Character;
		-- numero de la colonne
		numColumn : Integer;
		-- numero de la ligne
		numRow : Integer;
	end record;
	type Coup is access CelluleC;

	-- Calcule l'etat suivant en appliquant le coup
    function Etat_Suivant(E : Etat; C : Coup) return Etat;
    -- Indique si l'etat courant est gagnant pour le joueur J
    function Est_Gagnant(E : Etat; J : Joueur) return Boolean; 
    -- Indique si l'etat courant est un status quo (match nul)
    function Est_Nul(E : Etat) return Boolean; 
    -- Fonction d'affichage de l'etat courant du jeu
    procedure Affiche_Jeu(E : Etat);
    -- Affiche a l'ecran le coup passe en parametre
    procedure Affiche_Coup(C : in Coup);   
    -- Retourne le prochaine coup joue par le joueur1
    function Coup_Joueur1(E : Etat) return Coup;
    -- Retourne le prochaine coup joue par le joueur2   
    function Coup_Joueur2(E : Etat) return Coup;
  	-- Initialisation du plateau
	procedure Initialiser(E : in out Etat);
private
    -- Representation de l'etat du tableau de jeu
	type Etat is array (1..boardGameWidth,1..boardGameHeight) of Character ;

end puissance4;
