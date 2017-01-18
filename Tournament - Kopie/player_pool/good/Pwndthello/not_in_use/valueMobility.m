function value = valueMobility(be,col)

neighbor = [ones(1,10);ones(8,1) be ones(8,1);ones(1,10)];
for ic=1:8
    for il=1:8
        if(be(ic,il)==-col)
            if neighbor(ic+2,il+1)==0
               neighbor(ic+2,il+1)=2;
            end
            if neighbor(ic+1,il+2)==0
               neighbor(ic+1,il+2)=2;
            end
            if neighbor(ic+2,il+2)==0
               neighbor(ic+2,il+2)=2;
            end
            if neighbor(ic,il+1)==0
               neighbor(ic,il+1)=2;
            end
            if neighbor(ic+1,il)==0
               neighbor(ic+1,il)=2;
            end
            if neighbor(ic,il)==0
               neighbor(ic,il)=2;
            end
            if neighbor(ic+2,il)==0
               neighbor(ic+2,il)=2;
            end
            if neighbor(ic,il+2)==0
               neighbor(ic,il+2)=2;
            end            
        end
    end
end

value= sum(sum(neighbor==2));