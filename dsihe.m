                                     %%%%%%%%%%%%%%%%%%%%
                                            %%%%%%%%%%
                                               %%%%%
%%%%%%%%          Patel, S., Bharath, K.P., Balaji, S. and Muthu, R.K., 2020.          %%%%%%%%
%%%%%%%%                             "Comparative study on                             %%%%%%%%
%%%%%%%%       histogram equalization techniques for medical image enhancement."       %%%%%%%%
%%%%%%%%              In Soft Computing for Problem Solving: SocProS 2018,             %%%%%%%%
%%%%%%%%                 Volume 1 (pp. 657-669). Springer Singapore.                   %%%%%%%%
%%%%%%%%                      DOI: 10.1007/978-981-15-0035-0_54                        %%%%%%%%
                                       %%%%%%%%%%%%%%%%%%%%
                                            %%%%%%%%%%
                                               %%%%%
                                               
% © Springer Nature Singapore Pte Ltd. 2020,
%   K. N. Das et al. (eds.),
%   Soft Computing for Problem Solving,
%   Advances in Intelligent Systems and Computing 1048,
%   https://doi.org/10.1007/978-981-15-0035-0_54657
 

%% You are expected to ethically cite the above article %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
clc;
clear;
close;
PicOri=imread('t3.jpg');
try
    PicGray=rgb2gray(PicOri);
catch
    PicGray=PicOri;
end

h=imhist(PicGray);

[m,n]=size(PicGray);

halfarea=floor(m*n/2);

SUM(1)=h(1);
for i=2:256
	SUM(i)=h(i)+SUM(i-1);
end

index=find(SUM>=halfarea);
Xm=index(1);

max=double(max(PicGray(:)));		
min=double(min(PicGray(:)));		

[rowl,coll]=find(PicGray<=Xm);
pixl=size(coll,1);

PZL=zeros(1,Xm+1);
for i=1:Xm+1
	PZL(i)=h(i)/pixl;				
end

SL=zeros(1,Xm+1);
SL(1)=PZL(1);
for i=2:Xm+1
	SL(i)=PZL(i)+SL(i-1);		
end

FuncHEL=min+(Xm-min)*SL;		

PicHE1=zeros(m,n);

for k=1:pixl
	PicHE1(rowl(k),coll(k))=floor(FuncHEL(PicGray(rowl(k),coll(k))+1));
end

[rowu,colu]=find(PicGray>Xm);
pixu=size(colu,1);

PZU=zeros(1,max-Xm-1);
for i=Xm+2:max
	PZU(i-Xm-1)=h(i)/pixu;				
end

%SU=zeros(1,max-Xm-1);
SU=zeros(1,max);
SU(Xm+2)=PZU(1);
for i=Xm+3:max
	SU(i)=PZU(i-Xm-1)+SU(i-1);		
end

FuncHEU=Xm+(max-Xm)*SU;			

for k=1:pixu
	PicHE1(rowu(k),colu(k))=floor(FuncHEU(PicGray(rowu(k),colu(k))));
end


PicHE=uint8(PicHE1);

subplot(2,2,1)
imshow(PicGray);
title('Input image');
subplot(2,2,2)
imhist(PicGray);
title('Histogram of input image');
subplot(2,2,3)
imshow(PicHE);
title('DSIHE');
subplot(2,2,4)
imhist(PicHE);
title('Histogram of DSIHE image');