function [ value_of_evaporation ] = ValueOfEvaporation(b,color)

b = b.*(b~=-color);
value_of_evaporation = 16-sum(sum(b(3:6,3:6)));

% mask = [ 1  1  1  1  1  1  1  1; ...
%       1  1  1  1  1  1  1  1; ...
%       1  1  0  0  0  0  1  1; ...
%       1  1  0  0  0  0  1  1; ...
%       1  1  0  0  0  0  1  1; ...
%       1  1  0  0  0  0  1  1; ...
%       1  1  1  1  1  1  1  1; ...
%       1  1  1  1  1  1  1  1;];
% 
% b(b==-color)=0;
% value_off_evaporation = 1/abs(sum(sum(b-mask*color)));

% if (diff < 5)
% value_off_evaporation = 1;
% else
% value_off_evaporation = 0;
% end

end

