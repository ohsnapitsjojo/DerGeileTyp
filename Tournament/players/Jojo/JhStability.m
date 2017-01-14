function [ stability ] = JhStability( b,color )

aMap =[1000 -300 100 80 80 100 -300 1000;
    -300 -500 -45 -50 -50 -45 -500 -300;
    100 -45 3 1 1 3 -45 100;
    80 -50 1 5 5 1 -50 80;
    80 -50 1 5 5 1 -50 80;100 -45 3 1 1 3 -45 100;
    -300 -500 -45 -50 -50 -45 -500 -300;
    1000 -300 100 80 80 100 -300 1000];

   

    opponent = -1*color;
    
    stabilityPlayer = sum(aMap(b==color));
    stabilityOpponent = sum(aMap(b==opponent));
    totalStability = abs(stabilityPlayer + stabilityOpponent);
    
    if totalStability ~= 0
      stability = 100 * (stabilityPlayer - stabilityOpponent)/totalStability;
  
    else
        stability = 0;
    end


end

