function returnField = ChuckNossek(aktFeld, color, time)
%IN: aktuelles Feld, Farbe, Restzeit
%OUT: Spielfeld
%Allgemeine Schreibweise: alpha_beta fï¿½r Funktionen und alphaBeta fï¿½r
%Variablen


addpath(['players' filesep 'ChuckNossek']);
depth = 6;
endGame = 0;
%Anzahl der gesetzten Steine ermitteln
stonesCount = sum(aktFeld(:) ~= 0);
nextMoves = next_moves(aktFeld, color);

%Abfrage nach Zugmglichkeiten als erstes 
if numel(nextMoves(:)) == 0 %Fall1: Kein Zug 
    returnField = aktFeld;
    return
elseif numel(nextMoves(:)) == 64   %Fall2: Exakt ein Zug 
    returnField = (nextMoves);
    return
end

%Anfangsphase
if stonesCount <= 13
    returnField = datenzugriff(aktFeld);
    if ~isempty(returnField)
%         rmpath(['players' filesep 'SpielerC']); 
        return;
    end
end

%MitteEnde vertiefen wenn möglich
if stonesCount <53 && stonesCount >44 && time > 60
    %disp('Tiefe 8');
    depth = 8;
end


%%Beschleunigen falls nötig
if time < 50
    depth = 4;
end

%Endphase
if stonesCount >= 53
    %disp('Endgame Start');
    endGame = 1;
    depth = 12;
end

%Notbremse
if time < 10 
	depth = 2;
end
	
if time < 4
    returnField = nextMoves(:,:,1);
    return
end

returnField = alpha_beta_first(nextMoves, color, depth, endGame);

% rmpath(['players' filesep 'SpielerC']);     
end

%##########################################################################
function [move] = alpha_beta_first(nextMoves, colour, depth, endGame)
    %IN: aktuelles Feld, Farbe, Suchtiefe OUT: zu spielendes Feld (im int8
    %Format) Funktion wird als erstes vom Spieler aufgerufen.

    %Initialisierung
    points = -Inf;
    alpha = -Inf;
    beta = Inf;

    act_depth = 0;

    possibleMoves = numel(nextMoves) / 64;

    for index = 1:possibleMoves
        actPoints = minValue_AlphaBeta(nextMoves(:,:,index), colour*(-1), depth - 1, alpha, beta, endGame, act_depth + 1);

        if actPoints >=points
            points = actPoints;
            move = nextMoves(:,:,index);
        end

    end %For
end

%##########################################################################
function [points, alpha, beta] = maxValue_AlphaBeta(field, colour, depth, alpha, beta, endGame, act_depth)



%Falls wir an einem Blatt angelangt sind wird nur bewertet sonst nix!
if depth == 0
    points = bewerten(field, colour, endGame);
    return
end

nextMoves = next_moves(field, colour);
localAlpha = -inf; 
possibleMoves = numel(nextMoves)/64;

if possibleMoves == 0
    stonesCount = sum(field(:) ~= 0);
    if stonesCount == 64
        points = bewerten(field, colour, endGame);
        return
    end
end 
    

if (act_depth == 4) &&(endGame == 0) && ~isempty(nextMoves)
   nextMoves = MultiProbCut(nextMoves, colour, endGame, -20); 
   possibleMoves = numel(nextMoves)/64;
end

for index = 1:possibleMoves
    [actPoints alpha beta] = minValue_AlphaBeta(nextMoves(:,:,index), colour*(-1), depth-1, alpha, beta, endGame, act_depth + 1);
    
    if actPoints > localAlpha
       if actPoints > beta
           points = actPoints; 
           return
       end
       localAlpha = actPoints;
       if actPoints > alpha
           alpha = actPoints;
       end
    end
end %For
points = localAlpha; 

end%Funct.

%##########################################################################
function [points, alpha, beta] = minValue_AlphaBeta(field, colour, depth, alpha, beta, endGame, act_depth)


%Falls wir an einem Blatt angelangt sind wird nur bewertet sonst nix!
if depth == 0
    points = bewerten(field, colour, endGame);
    return
end

nextMoves = next_moves(field, colour);
possibleMoves = numel(nextMoves) / 64;
localBeta = inf;

if possibleMoves == 0
    stonesCount = sum(field(:) ~= 0);
    if stonesCount == 64
        points = bewerten(field, colour, endGame);
        return
    end
end 

for index = 1:possibleMoves
    [actPoints alpha beta] = maxValue_AlphaBeta(nextMoves(:,:,index), colour*(-1), depth-1, alpha, beta, endGame, act_depth + 1);
    
    if actPoints < localBeta
       if actPoints < alpha
           points = actPoints;
           return
       end
       localBeta = actPoints;
       if actPoints < beta
           beta = actPoints;
       end
    end
end %For
points = localBeta;
end %funct

%##########################################################################
function [ next_moves ] = next_moves( field, color )
%function [ next_moves taken_stones] = next_moves( field, color )
%   function [ next_moves ] = next_moves( field, color )  
%
%   Eingangsparameter
%   field: Spielfeld, dass auf die nächsten Züge überprüft werden soll
%   color: Farbe, die als nächstes gespielt wird
%
%   Ausgabewerte
%   next_moves: 8x8xn Matrix
%               Diese Matrix enthält alle möglichen Spielfelder, die durch
%               einen gültigen Zug vom Eingangsfeld field aus getätigt
%               werden können. Falls kein Zug möglich ist wird []
%               ausgegeben. Dies kann mit isempty(next_moves) überprüft
%               werden.

    %Variablen die viel Zeit zur Erzeugung brauchen werden in der Funktion
    %behalten
    persistent compare_matrix;
    persistent compare_matrix_other_color;
    persistent all_offsets;
    persistent offset_translator;
    persistent preorder;
        

    if isempty(offset_translator)
        
        maximal_stones = 64;

        preorder = zeros(10,10);
        %preorder = zeros(10,10,'int8');
        preorder(2:9,2:9) = ([120  10    30 25 25 30  10   120 ;
                                  10  -100   30 20 20 30 -100  10 ;
                                  30   30    15 10 10 15  30   30 ;
                                  25   20    10 10 10 10  20   25 ;
                                  25   20    10 10 10 10  20   25 ;
                                  30   30    15 10 10 15  30   30 ;
                                  10  -100   30 20 20 30 -100  10 ;
                                  120  10    30 25 25 30  10   120]);

%         preorder(2:9,2:9) = int8([120  10    30 25 25 30  10   120 ;
%                                   10  -100   30 20 20 30 -100  10 ;
%                                   30   30    15 10 10 15  30   30 ;
%                                   25   20    10 10 10 10  20   25 ;
%                                   25   20    10 10 10 10  20   25 ;
%                                   30   30    15 10 10 15  30   30 ;
%                                   10  -100   30 20 20 30 -100  10 ;
%                                   120  10    30 25 25 30  10   120]);

        preorder = preorder * (-1);
        
        compare_matrix = [ 1 -1  0  0  0  0  0; ...
                           1  1 -1  0  0  0  0; ...
                           1  1  1 -1  0  0  0; ...
                           1  1  1  1 -1  0  0; ...
                           1  1  1  1  1 -1  0; ...
                           1  1  1  1  1  1 -1];

        offset_small = [ 1 2 -120 -120 -120 -120 -120; ...
                         1 2 3     -120 -120 -120 -120; ...
                         1 2 3     4     -120 -120 -120; ...
                         1 2 3     4     5     -120 -120; ...
                         1 2 3     4     5     6     -120; ...
                         1 2 3     4     5     6     7];

        %Angenommen 64 Steine können maximal gesetzt werden
        %Die eye_6 wird also 6x2880 (davon wird immer nur das benutzt was
        %für die Anzahl Steine auch nötig ist)
        eye_6 = zeros(6, maximal_stones * 7 * 8);
        eye_6(1:7:(maximal_stones * 6 * 7 * 8)) = 1;
        eye_6(:,7:7:(maximal_stones * 7 * 8)) = [];
        
        %Die eye_10 wird also 10x600 (davon wird immer nur das benutzt was
        %für die Anzahl Steine auch nötig ist)
        eye_10 = zeros(10, maximal_stones * 11);
        eye_10(1:11:(maximal_stones * 10 * 11)) = 1;
        eye_10(:,11:11:(maximal_stones * 11)) = [];

        eye_matrix = [eye(6); (-1)*eye(6); (-9)*eye(6); (-10)*eye(6); ...
                    (-11)*eye(6); 9*eye(6); 10*eye(6); 11*eye(6)];


        compare_matrix = (eye_6' * compare_matrix);
  %      compare_matrix = int8(eye_6' * compare_matrix);
        compare_matrix_other_color = (compare_matrix * (-1));
      %  compare_matrix_other_color = int8(compare_matrix * (-1));
        offset_temp = eye_matrix * offset_small;
        
        all_offsets = [];
        
        counter = 0;
        for i = [12:19 22:29 32:39 42:49 52:59 62:69 72:79 82:89]
            counter = counter + 1;
            all_offsets(((counter - 1) * 48 + 1) : counter * 48 ,1:7) = offset_temp + i;
            all_offsets(((counter - 1) * 48 + 1) : counter * 48 ,8) = i;
        end
        all_offsets((all_offsets < 1) | (all_offsets > 100)) = 1;
      %  all_offsets = int8(all_offsets);
        
        %64 sind die Anzahl aller Steine
        %all_offsets = [compare_matrix(1:64*48,:) all_offsets];
        
        %Übersetzt die indizes des 10er Feldes in das des 8er Feldes
        offset_translator = 1:100;
        offset_translator([12:19 22:29 32:39 42:49 52:59 62:69 72:79 82:89]) = (1:64) * 48;
        
        for i = 1:48
            offset_translator(i,:) = offset_translator(1,:) + (i-1);
        end
       % offset_translator = int16(offset_translator - 47);
        offset_translator = (offset_translator - 47);
        
    end
    
        
   % stone_color_mod = zeros(10,10,'int8');
    stone_color_mod = zeros(10,10);
  %  big_field = zeros(10,10,'int8');
    big_field = zeros(10,10);
    big_field(2:9,2:9) = (field);
   % big_field(2:9,2:9) = int8(field);

    stone_color = find(big_field == (color*(-1)));

    %An dieser Stelle sitzen irgendwelche Steine, sie kann also nicht
    %besetzt werden
    stones = (big_field ~= 0);
   % stones = int8(big_field ~= 0);
    
    stone_color_mod([stone_color-1; stone_color+1; stone_color-9; ...
        stone_color-10; stone_color-11; stone_color+9;stone_color+10; ...
        stone_color+11]) = 1;
    
    %allowed_fields enthält an allen Stellen eine 1, die an einem andersfarbigem
    %Stein liegen und auf denen noch kein Stein liegt
    allowed_fields = stone_color_mod - (stone_color_mod & stones);
  %  allowed_fields = stone_color_mod - int8(stone_color_mod & stones);
    allowed_fields([1:10 11:10:81 91:100 20:10:90]) = 0;%temp;
    
    stones = (find(allowed_fields == 1)); 
    %stones = int8(find(allowed_fields == 1));
    
    next_moves = [];
    %taken_stones = [];
    if isempty(stones)
        return;
    end
 
    %Aus den persistenten Matrizen werden die Einträge rauskopiert, die für
    %die möglichen Steine benötigt werden
    temp = offset_translator(:, stones);
    offset_matrix = all_offsets(temp(:), :);
    
    
    %Die eigentlichen Berechnungen finden in diesen Zeilen statt
    if color == 1
       offset_matrix(any(~(compare_matrix_other_color(1:size(stones,1)*48,:) == big_field(offset_matrix(:, 1:7))),2),:) = [];
    else
       offset_matrix(any(~(compare_matrix(1:size(stones,1)*48,:) == big_field(offset_matrix(:, 1:7))),2),:) = [];
    end
    
    
    %Herausfinden wie viele verschiedene Matrizen gebildet werden müssen.   
    %matrix_count realisiert eine für diesen Zweck sehr schnelle unique
    %Funktion.
    matrix_count = ([(1:100)' zeros(100,1) preorder(:)]);
  %  matrix_count = int16([(1:100)' zeros(100,1) preorder(:)]);
    matrix_count(offset_matrix(:,8),2) = 1;
    matrix_count(any(~matrix_count(:,2),2),:) = [];
    %Vorsortieren für AlphaBeta
    matrix_count = sortrows(matrix_count, 3);
    
    next_moves = zeros(8,8,size(matrix_count,1));
  %  next_moves = zeros(8,8,size(matrix_count,1),'int8');
    for i = 1:size(matrix_count,1)
           temp = offset_matrix(offset_matrix(:,8) == matrix_count(i,1), :);
           temp2 = big_field;
           temp2(temp(:)) = color;
           next_moves(1:8,1:8, i) = temp2(2:9,2:9);
           %taken_stones(i) = matrix_count(i,1);
    end
    
end

%##########################################################################
function [points] = bewerten(field, color, endGame)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if color == -1
    points = -1 * bewertungsfunktion(field, endGame);
else
    points = bewertungsfunktion(field, endGame);
end

end

%##########################################################################
function [points] = bewertungsfunktion(field, endGame)

if endGame == 1              %Bei den finalen Z?gen z?hlen nur die Anzahl der Steine
    temp = double(field);
    temp = temp.*ones(8);
    points = sum(temp(:));
    return; 
end

persistent statische_bewertung;
persistent stabilitaets_bonus;

if isempty(statische_bewertung)
    
statische_bewertung = [
			1500     -200	30      60      60      30      -200	1500;
			-200	-100    5       45      45      5       -100	-200;
			30      5       45      40      40      45      5       30;
			60      45      40      25      25      40      45  	60;
			60      45      40      25      25      40      45  	60;
			30      5       45      40      40      45      5       30;
			-100	-100    5       45      45      5       -100     -200;
			1500     -100	30      60      60      30      -200 	1500;
];


% Stabilit?tsanalyse
stabilitaets_bonus = 110;

end

gewichtung = statische_bewertung;
if field(1,1) ~= 0	% links oben
	stable_color = field(1,1);
	stable = true;
	stable_index = 2;
	while(stable && (stable_index<9))
		if field(1,stable_index) == stable_color
			gewichtung(1,stable_index) = statische_bewertung(1,stable_index) + stabilitaets_bonus;
			stable_index = stable_index + 1;
		else
			stable = false;
		end;
	end;
	
	stable = true;
	stable_index = 2;
	while(stable && (stable_index<9))
		if field(stable_index,1) == stable_color
			gewichtung(stable_index,1) = statische_bewertung(stable_index,1) + stabilitaets_bonus;
			stable_index = stable_index + 1;
		else
			stable = false;
		end;
	end;	
end;	

if field(1,8) ~= 0	% links unten
	stable_color = field(1,8);
	stable = true;
	stable_index = 2;
	while(stable && (stable_index<9))
		if field(1,9-stable_index) == stable_color
			gewichtung(1,9-stable_index) = statische_bewertung(1,9-stable_index) + stabilitaets_bonus;
			stable_index = stable_index + 1;
		else
			stable = false;
		end;
	end;
	
	stable = true;
	stable_index = 2;
	while(stable && (stable_index<9))
		if field(stable_index,8) == stable_color
			gewichtung(stable_index,8) = statische_bewertung(stable_index,8) + stabilitaets_bonus;
			stable_index = stable_index + 1;
		else
			stable = false;
		end;
	end;	
end;	

if field(8,1) ~= 0	% rechts oben
	stable_color = field(8,1);
	stable = true;
	stable_index = 2;
	while(stable && (stable_index<9))
		if field(8,stable_index) == stable_color
			gewichtung(8,stable_index) = statische_bewertung(8,stable_index) + stabilitaets_bonus;
			stable_index = stable_index + 1;
		else
			stable = false;
		end;
	end;
	
	stable = true;
	stable_index = 2;
	while(stable && (stable_index<9))
		if field(9-stable_index,1) == stable_color
			gewichtung(9-stable_index,1) = statische_bewertung(9-stable_index,1) + stabilitaets_bonus;
			stable_index = stable_index + 1;
		else
			stable = false;
		end;
	end;	
end;	

if field(8,8) ~= 0	%rechts unten
	stable_color = field(8,8);
	stable = true;
	stable_index = 2;
	while(stable && (stable_index<9))
		if field(8,9-stable_index) == stable_color
			gewichtung(8,9-stable_index) = statische_bewertung(8,9-stable_index) + stabilitaets_bonus;
			stable_index = stable_index + 1;
		else
			stable = false;
		end;
	end;
	
	stable = true;
	stable_index = 2;
	while(stable && (stable_index<9))
		if field(9-stable_index,8) == stable_color
			gewichtung(9-stable_index,8) = statische_bewertung(9-stable_index,8) + stabilitaets_bonus;
			stable_index = stable_index + 1;
		else
			stable = false;
		end;
	end;	
end;	
		

temp = double(field);
temp = temp.*gewichtung;

%Ich baue hier jetzt einfach mal die Mobilit?t mit ein. vG Sebastian
points = sum(temp(:)) + 55*mobility(field, 1);

% 
% 
% %Mobilit?tsbewertung
% for spalte = 1:8
%     for zeile = 1:8
%         if field(zeile,spalte) = -1;                 % ist Feld vom Gegner besetzt?
%             if field(zeile+1,spalte+1) = 0;          % ist Feld rechts unten davon frei?
%                 if field(zeile-1,spalte-1) = 1;      % kann Feld besetzt werden?
%                     mobilitaet = mobilitaet + 1;     % Mobilit?t erh?ht sich f?r uns   
%                 else                                 % Mobilit?tspotential erh?ht sich
%                     mobilitaet_potential = mobilitaet_potential + 1;   
%                 end;
%         else end;
%         end;
%     end;
% end;
% 
% % nochmal eine
% for spalte = 1:8
% 	for zeile = 1:8
% 		if field(zeile,spalte) == 0						% freies Feld, analysieren wir das auf Mobilit?t
% 			mobil = false;
% 			
% 			% nun gehen wir alle 8 Raumrichtungen durch und pr?fen, ob sie g?ltig sind (nicht am Rand)
% 			
% 			% Richtung 12 Uhr
% 			if (zeile ~= 1)
% 														% In dieser Raumrichtung k?nnen wir f?r's Erste scannen!
% 				if field(zeile-1,spalte) ~= 0			% lohnt sich weiteres Scannen ?berhaupt?
% 					raycolor = field(zeile-1,spalte);	% Farbe :) des Nachbars
% 					subzeile = zeile - 1;
% 					active = true;
% 					while(active)
% 						if (field(subzeile,spalte) == -1*raycolor)
% 							mobil = true;
% 							active = false;
% 					
% 						subzeile = subzeile - 1;
% 						if (active)
% 							active = (subzeile > 0);
% 					end;
% 					
% 					if (mobil)
% 						mobilitaetscounter++;
% 					else
% 						mobilitaetspotential++;
% 			end;
% 			
% 			% Richtung 3 Uhr
% 			if ((mobil == false) && ((zeile =~1) && (spalte =~ 8)))
% 						
% 						
% 		
% 		end;
% 	end;
% end;
    


%Alte Versionen, beste steht oben


% temp = temp.*[   500    10      300      250      250      300      0     500 ; ...   %Die Felder direkt an den Ecken setzt ich mal runter... 
%                  10     10      50       75       75       50       10     10  ; ... 
%                  300    50      200      150      150      200      50     300  ; ... 
%                  250    75      150      275      275      150      75     250  ; ... %Die Mitte wird im Spielverlauf schon noch wichtig...
%                  250    75      150      275      275      150      75     250  ; ... 
%                  300    50      200      150      150      200      50     300  ; ...
%                  10     10      50       75       75       50       10     10  ; ...
%                  500    10      300      250      250      300      10     500 ];


%  500    0       300      250      250      300      0     500 ; ...   %Die Felder direkt an den Ecken setzt ich mal runter... 
%                  0      0       50       75       75       50       0      0   ; ... 
%                  300    50      400      150      150      400      50     300  ; ... 
%                  250    75      150      275      275      150      75     250  ; ... %Die Mitte wird im Spielverlauf schon noch wichtig...
%                  250    75      150      275      275      150      75     250  ; ...
%                  300    50      400      150      150      400      50     300  ; ...
%                  0      0       50       75       75       50       0      0   ; ...
%                  500    0       300      250      250      300      0      500 ];


% Vorsicht: Im Player Bedingung für Zugangszahl formulieren
end

%##########################################################################
function [ mobility ] = mobility( field, color )
%   function [ next_moves ] = next_moves( field, color )  
%
%   Eingangsparameter
%   field: Spielfeld, dass auf die nächsten Züge überprüft werden soll
%   color: Farbe, die als nächstes gespielt wird
%
%   Ausgabewerte
%   next_moves: 8x8xn Matrix
%               Diese Matrix enthält alle möglichen Spielfelder, die durch
%               einen gültigen Zug vom Eingangsfeld field aus getätigt
%               werden können. Falls kein Zug möglich ist wird []
%               ausgegeben. Dies kann mit isempty(next_moves) überprüft
%               werden.

    %Variablen die viel Zeit zur Erzeugung brauchen werden in der Funktion
    %behalten
    persistent compare_matrix;
    persistent all_offsets;
    persistent offset_translator;
        

    if isempty(offset_translator)
        
        maximal_stones = 64;
%         compare_matrix = [ 1 -1  0  0  0  0  0; ...
%                            1  1 -1  0  0  0  0; ...
%                            1  1  1 -1  0  0  0; ...
%                            1  1  1  1 -1  0  0; ...
%                            1  1  1  1  1 -1  0; ...
%                            1  1  1  1  1  1 -1];
% 
%         offset_small = [ 1 2 -120 -120 -120 -120 -120; ...
%                          1 2 3     -120 -120 -120 -120; ...
%                          1 2 3     4     -120 -120 -120; ...
%                          1 2 3     4     5     -120 -120; ...
%                          1 2 3     4     5     6     -120; ...
%                          1 2 3     4     5     6     7];    

        compare_matrix = [ 1 -1  0  0  0  0  0; ...
                           1  1 -1  0  0  0  0; ...
                           1  1  1 -1  0  0  0; ...
                           1  1  1  1 -1  0  0;];

        offset_small = [ 1 2 -120 -120 -120 -120 -120; ...
                         1 2 3     -120 -120 -120 -120; ...
                         1 2 3     4     -120 -120 -120; ...
                         1 2 3     4     5     -120 -120;];

        %Angenommen 64 Steine können maximal gesetzt werden
        %Die eye_6 wird also 6x2880 (davon wird immer nur das benutzt was
        %für die Anzahl Steine auch nötig ist)
        eye_6 = zeros(4, maximal_stones * 7 * 8);
        eye_6(1:5:(maximal_stones * 4 * 7* 8)) = 1;
        eye_6(:,5:5:(maximal_stones * 7 * 8)) = [];
        

        eye_matrix = [eye(4); (-1)*eye(4); (-9)*eye(4); (-10)*eye(4); ...
                    (-11)*eye(4); 9*eye(4); 10*eye(4); 11*eye(4)];


        compare_matrix = (eye_6' * compare_matrix);
        compare_matrix = (compare_matrix * (-1));
        %compare_matrix = int8(eye_6' * compare_matrix);
       % compare_matrix = int8(compare_matrix * (-1));
        offset_temp = eye_matrix * offset_small;
        
        all_offsets = [];
        
        counter = 0;
        for i = [12:19 22:29 32:39 42:49 52:59 62:69 72:79 82:89]
            counter = counter + 1;
            all_offsets(((counter - 1) * 32 + 1) : counter * 32 ,1:7) = offset_temp + i;
            all_offsets(((counter - 1) * 32 + 1) : counter * 32 ,8) = i;
        end
        all_offsets((all_offsets < 1) | (all_offsets > 100)) = 1;
        all_offsets = (all_offsets);
        %all_offsets = int8(all_offsets);
        
        %64 sind die Anzahl aller Steine
        %all_offsets = [compare_matrix(1:64*48,:) all_offsets];
        
        %Übersetzt die indizes des 10er Feldes in das des 8er Feldes
        offset_translator = 1:100;
        offset_translator([12:19 22:29 32:39 42:49 52:59 62:69 72:79 82:89]) = (1:64) * 32;
        
        for i = 1:32
            offset_translator(i,:) = offset_translator(1,:) + (i-1);
        end
        offset_translator = (offset_translator - 31);
       % offset_translator = int16(offset_translator - 31);
        
    end
    
        
    stone_color_mod = zeros(10,10);
    big_field = zeros(10,10);
    big_field(2:9,2:9) = (field);
% 
%     stone_color_mod = zeros(10,10,'int8');
%     big_field = zeros(10,10,'int8');
%     big_field(2:9,2:9) = int8(field);

    stone_color = find(big_field == (color*(-1)));

    %An dieser Stelle sitzen irgendwelche Steine, sie kann also nicht
    %besetzt werden
    stones = (big_field ~= 0);
  %  stones = int8(big_field ~= 0);
    
    stone_color_mod([stone_color-1; stone_color+1; stone_color-9; ...
        stone_color-10; stone_color-11; stone_color+9;stone_color+10; ...
        stone_color+11]) = 1;
    
    %allowed_fields enthält an allen Stellen eine 1, die an einem andersfarbigem
    %Stein liegen und auf denen noch kein Stein liegt
    allowed_fields = stone_color_mod - (stone_color_mod & stones);
   % allowed_fields = stone_color_mod - int8(stone_color_mod & stones);
    allowed_fields([1:10 11:10:81 91:100 20:10:90]) = 0;%temp;
    
    stones = (find(allowed_fields == 1));
  %  stones = int8(find(allowed_fields == 1));
    
    mobility = 0;
    if isempty(stones)
        return;
    end
 
    %Aus den persistenten Matrizen werden die Einträge rauskopiert, die für
    %die möglichen Steine benötigt werden
    temp = offset_translator(:, stones);
    offset_matrix = all_offsets(temp(:), :);
    
    a = compare_matrix(1:size(stones,1)*32,:) == big_field(offset_matrix(:, 1:7));
    mobility = round(size(a(all(a,2)), 1) / 1.2);
    
%     global mob;
%     mobility_old = mobility_alt(field, color);
%     if (mobility ~= 0) && (mobility_old ~= 0)
%         index = round((mobility_old/mobility) * 100);
%         if index <= 200
%         mob(index,2) = mob(index,2) + 1;
%         end
%     end
    
end

%##########################################################################
function [ cut_moves ] = MultiProbCut( next_moves, color, endgame, skalieren)
% So, diese schöne Funktion bewertet die Matrizen, die übergeben werden,
% und schneidet die schlechtesten weg.
% Mit skalieren kann man den Wert, bei dem Weggeschnitten wird, prozental
% größer oder kleiner machen. Bei +10 wird z.B. nicht mehr alles unter 500
% weggeschnitten, sondern alles unter 550, bei -10 dann alles unter 450;

bewertungen = [zeros(size(next_moves, 3), 1), (1:size(next_moves, 3))'];

for i = 1:size(next_moves, 3)
    %Die Einträge werden nachher aufsteigend sortiert, damit die am
    %höchsten bewerteten bei den ersten Einträgen landen, müssen sie einmal
    %invertiert werden.
    bewertungen(i, 1) = (-1) * bewerten(next_moves(:,:,i), color, endgame);
end

%Nach Wertung sortieren
bewertungen = sortrows(bewertungen, 1);

%Berechnen, wie viele Züge weggeschnitten werden sollen. Hier wird es auch
%noch etwas skaliert, sonst besteht nämlich keine Möglichkeit hier etwas
%einzustellen. RUMPROBIEREN!!!
cut_line = sqrt(mean(bewertungen(:,1).^2)) * (1+ (skalieren/100));

merker = bewertungen;

%Jetzt kommt der Cut
bewertungen = bewertungen(bewertungen(:,1) <= ((-1)*cut_line), :);

%Falls alles weggeschnitten wurde, rückgängig machen
if isempty(bewertungen)
    bewertungen = merker;
end

%Und jetzt nach Wertung sortiert in die Ausgabe packen, das weggeschnittene
%dabei aber weglassen.
cut_moves = zeros(8,8,size(bewertungen,1));
%cut_moves = zeros(8,8,size(bewertungen,1),'int8');
for i = 1:size(bewertungen,1)
   cut_moves(:,:,i) = next_moves(:,:,bewertungen(i,2));
end

end

%##########################################################################
function [ next_moves ] = put_stone( field, color, stone )
%   function [ next_moves ] = next_moves( field, color )  
%
%   Eingangsparameter
%   field: Spielfeld, dass auf die nächsten Züge überprüft werden soll
%   color: Farbe, die als nächstes gespielt wird
%
%   Ausgabewerte
%   next_moves: 8x8xn Matrix
%               Diese Matrix enthält alle möglichen Spielfelder, die durch
%               einen gültigen Zug vom Eingangsfeld field aus getätigt
%               werden können. Falls kein Zug möglich ist wird []
%               ausgegeben. Dies kann mit isempty(next_moves) überprüft
%               werden.

    %Variablen die viel Zeit zur Erzeugung brauchen werden in der Funktion
    %behalten
    persistent compare_matrix;
    persistent compare_matrix_other_color;
    persistent all_offsets;
    persistent offset_translator;
    persistent preorder;
        

    if isempty(offset_translator)
        
        maximal_stones = 64;

        %preorder = zeros(10,10,'int8');
        preorder = zeros(10,10);
%         preorder(2:9,2:9) = int8([120  10    30 25 25 30  10   120 ;
%                                   10  -100   30 20 20 30 -100  10 ;
%                                   30   30    15 10 10 15  30   30 ;
%                                   25   20    10 10 10 10  20   25 ;
%                                   25   20    10 10 10 10  20   25 ;
%                                   30   30    15 10 10 15  30   30 ;
%                                   10  -100   30 20 20 30 -100  10 ;
%                                   120  10    30 25 25 30  10   120]);        
        preorder(2:9,2:9) = ([120  10    30 25 25 30  10   120 ;
                                  10  -100   30 20 20 30 -100  10 ;
                                  30   30    15 10 10 15  30   30 ;
                                  25   20    10 10 10 10  20   25 ;
                                  25   20    10 10 10 10  20   25 ;
                                  30   30    15 10 10 15  30   30 ;
                                  10  -100   30 20 20 30 -100  10 ;
                                  120  10    30 25 25 30  10   120]);

        preorder = preorder * (-1);
        
        compare_matrix = [ 1 -1  0  0  0  0  0; ...
                           1  1 -1  0  0  0  0; ...
                           1  1  1 -1  0  0  0; ...
                           1  1  1  1 -1  0  0; ...
                           1  1  1  1  1 -1  0; ...
                           1  1  1  1  1  1 -1];

        offset_small = [ 1 2 -120 -120 -120 -120 -120; ...
                         1 2 3     -120 -120 -120 -120; ...
                         1 2 3     4     -120 -120 -120; ...
                         1 2 3     4     5     -120 -120; ...
                         1 2 3     4     5     6     -120; ...
                         1 2 3     4     5     6     7];

        %Angenommen 64 Steine können maximal gesetzt werden
        %Die eye_6 wird also 6x2880 (davon wird immer nur das benutzt was
        %für die Anzahl Steine auch nötig ist)
        eye_6 = zeros(6, maximal_stones * 7 * 8);
        eye_6(1:7:(maximal_stones * 6 * 7 * 8)) = 1;
        eye_6(:,7:7:(maximal_stones * 7 * 8)) = [];
        
        %Die eye_10 wird also 10x600 (davon wird immer nur das benutzt was
        %für die Anzahl Steine auch nötig ist)
        eye_10 = zeros(10, maximal_stones * 11);
        eye_10(1:11:(maximal_stones * 10 * 11)) = 1;
        eye_10(:,11:11:(maximal_stones * 11)) = [];

        eye_matrix = [eye(6); (-1)*eye(6); (-9)*eye(6); (-10)*eye(6); ...
                    (-11)*eye(6); 9*eye(6); 10*eye(6); 11*eye(6)];


        compare_matrix = (eye_6' * compare_matrix);
    %    compare_matrix = int8(eye_6' * compare_matrix);
        compare_matrix_other_color = (compare_matrix * (-1));
     %   compare_matrix_other_color = int8(compare_matrix * (-1));
        offset_temp = eye_matrix * offset_small;
        
        all_offsets = [];
        
        counter = 0;
        for i = [12:19 22:29 32:39 42:49 52:59 62:69 72:79 82:89]
            counter = counter + 1;
            all_offsets(((counter - 1) * 48 + 1) : counter * 48 ,1:7) = offset_temp + i;
            all_offsets(((counter - 1) * 48 + 1) : counter * 48 ,8) = i;
        end
        all_offsets((all_offsets < 1) | (all_offsets > 100)) = 1;
      %  all_offsets = int8(all_offsets);
        
        %64 sind die Anzahl aller Steine
        %all_offsets = [compare_matrix(1:64*48,:) all_offsets];
        
        %Übersetzt die indizes des 10er Feldes in das des 8er Feldes
        offset_translator = 1:100;
        offset_translator([12:19 22:29 32:39 42:49 52:59 62:69 72:79 82:89]) = (1:64) * 48;
        
        for i = 1:48
            offset_translator(i,:) = offset_translator(1,:) + (i-1);
        end
        offset_translator = int16(offset_translator - 47);
        %offset_translator = (offset_translator - 47);
        
    end
    
    big_field = zeros(10,10);
   % big_field = zeros(10,10,'int8');
   % big_field(2:9,2:9) = int8(field);
    big_field(2:9,2:9) = (field);
    
    stones = stone;
    
    %Aus den persistenten Matrizen werden die Einträge rauskopiert, die für
    %die möglichen Steine benötigt werden
    temp = offset_translator(:, stones);
    offset_matrix = all_offsets(temp(:), :);
        
    %Die eigentlichen Berechnungen finden in diesen Zeilen statt
    if color == 1
       offset_matrix(any(~(compare_matrix_other_color(1:size(stones,1)*48,:) == big_field(offset_matrix(:, 1:7))),2),:) = [];
    else
       offset_matrix(any(~(compare_matrix(1:size(stones,1)*48,:) == big_field(offset_matrix(:, 1:7))),2),:) = [];
    end
    
    
    %Herausfinden wie viele verschiedene Matrizen gebildet werden müssen.   
    %matrix_count realisiert eine für diesen Zweck sehr schnelle unique
    %Funktion.
    matrix_count = ([(1:100)' zeros(100,1) preorder(:)]);
  %  matrix_count = int16([(1:100)' zeros(100,1) preorder(:)]);
    matrix_count(offset_matrix(:,8),2) = 1;
    matrix_count(any(~matrix_count(:,2),2),:) = [];
    
    next_moves = zeros(8,8,size(matrix_count,1));
 %   next_moves = zeros(8,8,size(matrix_count,1),'int8');
    for i = 1:size(matrix_count,1)
           temp = offset_matrix(offset_matrix(:,8) == matrix_count(i,1), :);
           temp2 = big_field;
           temp2(temp(:)) = color;
           next_moves(1:8,1:8, i) = temp2(2:9,2:9);
    end
    
end

%##########################################################################
function returnField = datenzugriff(akt_feld)
%akt_feld: Feld, dass in der Datenbank gesucht werden soll
%werden kann

% Variable move persistent definieren
persistent moves_db;

if isempty(moves_db)
    moves_db = load('moves.mat','moves');
    moves_db = moves_db.moves;
    
    move_converting_1 = reshape(1:100,10,10)';
    move_converting_2 = reshape(100:-1:1,10,10);
    
    %Hier werden aus den gespeicherten Matrizen die symmetrischen Matrizen
    %erzeugt
    for i = 2:size(moves_db,2)
        old_size = size(moves_db{1,i},3);
        %moves_db{1,i}(:,:, (4 * old_size)) = zeros(8,'int8');
        moves_db{1,i}(:,:, (4 * old_size)) = zeros(8);
        moves_db{2,i}(4 * old_size) = 0;
        for m = 1:8
            moves_db{1,i}(:,m, (old_size + 1):(2 * old_size)) = moves_db{1,i}(m,:, 1:old_size);
        end
        for m = 1:8
            moves_db{1,i}(9-m,:, (2 * old_size + 1):(4 * old_size)) = moves_db{1,i}(m,8:-1:1, 1: 2*old_size);
        end
        
        moves_db{2,i}((old_size + 1):(2 * old_size)) = move_converting_1(moves_db{2,i}(1:old_size));
        moves_db{2,i}((2*old_size + 1):(4 * old_size)) = move_converting_2(moves_db{2,i}(1:2*old_size));
    end
end

returnField = [];
temp = akt_feld ~= 0;
stone_count = sum(temp(:));
color = (-1)^(stone_count + 1);
zug = stone_count - 3;
%akt_feld = int8(akt_feld);

if zug <= size(moves_db, 2)
    %Hier wird die Datenbank durchsucht.
    for idx = 1:size(moves_db{1,zug},3)
        if (moves_db{1,zug}(:,:,idx)) == akt_feld
            if moves_db{2,zug}(idx) == 1
                break;
            end
            returnField = double(put_stone(moves_db{1,zug}(:,:,idx), color, moves_db{2,zug}(idx)));
            break;
        end
    end
end


end
