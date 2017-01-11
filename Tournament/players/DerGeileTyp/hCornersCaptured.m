function [ cornersCaptured ] = hCornersCaptured(b, color )
% Berechnet die Corners Captured Heueristic
corners=[b(1,1) b(1,8) b(8,1) b(8,8)];
playerCorners= length(find(corners==color));
opponentCorners=length(find(corners== -1*color));
%nCornersCaptured = b(1,1).^2+b(1,8).^2+b(8,1).^2+b(8,8).^2;
if playerCorners+opponentCorners ~= 0
    cornersCaptured=100*(playerCorners-opponentCorners)/(playerCorners+opponentCorners);
else
    
    cornersCaptured = 0;
end
        
%   if  nCornersCaptured ~= 0 
%         cornersCaptured = 100*(b(1,1)*color+b(1,8)*color+b(8,1)*color+b(8,8)*color)/nCornersCaptured;
%         %FROMEL 100*(playerCorner-opponentCorners)/nCornersCaptured
%     else
%         cornersCaptured = 0;
%     end
end
