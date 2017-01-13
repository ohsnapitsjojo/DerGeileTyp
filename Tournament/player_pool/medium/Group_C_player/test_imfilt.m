clc; clear all; close all;

a= (rand(8) > 0.5 ) - (rand(8) > 0.5);

h = [ 0 1 0; 1 0 1; 0 1 0];

kmax = 1000
tic
for k=1:kmax
    res_gc = GC_imfilt(a,h);
end
toc

tic
for k=1:kmax    
    res_imfilter = imfilter(a,h, 'replicate');
end
toc