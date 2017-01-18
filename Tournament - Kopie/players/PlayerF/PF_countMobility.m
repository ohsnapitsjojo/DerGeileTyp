function mobility = PF_countMobility(b,color)
%This function evaluates the the approx. mobility on board 'b'
%out of the perspective of the player 'color'
%
%Using a filter empty fields neighboring an enemy field are found
%efficiently

filter=ones(3);
filter(2,2)=0;

b1=b;
b1(b1~=0)=NaN;
b(b~=-color)=0;
b=conv2(b,filter,'same')+b1;

%exclude mulitple counts
b(color*b<0)=1;
b(isnan(b))=0;
mobility=sum(b(:));

% %include multiple counts
% mobility=-color*sum(b(color*b<0));

end

