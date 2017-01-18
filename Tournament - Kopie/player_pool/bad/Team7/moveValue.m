
%#######################################################################
% Inputvalues: playground, moveField, color
% 
% What is moveField: tmpGameMatrix(k,:) from mainfunction. Its called when
% we do not have enough time to execute minmax()
% 
% global turnVec is set in function continueSearching and at the end 
%turnK = turnVec; is returned from the Function moveValue!
%
% return Value of moveValue = turnK = turnVec
%#####################################################################

function turnK = moveValue(playground, moveField, color)
    global turnVec;
    global currentMove;


    % from tmpGameMatrix(k,:) the first indices are loaded into x and y:
    x = moveField(1,2);
    y = moveField(1,1);
    
    % initialize searchingPos and tmpTurnVec
    searchingPos = zeros(1,2);
    tmpTurnVec = zeros(1,2);

    % search around one Place of Field and give back a turnVec
    for i = -1:1:1
        for k = -1:1:1
            % check if field is on the playground:
            if ( ( y + k ) < 9 ) && ( ( y + k ) > 0) && ( ( x + i ) < 9) && ( ( x + i ) > 0 )
                
                % check for enemystones on playground = tmpPlayground:
                if((playground(y+k,x+i) ~= 0) && (playground(y+k,x+i) ~= color))
                    searchingPos(1) = y+k;
                    searchingPos(2) = x+i;
                    
                    %continueSearching Input: 
                    %           playground = tmpPlayground
                    %           moveField = tmpGameMatrix(k,:)
                    %           searchingPos
                    %           tmpcolor = 1 oder 2
                    %           tmpTurnvec = [0;0]
                    continueSearching(playground, moveField, searchingPos, color, tmpTurnVec);
                    % Output of continueSearching is the calculated global
                    % turnVec
                end
            end
        end
    end


    currentMove(end+1,1) = size(turnVec,1);
    
% turnVec is saved in returnvalue turnK
    turnK = turnVec;

% turnVec is set to empty
    turnVec = [];
    return
end

