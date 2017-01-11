%  @file test_queryDictionary.m
%  @brief Tests GC_queryDictionary().
% 
%  @author: Martin Becker
%  @date 2011-Jan-06
%  @callgraph
%  @callergraph
clear all; close all; clc;

color = 1; 

% board = zeros(8);    
% board(4:5,4:5) = [ 1 , -1;   
%                   -1 ,  1];

board = zeros(8);    
board(4:6,4:5) = [ 1 , -1;   
                  -1 , -1
                   0 , -1 ];
               
GC_plotWrapper(board, 'Board');

[goodMoves, badMoves] = GC_queryDictionary(board, color, 1);




