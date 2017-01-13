% Gruppe G Player
function b = Hanzelot(b,color,t)


% Zeiteinsparen mittels einmaligem Aufruf von 'addpath'
persistent cnt

if isempty(cnt)
    cnt=0;
    addpath(['players' filesep 'Hanzelot']);
end

if cnt<1

% setze die ersten beiden Züge zufällig aus den möglichen Zügen
    
  [steine]=get_valids(b,color);

   moves=find(steine);

   [row, col]=ind2sub([8 8],moves(ceil(rand(1)*length(moves))));
   
   b=set_stone(b,color,row,col);
   
   cnt=cnt+1;
   return;

else

    max_tiefe=get_depth(b,color,t);
    
% max_tiefe=5; %guter fixwert...

tiefe=max_tiefe;

tic

% Alpha-Beta Rekursion hier starten

[wert,move_val]=fMax(tiefe,-Inf,+Inf,b,color,max_tiefe);

if isempty(move_val)
    disp('No move was possible!')
    %     No move possible, return board without change
    
    cnt=cnt+1;

    return;
else

% finde zug mit den groeßtem Wert
[~,idx]=max(move_val(:,1));

% setzt diesen Zug, und gibt diesen Zug zurück 
b=set_stone(b,color,move_val(idx,2),move_val(idx,3));

% Zeitmessungs ausgabe
time=toc;

fprintf('Suchiefe= %d dauerte: %f \n',max_tiefe,time);

%     fun-part check towards end of game;
    if cnt>20
        if isempty(find(b==0, 1)) %game over
            ascii_img();
        end
        
    end

end

cnt=cnt+1;

end

end