function [numturn gamestate] = PWND_getGamestate(board,boarders)
% Returns number of turn and gamestate as a string
% gamestate = {'opening','middle','endgame'}

numturn = sum(sum(board ~= 0))-3;

if numturn > boarders(2)
    gamestate = 'endgame';
    return
end
if numturn > boarders(1)
    gamestate = 'middle';
else
    gamestate = 'opening';
end