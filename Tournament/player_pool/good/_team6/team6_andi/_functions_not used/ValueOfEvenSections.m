function [ value_of_even_sections ] = ValueOfEvenSections(b)

%%%%%%%%%%%%%%%%%%%%%% function is not used! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% function was initially used in EvaluateBoard(), but did not improve our %
% player; intention: look for regions that correspond to the defined      %
% patterns and force the opponent to do the first move in an even section %
% at the end of the game; in this way we're probably doing the last       %
% important moves in the game.                                            %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % return value
    value_of_even_sections=0;
    
    % define patterns
    even_row_vector=[0 0];
    even_col_vector=[0;0];
    even_matrix=[0 0;0 0];
    
    % search for patterns in board
    
    for k=1:8
        for l=1:8
            if k<7 && l<7
                % pattern even_matrix
                act_matrix=b(k:k+1,l:l+1);
                if isequal(even_matrix, act_matrix)
                    value_of_even_sections=value_of_even_sections+1;                
                end
            end
            if l<7
                 % pattern even row vector
                 act_row_vector=b(k,l:l+1);
                 if isequal(even_row_vector, act_row_vector)
                     value_of_even_sections=value_of_even_sections+1;
                 end
            end
            if k<7
                % pattern even column vector
                act_col_vector=b(k:k+1,l);
                if isequal(even_col_vector, act_col_vector)
                    value_of_even_sections=value_of_even_sections+1;
                end
            end
        end
    end
end