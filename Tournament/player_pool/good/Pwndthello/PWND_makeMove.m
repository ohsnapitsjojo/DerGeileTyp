function [A, changed] = PWND_makeMove(b,color,m,n)
% Stefan/Claudius 
% status: detects invalid moves. works fine. tested. (24.05.12 17:20)
% update(Ferdl, 5.6.12, 00.51): enables field position input as matrix 

%% treat m as a vector and ignore n
if nargin < 4
    % is m is a matrix, choose an arbitrary row
    if ~isempty(m) && size(m,2) > 1
       idx = randi(size(m,1),1); % ???
       n = m(idx,2);
       m = m(idx,1);
    elseif ~isempty(m)
       n = m(2);
       m(2) = [];
    else
        error('Error: input m is empty');
    end
end

%% pre-assignment of result table 'A'
A = b;
changed = 1;

%% search direction: right/east
k = n+1;

while k < 8 && b(m,k) == -color
    % check stone next to it, if own color change all stones up to this one
    if b(m,k+1) == color 
        A(m,n:k) = color;
        break; 
    elseif b(m,k+1) == 0
        break;    
    end
    % perform the same for next stone with different color
    k = k+1;
end

%% search direction: left/west
k = n-1;

while k > 1 && b(m,k) == -color
    % check stone next to it, if own color change all stones up to this one
    if b(m,k-1) == color 
        A(m,k:n) = color; % index swapping (left to right)
        break; 
    elseif b(m,k-1) == 0
        break;    
    end
    % perform the same for next stone with different color
    k = k-1;
end

%% search direction: down/south
k = m+1;

while k < 8 && b(k,n) == -color
    % check stone next to it, if own color change all stones up to this one
    if b(k+1,n) == color 
        A(m:k,n) = color;
        break; 
    elseif b(k+1,n) == 0
        break;    
    end
    % perform the same for next stone with different color
    k = k+1;
end

%% search direction: up/north
k = m-1;

while k > 1 && b(k,n) == -color
    % check stone next to it, if own color change all stones up to this one
    if b(k-1,n) == color 
        A(k:m,n) = color; % index swapping (up to down)
        break; 
    elseif b(k-1,n) == 0
        break;    
    end
    % perform the same for next stone with different color
    k = k-1;
end

%% search direction: south-east
k = m+1;
l = n+1;
z = 0;

while k < 8 && l < 8 && b(k,l) == -color
    % check stone next to first neighbour, if own color change all stones
    % including current move
    z = z+1; % enemy stones to be flipped
    if b(k+1,l+1) == color
        while z >= 0
         A(m+z,n+z) = color;
         z = z-1;   
        end
        break; 
    elseif b(k+1,l+1) == 0
        break;    
    end
    % perform the same for next stone with different color
    k = k+1;
    l = l+1;
end

%% search direction: north-west
k = m-1;
l = n-1;
z = 0;

while k > 1 && l > 1 && b(k,l) == -color
    % check stone next to first neighbour, if own color change all stones
    % including current move
    z = z+1; % enemy stones to be flipped
    if b(k-1,l-1) == color
        while z >= 0
         A(m-z,n-z) = color;
         z = z-1;   
        end
        break; 
    elseif b(k-1,l-1) == 0
        break;    
    end
    % perform the same for next stone with different color
    k = k-1;
    l = l-1;
end

%% search direction: north-east
k = m-1;
l = n+1;
z = 0;

while k > 1 && l < 8 && b(k,l) == -color
    % check stone next to first neighbour, if own color change all stones
    % including current move
    z = z+1; % enemy stones to be flipped
    if b(k-1,l+1) == color
        while z >= 0
         A(m-z,n+z) = color;
         z = z-1;   
        end
        break; 
    elseif b(k-1,l+1) == 0
        break;    
    end
    % perform the same for next stone with different color
    k = k-1;
    l = l+1;
end

%% search direction: south-west
k = m+1;
l = n-1;
z = 0;

while k < 8 && l > 1 && b(k,l) == -color
    % check stone next to first neighbour, if own color change all stones
    % including current move
    z = z+1; % enemy stones to be flipped
    if b(k+1,l-1) == color
        while z >= 0
         A(m+z,n-z) = color;
         z = z-1;   
        end
        break; 
    elseif b(k+1,l-1) == 0
        break;    
    end
    % perform the same for next stone with different color
    k = k+1;
    l = l-1;
end

%% Invalid Move
if A == b
    changed = 0;
    %disp(['invalid move: color =', num2str(color), ' desired position: (', num2str(m), ',', num2str(n), ')'])
else
    %disp(['allowed move: color =', num2str(color), ' desired position: (', num2str(m), ',', num2str(n), ')'])
end

end
