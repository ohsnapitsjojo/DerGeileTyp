function [M N] = PWND_frontierDisks(b, color)
% calculates the frontier disks of the given color, this function can be used
% for two purposes: on
%
% see http://radagast.se/othello/Help/strategy.html for a detailed explanation why these
% are important;
% we use this information as an approximation of the total mobility that would involve
% a lot of calls to findAllowedPositions() which is rather expensive
%
% fst, works like a charme, 06/21/2012
M = [];
N = [];

filter = ones(3);
filter(2,2) = 0;

% bad idea as this would involve counting neighbouring discs
% several times
%b_padded = [zeros(1,10);
%         zeros(8,1) b zeros(8,1);
%         zeros(1,10)];

%for ii = 1:size(idx_m, 1)
%  num = num + (8 - sum(sum(b_padded(idx_m(ii):idx_m(ii)+2,idx_n(ii):idx_n(ii)+2) & filter)));
%end

% instead, use the Computer Vision way of life...
b_only_me = b;
b_only_me(b_only_me ~= color) = 0;
b_conv = conv2(b_only_me, filter, 'same');
b_conv(b_conv ~= 0) = 1;
%   b_conv(find(b == -color)) = 0;  % find is not necessary here
%   b_conv(find(b == color)) = 0;
b_conv( b == -color ) = 0;
b_conv( b == color ) = 0;

[M N] = find(b_conv ~= 0);
end