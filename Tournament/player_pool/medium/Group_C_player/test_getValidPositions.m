%  @file test_getValidPositions.m
%  @brief Tests GC_getValidPositions() and one concurrent algorithm in their
%  complexity vs. disk density.
% 
%  More detailed description.
%  @author: Martin Becker
%  @date 2010-Dec-30
%  @callgraph
%  @callergraph
clear all; close all; clc;

% ------ settings -----------------------------------------
color=1;
kmax=1000;
show=0;
pset = [0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95];
% ---------------------------------------------------------

tp1=[];
tp2=[];
for p = pset;   % change disk density to have a look in scalability

    t1=0;
    t2=0;
    for numboards = 1:kmax              % repeat to make statistically significant

        % only fields where BOTH opponent and me is present are allowed.      
        mine_coord=[];
        opponent_coord=[];
        while (isempty(mine_coord) | isempty(opponent_coord))
            field = (rand(8)>p);            % me 
            field = field - (rand(8)>p);    % opp. Intersections are erasing themselves this way.

            [mine_coord_row, mine_coord_col] = find(field == color);
            [opponent_coord_row, opponent_coord_col] = find(field == -color);
            opponent_coord = [opponent_coord_row';opponent_coord_col']; % row 1: row coord, row 2: col coord.
            mine_coord = [mine_coord_row'; mine_coord_col']; 
        end
        
        if show
            figure('Name', 'Original Board');               
            GC_plotBoard(mine_coord, opponent_coord);
        end

        %% ALGO 1 UNDER TEST
        tic;    
        [possibleBoards,newdisks,numReversed] = GC_getValidPositions(field,1,1,'');
        t1 = t1 + toc;

        %% ALGO 2 UNDER TEST
        tic
        [possibleBoards,newdisks,numReversed] = GC_getValidPositions(field,1,1,'');
        t2 = t2 + toc;

        if show
            numPossibilities = size(possibleBoards,3);
            if (numel(possibleBoards)==0)
                numPossibilities = 0;
                warning('No Possibilities!');
            end
            for k = 1:numPossibilities
                figure('Name', ['Possibility ' num2str(k), ', ' num2str(numReversed(k)) ' reversed disks']);
                [mine_coord_row, mine_coord_col] = find(possibleBoards(:,:,k) == color);
                [opponent_coord_row, opponent_coord_col] = find(possibleBoards(:,:,k) == -color);
                opponent_coord = [opponent_coord_row';opponent_coord_col']; % row 1: row coord, row 2: col coord.
                mine_coord = [mine_coord_row'; mine_coord_col'];
                GC_plotBoard(mine_coord, opponent_coord, newdisks(:,k), [], '');
            end
        end

    end %for numboards
    tp1(end+1) = t1/kmax;
    tp2(end+1) = t2/kmax;
end %for p

thisfig=figure;
plot(pset,tp1, 'r-+', pset, tp2, 'b-+');
grid on;
legend('LGS', 'LGS');
xlabel('p [density]');
ylabel('avg. speed per board [sec]');
title(['scaling: algorithm execution time per call (' num2str(kmax) ' samples per point) vs. disk density/probability']);
print (thisfig , '-r300', '-dpng' , 'plot');

