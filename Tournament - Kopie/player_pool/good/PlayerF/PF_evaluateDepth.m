function [depth, sort_depth, finish_flag] = PF_evaluateDepth(board,time,round_count,color)
%EVALUATEDEPTH
%This function sets the search depth of the search alogrithm by evaluating
%the elapsed time and the elapsed number of moves we did

%% Finisher
%iff only some free fields are left and we have enough time left evaluate
%board completly
%             1 2 3 4 5 6   7 8 9
time_borders=[0 0 0 0 0 1 2 10 35];

free=ones(1,8)*(board==0)*ones(8,1);
finish_flag=0;
if (free<=9 && time>time_borders(free))
    evalt_start=tic;
    PF_negamax_sort( board, color, free-4, 0, 1);
    evalt=toc(evalt_start);
    if (time>30*evalt)
        finish_flag=1;
        sort_depth=free;
        depth=0;    
    else
        disp('Too early for endgame');
    end
end

if (finish_flag==0)
    %% vorschl�ge f�r suchtiefe anhand der freien steine auf dem feld
    borders=[11 13 15 25 30 61];
    depth_cand=[9 8 7 6 5 4 3 2 1];
    sort_depth=[3 3 3 2 2 1 1 0 0];
    depth=depth_cand(find(borders>free,1));

    %% korrigiere suchtiefe durch zeitbetrachtung
    %nette idee auber zu unausgereift, daher nur korrektur der suchtiefe
    %nach unten
    
    persistent budget;

    if isempty(budget)||(abs(time - 180)<= eps(180))
        budget=ones(1,33)*180;
    else
        budget(round_count)=time;
    end

    if round_count>15
        lastmove=budget(round_count-1)-budget(round_count);

        %calculate a border including a security margin and an exponential
        %increase in the time budget per move
        factor=exp(5*round_count/30)/35;
        border=factor*time/(30-round_count);
        if lastmove>border
            depth=depth-1;
        end
        %increase depth if lastmove was fast (>2 to exclude dictionary 
        %moves, <border-3 to avoid jumping between search depths)
        if 2<lastmove<border-3
            %depth=depth+1;
        end
    end

    %% Obere Grenzen: depth ist maximal free, 9 und not stop wenn zeit knapp wird
    if depth>9
        depth=9;
    end
    if depth>free
        depth=free;
    end
    if time<60 && round_count<20
        depth=4;
    end
    if time<40 && round_count<24
        depth=3;
    end
    if time<20 && round_count<28
        depth=2;
    end
    if time<5 
        depth=1;
    end

    sort_depth=sort_depth(depth_cand==depth);

end

end

