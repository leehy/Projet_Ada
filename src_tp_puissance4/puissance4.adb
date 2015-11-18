with Participant; use Participant;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;

package body puissance4 is 

	-- Calcule l'etat suivant en appliquant le coup
    function Etat_Suivant(E : Etat; C : Coup) return Etat is
		Row: Integer;
		Column : Integer;
		EtatCourant : Etat := E;
	begin
		Row := C.numRow;
		Column := C.numColumn;
		EtatCourant(Row, Column) := C.Sign;
		return EtatCourant;
	end Etat_Suivant;

    -- Indique si l'etat courant est gagnant pour le joueur J
    function Est_Gagnant(E : Etat; J : Joueur) return Boolean is 
		Row: Integer:=1;
		RowDiag : Integer:=1;
		Column : Integer:=1;
		ColumnDiag : Integer:=1 ;
		num_checkers_aligned : Integer:=0;
		sign : Character;
		
	begin
		-- On assigne les signes aux joueurs pour pouvoir compter le nombre de signes côte à côte
		if J = Joueur1 then
			sign := signPlayer1;
		else 
			sign := signPlayer2;
		end if; 

		-- traitement du cas d'une victoire verticale
		for Column in 1..boardGameWidth loop
			num_checkers_aligned := 0;
			for Row in 1..boardGameHeight loop
				if E(Row, Column)= sign then
					num_checkers_aligned := num_checkers_aligned + 1;
				end if;
				
				if num_checkers_aligned = nbCheckersToWin then
					return true;
				end if;
			
				if E(Row, Column) /= sign then
					num_checkers_aligned := 0;
				end if;
			end loop;
		end loop;

		-- traitement du cas d'une victoire horizontale 
		for Row in 1..boardGameHeight loop
			num_checkers_aligned := 0;
			for Column in 1..boardGameWidth loop
				if E(Row,Column) = sign then 
					num_checkers_aligned := num_checkers_aligned + 1;
				end if;
				
				if num_checkers_aligned = nbCheckersToWin then
					return true;
				end if;
				if E(Row, Column) /= sign then
					num_checkers_aligned := 0;
				end if;
			end loop;
		end loop;

		-- traitement du cas d'une victoire via une diagonale ascendante de la gauche vers la droite
		for Row in 1..boardGameHeight-nbCheckersToWin + 1 loop
			num_checkers_aligned := 0;
			for Column in 1..boardGameWidth-nbCheckersToWin + 1 loop
				if E(Row, Column) /= sign then
					num_checkers_aligned := 0 ;
				elsif E(Row,Column) = sign then
					num_checkers_aligned := num_checkers_aligned + 1;
					ColumnDiag := Column;
					RowDiag := Row;
			
					while (num_checkers_aligned /= 0) and (ColumnDiag < boardGameWidth and RowDiag < boardGameHeight) loop -- boardGameWidth or boardGameWidth + 1 ?
						if E(RowDiag +1, ColumnDiag+1) /= sign then
							num_checkers_aligned :=0;
						elsif E(RowDiag + 1, ColumnDiag + 1) = sign then
							num_checkers_aligned := num_checkers_aligned + 1;
							RowDiag := RowDiag + 1;
							ColumnDiag := ColumnDiag + 1;
						end if;

						if num_checkers_aligned = nbCheckersToWin then
							return true;
						end if;
					end loop;

				end if;
			end loop;
		end loop;

		-- traitement du cas d'une victoire via une diagnole descendante de la gauche vers la droite
		for Column in 1..boardGameWidth-nbCheckersToWin + 1 loop
			num_checkers_aligned := 0;
			for Row in boardGameHeight-nbCheckersToWin + 1..boardGameHeight loop
				if E(Row, Column) /= sign then
					num_checkers_aligned := 0 ;
				elsif E(Row,Column) = sign then
					num_checkers_aligned := num_checkers_aligned + 1;
					ColumnDiag := Column;
					RowDiag := Row;
			
					while (num_checkers_aligned /= 0) and (ColumnDiag < boardGameWidth and RowDiag > 1) loop -- boardGameWidth or boardGameWidth + 1 ?
						if E(RowDiag - 1, ColumnDiag + 1) /= sign then
							num_checkers_aligned :=0;
						elsif E(RowDiag - 1, ColumnDiag + 1) = sign then
							num_checkers_aligned := num_checkers_aligned + 1;
							RowDiag := RowDiag - 1;
							ColumnDiag := ColumnDiag + 1;
						end if;

						if num_checkers_aligned = nbCheckersToWin then
							return true;
						end if;
					end loop;
				end if;
			end loop;
		end loop;
		return false;
	end Est_Gagnant;

    -- Indique si l'etat courant est un status quo (match nul)
    function Est_Nul(E : Etat) return Boolean is 
		Row : Integer:=1;
	begin
		-- on ne va verifier que la ligne tout en haut pour economiser des operations
		for Row in 1..boardGameWidth loop
			if E(Row, boardGameHeight) = signEmptyCase then
				return false;
			end if;
		end loop;
		return true;
	end Est_Nul;

    -- Fonction d'affichage de l'etat courant du jeu
    procedure Affiche_Jeu(E : Etat) is
		Row : Integer:=boardGameWidth;	
		Column : Integer:=1;
	begin 
		Put("|");
		for Column in 1..boardGameWidth loop
			Put(Integer'Image(Column) & " |");
		end loop;
		Put_Line("");

		for Row in reverse 1..boardGameHeight loop
			Put("|");
			for Column in 1..boardGameWidth loop
				Put( Character'Image(E(Row,Column)) & "|");
			end loop;
			Put_Line("");
		end loop;
	end Affiche_Jeu;

    -- Affiche a l'ecran le coup passe en parametre
    procedure Affiche_Coup(C : in Coup) is
		Play : Coup := C;
	begin
		Put_Line("The next play is " & Character'Image(Play.Sign) & " in column number " & Integer'Image(Play.numColumn));
	end Affiche_Coup;
   
    -- Retourne le prochain coup joue par le joueur1
    function Coup_Joueur1(E : Etat) return Coup is
		Play : Coup;
		isValid : Boolean := false;
		Row : Integer;
		Column : Integer;
	begin

		while isValid = false loop
			Put_Line("It's time for number 1 to play");
			Put_Line("Select the Row number where you want to play");

			Ada.Integer_Text_IO.Get(Column);

			if Column < 1 or Column > boardGameWidth then
				Put("The value must be between 1 and");
				Put(Integer'Image(boardGameWidth));
				Put_Line(" Please try again");
			else
				Row := 1;
				while Row < boardGameHeight+1 and E(Row, Column) /= signEmptyCase loop
					Row := Row + 1;
				end loop;  

				if Row > boardGameHeight then 
					Put_Line("This column is already full, please try again");
				elsif E(Row,Column)=signEmptyCase then
					Play := new CelluleC'(signPlayer2, Column, Row);
					isValid:=true;
				else 
					Put_Line("There is an error");	
				end if;
			end if;
		end loop;
		return Play;
	end Coup_Joueur1;

    -- Retourne le prochain coup joue par le joueur2   
    function Coup_Joueur2(E : Etat) return Coup is
	Play : Coup;
		isValid : Boolean := false;
		Row : Integer;
		Column : Integer;
	begin

		while isValid = false loop
			Put_Line("It's time for number 1 to play");
			Put_Line("Select the Row number where you want to play");

			Ada.Integer_Text_IO.Get(Column);

			if Column < 1 or Column > boardGameWidth then
				Put("The value must be between 1 and ");
				Put(Integer'Image(boardGameWidth));
				Put_Line("Please try again");
			else
				Row := 1;
				while Row < boardGameHeight+1 and E(Row, Column) /= signEmptyCase loop
					Row := Row + 1;
				end loop;  

				if Row > boardGameHeight then 
					Put_Line("This column is already full, please try again");
				elsif E(Row,Column)=signEmptyCase then
					Play := new CelluleC'(signPlayer1, Column, Row);
					isValid:=true;
				else 
					Put_Line("There is an error");	
				end if;
			end if;
		end loop;
		return Play;
	end Coup_Joueur2;

	--procedure Initialiser(E:in out Etat, Etp : in out EtatTopPion) is 
	procedure Initialiser(E : in out Etat) is
		Row : Integer :=1;
		Column : Integer :=1;
	begin
		for Column in 1..boardGameWidth loop
			--Etp(Row)=0;
			for Row in 1..boardGameHeight loop
				E(Row,Column):= signEmptyCase;
			end loop;
		end loop;

	end Initialiser;

	function Coups_Possibles(E : Etat; J : Joueur) return Liste_Coups.Liste is
		Row : Integer:=1;
		Column : Integer:=1;
		L : Liste_Coups.Liste;
		Sign : Character;
		CoupPossible : Coup;
	begin
		for Column in 1..boardGameWidth loop
				while Row < boardGameHeight+1 and E(Row, Column) /= signEmptyCase loop
					Row := Row + 1;
				end loop;
				if Row < boardGameHeight + 1 then
					if J = Joueur1 then
						Sign := signPlayer1;
					else 
						Sign := signPlayer2;
					end if;
					CoupPossible := new CelluleC'(Sign, Row, Column);
					Liste_Coups.Insere_Tete(CoupPossible, L);
				else 
					Put("The column ");
					Put(Integer'Image(Column));
					Put(" is full");
				end if;
				
		end loop;
		return L;
	end Coups_Possibles;

	--function Eval ( E : Etat ) return Integer is 
	--begin	
	--end Eval;


end puissance4;
