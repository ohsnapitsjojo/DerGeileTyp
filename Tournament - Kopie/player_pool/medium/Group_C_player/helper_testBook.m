% @file helper_testBook.m
% @brief trying to read out own book format
% @author Martin Becker
% @date 2011-Jan-14
clc;
close all;
clear all;

% we have a size limitation: max 2MB for all the code. Using approx. 1.5MB
% here with the Logistello Book.
tic;
disp('Loading dict...');
load Logistello_book_1999.wtb.mat; 
toc

thisSeq = 'f5d6c4g5c6c5d7d3b4c3e3';

matchList = [];
numMatches = 0;
maxNumMatches = 1000;

tic;
disp('Searching matches...');
idx=(not(cellfun(@isempty, regexp(moveList(:,4),['^' thisSeq '.*']))));

% matching time is reasonable. takes about one second to find all boards
% out of ~220k.
% cutoff number of matches
if sum(idx) > maxNumMatches
    disp('Too many matches, limiting.');
    idx = find(idx == 1,maxNumMatches);
end

% get matches
matchList = moveList(idx,:);
numMatches = size(matchList,1)

t_read = toc

disp(['Got ' num2str(numMatches) ' matching games isolated to variable "matchList".']);

