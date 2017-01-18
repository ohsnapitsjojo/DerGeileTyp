function [ value_of_evaporation ] = ValueOfEvaporation(b,color)

%%%%%%%%%%%%%%%%%%%%%% function is not used! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
% function was initially used in EvaluateBoard(), but did not improve our%
% player; intention: calculate evaportaion and add to value of board;    %
% function was used to increase our mobility at the beginning of the game%
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create new board
b = b.*(b~=-color);
% value_of_evaporation = 16-sum(sum(b(3:6,3:6)));

mask = [ 1  1  1  1  1  1  1  1; ...
         1  1  1  1  1  1  1  1; ...
         1  1  0  0  0  0  1  1; ...
         1  1  0  0  0  0  1  1; ...
         1  1  0  0  0  0  1  1; ...
         1  1  0  0  0  0  1  1; ...
         1  1  1  1  1  1  1  1; ...
         1  1  1  1  1  1  1  1;];

b(b==-color)=0;

% calculate value_of_evaporation
value_of_evaporation = 1/abs(sum(sum(b-mask*color)));

end

