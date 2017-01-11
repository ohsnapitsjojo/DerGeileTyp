function value_of_board = ValueOfBoard(b,color)

%% Define Look-Up-Tabel for the board to improve the result

% global number_of_turns
% 
% if(number_of_turns>12&&number_of_turns<46)
%  % Weighting of board positions according to http://othellomaster.com/OM/Report/HTML/report.html
% weighted_board=[20000     -2000     5000     800     800      5000     -2000      20000;
%                 -2000     -3000     450      500     500      450     -3000      -2000;
%                  5000     450       -300    -300    -300      -300      450       5000;
%                   800     500       -300    -500    -500      -300      500        800;
%                   800     500       -300    -500    -500      -300      500        800;
%                  5000     450       -300    -300    -300      -300      450       5000;
%                 -2000     -3000     450      500     500      450     -3000      -2000;
%                 20000     -2000     5000     800     800      5000     -2000      20000;];    
% else
%  % Weighting of board positions according to http://othellomaster.com/OM/Report/HTML/report.html
% weighted_board=[10000     -3000     1000     800     800      1000     -3000      10000;
%                 -3000     -5000     -450    -500    -500      -455     -5000      -3000;
%                  1000      -450       30      10      10        30      -450       1000;
%                   800      -500       10      50      50        10      -500        800;
%                   800      -500       10      50      50        10      -500        800;
%                  1000      -450       30      10      10        30      -450       1000;
%                 -3000     -5000     -450    -500    -500      -455     -5000      -3000;
%                 10000     -3000     1000     800     800      1000     -3000      10000;];  
% end

% Weighting of board positions according to http://othellomaster.com/OM/Report/HTML/report.html
weighted_board=[10000     -3000     1000     800     800      1000     -3000      10000;
                -3000     -5000     -450    -500    -500      -455     -5000      -3000;
                 1000      -450       30      10      10        30      -450       1000;
                  800      -500       10      50      50        10      -500        800;
                  800      -500       10      50      50        10      -500        800;
                 1000      -450       30      10      10        30      -450       1000;
                -3000     -5000     -450    -500    -500      -455     -5000      -3000;
                10000     -3000     1000     800     800      1000     -3000      10000;];
   
% Modification of weights if a corner is occupied by us
if(b(1,1)==color)
    weighted_board(2,1)=7500;
    weighted_board(1,2)=7500;
    weighted_board(2,2)=8500;
elseif(b(1,8)==color)
    weighted_board(1,7)=7500;
    weighted_board(2,8)=7500;
    weighted_board(2,7)=8500;
elseif(b(8,1)==color)
    weighted_board(7,1)=7500;
    weighted_board(8,2)=7500;
    weighted_board(7,2)=8500;
elseif(b(8,8)==color)
    weighted_board(7,8)=7500;
    weighted_board(8,7)=7500;
    weighted_board(7,7)=8500;
end

% %% Versuch
% if(b(1,2)==color||b(2,1)==color)
%     weighted_board(1,1)=weighted_board(1,1)*10;
% elseif(b(7,1)==color||b(8,2)==color)
%     weighted_board(1,8)=weighted_board(1,8)*10;
% elseif(b(1,7)==color||b(2,8)==color)
%     weighted_board(8,1)=weighted_board(8,1)*10;
% elseif(b(7,8)==color||b(8,7)==color)
%     weighted_board(8,8)=weighted_board(8,8)*10;
% end

% if(b(1,1)==color)
%     weighted_board(2,1)=-weighted_board(2,1);
%     weighted_board(1,2)=-weighted_board(1,2);
%     weighted_board(2,2)=-weighted_board(2,2);
% elseif(b(1,8)==color)
%     weighted_board(1,7)=-weighted_board(1,7);
%     weighted_board(2,8)=-weighted_board(2,8);
%     weighted_board(2,7)=-weighted_board(2,7);
% elseif(b(8,1)==color)
%     weighted_board(7,1)=-weighted_board(7,1);
%     weighted_board(8,2)=-weighted_board(8,2);
%     weighted_board(7,2)=-weighted_board(7,2);
% elseif(b(8,8)==color)
%     weighted_board(7,8)=-weighted_board(7,8);
%     weighted_board(8,7)=-weighted_board(8,7);
%     weighted_board(7,7)=-weighted_board(7,7);
% end

% if (b(1,1)==color&&b(2,2)==color&&b(3,3)==color&&b(4,4)==color&&b(5,5)==color&&b(6,6)==color) weighted_board(7,7) = 8000; end
% if (b(8,8)==color&&b(2,2)==color&&b(3,3)==color&&b(4,4)==color&&b(5,5)==color&&b(6,6)==color) weighted_board(7,7) = 8000; end
% if (b(1,8)==color&&b(2,7)==color&&b(3,6)==color&&b(4,5)==color&&b(5,4)==color&&b(6,3)==color) weighted_board(7,2) = 8000; end
% if (b(8,1)==color&&b(2,7)==color&&b(3,6)==color&&b(4,5)==color&&b(5,4)==color&&b(6,3)==color) weighted_board(7,2) = 8000; end

%%% copy paste
% 
% %cornerstone
%         if (ii==1&&jj==1 || ii==8&&jj==8 || ii==1&&jj==8 || ii==8&&jj==1)&& b(ii,jj)==color
%             value = value + abs(b(ii,jj)*3*weight); 
%                             
% 	%x und c Felder (insgesamt 12)negativ bewerten 
%         elseif (ii==1&&(jj==2||jj==7)...
%               ||ii==2&&(jj==1||jj==2||jj==7||jj==8)...
%               ||ii==7&&(jj==1||jj==2||jj==7||jj==8)...
%               ||ii==8&&(jj==2||jj==7))...
%               && b(ii,jj)==color
%               
%           value = value - abs(b(ii,jj)*2*weight);
%                 
%             
% 	%edgestone without cornerstone set
%         elseif    (b(1,1)&&b(1,8)==1&&ii==1&&jj>2||jj<7 ...
%                 || b(1,8)&&b(8,8)==1&&jj==8&&ii>2||ii<7 ...
%                 || b(8,8)&&b(8,1)==1&&ii==8&&jj>2||jj<7 ...
%                 || b(8,1)&&b(1,1)==1&&jj==1&&ii>2||ii<7)...
%                 && b(ii,jj)==color
%             
%             value = value + abs(b(ii,jj)*2*weight);
%         	
% 	
% 	%edgestone with cornerstone set
%         elseif    (b(1,1)&&b(1,8)==color&&ii==1 ...
%                 || b(1,8)&&b(8,8)==color&&jj==8 ...
%                 || b(8,8)&&b(8,1)==color&&ii==8 ...
%                 || b(8,1)&&b(1,1)==color&&jj==1)...
%                 && b(ii,jj)==color
%             
%             value = value + abs(b(ii,jj)*2*weight);
% 	
% 	
% 	
%         else
%             value2 = value2 + b(ii,jj);
%         end
%         
%         %%%%



% Summarize of alle weights
value_of_board = sum(weighted_board(b==color));
