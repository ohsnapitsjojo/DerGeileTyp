function [score,b]=Tournament(b,side,w,color,t1,t2)
    if (side==color)
        tic;
        bnew=GetzReward(b,color,t1,w);
        t1=t1-toc
    else
        tic;
        bnew=Getz(b,-color,t2);
        t2=t2-toc
    end
    if (bnew==b)
        side=side*-1;
        if (side==-color)           
            tic;
            bnew=Getz(b,1,t2);
            t2=t2-toc
        else
            tic;
            bnew=GetzReward(b,color,t1,w);
            t1=t1-toc
        end
    end
while 1
b=bnew;
side=side*-1;
    if (side==color)
        tic;
        bnew=GetzReward(b,color,t1,w);
        t1=t1-toc
    else
        tic;
        bnew=Getz(b,-color,t2);
        t2=t2-toc
    end
    if (bnew==b)
        side=side*-1;
        if (side==color)
            tic;
            bnew=GetzReward(b,color,t1,w);
            t1=t1-toc

        else
            tic;
            bnew=Getz(b,-color,t2);
            t2=t2-toc
        end
    end
    if b==bnew
        break;
    end
        
end
        b=bnew; 
        score=sum(sum(b==color))-sum(sum(b==-color));
end