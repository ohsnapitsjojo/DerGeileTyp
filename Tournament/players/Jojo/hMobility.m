function [ mobility ] = hMobility( b, color )
% Berechnet den wert der Mobility Heueristic
% Best case 100 
% Worst cast -100
    opponent = color*-1;
    
    
    
    mobilityPlayer = length(allPossible(b,color));
    mobilityOpponent = length(allPossible(b,opponent));
    
    if (mobilityPlayer + mobilityOpponent) ~= 0
        mobility = 100*(mobilityPlayer-mobilityOpponent)/(mobilityPlayer+mobilityOpponent);
    else
        mobility = 0;
    end
end

