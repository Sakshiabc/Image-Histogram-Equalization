function LocalHistogramEqualization(img)
% tStart=tic;
data=uint8(imread(img));
[m,n]=size(data);

subplot(2,2,1);
imshow(data);
title('Input image');
subplot(2,2,2);
imhist(data);
title('Histogram of input image');

padSize=20;  
lenn=padSize*2+1;
spatial=padarray(data,[padSize,padSize],0);

blockNum=lenn^2;  

midBlockPos=padSize+1;   

LocalHist=zeros(m,n);
for i=1:m
    for j=1:n
        LocalHist(i,j)=getPixel(spatial(i:i+2*padSize,j:j+2*padSize),midBlockPos,blockNum);
    end
end
LocalHist=uint8(LocalHist);
% tEnd=toc(tStart);
% fprintf('%.4f',tEnd);
subplot(2,2,3);
imshow(LocalHist);
title('LHE');
subplot(2,2,4);
imhist(LocalHist);
title('Histogram of LHE image');
end



function pixel=getPixel(block,midBlockPos,blockNum)
     midPixel=block(midBlockPos,midBlockPos);   
%      index=length(find(block(:)<=midPixel));
     index=sum(block(:)<=midPixel);  
     pixel=round(255*index/blockNum);
end
%      block=sort(block(:));   
%      index=find(block==midPixel);  
%      pixel=round(255*index(end)/blockNum);  
     
% [m,n]=size(spatial);
% data=spatial(:); 
% axis_x=0:255; 
% inter=intersect(axis_x,data); 
% axis_y=zeros(256,1);
% 
% for i=inter'
%     axis_y(i+1)=sum(data==axis_x(i+1));
% end
% 
% pr=axis_y./length(data);
% 
% midPixel=spatial((m+1)/2,(n+1)/2)+1;
% 
% pixel=round(255*sum(pr(1:midPixel)));  

% pixel=transform(spatial((m+1)/2,(n+1)/2)+1);  

