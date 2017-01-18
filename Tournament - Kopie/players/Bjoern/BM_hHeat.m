function [hHeatmap]=BM_hHeat(b,color)
heatMap1 =[10000 -3000 100  80  80 100 -3000 10000;
       -3000 -5000 -45 -50 -50 -45 -5000 -3000;
        100  -45   3   1   1   3  -45  100;
         80  -50   1   5   5   1  -50   80;
         80  -50   1   5   5   1  -50   80;
        100  -45   3   1   1   3  -45  100;
       -3000 -5000 -45 -50 -50 -45 -5000 -3000;
       10000 -3000 100  80  80 100 -3000 10000];
   
   heatMap2 =[10000 -3000 100  80  80 100 -3000 10000;
       -3000 -5000 -45 -50 -50 -45 -5000 -3000;
        100  -45   3   1   1   3  -45  100;
         80  -50   1   5   5   1  -50   80;
         80  -50   1   5   5   1  -50   80;
        100  -45   3   1   1   3  -45  100;
       -3000 -5000 -45 -50 -50 -45 -5000 -3000;
       10000 -3000 100  80  80 100 -3000 10000];
if(b(1,1)==color)
    heatMap1(2,1)=750;
    heatMap1(1,2)=750;
    heatMap1(2,2)=850;
elseif(b(1,8)==color)
    heatMap1(1,7)=750;
    heatMap1(2,8)=750;
    heatMap1(2,7)=850;
elseif(b(8,1)==color)
    heatMap1(7,1)=750;
    heatMap1(8,2)=750;
    heatMap1(7,2)=850;
elseif(b(8,8)==color)
    heatMap1(7,8)=750;
    heatMap1(8,7)=750;
    heatMap1(7,7)=850;
end
    
if(b(1,1)==-color)
    heatMap2(2,1)=750;
    heatMap2(1,2)=750;
    heatMap2(2,2)=850;
elseif(b(1,8)==-color)
    heatMap2(1,7)=750;
    heatMap2(2,8)=750;
    heatMap2(2,7)=850;
elseif(b(8,1)==-color)
    heatMap2(7,1)=750;
    heatMap2(8,2)=750;
    heatMap2(7,2)=850;
elseif(b(8,8)==-color)
    heatMap2(7,8)=750;
    heatMap2(8,7)=750;
    heatMap2(7,7)=850;
end
    stabilityPlayer = sum(heatMap1(b==color));
    stabilityOpponent = sum(heatMap2(b==-color));
    hHeatmap = stabilityPlayer - stabilityOpponent;
end