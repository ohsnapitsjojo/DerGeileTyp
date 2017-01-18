%  @brief Given a board, this function queries a database of known moves.
%  Then it returns a move which is useful to play. The underlying 'database'
%  mainly contains openings.
%  
%  Goals of this dictionary are:
%  @li Aus gespielten Partien lernen zwei Spiele nicht auf die gleiche Weise zu verlieren
%  @li NOT: Einen st�rkeren Gegner, der aber nicht �ber vergleichbare
%  Mechanismen verf�gt, in einer Folge von Spielen kompromittieren. Folge
%  ist nutzlos, da jeder Gegner in den angestrebten Turnier nur zweimal
%  gegen einen antritt.
%  @li Eine auf die eigenen Schw�chen eingehende Er�ffnungsbibliothek automatisch erzeugen
% 
% @section Strategie
% Die Grundstrategien sind:
% @subsection Hast du ein Spiel gewonnen, so versuche es auf die gleiche Art nochmal
% @li Schwachpunkt:  Ein Programm, das nur diese Strategie verfolgt, ist ihr hilflos ausgeliefert.                                      
% @li L�sung: Ein Mechanismus, der geeignete Zugalternativen finden kann; Benutzung einer gro�en, randomisierten Er�ffnungsbibliothek, mit kleiner Wahrscheinlichkeit ein Spiel �berhaupt zu wiederholen.
% @li Schwachpunkt: Mit jedem verlorenen Spiel w�chst die Wahrscheinlichkeit ein weiteres  zu verlieren. 
% 
% @subsection Versuche, eigene verlorene Spiele aus der Sicht des Gegners zu wiederholen
% @li So wird ein st�rkerer Gegner ohne Lernmachanismus gegen sich selbst spielen und verlieren. 
% @li Schwachpunkt: Der Gegner muss nicht unbedingt optimal spielen, er k�nnte die besten Z�ge als �berraschung f�r die n�chsten Spiele aufheben.
% 
% @subsection Kombiniert: Kam die aktuelle Position schon einmal vor und ist dort keine Gewinnfortsetzung bekannt, so suche nach einer viel versprechenden Zugalternative
% Ein Programm, das alle drei Strategien befolgt, ist ein unangenehmer Spielpartner. Es wiederholt eigene und gegnerische Gewinne, verliert nicht zweimal auf die gleiche Art, da es nach Zugalternativen sucht. Es lernt gute Er�ffnungspfade, die es selbst vielleicht nie beschreiten w�rde und korrigiert eigene Fehler in folgenden Spielen.
% 
% @section Ausblick
% Da hier keine Sequenzen verwendet wurden (z.B. 'F5,D6,...') kann im
% Prinzip jede m�gliche Konstellation mit nachfolgenden Z�gen abgelegt
% werden, auch im Mittelspiel ohne Vorg�nger bis zum Spielanfang. Dadurch
% k�nnte das Dictionary prinzipiell das ganze SPiel �ber laufen.
% 
%  @author Martin Becker
%  @date 2011-Jan-26
% 
%  @callgraph
%  @callergraph
% 
% input arguments
%   @param board the playing board described by an 8-by-8 matrix.
%   @param color - positions in 'board' where the value equals 'color' are
%       assumed
%       to be my disks. Elements with zero are assumed to be free, whereas
%       others are all opponents. WARNING: -1 is mapped to BLACK and +1 is
%       mapped to WHITE. This mapping is fixed, but allows to either let
%       black or white start, unlinke traditional Othello game, where
%       always white has to start. The mapping is also affecting the
%       dictionary.
%   @param a non-zero positive number indicating the current round number.
%       If this argument is omitted then 
%   @param gameSequence a alphanumeric sequence indicating the othello
%       moves done up to now. If empty, no dictionary can be used and the
%       returned moves are a set of all actually possible ones.
% 
% return value: partially consistent with GC_getValidPositions.m
%   @retval goodDisk a 2-by-1 vector indicating recommended move. 
%       If empty, dictionary has no entry for the given
%       constellation.
%   @retval goodBoard the board after the move belonging to goodDisk.
%   @retval badDisks analogue to goodDisk, but holds ALL the moves in a 2-by-p matrix which are
%       NOT recommended. Note that is makes only sense to use them if goodBoard
%       is empty, otherwise this return variable will be empty.
function [goodDisk, goodBoard, badDisks]  = GC_queryDictionary(board, color, RoundNumber, gameSequence)
goodBoard = [];
badDisks  = [];
goodDisk  = [];

% Dictionary (moveList): MAT-file derived from WTHOR format.
% Contents: 
%    #1 numPlayersBlack: How often this was played by black
%    #2 numPlayersWhite: How often this was played by white
%    #3 score_fin_black: The score of black at the end of the game.
%    Starting from that board the game was finished "perfectly".
%    #4 sequence: Othello sequence "F5D6..." 
%
persistent moveList;

%% if this is the first move in the game, gamble one out of four and return.
if (RoundNumber == 1 && isempty(gameSequence)) % new game starts
        % at first invalidate dictionary, so that a reload is forced.
        moveList = [];

        % no move was done, yet. Randomize the very first opening disk.

        goodBoard = board;
        
        % randomize the direction I use this time. Modify the board and
        % return.
        luckyNumber = rand(1,1);
        
        BLACK_STARTS = (color ==-1);
        
        if BLACK_STARTS
            disp([mfilename ': "BLACK starts, all fine."']);        
            if (luckyNumber <=0.25) 
                startingPosition = 'f5';
                goodDisk=[5;6];
                goodBoard(5,5:6) = color;
            elseif (luckyNumber <= 0.5) 
                startingPosition = 'c4';
                goodDisk=[4;3];
                goodBoard(4,3:4) = color;
            elseif (luckyNumber <= 0.75) 
                startingPosition = 'd3';
                goodDisk=[3;4];
                goodBoard(3:4,4) = color;
            else
                startingPosition = 'e6';
                goodDisk=[6;5];
                goodBoard(5:6,5) = color;
            end    
        else
            disp([mfilename ': "Hm...WHITE starts...weirdo, but no problem."']);        
            if (luckyNumber <=0.25) 
                startingPosition = 'c5';
                goodDisk=[5;3];
                goodBoard(5,3:5) = color;
            elseif (luckyNumber <= 0.5) 
                startingPosition = 'd6';
                goodDisk=[6;4];
                goodBoard(4:6,4) = color;
            elseif (luckyNumber <= 0.75) 
                startingPosition = 'e3';
                goodDisk=[3;5];
                goodBoard(3:5,5) = color;
            else
                startingPosition = 'f4';
                goodDisk=[4;6];
                goodBoard(4,4:6) = color;
            end       
        end
        
        disp([mfilename ': "I choose to start with ' startingPosition '."']);        
        return;
end

% When we arrive here, the opponent already set a disk.

% something went wrong: we are in the game and have no sequence, or
% suppression of dictionary on purpose. Return empty sets.
if (isempty(gameSequence))
    % Don't do anything.
    disp([mfilename ': empty sequence.']);
    return;
end

% when arrived here, we have a game sequence and everything is fine. load
% dictionary, if not done, yet.

%disp([mfilename ': Round number =' num2str(RoundNumber)]);

%% 1. initialize dictionary 
if (isempty(moveList))  % force reload when empty.
    % load tables: all sequences given start at f5
    disp([mfilename ': "Loading dictionary now..."']);
    tic;
    % variable: moveList (cell array). This baby has 37709 known FULL GAME
    % sequences. Because black/white and symmetry is considered, 8 times
    % the number of entrys can be matched, which is 301672. Additionally,
    % Each of the 37709 entries has full length of 60 plys. Which means
    % actually a lot more boards are available.
    moveList=[];
    load Logistello_book_1999.wtb.mat; 
    t_load = toc    % @todo DEBUG only. remove.
end


%% 2. transpose sequence to a f5-based sequence, because only that is in database.

% @todo debug, remove
disp([mfilename ': sequence=' gameSequence]);

seqStart = gameSequence(1:2);
if (~strcmp(seqStart,'f5'))    
    gameSequence = GC_transposeSequence(gameSequence, 'f5');  % make white to black if necessary and refer everything as F5
end

%% 3. scan book for the sequence
idx=(not(cellfun(@isempty, regexp(moveList(:,4),['^' gameSequence '.+']))));

% get matches -> moveList is shrinking every time, so this gets faster and
% faster...
moveList = moveList(idx,:); % @todo think about NOT deleting the others. I could use the same list over and over again over the games. Let's just wait and see if matching time is reduced significantly.
numMatches = size(moveList,1);

%% 4. found move(s). 
% Keep in mind that in book everything is listed for black. If i am white, my moves have 
% been neutralized to "F5"-prefixed sequences in line 175, so what I have to do is maximize black.
if numMatches 

    disp([mfilename ': numMatches=' num2str(numMatches)]);
    % the offset in the sequence string we need to cut out (=next move, alphanum 2-digit)
    seq_start = numel(gameSequence) + 1;   
    
    % discriminate good/bad.

    idx_good=((cellfun(@max, moveList(:,3)))>31);   % All moves that lead to black winning or to a tie are good.    
    idx_bad =not(idx_good);
    
    numBad = sum(idx_bad);
    numGood = sum(idx_good);
        
   
    % Discriminate between good and bad now. Don't forget to pretend I am black now. the
    % backtransform to white (if I'm white) happens later on.    
    if numGood                       
        matchList_good = moveList(idx_good,:); 
        % If more than one good move is available, randomize one according
        % to its statistical victory. The moves having better score should
        % be more likely to be selected.
        
        if numGood > 1
            i_sel = GC_gambleMove(matchList_good);
        else
            i_sel = 1;
        end
                
        % grep the selected move
        dictMove = matchList_good{i_sel,4};    % alphanum string starting at F5
        disp(['    ... found ' num2str(numGood) ' good postdecessors. Selecting #' num2str(i_sel) '  with ' num2str(matchList_good{i_sel,3}) ' potential end points...']);

        % transpose back the found entry from the book to the actual
        % starting sequence (also black/white)
        if (~strcmp(seqStart,'f5'))  
            % if this wasn't a game where black started with f5, translate the disk
            % to be set acc. to dictionary back to correct transpose
            dictMove = GC_transposeSequence(dictMove, seqStart);  
        end
        goodDisk = dictMove(seq_start:seq_start+1);  % get the NEXT disk, not the LAST (because the sequence might be longer)
        
        % execute the move on the current board and return the board.
        goodDisk = (GC_othseq2coord(goodDisk))';
        goodBoard = GC_simMove(goodDisk', color, board);
    elseif numBad
        matchList_bad = moveList(idx_bad,:);
        % If No good move is known, but a bad one, return ALL bad moves to
        % allow suppression of them in the possibility search later on.
        disp(['    ... found only ' num2str(numGood) ' bad moves. Trying to avoid them.']);
        
        % return ALL new disks to be set for the bad known moves. Board
        % isn't needed in this case. Translate the coordinates back from F5 to
        % the right symmetry axis.
        
        for k = 1:numBad
            % transpose back the found entry from the book to the actual
            % starting sequence (also black/white)
            badDisk = matchList_bad{k,4};
            if (~strcmp(seqStart,'f5'))  
                % if this wasn't a game where black started with f5, translate the disk
                % to be set acc. to dictionary back to correct transpose
                badDisk = GC_transposeSequence(badDisk, seqStart);  
            end            
            badDisk = (GC_othseq2coord(badDisk(seq_start:seq_start+1)))';     % coordinates of the last disk
            badDisks=cat(2,badDisks,badDisk);    % append to the list
        end
    end
end


