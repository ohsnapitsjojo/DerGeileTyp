function b_new = Pwndthello(b,color,time_left)
%% Othello Implementation of 
%                            Claudius Fink, 3602817
%                            Paskal Kiefer, 3603716 
%                            Julian Schiele, 3601900
%                            Fabian Steiner, 3601535
%                            Stefan Ries, 3600268
%                            Ferdinand Trommsdorf, 3602460
%
% Developed within the "Projektpraktikum Matlab" @ LDV EI TUM, June/July 2012
%
%                             

addpath(['players' filesep mfilename]);

try
    %% Determine search depth and finish_flag for endgame table
    numturn = sum(sum(b ~= 0))-3;
    [depth, msg] = PWND_determineDepth(numturn, time_left);
    
    %% Start searching...
    if numturn < 20
        % Get database move
        [b_new, found] = PWND_databaseSearch(b, color, numturn);
        if found == false
            disp([mfilename ': nothing found in database']);
            disp([mfilename ': search depth is ' num2str(depth) ' (' msg ')']);
            % Call Negamax as fallback
            [~, b_new] = PWND_negamaxPruning(b, color, -inf, +inf, depth);
        end
        
    else
        disp([mfilename ': search depth is ' num2str(depth) ' (' msg ')']);
        % Call Negamax
        [~, b_new] = PWND_negamaxPruning(b, color, -inf, +inf, depth);
    end
    
    
catch ME1
    % In case an error occured somewhere
    disp([mfilename ': Error: ' ME1.message]);
    disp([mfilename ': something went wrong, using depth 1.']);
    try
        [~, B] = PWND_findAllowedPositions2(b, color);
        score = zeros(size(B,3),1);
        for k = 1:size(B,3)
            score(k) = PWND_evaluateBoard(B(:,:,k), color);
        end
        [~, idx]= max(score);
        b_new = B(:,:,idx);
    catch ME2
        % we definitely don't wanna get here
        disp([mfilename ': Error: ' ME2.message]);
        disp([mfilename ': something went wrong again, doing random move. :(']);
        try
            [~, B] = PWND_findAllowedPositions2(b, color);
            b_new = B(:,:,ceil(rand*size(B,3)));
        catch ME3
            disp([mfilename ': Error: ' ME3.message]);
            disp('Pwndthello hit himself in confusion. Pwndthello fainted.');
        end
    end
end