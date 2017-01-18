function out = GC_imfilt(img, kernel)

    out = zeros(size(img));

    [r,c]=size(img);
    img = [ img(1,:); 
            img(:,:); 
            img(end,:)];
    img = [img(:,1) img(:,:) img(:,end)];

    for xx = 2:size(img,2)-1
            for yy=2:size(img,1)-1
                tmp=img(yy-1:yy+1, xx-1:xx+1) .* kernel;
                out(yy-1,xx-1)=sum(tmp(:));
            end
    end
return

