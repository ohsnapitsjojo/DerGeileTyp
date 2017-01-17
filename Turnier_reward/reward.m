function [w, score, board]=reward
load('GameStages.mat')
side=1;
color=side;
t1=180;
t2=t1;
for i=1:1  % Anzahl verschiedener Boards die gespielt werden
b=init;%b=Boards20ToGo(:,:,i); 
    for j=1:5  % Anzahl verschiedener weigts die gespielt werden.
        weight=rand(4,1);
        w(:,i,j)=weight/sum(weight);
        [score(i,j),board(:,:,i,j)]=Tournament(b,side,w(:,i,j)',color,t1,t2) % Ohne ; damit Fortschritt auf Konsole zu erkennen ist
        
    end
end
end