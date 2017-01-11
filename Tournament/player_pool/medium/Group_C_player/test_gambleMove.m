% @file test_gambleMove.m
% @brief Tests the random selection routine for the dictionary. When more than one
% good move is known, out of the set of good moves ONE is selected, whereas
% the chance for a particular move to be selected should raise with the
% number of points this move can offer. This script computes a probabilty
% density function (pdf) for a set of good moves and compares the density
% vs. the score of each particular move. The goal is that they correlate
% somehow.

clear all; close all; clc;

disp('Loading dict...');
load Logistello_book_1999.wtb.mat   % loads cell array moveList(1...k,4).

% an example sequence to match
thisSeq = GC_transposeSequence('c4e3f6c5','f5')

% actual matching.
disp('Matching a sequence...');
idx=(not(cellfun(@isempty, regexp(moveList(:,4),['^' thisSeq '.+']))));
matchList = moveList(idx,:);

% grep good ones
idx_good = ((cellfun(@max, matchList(:,3)))>31);
idx_bad  = not(idx_good);

numGood = sum(idx_good);

if numGood
    
    disp('Sequence has good posts, building statistics...');
    matchList_good=matchList(idx_good,:);
        
    % do sorting. This eases the evaluation of the pdf.
    disp('Sorting to make life easier...');
    points = cell2mat(matchList_good(:,3));
    [points,sortidx] = sort(points);
    matchList_good=matchList_good(sortidx,:); 

    %probabilty density function, will be filled in 
    pdf = zeros(numGood,1);    
    
    MAXGAMBLES = 100;
    tic;
    for k=1:MAXGAMBLES        
       i_sel = GC_gambleMove(matchList_good);
       pdf(i_sel) = pdf(i_sel)+1;  
    end
    toc;
    
    pdf = pdf / MAXGAMBLES;   % normalize
    
    fig=figure;
    [AX,H1,H2] = plotyy(1:numGood,pdf,1:numGood,points,'bar','plot');
    set(H2,'LineStyle','--', 'Color', 'r', 'LineWidth' ,2);
    xlabel('move index');
    ylabel('probability of selection');
    title(['probability density of the good moves, ' num2str(MAXGAMBLES) ' draws.']);
    axes(AX(2))
    set(AX(2), 'YColor','r');
    ylabel('points of the move');

    
    print (fig , '-r300', '-dpng' , 'pdf_select_good_moves');
else
    disp('This sequence has no known good postdecessors!');
end