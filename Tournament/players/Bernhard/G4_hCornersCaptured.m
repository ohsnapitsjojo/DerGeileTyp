function [ cornersCaptured ] = G4_hCornersCaptured(b, color )
% Berechnet die Corners Captured Heueristic
    corners=[b(1,1) b(1,8) b(8,1) b(8,8)];
    playerCorners= length(find(corners==color));
    opponentCorners=length(find(corners== -1*color));
    if playerCorners+opponentCorners ~= 0
        cornersCaptured=100*(playerCorners-opponentCorners)/(playerCorners+opponentCorners);
    else
        cornersCaptured = 0;
    end
end
