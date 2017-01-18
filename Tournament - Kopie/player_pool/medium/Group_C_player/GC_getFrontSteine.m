% @brief Markiert Frontsteine der Farbe 'color' im Spielfeld.
% Frontsteine sind alle Steine, die Kontakt zu mindestens einem Leeren Feld
% haben.
% @author Martin Becker
% @date 2011-Jan-31
% @todo do without image processing toolbox depency! (nortuse imfilter())
function [b_front] = GC_getFrontSteine (b, color)
b_all = double(b~=0);

% 1) filter counts the neighbours.
filt = ones(3); filt(2,2)=0;
numMin = 8;

% use this instead of 1), if diagonally free fields do not count
% filt = [ 0 1 0;
%          1 0 1;
%          0 1 0];
% numMin = 4;

% count neighbours
b_front = imfilter(b_all,filt, 'replicate');

% remove opponent's
b_front = ((b_front < numMin) & (b==color));
end