function GlobalHistogramEqualization(img)
% tStart=tic;
data=uint8(imread(img));

subplot(2,2,1);
imshow(data);
title('Input image');
subplot(2,2,2);
imhist(data);
title('Histogram of input image');

[m,n]=size(data);
data=data(:); 
axis_x=0:255; 
inter=double(intersect(axis_x,data));
axis_y=zeros(256,1); 


for i=inter'
    axis_y(i+1)=sum(data==axis_x(i+1));
end

pr=axis_y./length(data);

% for i=1:256
%     transform(i)=round(255*sum(pr(1:i)));  
% end

transform=round(cumsum(pr)*255);  

for i=1:length(data)
    data(i)=transform(data(i)+1);  
end
% tEnd=toc(tStart);

subplot(2,2,3);
z=reshape(data,m,n);
imshow(z);
title('GHE');
subplot(2,2,4);
imhist(data);
title('Histogram of GHE image');