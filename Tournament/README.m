% Regeln fuer die Spieler-Programme:
%
% - Spielregeln fuer Othello: http://de.wikipedia.org/wiki/Othello_(Spiel)
%
% - reine Matlab-Implementierung (kein C/C++, Java, Fortran etc., auch
% keine Teile des Programms), d.h. m-Dateien.  Erlaubt ist die
% Benutzung von mat-Dateien, um Konfigurations-Daten einzulesen bzw. zu
% speichern.
%
% - das Programm muss alle Berechnungen im selben Matlab-Prozess
% durchfuehren.  Insbesondere sind nicht erlaubt:
%  * Erzeugen weiterer Prozesse
%  * Aufbau von Netzwerkverbindungen zu anderen Programmen
%  * etc.
%
% - falls das Programm aus mehreren Dateien (m-Funktionen bzw.
% Daten-Dateien) besteht, dann muessen diese weiteren Dateien (mit Ausnahme
% der Hauptfunktion) in einem gemeinsamen Unterverzeichnis mit demselben
% Namen wie das Hauptprogramm abgelegt werden.
%
% - die Gesamtgroesse aller Dateien des Programms darf 2 MB nicht
% ueberschreiten.
%
% - Zum Loesen des Spiels soll der Minimax-Algorithmus oder eine Variante
% davon implementiert werden.
% http://de.wikipedia.org/wiki/Minimax-Algorithmus
%
% - Jeder Spieler hat ein Zeitbudget von 180 Sekunden. Dieses Zeitbudget
% von 180 Sekunden bezieht sich auf alle Zuege eines Spielers. Das bedeutet,
% dass z.B. fuer den ersten Zug eine Rechenzeit von 10 s verwendet werden
% kann und fuer die restlichen Zuege entsprechend nur noch 170 s uebrig
% bleiben. Jeder Spieler hat 180 s Zeit. Ein Spiel kann  also maximal 6
% Minuten dauern.
%
% - Beispiel zum Aufruf des Turnier-Servers:
% tournament_main('time_budget',180,'games_per_pair',2)
