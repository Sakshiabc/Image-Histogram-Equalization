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
clear all;
close all;
y=imread('t3.jpg'); %image read
[m,n]=size(y); %size of image
mean1=round(mean(y(:))); %mean of an image
h_l=zeros(1,256);   
h_u=zeros(1,256);
for i=1:m  % first go through row
    for j=1:n  %second go through column
        g_val =y(i,j);
        if g_val >0
        if(g_val<=mean1)
           h_l(g_val)=h_l(g_val)+1;
        else
            h_u(g_val)=h_u(g_val)+1;
        end   
        end
    end
end
%PDF
pl=h_l/sum(h_l);
pu=h_u/sum(h_u);
%CDF
cdf_l=zeros(1,256);
cdf_u=zeros(1,256);
cdf_l(1)=pl(1);
cdf_u(1)=pl(1);
for k=2:256
    cdf_l(k)=cdf_l(k-1)+pl(k);
    cdf_u(k)=cdf_u(k-1)+pu(k);
end
%modified image
new_i=zeros(size(y));
rl=[1 mean1];
ru=[(mean1+1) 255];
for i=1:m
    for j=1:n
         g_val =y(i,j);
         if(g_val<mean1)
         new_i(i,j)=rl(1)+((rl(2)-rl(1))*cdf_l(g_val+1));
         else
             new_i(i,j)=ru(1)+((ru(2)-ru(1))*cdf_u(g_val+1));
         end
    end
end
EI=uint8(new_i);
subplot(2,2,1)
imshow(y);
title('Input image');
subplot(2,2,2)
imhist(y);
title('Histogram of input image');
subplot(2,2,3)
imshow(EI);
title('BBHE');
subplot(2,2,4)
imhist(EI);
title('Histogram of BBHE image');