with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Unchecked_Deallocation;

package body liste_Generique is

	-- Procedure de liberation d'une Cellule (accedee par Liste)
	procedure Liberer is new Ada.Unchecked_Deallocation (Cellule, Liste);
	procedure LibererIt is new Ada.Unchecked_Deallocation (Iterateur_Interne, Iterateur);

    -- Affichage de la liste, dans l'ordre de parcours
    procedure Affiche_Liste (L : in Liste) is 
	Cour : Liste := L;
	begin	
		while Cour.Suiv /= NULL loop
			Put(Cour.Val);
			Put(" ");
			Cour:= Cour.Suiv;
		end loop;
	end Affiche_Liste;

    -- Insertion d'un element V en tete de liste
    procedure Insere_Tete (V : in Element; L : in out Liste) is
	List : Liste;
	begin

		if L = NULL then
			List:= new Cellule'(V,NULL);
			L:= List;
		else
			List := new Cellule'(V,L);
			L:= List;
		end if;

	end Insere_Tete;

    -- Vide la liste et libere toute la memoire utilisee
    procedure Libere_Liste(L : in out Liste) is
	List : Liste;
	begin
		while L /= null loop
			List := L.Suiv;
			Liberer(L);
			L := List;
		end loop;
	end Libere_Liste;

    -- Creation de la liste vide
    function Creer_Liste return Liste is
	begin	
		return null;
	end Creer_Liste;

    -- Cree un nouvel iterateur 
    function Creer_Iterateur (L : Liste) return Iterateur is 
	It : Iterateur;
	begin
		if L = null then
			It := new Iterateur_Interne'(NULL, NULL);
		else 
			It := new Iterateur_Interne'(It.Cour, It.Suivant);
		end if;
		return It;
	end Creer_Iterateur;

    -- Liberation d'un iterateur
    procedure Libere_Iterateur(It : in out Iterateur) is 
	begin
		LibererIt(It);
	end Libere_Iterateur;

    -- Avance d'une case dans la liste
    procedure Suivant(It : in out Iterateur) is
	begin

		if It.Cour = NULL then
			Put_Line("La liste est vide");

		elsif A_Suivant(It) = false then
			raise FinDeListe;
		else
		It.Cour := It.Suivant;
		It.Suivant := It.Suivant.Suiv;
		end if;
	end Suivant;

    -- Retourne l'element courant
    function Element_Courant(It : Iterateur) return Element is
	begin
		if It.Cour = NULL then
			Put_Line("La liste est vide");
		elsif A_Suivant(It) = false then
			raise FinDeListe;
		end if;
		return It.Cour.Val;
	end Element_Courant;

    -- Verifie s'il reste un element a parcourir
    function A_Suivant(It : Iterateur) return Boolean is
	begin
		if It.Suivant /= NULL then 
			return true;
		else
		return false;
		end if;
	end A_Suivant;

end Liste_Generique;




