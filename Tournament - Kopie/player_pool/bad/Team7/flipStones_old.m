
function tmpPlayground = flipStones_old(playground, moveField, color)

    % will be used in other functions, so we made it global, contains all
    % indices of playground that have to be flipped in the end
    global turnVec;
    turnVec=[];
    % get final move values
    x = moveField(1,2);
    y = moveField(1,1);
    
    % temp vectors
    searchingPos = zeros(1,2);
    tmpTurnVec = zeros(1,2);

    % i and k are offsets for indices in order to address the current
    % playground file and all its neighbors: currentField([-1,0,1][-1,0,1])
    for i = -1:1:1
        for k = -1:1:1
            % if index with offset is in a valid range [0-8][0-8] than do:
            if ( ( y + k ) < 9 ) && ( ( y + k ) > 0) && ( ( x + i ) < 9) && ( ( x + i ) > 0 )
                % if current field value is not 0 and not our own color
                % it must be an enemy stone 
                if( (playground( y + k , x + i) ~= 0) && ( playground ( y + k , x + i ) ~= color ) )
                    % store this index in searchingPos vector and give it
                    % to fnc continueSearching
                    searchingPos(1) = y + k;
                    searchingPos(2) = x + i;
                    % continueSearching will put coordinates into the
                    % global turnVector
                    continueSearching(playground, moveField, searchingPos, color, tmpTurnVec);
                end
            end
        end
    end

    % finally flip the stones, it means set our color on all points in the
    % playground, whose indices/coordinates are listed in turnVec
    for l = 1:size(turnVec,1)
        playground(turnVec(l,1), turnVec(l,2)) = color;
    end


    tmpPlayground = playground;

    turnVec = [];

end
