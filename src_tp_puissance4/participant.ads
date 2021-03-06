
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;

package Participant is
   
    type Joueur is (Joueur1, Joueur2);
   
    -- Retourne l'adversaire du joueur passé en paramètre
    function Adversaire(J : Joueur) return Joueur;
      
end Participant;
