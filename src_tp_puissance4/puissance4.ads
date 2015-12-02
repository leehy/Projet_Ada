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
	--type EtatTopPion is private;
	type CelluleC is record
		-- Signe du coup (soit signPlayer1, soit signPlayer2, soit signEmptyCase)
		Sign : Character;
		-- numero de la ligne
		numColumn : Integer;
		-- numero de la colonne
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
	procedure Initialiser(E:in out Etat);
	--procedure Initialiser(E : in out Etat, Etp : in out EtatTopPion);


	package Liste_Coups is new Liste_Generique(Coup, Affiche_Coup);
	-- Retourne la liste des coups possibles pour J a partir de l’etat
	function Coups_Possibles ( E : Etat ; J : Joueur ) return Liste_Coups.Liste ;
	-- Evaluation statique du jeu du point de vue de l ’ ordinateur
	function Eval ( E : Etat) return Integer ;


private
	-- Representation d'un tableau de compteur qui nous permettra d'obtenir la position du pion place au plus haut du jeu
	--type EtatTopPion is array (1..boardGameWidth) of Integer;

    -- Representation de l'etat du tableau de jeu
	type Etat is array (1..boardGameWidth,1..boardGameHeight) of Character ;

end puissance4;
