%  @file test_thinktime.m
%  @brief Tests if there is a connection between searchtime and number of
%  free fields.
% 
%  More detailed description.
%  @author: Martin Becker
%  @date 2011-Jan-29
%  @callgraph
%  @callergraph
clear all; close all; clc;

% ------ settings -----------------------------------------
color=1;
kmax=3;   % number of boards per density
show=0;
pset = [0.05 0.1 0.2 0.3 0.4 0.5]; % percentage of occupied fields per color
depths = [1:7];
% ---------------------------------------------------------

tp1=[];
tp2=[];
results = zeros(depths,numel(pset)*kmax,2);
hw = waitbar(0,'testing...');

maxcases = numel(depths)*numel(pset);

for d = depths
            
    c = 0;
    for p = pset;   % change disk density to have a look in scalability  
        numcases = ((d-1)*numel(pset))+p;
        waitbar(numcases/maxcases);        

        disp(['depth=' num2str(d) ', density=' num2str(p)]);
        for numboards = 1:kmax              % repeat to make statistically significant
            c = c+1;

            % only fields where BOTH opponent and me is present are allowed.      
            mine_coord=[];
            opponent_coord=[];
            while (isempty(mine_coord) || isempty(opponent_coord))
                field = (rand(8)>p);            % me 
                opp = rand(8)>p;
                
                % NON-Erasing addup!!!
                opp = opp &~ field;                              
                field = field - opp;    % opp. Intersections are erasing themselves this way.
               
                [mine_coord_row, mine_coord_col] = find(field == color);
                [opponent_coord_row, opponent_coord_col] = find(field == -color);
                opponent_coord = [opponent_coord_row';opponent_coord_col']; % row 1: row coord, row 2: col coord.
                mine_coord = [mine_coord_row'; mine_coord_col']; 

                numFree = sum(sum(field==0));
            end

            tic;    
                GC_AlphaBetaWhite(field,-Inf,Inf,d, 3, '');
            t1 = toc;

            results(d,c,1) = numFree;
            results(d,c,2) = t1;

        end %for numboards
    
    end %for p  
end

close(hw);

thisfig=figure;
ltext='';
% colors
ColorSet = [
	0.00  0.00  1.00
	0.00  0.50  0.00
	1.00  0.00  0.00
	0.00  0.75  0.75
	0.75  0.00  0.75
	0.75  0.75  0.00
	0.25  0.25  0.25
	0.75  0.25  0.25
	0.95  0.95  0.00
	0.25  0.25  0.75
	0.75  0.75  0.75
	0.00  1.00  0.00
	0.76  0.57  0.17
	0.54  0.63  0.22
	0.34  0.57  0.92
	1.00  0.10  0.60
	0.88  0.75  0.73
	0.10  0.49  0.47
	0.66  0.34  0.65
	0.99  0.41  0.23
];
set(gca, 'ColorOrder', ColorSet);
set(gca,'LineStyleOrder', '-o')
hold all;
for k = depths
    
    % sort by num free
    [freeOnes,idx]=sort(results(k,:,1));
    times = results(k,idx,2);
    plot(freeOnes,times);
    if (isempty(ltext))
        ltext = ['''depth=' num2str(k) ''''];
    else
        ltext = [ltext ',''depth=' num2str(k) ''''];
    end
end
set(gca, 'YScale','log');
%print (thisfig , '-r300', '-dpng' , 'plot');
eval(['legend(' ltext ')']);
xlabel('number of free fields');
ylabel('think time [sec]');
title(['Think time vs. disk density/probability for different depths']);


