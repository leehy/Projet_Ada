
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;

package body Participant is
   
    -- Retourne l'adversaire du joueur passé en paramètre
    function Adversaire(J : Joueur) return Joueur is
	begin
		if J = Joueur1 then
			return Joueur2;
		elsif J= Joueur2 then
			return Joueur1;
		else
			Put("Il y a eu une erreur dans le choix des joueurs");
			return Joueur1;
		end if;
	end Adversaire;
      
end Participant;
