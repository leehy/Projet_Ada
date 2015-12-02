--test_listes_daltons.adb
---------------------------------------------------------------

with Ada.Text_Io;
use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Unchecked_Deallocation;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Liste_Generique;

procedure Test_Liste_Daltons is

   ------------  GENERICITÉ : instanciation avec les daltons ------------

   type Taille_Dalton is (Petit, Moyen, Bete);

   type Dalton is record
      Nom : Unbounded_String;
      Taille :Taille_Dalton;
   end record;

   -- affiche un dalton

   procedure Affiche_Dalton (D : Dalton )is
   begin
      Put("("& To_String(D.Nom) & "," & Taille_Dalton'Image(D.Taille) & ")");
   end Affiche_Dalton;


   package Liste_Dalton is new Liste_Generique ( Dalton, Affiche_Dalton );
   use Liste_Dalton;

   Joe : constant Dalton := ( To_Unbounded_String ("joe"), Petit );
   Jack : constant Dalton := ( To_Unbounded_String ("jack"), Moyen );
   Averell : constant Dalton := ( To_Unbounded_String ("averell"), Bete);

   Les_Daltons : Liste := Creer_Liste;
   Ite_Daltons : Iterateur;

begin
   Insere_Tete( Joe , Les_Daltons);
   Insere_Tete( Jack , Les_Daltons);
   Insere_Tete( Averell , Les_Daltons);

   Affiche_Dalton(Joe);
   Put_Line("liste initiale : ");
   Affiche_Liste(Les_Daltons);
   Put_Line("on va vider cette liste : " );
   Libere_Liste( Les_Daltons);
   Affiche_Liste(Les_Daltons);

   Insere_Tete( Joe , Les_Daltons);
   Insere_Tete( Jack , Les_Daltons);
   Insere_Tete( Averell , Les_Daltons);

   Put_Line("liste n°2 : ");
   Affiche_Liste(Les_Daltons);

   Ite_Daltons := Creer_Iterateur(Les_Daltons);
   Put_Line ("on affiche l'élement courant de l'itérateur :");
   Affiche_Dalton( Element_Courant(Ite_Daltons));
   Suivant(Ite_Daltons);
   Put_Line ("on est passé au suivant, on affiche l'élement courant de l'itérateur :");
    Affiche_Dalton(Element_Courant(Ite_Daltons));
    Put_Line ("on vérifie s'il reste un élement apres :");
    if A_Suivant( Ite_Daltons) then Put_Line("il reste un element");
    else Put_Line("il n'y a plus d'élément");
    end if;


    Put_Line(" on passe au dernier élément de la liste");
    Suivant(Ite_Daltons);
    Put_Line ("on est passé au derbier élément, on teste s'il reste un élément reponse attendue : false :");
    if  A_Suivant(Ite_Daltons) then Put_Line ("true");
    else Put_Line("false");
    end if;


end Test_Liste_Daltons;
