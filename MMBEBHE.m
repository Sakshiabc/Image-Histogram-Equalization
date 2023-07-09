clc;
clear all;
close all;
i=imread('t3.jpg');
%% 
X=imhist(uint8(i));  %function to get histogram
[w,l]=size(i);
n=w*l;
%% information theory
c=zeros(1,256);                     %CDF
P1=(X)'/(n);                              %PDF
c(1)=P1(1);
for r=2:256
    c(r)=P1(r)+c(r-1);
end
%% MMBEBHE
[w,l]=size(i);
n=w*l;
MBE=zeros(1,256);
P3=X/n;
for r=1:256
    E=sum((r-1)*P3(r));
end
MBE(1)=0.5*(256*(1-P3(1)))-E;
for r=2:256
    MBE(r)=MBE(r-1)+0.5*(1-256*P3(r));
end
[AMBE, X_T]=min(abs(MBE));
MBE1=min(abs(MBE));
MMBEBHEoutput=BBHE_fun(MBE1);
subplot(2,2,1);imshow(i,[]);title('Input image');
subplot(2,2,2);imhist(i);title('Histogram of Input image');
subplot(2,2,3);imshow(MMBEBHEoutput,[]);title('MMBEBHE');
subplot(2,2,4);imhist(MMBEBHEoutput,[]);title('Histogram of MMBEBHE image');