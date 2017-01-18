
% #########################################################################
% continueSearching:
% Input: playground, moveField, searchingPos, color, tmpTurnVec
                    %continueSearching Input: 
                    %           playground = tmpPlayground
                    %           moveField = tmpGameMatrix(k,:)
                    %           searchingPos = One position of playground
                    %           around a currently inspected one
                    %      
                    %           tmpcolor = 1 oder 2
                    %           tmpTurnvec = [0;0]
% Output: global Value turnVec
% ######################################################################
function continueSearching(playground, moveField, searchingPos, color, tmpTurnVec)

    global turnVec;

    sy = searchingPos(1) - moveField(1);
    sx = searchingPos(2) - moveField(2);


    tmpTurnVec(1,1) = searchingPos(1);
    tmpTurnVec(1,2) = searchingPos(2);

    % as long as the current field and its neighbors are not our color and are not 0 do:
    while ( (playground(searchingPos(1),searchingPos(2)) ~= color) && (playground(searchingPos(1),searchingPos(2)) ~= 0) )
        
        % add sy/sx to searching pos
        searchingPos(1) = searchingPos(1) + sy;
        searchingPos(2) = searchingPos(2) + sx;

        % break, if edge of playground was reached!
        if ((searchingPos(1) > 8) || (searchingPos(2) > 8) || (searchingPos(1) < 1) || (searchingPos(2) < 1))
            break
        end

        % extend tempTurnVec with new found positions, that have to be
        % turned
             
        if ((playground(searchingPos(1),searchingPos(2)) ~= color) && (playground(searchingPos(1),searchingPos(2)) ~= 0))
            tmpTurnVec(end+1,:) = [searchingPos(1) searchingPos(2)];
        end
    end

    % boundary check, that the coordinates in searchingPos are between 0
    % and 8 and, most importantly, that the final val in searchingPos is of
    % our own color, so that we respect the basic principle of the game to
    % only turn enemy stones between an old stone and a newly set stone
    if ((searchingPos(1) < 9) && (searchingPos(2) < 9)) && ((searchingPos(1) > 0) && (searchingPos(2) > 0)) && ( playground(searchingPos(1),searchingPos(2)) == color )
        % simply append tmpTurnVec at global turnVec!
        turnVec = [turnVec; tmpTurnVec];
    end

end
