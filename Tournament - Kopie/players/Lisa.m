%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Projektkurs Matlab WS 2011/12, Lehrstuhl fuer Datenverarbeitung
% ===============================================================
%
% Programmierprojekt Othello-Spieler
% 
% Gruppe B: Chau, Huy
%           Dietmannsberger, Markus
%           Goetz, Christoph
%           Schulze, Simon
%           Wagner, Anton              
%
% Datei:        Lisa.m
% Beschreibung: 
% Autor:        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function new_board = Lisa(board,farbe,time)
    addpath(['players' filesep 'Lisa']);
    % Ausfuehren des Zugs
    new_board = lisa_management(board,farbe,time);
    % =====================================================================
end

