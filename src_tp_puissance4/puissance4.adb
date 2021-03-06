with Participant; use Participant;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;

package body puissance4 is 

	-- Calcule l'etat suivant en appliquant le coup
    function Etat_Suivant(E : Etat; C : Coup) return Etat is
		Column: Integer;
		Row : Integer;
		EtatCourant : Etat := E;
	begin
		Column := C.numColumn;
		Row := C.numRow;
		EtatCourant(Column, Row) := C.Sign;
		return EtatCourant;
	end Etat_Suivant;

    -- Indique si l'etat courant est gagnant pour le joueur J
    function Est_Gagnant(E : Etat; J : Joueur) return Boolean is 
		-- Pour parcourir les lignes du plateau de jeu
		Column: Integer:=1;
		-- Pour parcourir les lignes quand il faudra voir s'il y a un Est_Gagnant en diagonale
		ColumnDiag : Integer:=1;
		-- Pour parcourir les colonnes du plateau de jeu
		Row : Integer:=1;
		-- Pour parcourir les colonnes quand il faudra voir s'il y a un Est_Gagnant en diagonale
		RowDiag : Integer:=1 ;
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
		for Row in 1..boardGameWidth loop
			num_checkers_aligned := 0;
			-- on ne va parcourir le plateau dans le sens vertical du pion 1 au pion 7-4+1= 4 car cela suffit à atteindre toutes les pièces du plateau
			for Column in 1..boardGameWidth loop
				-- si le signe correspond à celui du joueur J, on incrémente le nombre de pièces
				if E(Column, Row)= sign then
					num_checkers_aligned := num_checkers_aligned + 1;
				end if;
				-- si le nombre de pièce est égal à aux nombres de pièces pour gagner la partie, on retourne vrai
				if num_checkers_aligned = nbCheckersToWin then
					return true;
				end if;
				-- si le signe ne correspond pas à celui du joueur J, on remet là valeur de num_checkers_aligned à 0
				if E(Column, Row) /= sign then
					num_checkers_aligned := 0;
				end if;
			end loop;
		end loop;

		-- traitement du cas d'une victoire horizontale 
		for Column in 1..boardGameWidth loop
			num_checkers_aligned := 0;
			-- on ne va parcourir le plateau dans le sens horizontal du pion 1 au pion 7-4+1= 4 car cela suffit à atteindre toutes les pièces du plateau
			for Row in 1..boardGameWidth loop
				-- on effectue la même chose que pour le traitement de la victoire verticale
				if E(Column,Row) = sign then 
					num_checkers_aligned := num_checkers_aligned + 1;
				end if;
				
				if num_checkers_aligned = nbCheckersToWin then
					return true;
				end if;
				if E(Column, Row) /= sign then
					num_checkers_aligned := 0;
				end if;
			end loop;
		end loop;

		-- traitement du cas d'une victoire via une diagonale ascendante de la gauche vers la droite
		for Column in 1..boardGameWidth-nbCheckersToWin + 1 loop
			num_checkers_aligned := 0;
			for Row in 1..boardGameWidth-nbCheckersToWin + 1 loop
				if E(Column, Row) /= sign then
					num_checkers_aligned := 0 ;
				elsif E(Column,Row) = sign then
					num_checkers_aligned := num_checkers_aligned + 1;
					RowDiag := Row;
					ColumnDiag := Column;
			
					while (num_checkers_aligned /= 0) and (RowDiag < boardGameWidth and ColumnDiag < boardGameWidth) loop -- boardGameWidth or boardGameWidth + 1 ?
						if E(ColumnDiag +1, RowDiag+1) /= sign then
							num_checkers_aligned :=0;
						elsif E(ColumnDiag + 1, RowDiag + 1) = sign then
							num_checkers_aligned := num_checkers_aligned + 1;
							ColumnDiag := ColumnDiag + 1;
							RowDiag := RowDiag + 1;
						end if;

						if num_checkers_aligned = nbCheckersToWin then
							return true;
						end if;
					end loop;

				end if;
			end loop;
		end loop;

		-- traitement du cas d'une victoire via une diagnole descendante de la gauche vers la droite
		for Row in 1..boardGameWidth-nbCheckersToWin + 1 loop
			num_checkers_aligned := 0;
			for Column in boardGameWidth-nbCheckersToWin + 1..boardGameWidth loop
				if E(Column, Row) /= sign then
					num_checkers_aligned := 0 ;
				elsif E(Column,Row) = sign then
					num_checkers_aligned := num_checkers_aligned + 1;
					RowDiag := Row;
					ColumnDiag := Column;
			
					while (num_checkers_aligned /= 0) and (RowDiag < boardGameWidth and ColumnDiag > 1) loop -- boardGameWidth or boardGameWidth + 1 ?
						if E(ColumnDiag - 1, RowDiag + 1) /= sign then
							num_checkers_aligned :=0;
						elsif E(ColumnDiag - 1, RowDiag + 1) = sign then
							num_checkers_aligned := num_checkers_aligned + 1;
							ColumnDiag := ColumnDiag - 1;
							RowDiag := RowDiag + 1;
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
		Column : Integer:=1;
		Row : Integer :=boardGameHeight;
	begin
		-- on ne va verifier que la ligne tout en haut pour economiser des operations
		-- S'il reste une case vide, retourne false, sinon retourne true
		for Column in 1..boardGameWidth loop
			if E(Column, Row) = signEmptyCase then
				return false;
			end if;
		end loop;
		return true;
	end Est_Nul;

    -- Fonction d'affichage de l'etat courant du jeu
    procedure Affiche_Jeu(E : Etat) is
		Column : Integer:=boardGameWidth;	
		Row : Integer:=1;
	begin 
		Put_Line("");
		-- On affiche des indicateurs de colonnes
		Put("|");
		for Row in 1..boardGameWidth loop
			Put(Integer'Image(Row) & " |");
		end loop;
		Put_Line("");

		-- On parcourt le tableau pour afficher les éléments à la bonne place
		for Row in reverse 1..boardGameHeight loop
			Put("|");
			for Column in 1..boardGameWidth loop
				Put( Character'Image(E(Column,Row)) & "|");
			end loop;
			Put_Line("");
		end loop;
	end Affiche_Jeu;

    -- Affiche a l'ecran le coup passe en parametre
    procedure Affiche_Coup(C : in Coup) is
		Play : Coup := C;
	begin
		Put_Line("");
		Put_Line("---------------------------------");
		Put_Line("The next play is " & Character'Image(Play.Sign) & " in Column number " & Integer'Image(Play.numColumn));
		Put_Line("---------------------------------");
	end Affiche_Coup;
   
    -- Retourne le prochain coup joue par le joueur1
    function Coup_Joueur1(E : Etat) return Coup is
		Play : Coup;
		isValid : Boolean := false;
		Column : Integer;
		Row : Integer;
	begin

		while isValid = false loop
			-- On récupère la valeur tapée par l'utilisateur dans Row
			Ada.Integer_Text_IO.Get(Column);
			
			-- Traitement du cas où la valeur retournée est en dehors des valeurs du tableau de jeu
			if Column < 1 or Column > boardGameWidth then
				Put("The value must be between 1 and");
				Put(Integer'Image(boardGameWidth));
				Put_Line(" Please try again");

			else
				Row := 1;
				-- On parcours les lignes pour arriver à l'endroit où il y a une case vide
				while Row < boardGameWidth and E(Column, Row) /= signEmptyCase loop
					Row := Row + 1;
				end loop;  
				-- Si on est à la dernière ligne ou plus, on renvoie un message d'erreur
				if Row > boardGameHeight then 
					Put_Line("This Column is already full, please try again");
				elsif E(Column,Row)=signEmptyCase then
					Play := new CelluleC'(signPlayer1, Column, Row);
					isValid:=true;
				else 
					Put_Line("This Column is not available, please try again");	
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
		Column : Integer;
		Row : Integer;
	begin

		while isValid = false loop
			-- On récupère la valeur tapée par l'utilisateur dans Row
			Ada.Integer_Text_IO.Get(Column);
			-- Traitement du cas où la valeur retournée est en dehors des valeurs du tableau de jeu
			if Column < 1 or Column > boardGameWidth then
				Put("The value must be between 1 and");
				Put(Integer'Image(boardGameWidth));
				Put_Line(" Please try again");

			else
				Row := 1;
				-- On parcours les lignes pour arriver à l'endroit où il y a une case vide
				while Row < boardGameWidth and E(Column, Row) /= signEmptyCase loop
					Row := Row + 1;
				end loop;  
				-- Si on est à la dernière ligne ou plus, on renvoie un message d'erreur
				if Row > boardGameHeight then 
					Put_Line("This Column is already full, please try again");
				elsif E(Column,Row)=signEmptyCase then
					Play := new CelluleC'(signPlayer2, Column, Row);
					isValid:=true;
				else 
					Put_Line("This Column is not available, please try again");	
				end if;
			end if;
		end loop;

		return Play;
	end Coup_Joueur2;

	procedure Initialiser(E : in out Etat) is
		Column : Integer :=1;
		Row : Integer :=1;
	begin
		for Row in 1..boardGameHeight loop
			--Etp(Column)=0;
			for Column in 1..boardGameWidth loop
				E(Column,Row):= signEmptyCase;
			end loop;
		end loop;

	end Initialiser;
	
	function Coups_Possibles(E : Etat; J : Joueur) return Liste_Coups.Liste is
		Column : Integer:=1;
		Row : Integer;
		L : Liste_Coups.Liste;
		Sign : Character;
		CoupPossible : Coup;
		Cpt : Integer:=0;
	begin
		for Column in reverse 1..boardGameWidth loop
				Row := 1;
				while Row < boardGameHeight and Row>0 and E(Column, Row) /= signEmptyCase loop
					Row := Row + 1;
				end loop;	
				--Put(" On est a la ligne ");Put(Row); Put_Line("");
				if Column < boardGameWidth + 1 and E(Column,Row)=signEmptyCase then
					if J = Joueur1 then
						Sign := signPlayer1;
					else 
						Sign := signPlayer2;
					end if;
					CoupPossible := new CelluleC'(Sign, Column, Row);
					Liste_Coups.Insere_Tete(CoupPossible, L);
					--Put(" Le coup est "); Put(Sign); Put(" "); Put(Column); Put(" "); Put(Row); Put_Line("");
				--else
				--	Put("The column "); Put(Column); Put_Line(" is full");
				end if;
		end loop;
		return L;
	end Coups_Possibles;

	function Eval (E : Etat) return Integer is 
		-- Pour parcourir les lignes du plateau de jeu
		Column: Integer:=1;
		
		-- Pour parcourir les lignes quand il faudra voir s'il y a un Est_Gagnant en diagonale
		ColumnDiag : Integer:=1;
		-- Pour parcourir les colonnes du plateau de jeu
		Row : Integer:=1;
		-- Pour parcourir les colonnes quand il faudra voir s'il y a un Est_Gagnant en diagonale
		RowDiag : Integer:=1 ;
		-- Pour parcourir les colonnes pour compter le nombre de pions
		RowHori : Integer :=1;
		-- Compteur pour voir combien il y a de pions alignes a la suite 
		num_checkers_aligned1 : Integer:=0;
		num_checkers_aligned2 : Integer:=0;
		num_empty_case : Integer := 0;
		Max_num_checkers_aligned1 : Integer := 0;
		Max_num_checkers_aligned2 : Integer := 0;
		-- Permet de compter le nombre de checkers pour chaque joueur dans l'état courant		
		nbcheckers1 : Integer := 0; 
		nbcheckers2 : Integer := 0;
		--Permet de stocker la difference entre Max_num_checkers_aligned1 et Max_..2
		diff : Integer := 0;
		-- Retourne la valeur du cout de l'evaluation
		cout : Integer := 0;
		-- Boolean pour l'etude horizontale pour voir s'il y a eu un enchainement pion joueur1 - pion joueur2
		isChanged : Boolean := false;
		
	begin	
			-- On a supose dans moteur_jeu que l'ordinateur etait le joueur 1 donc il joue des coups de signes signPlayer1
			-- traitement du cas d'une victoire verticale
			-- on parcourt toutes les colonnes
			for Column in 1..boardGameWidth loop
				Row := 1;
				while E(Column,Row) /= signEmptyCase and Row < boardGameHeight loop
					Row := Row + 1;
				end loop;	
				--Put_Line(" hey ");
				--Put("Row = "); Put(Row); Put_Line(" ");
				if Row /= 1 then	
					Row := Row-1;
				end if;
				
				-- si le signe correspond à celui du joueur J, on incrémente le nombre de pièces alignées de joueur 1
				if E(Column, Row)= signPlayer1 then
					--Put_Line("hahahaha");
					if Column>1 then
					num_checkers_aligned1 := num_checkers_aligned1 +1;
					end if;
				
					while E(Column, Row) = signPlayer1 and Row > 1 loop
						num_checkers_aligned1 := num_checkers_aligned1 + 1;
						Row := Row-1;
					end loop;
					--Put("Nouveau Row via joueur 1 = "); Put(Row); Put_Line(" ");
				-- si le signe correspond à celui du joueur J, on incrémente le nombre de pièces alignées de joueur 2
				elsif E(Column, Row)= signPlayer2 then
					num_checkers_aligned2 := num_checkers_aligned2 + 1;
					while E(Column, Row) = signPlayer2 and Row > 1 loop
						num_checkers_aligned2 := num_checkers_aligned2 + 1;
						Row := Row -1;
					end loop;
					--Put("Nouveau Row via joueur 2 = "); Put(Row); Put_Line(" ");
				end if;

				-- On stocke les valeurs max du joueur 1 et joueur 2
				Max_num_checkers_aligned1 := Integer'Max (Max_num_checkers_aligned1, num_checkers_aligned1);
				Max_num_checkers_aligned2 := Integer'Max (Max_num_checkers_aligned2, num_checkers_aligned2);
				num_checkers_aligned1 := 0;
				num_checkers_aligned2 := 0;	
		end loop;

		-- traitement du cas d'une victoire horizontale
		for Row in 1..boardGameHeight loop
				for Column in 1..boardGameWidth loop
					
					if E(Column,Row) = signEmptyCase then
						num_empty_case := num_empty_case + 1;
					elsif E(Column,Row) = signPlayer1 and isChanged=false then 
						num_checkers_aligned1 := num_checkers_aligned1 + 1;
					elsif E(Column, Row) = signPlayer2 and isChanged=false then
						num_checkers_aligned2 := num_checkers_aligned2 + 1;

						if num_checkers_aligned1+num_empty_case >= nbCheckersToWin then 
							Max_num_checkers_aligned1 := Integer'Max (Max_num_checkers_aligned1, num_checkers_aligned1);
							num_checkers_aligned1 := 0;
							num_empty_case := 0;
						else
							num_checkers_aligned1 := 0;
							num_empty_case := 0;
						end if;	
						isChanged := true;

					elsif E(Column,Row) = signPlayer1 and isChanged=true then 
						num_checkers_aligned1 := num_checkers_aligned1 + 1;
						if num_checkers_aligned2+num_empty_case >= nbCheckersToWin then 
							Max_num_checkers_aligned2 := Integer'Max (Max_num_checkers_aligned2, num_checkers_aligned2);
							num_checkers_aligned2 := 0;
							num_empty_case := 0;
						else
							num_checkers_aligned2 := 0;
							num_empty_case := 0;
						end if;	
						isChanged := false;
					elsif E(Column, Row) = signPlayer2 and isChanged=true then
						num_checkers_aligned2 := num_checkers_aligned2 + 1;
					end if;
				end loop;
			--end if;
		end loop;

		if Max_num_checkers_aligned1 = 0 then
			Max_num_checkers_aligned1 := 1;
		end if;
--traitement du cas d'une diagonale ascendante de la gauche vers la droite
		num_checkers_aligned1 := 0;
		num_checkers_aligned2 := 0;
		num_empty_case := 0;
		Row := 1;
		Column := 1;
		--On parcourt le petit plateau de taille 4-4 qui va permettre d'atteindre tout les pions qui permettent de gagner via une diagonale ascendante
		for Row in 1..(boardGameHeight-nbCheckersToWin + 1) loop
		    for Column in 1..(boardGameWidth-nbCheckersToWin + 1) loop	
				-- Si la case est vide 	et que la prochaine case de la diagonale est un pion du joueur 2
				if (E(Column, Row) = signPlayer2) or (E(Column, Row) = signEmptyCase and E(Column+1, Row+1)=signPlayer2) then
					if E(Column, Row) = signEmptyCase then 
						num_empty_case:= num_empty_case+1;
					elsif E(Column,Row) = signPlayer2 then
						num_checkers_aligned2 := num_checkers_aligned2 + 1;
					end if;
					RowDiag := Row + 1;
					ColumnDiag := Column + 1;
					while (E(ColumnDiag, RowDiag) = signPlayer2 or E(ColumnDiag, RowDiag) = signEmptyCase) and (RowDiag < Row + nbCheckersToWin -1) 
					and (ColumnDiag < Column + nbCheckersToWin -1) loop
						if E(ColumnDiag, RowDiag) = signPlayer2 then
							num_checkers_aligned2 := num_checkers_aligned2 + 1;
						elsif E(ColumnDiag, RowDiag) = signEmptyCase then
							num_empty_case := num_empty_case + 1;
						end if;
						RowDiag := RowDiag + 1;
						ColumnDiag := ColumnDiag + 1;
					end loop;

					if (num_checkers_aligned2 + num_empty_case >= nbCheckersToWin) then
						Max_num_checkers_aligned2 := Integer'Max(Max_num_checkers_aligned2, num_checkers_aligned2);
						num_checkers_aligned2 := 0;
						num_empty_case := 0;
					else 		
						num_checkers_aligned2 := 0;
						num_empty_case := 0;
					end if;		
				-- Si la case est vide 	et que la prochaine case de la diagonale est un pion du joueur 1
				elsif (E(Column, Row) = signPlayer1) or (E(Column, Row) = signEmptyCase and E(Column+1, Row+1)=signPlayer1) then
					if E(Column, Row) = signEmptyCase then 
						num_empty_case:= num_empty_case+1;
					elsif E(Column,Row) = signPlayer1 then
						num_checkers_aligned1 := num_checkers_aligned1 + 1;
					end if;
					RowDiag := Row + 1;
					ColumnDiag := Column + 1;
					while (E(ColumnDiag, RowDiag) = signPlayer1 or E(ColumnDiag, RowDiag) = signEmptyCase) and (RowDiag < Row + nbCheckersToWin -1) 
					and (ColumnDiag < Column + nbCheckersToWin -1) loop
						if E(ColumnDiag, RowDiag) = signPlayer1 then
							num_checkers_aligned1 := num_checkers_aligned1 + 1;
						elsif E(ColumnDiag, RowDiag) = signEmptyCase then
							num_empty_case := num_empty_case + 1;
						end if;
						RowDiag := RowDiag + 1;
						ColumnDiag := ColumnDiag + 1;
					end loop;

					if (num_checkers_aligned1 + num_empty_case >= nbCheckersToWin) then
						Max_num_checkers_aligned1 := Integer'Max(Max_num_checkers_aligned1, num_checkers_aligned1);
						num_checkers_aligned1 := 0;
						num_empty_case := 0;
					else 		
						num_checkers_aligned1 := 0;
						num_empty_case := 0;
					end if;	
				end if;
			end loop;
		end loop;

		--traitement du cas d'une diagonale descendante de la gauche vers la droite
		num_checkers_aligned1 := 0;
		num_checkers_aligned2 := 0;
		num_empty_case := 0;
		Row := 1;
		Column := 1;
		--On parcourt le petit plateau de taille 4-4 en haut à gauche qui va permettre d'atteindre tout les pions qui permettent de gagner via une diagonale ascendante
		for Row in (boardGameHeight-nbCheckersToWin + 1)..boardGameHeight loop
		    for Column in 1..(boardGameWidth-nbCheckersToWin + 1) loop	
				-- Si la case est vide 	et que la prochaine case de la diagonale est un pion du joueur 2
				if (E(Column, Row) = signPlayer2) or (E(Column, Row) = signEmptyCase and E(Column+1, Row-1)=signPlayer2) then
					if E(Column, Row) = signEmptyCase then 
						num_empty_case:= num_empty_case+1;
					elsif E(Column,Row) = signPlayer2 then
						num_checkers_aligned2 := num_checkers_aligned2 + 1;
					end if;
					RowDiag := Row - 1;
					ColumnDiag := Column + 1;
					while (E(ColumnDiag, RowDiag) = signPlayer2 or E(ColumnDiag, RowDiag) = signEmptyCase) and (ColumnDiag < Column + nbCheckersToWin -1) loop
						if E(ColumnDiag, RowDiag) = signPlayer2 then
							num_checkers_aligned2 := num_checkers_aligned2 + 1;
						elsif E(ColumnDiag, RowDiag) = signEmptyCase then
							num_empty_case := num_empty_case + 1;
						end if;
						RowDiag := RowDiag - 1;
						ColumnDiag := ColumnDiag + 1;
					end loop;

					if (num_checkers_aligned2 + num_empty_case >= nbCheckersToWin) then
						Max_num_checkers_aligned2 := Integer'Max(Max_num_checkers_aligned2, num_checkers_aligned2);
						num_checkers_aligned2 := 0;
						num_empty_case := 0;
					else 		
						num_checkers_aligned2 := 0;
						num_empty_case := 0;
					end if;		
				-- Si la case est vide 	et que la prochaine case de la diagonale est un pion du joueur 1
				elsif (E(Column, Row) = signPlayer1) or (E(Column, Row) = signEmptyCase and E(Column+1, Row-1)=signPlayer1) then
					if E(Column, Row) = signEmptyCase then 
						num_empty_case:= num_empty_case+1;
					elsif E(Column,Row) = signPlayer1 then
						num_checkers_aligned1 := num_checkers_aligned1 + 1;
					end if;
					RowDiag := Row - 1;
					ColumnDiag := Column + 1;
					while (E(ColumnDiag, RowDiag) = signPlayer1 or E(ColumnDiag, RowDiag) = signEmptyCase) and (ColumnDiag < Column + nbCheckersToWin -1) loop
						if E(ColumnDiag, RowDiag) = signPlayer1 then
							num_checkers_aligned1 := num_checkers_aligned1 + 1;
						elsif E(ColumnDiag, RowDiag) = signEmptyCase then
							num_empty_case := num_empty_case + 1;
						end if;
						RowDiag := RowDiag - 1;
						ColumnDiag := ColumnDiag + 1;
					end loop;

					if (num_checkers_aligned1 + num_empty_case >= nbCheckersToWin ) then
						Max_num_checkers_aligned1 := Integer'Max(Max_num_checkers_aligned1, num_checkers_aligned1);
						num_checkers_aligned1 := 0;
						num_empty_case := 0;
					else 		
						num_checkers_aligned1 := 0;
						num_empty_case := 0;
					end if;		
				end if;
			end loop;
		end loop;
		
		

		--Traitement des comptes de points
		--if(Max_num_checkers_aligned1 = 4 or Max_num_checkers_aligned2 = 4) then
		--	if(Max_num_checkers_aligned1 = 4) then
		--		cout := 100;				
		--	elsif (Max_num_checkers_aligned2 = 4) then 
		--		cout := -100;	
		--	end if;
		--elsif Max_num_checkers_aligned1 = 3 or Max_num_checkers_aligned2 = 3 then
		--	if Max_num_checkers_aligned2 < Max_num_checkers_aligned1 then
		--		cout := 80;
		--	elsif Max_num_checkers_aligned2 > Max_num_checkers_aligned1 then 
		--		cout := -80;
		--	elsif Max_num_checkers_aligned2 = Max_num_checkers_aligned1 then
		--		cout := 70;
		--	end if;
		--elsif Max_num_checkers_aligned1 = 2 or Max_num_checkers_aligned2 = 2 then
		--	if Max_num_checkers_aligned2 < Max_num_checkers_aligned1 then
		--		cout := 60;
		--	elsif Max_num_checkers_aligned2 > Max_num_checkers_aligned1 then 
		--		cout := -60;
		--	elsif Max_num_checkers_aligned2 = Max_num_checkers_aligned1 then
		--		cout := 50;
		--	end if;
		--elsif Max_num_checkers_aligned1 = 1 or Max_num_checkers_aligned2 = 1 then
		--	if Max_num_checkers_aligned2 < Max_num_checkers_aligned1 then
		--		cout := 40;
		--	elsif Max_num_checkers_aligned2 > Max_num_checkers_aligned1 then 
	--			cout := -40;
		--	elsif Max_num_checkers_aligned2 = Max_num_checkers_aligned1 then
		--		cout := 30;
		--	end if;
		--elsif Max_num_checkers_aligned2 = 0 then
		--	cout := 90;
		--elsif Max_num_checkers_aligned1 = 0 then
		--	cout := -90;
		--else cout := 1;
		--end if;
		--AUTRES CAS:	 
		if (Max_num_checkers_aligned1/=4 and Max_num_checkers_aligned2/=4) then
			diff := Max_num_checkers_aligned1 - Max_num_checkers_aligned2;
			if(diff = 0) then
				for Row in 1..boardGameWidth loop
					for Column in 1..boardGameWidth loop			     
				   		if E(Column, Row)= signPlayer1 then
 							nbcheckers1 := nbcheckers1 + 1;
			     		end if;
		
					     if E(Column, Row)= signPlayer2 then
							nbcheckers2 := nbcheckers2 + 1;
					     end if; 
					end loop;
				end loop;

				if(nbcheckers1 > nbcheckers2) then
					cout := cout + 5;					
				elsif(nbcheckers2 > nbcheckers1) then
					cout := cout - 5;
				end if;
			elsif(diff>0) then
				cout := cout+ 10*diff;	
			elsif(diff<0) then
				cout := cout-10*diff;
			end if;
		end if;
		--Put(cout);Put(" "); Put(Max_num_checkers_aligned1); Put(Max_num_checkers_aligned2); Put_Line("");
		Max_num_checkers_aligned1 := 0; Max_num_checkers_aligned2:=0;
	return cout;
	end Eval;
end puissance4;
