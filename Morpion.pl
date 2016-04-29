% On définit les  cases à vide
:-dynamic case/3.

case(1,1,' - ').
case(1,2,' - ').
case(1,3,' - ').
case(2,1,' - ').
case(2,2,' - ').
case(2,3,' - ').
case(3,1,' - ').
case(3,2,' - ').
case(3,3,' - ').

% On définit le joueur courant (initialement le joueur 1)
:-dynamic joueur/2.

joueur('Joueur 1', ' X ').

% On définit la fin du match en 1 (initialement à 0)
:-dynamic fin/1.

fin(0).

/* Permet d'afficher une case */

% Cette case permet de délimiter les lignes des colonnes
afficherCase(0,0):-nl,write('   ').
% Ces cases permettent d'affiche les numéros des colonnes
afficherCase(0,Y):-Y>0,write(' '),write(Y),write(' ').
% Cette case permettent d'afficher les numéros des lignes
afficherCase(X,0):-X>0,write(' '),write(X),write(' ').
% Ces cases permettent d'afficher le contenue d'une case
afficherCase(X,Y):-X>0,Y>0,case(X,Y,R),writef(R).

/* Permet d'affiche la grille */

% Affiche les cases
afficherGrille(X,Y):-X=<3,Y<3,afficherCase(X,Y),Y1 is Y+1,afficherGrille(X,Y1).
% Affiche la dernière case d'une ligne et passe à la ligne suivante
afficherGrille(X,3):-X=<3,afficherCase(X,3),nl,X1 is X+1,afficherGrille(X1,0).
% Affiche la premier case [0,0]
afficherGrille:-afficherGrille(0,0).
% Fin de l'affichage de la grille
afficherGrille(4,0).

% Si la case est déja prise, on relance la fonction "poser"
caseNonLibre(X,Y):-case(X,Y,P),P\=' - ',nl,write('Cette case est déja prise...'),nl,poser.

% Lorqu'on pose un pion, on vérifie que le match est finit ou non
poserPion(X,Y):-joueur(_,P),retract(case(X,Y,_)),assert(case(X,Y,P)),finMatch.

/* Permet de poser un pion */

% Si la case est libre
poser:-joueur(J,_),nl,write(J),write(' doit poser un pion !'),nl,write('Ligne : '),nl,nl,read(L),nl,write('Colonne : '),nl,read(C),not(caseNonLibre(L,C)),poserPion(L,C).
% Si la case n'est pas libre
poser:-joueur(J,_),nl,write(J),write(' doit poser un pion !'),nl,write('Ligne : '),nl,read(L),nl,write('Colonne : '),nl,read(C),caseNonLibre(L,C).

/* Permet de changer de joueur */

% Joueur 1 devient Joueur 2
changerJoueur:-joueur(J,P),J=='Joueur 1',P==' X ',retract(joueur('Joueur 1',' X ')),assert(joueur('Joueur 2',' O ')),nl,write('Changement du joueur'),nl.
% Joueur 2 devient Joueur 1
changerJoueur:-joueur(J,P),J=='Joueur 2',P==' O ',retract(joueur('Joueur 2',' O ')),assert(joueur('Joueur 1',' X ')),nl,write('Changement du joueur'),nl.

% Fin du match
fin:-joueur(J,_),write(J),write(' Gagne !').

/* Permet de vérifier si le match est finit */

% diagonale Haut-Gauche -> Bas-Droite
finMatch:-case(1,1,P1),case(2,2,P2),case(3,3,P3),P1\=' - ',P2\=' - ',P3\=' - ',P1==P2,P1==P3,P2==P3,retract(fin(0)),assert(fin(1)),fin.
% Diagonale Haut-Droite -> Bas-Gauche
finMatch:-case(1,3,P1),case(2,2,P2),case(3,1,P3),P1\=' - ',P2\=' - ',P3\=' - ',P1==P2,P1==P3,P2==P3,retract(fin(0)),assert(fin(1)),fin.
% Ligne 1
finMatch:-case(1,1,P1),case(1,2,P2),case(1,3,P3),P1\=' - ',P2\=' - ',P3\=' - ',P1==P2,P1==P3,P2==P3,retract(fin(0)),assert(fin(1)),fin.
% Ligne 2
finMatch:-case(2,1,P1),case(2,2,P2),case(2,3,P3),P1\=' - ',P2\=' - ',P3\=' - ',P1==P2,P1==P3,P2==P3,retract(fin(0)),assert(fin(1)),fin.
% Ligne 3
finMatch:-case(3,1,P1),case(3,2,P2),case(3,3,P3),P1\=' - ',P2\=' - ',P3\=' - ',P1==P2,P1==P3,P2==P3,retract(fin(0)),assert(fin(1)),fin.
% Colonne 1
finMatch:-case(1,1,P1),case(2,1,P2),case(3,1,P3),P1\=' - ',P2\=' - ',P3\=' - ',P1==P2,P1==P3,P2==P3,retract(fin(0)),assert(fin(1)),fin.
% Colonne 2
finMatch:-case(1,2,P1),case(2,2,P2),case(3,2,P3),P1\=' - ',P2\=' - ',P3\=' - ',P1==P2,P1==P3,P2==P3,retract(fin(0)),assert(fin(1)),fin.
% Colonne 3
finMatch:-case(1,3,P1),case(2,3,P2),case(3,3,P3),P1\=' - ',P2\=' - ',P3\=' - ',P1==P2,P1==P3,P2==P3,retract(fin(0)),assert(fin(1)),fin.
% Le match n'est pas finit
finMatch:-changerJoueur,jouer.

/* Permet de jouer */

% Si la partie n'est pas finit, on affiche la grille et on pose un pion
jouer:-fin(0),afficherGrille,poser.
% Si la partie est finit, on affiche le gagnant
jouer:-fin(1),joueur(J,_),write(J),write(' Gagne !').
