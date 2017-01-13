function [ stability ] = hStability( b,color )
%% TODO implement
    % Es gibt nur positive stability Werte
    load('Accountability.mat');
    opponent = -1*color;     
    stabilityPlayer = sum(aMap(find(b==color)));
    stabilityOpponent = sum(aMap(find(b==opponent)));
    
    totalStability = stabilityPlayer + stabilityOpponent;
    
    diffStability = stabilityPlayer-stabilityOpponent;
    stability = 100*diffStability/totalStability;

end

