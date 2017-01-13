function b = Bully(b,color,t)
r = randperm(numel(b));
b(r(1)) = color;
