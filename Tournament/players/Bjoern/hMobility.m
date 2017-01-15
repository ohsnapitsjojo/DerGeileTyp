function [ mobility ] = hMobility( b, color )
% Berechnet den wert der Mobility Heueristic
% Best case 100 
% Worst cast -100
    opponent = color*-1;
    if length(allPossible(b,opponent))~=0
        mobility=100/length(allPossible(b,opponent));
    else
        mobility=0;
    end
    %mobilityPlayer = length(allPossible(b,color));
    %mobilityOpponent = length(allPossible(b,opponent));
    
        %mobility = 100*(mobilityPlayer-mobilityOpponent)/(mobilityPlayer+mobilityOpponent);
end

