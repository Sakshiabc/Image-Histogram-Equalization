function SpecialDynamicHistogramEqualization(img)
% tStart=tic;  
data=imread(img);
data=data(:,:,1);

subplot(2,2,1);
imshow(data);
title('Input image');
subplot(2,2,2);
imhist(data);
title('Histogram of input image');

[m,n]=size(data);
data=data(:); 
allPixel=0:255; 
inter=double(intersect(allPixel,data));
pixelCount=zeros(256,1); 

for i=inter'
    pixelCount(i+1)=sum(data==allPixel(i+1));
end


padCount=[0
    pixelCount
    0];
for i=2:257
    pixelCount1(i-1)=sum(padCount(i-1:i+1))/3.0;  
end

pixelCount1=round(pixelCount1);
index=find(pixelCount1~=0);   
pixelStart=index(1);    
pixelEnd=index(end);

part=partition(pixelStart,pixelEnd,pixelCount1);    

flag=1;
i=1;
while flag
    [i,part,flag]=rePartition(pixelCount,part,i);  
end

% span(1)=part(1,2)-part(1,1);
% for i=2:size(part,1)
%     span(i)=part(i,2)-part(i,1)+1;
% end
for i=1:size(part,1)
    span(i)=part(i,2)-part(i,1)+1-sum(ismember(pixelCount(part(i,1):part(i,2)),0));%这个部分是逗比的尝试部分
end

range=span.*255./sum(span);   
partSpan(1,1)=0;         
partSpan(1,2)=range(1); 

for i=2:size(part,1)
    partSpan(i,1)=partSpan(i-1,2);
    partSpan(i,2)=partSpan(i,1)+range(i);  
end

partSpan=round(partSpan);

%%
transFun=getTransformFunction(part,partSpan,pixelCount);   

for i=1:length(data)
    data(i)=transFun(data(i)+1);  
end

% tEnd=toc(tStart);
subplot(2,2,3);
z=reshape(data,m,n);
imshow(z);
title('SDHE');
subplot(2,2,4);
imhist(data);
title('Histogram of SDHE image');
end

function transFun=getTransformFunction(part,partSpan,pixelCount)   
transFun=zeros(1,256);   
transFun=GH(pixelCount(part(1,1):part(1,2)),part(1,1):part(1,2),partSpan(1,:),transFun);
for i=2:size(part,1)
    transFun=GH(pixelCount(part(i,1):part(i,2)),part(i,1):part(i,2),[partSpan(i,1)+1 partSpan(i,2)],transFun);
end
end
function transFun=GH(pixelCount,pixelIndex,partSpan,transFun)
pixelAll=sum(pixelCount);  
max1=max(pixelIndex)-1;
min1=min(pixelIndex)-1;

pixelIndex1=round((pixelIndex-min1)./(max1-min1).*(partSpan(2)-partSpan(1))+partSpan(1));  

for i=1:length(pixelIndex)
    index=find(pixelIndex1<=pixelIndex1(i));    
    count=0;
    for j=1:length(index)
        count=count+pixelCount(index(j));
    end
    transFun(pixelIndex(i))=round(count/pixelAll*(partSpan(2)-partSpan(1))+partSpan(1));  
    %     temp=round((max1-min1)*sum(pixelCount(1:i))/pixelAll+min1);
    %     transFun(pixelIndex(i))=round((partSpan(2)-(partSpan(1)))*(temp-min1)/(max1-min1)+partSpan(1));
    % %     transFun(pixelIndex(i))=round((partSpan(2)-(partSpan(1)))*sum(pixelCount(1:i))/pixelAll+partSpan(1));  
end
end
function part=partition(pixelStart,pixelEnd,pixelCount)   
%pixelCount=pixelCount';
part(1,1)=pixelStart;
count=1;
winSize=1;   
gap=0;      
padPix=padarray(pixelCount,[0,winSize]);    
for i=pixelStart+1+winSize:pixelEnd-1+winSize
    if check(padPix,i,winSize,gap)        
        part(count,2)=i-winSize;
        count=count+1;
        part(count,1)=i+1-winSize;
        continue;
    end
end
% a=60;
% part(1,2)=a;
% count=count+1;
% part(count,1)=a+1;
part(count,2)=pixelEnd;
end
function F=check(padPix,i,winSize,gap)
% F=all([padPix((i-winSize):(i-1)) padPix((i+1):(i+winSize))]>(padPix(i)+gap));%&&~(all([padPix((i-winSize):(i-1)) padPix((i+1):(i+winSize))]==(padPix(i)+gap)))
 check1=all([padPix((i-winSize):(i-1)) padPix((i+1):(i+winSize))]>(padPix(i)+gap));
 check2=~(all([padPix((i-winSize):(i+winSize))]==0))&&padPix(i)==0;
 F=check1||check2;
end
function [i,part,flag]=rePartition(pixelCount,part,i)   
[mean,std,totalNum]=caculate((part(i,1)-1):(part(i,2)-1),pixelCount(part(i,1):part(i,2)));  

if isnan(mean)   
    
    i=i+1;
    if(i>=size(part,1))  
        flag=0;
    else
        flag=1;
    end
    return;
    
else   
 
    if(round(mean-std)+1>=1)
    regionCount=sum(pixelCount((round(mean-std)+1):(round(mean+std)+1)));
    else
        regionCount=sum(pixelCount(1:(round(mean+std)+1)));
    end
    if regionCount/totalNum>0.683
        i=i+1;
    else
        partTemp=zeros(size(part,1)+2,2);   
        partTemp(1:(i-1),:)=part(1:(i-1),:);
        partTemp(i,:)=[part(i,1) round(mean-std)+1];
        partTemp(i+1,:)=[round(mean-std)+2 round(mean+std)+1];
        partTemp(i+2,:)=[round(mean+std)+2 part(i,2)];
        partTemp((i+3):end,:)= part((i+1):end,:);
        part=partTemp;
    end
    if i>=size(part,1)   
        flag=0;
    else
        flag=1;
    end
end
end
function [mean,std,totalNum]=caculate(num,count)   
totalNum=sum(count');
mean=sum(num.*count')/totalNum;
std=sqrt(sum(((num-mean).^2).*count')/totalNum);
end