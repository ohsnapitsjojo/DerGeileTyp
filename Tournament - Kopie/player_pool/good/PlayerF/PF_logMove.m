function PF_logMove( board, color )
%PF_LOGMOVE Summary of this function goes here
%   Detailed explanation goes here

global PF_log_moves_total
global PF_log_moves_count
global PF_log_rotate
global PF_log_old_board


% Board nach erstem Zug ausrichten
if sum(board(:)~=0)>4
    if PF_log_moves_count==0
        alt = board-PF_log_old_board;
        [x y] = find(alt~=0 & ~isnan(alt), 1);
        PF_log_rotate = [x y]*[16; 1];
    end
        
    switch PF_log_rotate
        case 101            % F5
            % do nothing
        case 86             % E6
            % 
            board = fliplr(rot90(board,3));
        case 52             % C4
            % 
            board = rot90(board,2);
        case 67             % D3
            board = fliplr(rot90(board,1));
    end;
end


alt = board-PF_log_old_board;
% letzten Zug speichern (if any)
[mey mex] = find(alt~=0 & ~isnan(alt));
if ~isempty(mey)
    PF_log_moves_count = PF_log_moves_count + 1;
    PF_log_moves_total(PF_log_moves_count) = uint8(mey*16 + mex);
end;



% Spielbrett merken
PF_log_old_board = board;
PF_log_old_board(PF_log_old_board~=0) = NaN;

end

