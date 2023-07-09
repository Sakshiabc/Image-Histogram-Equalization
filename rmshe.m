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
clear;
close;
clc;
PicOri=imread('t3.jpg');
try
    PicGray=rgb2gray(PicOri);
catch
    PicGray=PicOri;
end
% figure(1),imshow(PicGray),title('gray image');

h=imhist(PicGray);
% figure(2),plot(h),title('histogram');

[m,n]=size(PicGray);
PicHEt=zeros(m,n);

max=double(max(PicGray(:)));		
min=double(min(PicGray(:)));		

r=1;
length=2^r+1;
Xm=zeros(1,length);
Xm(1)=max+1;
Xm(2)=min+1;

for i=1:r
	for j=1:2^(i-1)
		Xm(2^(i-1)+j+1)=averpixcal(h,Xm(2^(i-1)-j+2),Xm(2^(i-1)-j+1));
	end
	Xm=sort(Xm,'descend');
end
Xm=sort(Xm);

for i=2:2^r
	[row,col]=find((PicGray>=Xm(i-1)-1)&(PicGray<=Xm(i)-2)); 
	PicHEt=FuncHE(PicGray,PicHEt,row,col,h,Xm(i-1)-1,Xm(i)-2,m,n);
end
[row,col]=find((PicGray>=Xm(2^r)-1)&(PicGray<=Xm(2^r+1)-1));
PicHEt=FuncHE(PicGray,PicHEt,row,col,h,Xm(2^r)-1,Xm(2^r+1)-1,m,n);

PicHE=uint8(PicHEt);
h1=imhist(PicHE);
subplot(2,2,1),imshow(PicGray),title('Input image');
subplot(2,2,2),imhist(PicOri),title('Histogram of input image');
subplot(2,2,3),imshow(PicHE),title('RMSHE');
subplot(2,2,4),imhist(PicHE),title('Histogram of RMSHE image');