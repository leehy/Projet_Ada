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
		-- Pour parcourir les lignes du plateau de jeu
		Row: Integer:=1;
		-- Pour parcourir les lignes quand il faudra voir s'il y a un Est_Gagnant en diagonale
		RowDiag : Integer:=1;
		-- Pour parcourir les colonnes du plateau de jeu
		Column : Integer:=1;
		-- Pour parcourir les colonnes quand il faudra voir s'il y a un Est_Gagnant en diagonale
		ColumnDiag : Integer:=1 ;
		-- Compteur pour voir combien il y a de pions alignes a la suite 
		num_checkers_aligned : Integer:=0;
		-- Assignation des signes pour les joueurs
		sign : Character;
		
		
	begin
		-- On assigne les signes aux joueurs pour pouvoir compter le nombre de signes côte à côte
		if J = Joueur1 then
			sign := signPlayer1;
		else 
			sign := signPlayer2;
		end if; 

		-- traitement du cas d'une victoire verticale
		-- on parcourt le plateau entier
		for Column in 1..boardGameWidth loop
			num_checkers_aligned := 0;
			-- on ne va parcourir le plateau dans le sens vertical du pion 1 au pion 7-4+1= 4 car cela suffit à atteindre toutes les pièces du plateau
			for Row in 1..boardGameHeight loop
				-- si le signe correspond à celui du joueur J, on incrémente le nombre de pièces
				if E(Row, Column)= sign then
					num_checkers_aligned := num_checkers_aligned + 1;
				end if;
				-- si le nombre de pièce est égal à aux nombres de pièces pour gagner la partie, on retourne vrai
				if num_checkers_aligned = nbCheckersToWin then
					return true;
				end if;
				-- si le signe ne correspond pas à celui du joueur J, on remet là valeur de num_checkers_aligned à 0
				if E(Row, Column) /= sign then
					num_checkers_aligned := 0;
				end if;
			end loop;
		end loop;

		-- traitement du cas d'une victoire horizontale 
		for Row in 1..boardGameHeight loop
			num_checkers_aligned := 0;
			-- on ne va parcourir le plateau dans le sens horizontal du pion 1 au pion 7-4+1= 4 car cela suffit à atteindre toutes les pièces du plateau
			for Column in 1..boardGameWidth loop
				-- on effectue la même chose que pour le traitement de la victoire verticale
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
		Row : Integer:=boardGameHeight;
		Column : Integer :=1;
	begin
		-- on ne va verifier que la ligne tout en haut pour economiser des operations
		-- S'il reste une case vide, retourne false, sinon retourne true
		for Column in 1..boardGameWidth loop
			if E(Row, Column) = signEmptyCase then
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
		-- On affiche des indicateurs de colonnes
		Put("|");
		for Column in 1..boardGameWidth loop
			Put(Integer'Image(Column) & " |");
		end loop;
		Put_Line("");

		-- On parcourt le tableau pour afficher les éléments à la bonne place
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
		--Type ArrayOfCheckers is array(1..boardGameWidth) of Integer ;
		--CheckersFull : ArrayOfCheckers ;
		--IndexArray : Integer;
	begin

		--for IndexArray in 1..boardGameWidth loop
		--	CheckersFull(IndexArray) := 0;
		--end loop;

		while isValid = false loop
			Put_Line("It's time for number 1 to play");
			Put_Line("Select the Row number where you want to play");

			-- On récupère la valeur tapée par l'utilisateur dans column
			
			Ada.Integer_Text_IO.Get(Column);
			
			
			-- Traitement du cas où la valeur retournée est en dehors des valeurs du tableau de jeu
			if Column < 1 or Column > boardGameWidth then
				Put("The value must be between 1 and");
				Put(Integer'Image(boardGameWidth));
				Put_Line(" Please try again");

			else
				Row := 1;
				-- On parcours les lignes pour arriver à l'endroit où il y a une case vide
				while Row < boardGameHeight and E(Row, Column) /= signEmptyCase loop
					Row := Row + 1;
				end loop;  
				--if Row = boardGameHeight+1 then
				--	Put_Line("teeestcamerereefss");
				--end if;
				-- Si on est à la dernière ligne ou plus, on renvoie un message d'erreur
				-- ne marche pas car il y a un raised constraint error
				if Row > boardGameHeight then 
					Put_Line("This column is already full, please try again");
				elsif E(Row,Column)=signEmptyCase then
					Play := new CelluleC'(signPlayer1, Column, Row);
					isValid:=true;
				else 
					Put_Line("This column is not available, please try again");	
				end if;
			end if;
		end loop;

		return Play;
	end Coup_Joueur1;

    -- Retourne le prochain coup joue par le joueur2   
	-- La même chose que pour joueur 1
    function Coup_Joueur2(E : Etat) return Coup is
		Play : Coup;
		isValid : Boolean := false;
		Row : Integer;
		Column : Integer;
		--Type ArrayOfCheckers is array(1..boardGameWidth) of Integer ;
		--CheckersFull : ArrayOfCheckers ;
		--IndexArray : Integer;
	begin

		--for IndexArray in 1..boardGameWidth loop
		--	CheckersFull(IndexArray) := 0;
		--end loop;

		while isValid = false loop
			Put_Line("It's time for number 2 to play");
			Put_Line("Select the Row number where you want to play");

			-- On récupère la valeur tapée par l'utilisateur dans column
			
			Ada.Integer_Text_IO.Get(Column);
			
			
			-- Traitement du cas où la valeur retournée est en dehors des valeurs du tableau de jeu
			if Column < 1 or Column > boardGameWidth then
				Put("The value must be between 1 and");
				Put(Integer'Image(boardGameWidth));
				Put_Line(" Please try again");

			else
				Row := 1;
				-- On parcours les lignes pour arriver à l'endroit où il y a une case vide
				while Row < boardGameHeight and E(Row, Column) /= signEmptyCase loop
					Row := Row + 1;
				end loop;  
				--if Row = boardGameHeight+1 then
				--	Put_Line("teeestcamerereefss");
				--end if;
				-- Si on est à la dernière ligne ou plus, on renvoie un message d'erreur
				-- ne marche pas car il y a un raised constraint error
				if Row > boardGameHeight then 
					Put_Line("This column is already full, please try again");
				elsif E(Row,Column)=signEmptyCase then
					Play := new CelluleC'(signPlayer2, Column, Row);
					isValid:=true;
				else 
					Put_Line("This column is not available, please try again");	
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

	function Eval (E : Etat) return Integer is 
		-- Pour parcourir les lignes du plateau de jeu
		Row: Integer:=1;
		
		-- Pour parcourir les lignes quand il faudra voir s'il y a un Est_Gagnant en diagonale
		RowDiag : Integer:=1;
		-- Pour parcourir les colonnes du plateau de jeu
		Column : Integer:=1;
		-- Pour parcourir les colonnes quand il faudra voir s'il y a un Est_Gagnant en diagonale
		ColumnDiag : Integer:=1 ;
		-- Pour parcourir les colonnes pour compter le nombre de pions
		ColumnHori : Integer :=1;
		-- Compteur pour voir combien il y a de pions alignes a la suite 
		num_checkers_aligned1 : Integer:=0;
		num_empty_case : Integer := 0;
		Max_num_checkers_aligned1 : Integer := 0;
		
	begin	
		-- On a suposse dans moteur_jeu que l'ordinateur etait le joueur 1 donc il joue des coups de signes signPlayer1
		-- traitement du cas d'une victoire verticale
		-- on parcourt toutes les colonnes
		for Column in 1..boardGameWidth loop
			while E(Row,Column) /= signEmptyCase loop
				Row := Row + 1;
			end loop;
				Row := Row - 1;
				-- si le signe correspond à celui du joueur J, on incrémente le nombre de pièces
				if E(Row, Column)= signPlayer1 and Row > 1 then
					while E(Row, Column) = signPlayer1 loop
						num_checkers_aligned1 := num_checkers_aligned1 + 1;
						Row := Row-1;
					end loop;
				--elsif E(Row, Column)= signPlayer2 then 
				--	num_checkers_aligned2 := num_checkers_aligned2 + 1;
				
				-- si le signe ne correspond pas à celui du joueur J, on remet là valeur de num_checkers_aligned à 0
				elsif E(Row, Column) /= signPlayer1 then
					Max_num_checkers_aligned1 := Integer'Max (Max_num_checkers_aligned1, num_checkers_aligned1);
					num_checkers_aligned1 := 0;
				end if;
		end loop;

		-- traitement du cas d'une victoire horizontale

		for Row in 1..boardGameHeight loop
			-- Si le joueur 2 a un pion sur la colonne 4, il n'y peut pas avoir de situation avantageuse pour l'ordinateur : on passe à la ligne suivante
			if E(Row,boardGameWidth-nbCheckersToWin+1)= signPlayer2 then
				num_checkers_aligned1 := 0;
			else
				num_checkers_aligned1 := 0;
				-- on ne va parcourir le plateau dans le sens horizontal du pion 1 au pion 7-4+1= 4 car cela suffit à atteindre toutes les pièces du plateau
				for Column in 1..boardGameWidth loop
					
					if E(Row,Column) = signEmptyCase then
						num_empty_case := num_empty_case + 1;
					elsif E(Row,Column) = signPlayer1 then 
						num_checkers_aligned1 := num_checkers_aligned1 + 1;
					elsif E(Row, Column) = signPlayer2 then
						if num_checkers_aligned1+num_empty_case >= nbCheckersToWin then 
							Max_num_checkers_aligned1 := Integer'Max (Max_num_checkers_aligned1, num_checkers_aligned1);
							num_checkers_aligned1 := 0;
							num_empty_case := 0;
						else
							num_checkers_aligned1 := 0;
							num_empty_case := 0;
						end if;		
					end if;

				end loop;
			end if;
		end loop;
		-- Code Samuel



		--COde samuel
		return Max_num_checkers_aligned1;
	end Eval;



end puissance4;
