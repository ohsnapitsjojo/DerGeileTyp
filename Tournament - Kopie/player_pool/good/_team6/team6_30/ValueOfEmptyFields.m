function value_of_empty_fields = ValueOfEmptyFields(b,color)

%% Approximation of Empty Fields around our opponent

% Defintion of the filter
filter = [1 1 1;
          1 0 1;
          1 1 1];

visited_matrix=(b~=0);

% look only at opponent stones on board
b(b~=-color)=0;

% Convolution of the opponent board and the filter
% dimension of b doesn't change (--> 'same')
b=conv2(b,filter,'same');

% Find out all fields which aren't visited at the moment
b=logical(b)-logical(visited_matrix.*b);

% Summary of all fields
value_of_empty_fields=sum(b(:));

% More Information: http://www.samsoft.org.uk/reversi/strategy.htm

end