package body Participant is
   
    -- Retourne l'adversaire du joueur passé en paramètre
    function Adversaire(J : Joueur) return Joueur is
	begin
		if J = Joueur1 then
			return J2;
		elsif J= Joueur2 then
			return J1;
		else
			Put("Il y a eu une erreur dans le choix des joueurs");
			return Joueur1;
		end if;
	end Adversaire;
      
end Participant;
