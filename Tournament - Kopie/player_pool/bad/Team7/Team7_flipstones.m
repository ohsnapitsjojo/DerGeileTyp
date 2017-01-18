%%
%%  Revision 7
%   Date 2012-12-16 19:43
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% flipStones
% needed functions: searchFlipVector, flip
% input playground, moveField, color
% output: newPlayground
%
% calls searchFlipVector and flip 
% -> flips stones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function newPlayground = flipStones(playgroundEdge, moveField, color)

    newPlayground = playgroundEdge;
      
    % 123
    % 4X5
    % 678
    
    s{1} = [-1 -1];
    s{2} = [-1 0];
    s{3} = [-1 1];
    s{4} = [0 -1];
    s{5} = [0 1];
    s{6} = [1 -1];
    s{7} = [1 0];  
    s{8} = [1 1];
    
    player = color;
    enemy = -player;
    
    for i=1:8
        if(moveField+s{i} == enemy)
                flipVector = searchFlipVector(playground, moveField, s{i});
            if(size(flipVector, 1) > 0)
                newPlayground = flip(flipVector, newPlayground);
            end
        end
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% searchFlipVector
% needed functions: none
% input: playground, start (new stone), step (vector direction)
% output: flipVector
%
% searches if a vector of stones can be flipped
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function flipVector = searchFlipVector(playground, start, step)

    start = start + step;
    
    player = playground{start};
    enemy = -player;
    
    flipVector = [];
    
    for i = 1:8
    
        if(playground{start+step} == enemy)
            start = start + step;
            flipVector = [flipVector; start]; 
        end
        if(playground{start+step} == player)
            break;
        end
        if(playground{start+step} == 3 || playground{start+step} == 0)
            flipVector = [];
            break;
        end
        
    end   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% flip
% needed functions: none
% input flipVector, playgroundIn
% output: new Playground
%
% flippes the stones in flipVector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function newPlayground = flip(flipVector, playgroundIn)

    newPlayground = playgroundIn;
    for i = 1:size(flipVector, 1)
        newPlayground(flipVector(i,:)) = newPlayground(flipVector(i,:)) * -1;
    end

end


