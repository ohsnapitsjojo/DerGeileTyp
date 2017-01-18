%% Test both of our negamax implementations for returning the same value for the score
% 
% expected result: values of val1 and val2 should be the same, the boards should also
% be equal
%
% fst, 06/25/2012 - TEST PASSED.

addpath('..')
addpath('../not_in_use')

s1 = 'O--OOOOX-OOOOOOXOOXXOOOXOOXOOOXXOOOOOOXX---OOOOX----O--X--------'; % black to move
s2 = '--OOO-------XX-OOOOOOXOO-OOOOXOOX-OOOXXO---OOXOO---OOOXO--OOOO--'; % black to move
s3 = '--XXXXX---XXXX---OOOXX---OOXXXX--OOXXXO-OOOOXOO----XOX----XXXXX-'; % white to move
s4 = '--O-X-O---O-XO-O-OOXXXOOOOOOXXXOOOOOXX--XXOOXO----XXXX-----XXX--'; % white to move

b = PWND_stringToBoard(s3);

[val1, b1] = PWND_negamax(b, 1, 6);
[val2, b2] = PWND_negamaxPruning(b, 1, -inf, inf, 6);

b

val1
b1

val2
b2
