%% Simple Tests for checking PWND_findAllowedPositions or PWND_PWND_makeMove
%
%
% fst, 06/15/2012



A = zeros(8,8);
B = zeros(8,8);
C = zeros(8,8);
D = zeros(8,8);


A(4,4) = 1;
A(4,5) = -1;
A(5,4) = -1;
A(5,5) = 1;

B(4,3) = 1;
B(5,3) = 1;
B(6,3) = 1;
B(3,4) = -1;
B(4,4) = -1;
B(5,4) = 1;
B(4,5) = 1;
B(5,5) = -1;

%sol_B

C(4,3) = -1;
C(5,3) = -1;
C(4,4) = -1;
C(5,5) = -1;
C(4,6) = -1;
C(5,6) = -1;
C(6,6) = -1;
C(3,4) = 1;
C(5,4) = 1;
C(6,4) = 1;
C(4,5) = 1;
C(3,6) = 1;

sol_C = [2 3; 2 4; 2 5; 2 6; 3 5; 6 5; 7 3; 7 4; 7 5];

D(2,3) = -1;
D(4,3) = -1;
D(4,6) = -1;
D(5,7) = -1;
D(6,6) = -1;
D(7,5) = -1;

D(3,3) = 1;
D(3,4) = 1;
D(3,5) = 1;
D(3,6) = 1;
D(4,4) = 1;
D(4,5) = 1;
D(5,4) = 1;
D(5,5) = 1;

sol_D = [2 2; 2 4; 2 5; 2 6; 5 6; 6 4; 6 5];


%idx = PWND_findAllowedPositions(A, 1)

%idx = PWND_findAllowedPositions(B, -1)

%tic;
%idx = PWND_findAllowedPositions(C, -1)
%toc

% tic;
% PWND_findAllowedPositions(D, -1)
% t1=toc


