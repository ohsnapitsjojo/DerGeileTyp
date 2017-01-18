function value = PWND_valueBoard(be, col)
% This function sums up the weights of all possessed fields.
% Therfore, a specific weight is added to every field of the board in advance, 
% whereas the weight of some fields can be changed adaptively.

%% Simple weighting all positions of the board
M =     [ 10000     -900     100     80     80      100     -900     10000;
           -900     -800     -45    -50    -50      -45     -800      -900;
            100      -45       4      1      1        4      -45       100;
             80      -50       1      5      5        1      -50        80;
             80      -50       1      5      5        1      -50        80;
            100      -45       4      1      1        4      -45       100;
           -900     -800     -45    -50    -50      -45     -800      -900;
          10000     -900     100     80     80      100     -900     10000;  ];     

%% Modify the weights of the board above...
%... if upper left corner is already possessed
if(be(1,1)==col)
    M(2,1)=7500;
    M(1,2)=7500;
    M(2,2)=8500;
end

%... if upper right coner is already possessed
if(be(1,8)==col)
    M(1,7)=7500;
    M(2,8)=7500;
    M(2,7)=8500;
end

%... if lower left corner is already possessed
if(be(8,1)==col)
    M(7,1)=7500;
    M(8,2)=7500;
    M(7,2)=8500;
end

%... if lower right corner is already possessed
if(be(8,8)==col)
    M(7,8)=7500;
    M(8,7)=7500;
    M(7,7)=8500;
end

%% Summing up the weights of all possessed fields
value = sum(M(be==col));
