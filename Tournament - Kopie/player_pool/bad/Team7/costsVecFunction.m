%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input: current last layer and team color
%
%
%
% following function descriptions needed: 
%   fieldDeallocation()
%   flipStones
% what does tmpGameMatrix do?
%
%
%
% output: sum of costs aka costsVec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function costs = costsVecFunction(playground,player)
        

        
        % very important! defines draw Strategy which edges/corners have
        % more weight

        a = 1;
        b = 3; 
        c = 6;
              
        d = 25;
        e = 20;
        f = 20;
        g = 15;
        
        h = -15;
        i = -11;
        j = -11;
        k = -9;
        

        % costs lookup table
        evaluationMatrix = [    d  h  c  b  b  c  i  e ;
                                h  h  a  a  a  a  i  i ;
                                c  a  a  a  a  a  a  c ;
                                b  a  a  a  a  a  a  b ;
                                b  a  a  a  a  a  a  b ;
                                c  a  a  a  a  a  a  c ;
                                k  k  a  a  a  a  j  j ;
                                g  k  c  b  b  c  j  f];
                              
        
        % find coordinates of own stones   
        playground
        size(playground)
        index=find(playground(:,:,end)==player);
        evaluationMatrixVector = evaluationMatrix(:);
        
        % sum up costs
        costs = 0;
        for i =1:length(index)
           costs = costs + evaluationMatrixVector(index(i));
        end

        return
end
