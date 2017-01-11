function b = Maniac(b,color,t)
idx = find(b==0);
r = randperm(numel(idx));
b(idx(r(1))) = color;
