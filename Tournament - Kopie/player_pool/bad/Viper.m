function b = Viper(b,color,t)

%change search depth depending on time left
if t > 30
    depth = 3;
elseif t > 10
        depth = 2;
    elseif t <= 10
            depth = 1;
end;

%check if the current board is in the database
% (yet to be implemented)

weight = 30;   % Kantengewicht

[cx,cy,~,pass]=ViperCore(b,weight,depth+1,color);
%Flip the pieces & update if we don't pass
if pass==0
  b=ViperFlip(b,color,cx,cy);
end
    
    
    
function [compx,compy,value,pass]=ViperCore(Game,weight,depth,color)

if depth==0                                                                %if we've reached the bottom of recursion just return
    pass=0;
    value=0;
    compx=0;
    compy=0;
    return
end

[x,y,v]=find(Game == 0);                                                   %find the elements which are zero
Possiblemoves=[];                                                          %initialize our possible moves
pass=0;                                                                    %we don't want to pass by accident

%Set up the recursion specific variables
newGame = Game;                                                            %we start with the current gameboard
nextvalue=0;                                                               %initialize our next value
nextpass=0;                                                                %and initialize our next pass

for k = 1:length(v);                                                       %for every empty element
            [newGame,value]=ViperFlip(Game,color,x(k),y(k));               %see what value we get for putting our dude there
            if (value~=0)                                                  %if value is >0 then store it in a list
                if (x(k)==0&&y(k)==0)||(x(k)==0&&y(k)==8)||(x(k)==8&&y(k)==0)||(x(k)==8&&y(k)==8)   %A corner piece
                    value = value + 3*weight;                              %Increase the value of corner plays, but only if it's a legal move
                elseif ((x(k)==0)||(x(k)==8))&&((y(k)==3)||(y(k)==4)||(y(k)==5)||(y(k)==6))||((y(k)==0)||(y(k)==8))&&((x(k)==3)||(x(k)==4)||(x(k)==5)||(x(k)==6))          %An edge piece without the next ones to the corners
                    value = value + 2*weight;                              %Increase the value of edge plays without the ones near the corners, but only if legal
                end
                [~,~,nextvalue,nextpass]=ViperCore(newGame,weight,depth-1,-color);  %play the next move nextvalue  nextpass
                
                if (nextpass==0)                                           %If the other player doesnt pass
                    value = value - nextvalue;                             %subtract the value of the next (enemy) move
                end
                Possiblemoves=[Possiblemoves;x(k),y(k),value];             %add to the list of possible moves
            end
end

%  depth
%  Possiblemoves

if isempty(Possiblemoves)                                                  %if we can't move set it up so we pass.
    pass=1;
    value=0;
    compx=0;
    compy=0;
    return
end

[value,row]=max(Possiblemoves(:,3));                                       %look through the value col and find the greatest one
compx = Possiblemoves(row,1);                                              %Return the coordinates of our move
compy = Possiblemoves(row,2);

return


function [FlipGame,value]=ViperFlip(Game,color,x,y)

[i,j,v]=find(Game);                                                        %find the nonzero elements
flipvec=[];                                                                %initialize counters
value=0;

for k = 1:length(v)
    if v(k) == color
        if i(k) == x                                                       %they're in the same row
            flipvec=[]; u=[]; b=[];                                        %re-initialize flipvec because we use it over and over, and do the same for u and b, the x and y coords of the pieces to flip
            if y > j(k)
                flipvec=Game(x,j(k)+1:y-1);
                for r = j(k)+1:y-1
                    u=[u;x]; b=[b;r];
                end
            else
                flipvec=Game(x,y+1:j(k)-1);
                for r = y+1:j(k)-1
                    u=[u;x]; b=[b;r];
                end
            end
            if (isempty(intersect(flipvec,0)))&&(isempty(intersect(flipvec,color)))   %if it's a continuous strip and doesn't contain our color
                Game=Flip(Game,u,b,color);                                 %flip the elements
                value=value+length(flipvec);                               %and add the number of elements flipped to the score value
            end
        end
        if j(k) == y                                                       %they're in the same column
            flipvec=[]; u=[]; b=[];
            if x > i(k)
                flipvec=Game(i(k)+1:x-1,y);
                for r = i(k)+1:x-1
                    u=[u;r]; b=[b,y];
                end
            else
                flipvec=Game(x+1:i(k)-1,y);
                for r = x+1:i(k)-1
                    u=[u;r]; b=[b;y];
                end
            end
            if (isempty(intersect(flipvec,0)))&&(isempty(intersect(flipvec,color)))   %if it's a continuous strip
                Game=Flip(Game,u,b,color);                                 %flip the elements
                value=value+length(flipvec);                               %and add the number of elements flipped to the score value
            end
        end
        if abs(x-i(k))==abs(y-j(k))                                        %they're on the same diagonal
            flipvec=[]; u=[]; b=[];
            if (i(k)>x)&&(j(k)>y)
                for r = x+1:i(k)-1
                    t = abs(r-x)+y;
                    flipvec=[flipvec;Game(r,t)];
                    u=[u;r]; b=[b;t];
                end
            elseif (i(k)>x)&&(j(k)<y)
                for r = x+1:i(k)-1
                    t = y-abs(r-x);
                    flipvec=[flipvec;Game(r,t)];
                    u=[u;r]; b=[b;t];
                end
            elseif(i(k)<x)&&(j(k)>y)
                for r = i(k)+1:x-1
                    t = abs(r-x)+y;
                    flipvec=[flipvec;Game(r,t)];
                    u=[u;r]; b=[b;t];
                end
            else                                                           %(i(k)<x)&&(j(k)<y)
                for r = i(k)+1:x-1
                    t = y-abs(r-x);
                    flipvec=[flipvec;Game(r,t)];
                    u=[u;r]; b=[b;t];
                end
            end
            if (isempty(intersect(flipvec,0)))&&(isempty(intersect(flipvec,color)))   %if it's a continuous strip
                Game=Flip(Game,u,b,color);                                 %flip the elements
                value=value+length(flipvec);                               %and add the number of elements flipped to the score value
            end
        end
    end
end
Game(x,y)=color;                                                           %Now update with the piece we just placed
FlipGame=Game;                                                             %And return the new flipped gameboard
return


function Game=Flip(Game,u,b,color)  %Flip the colors we want.
for k = 1:length(u)                 %for every element in u
        Game(u(k),b(k)) = color; %set the stone to our color
end
return