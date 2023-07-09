function [u]=BBHE_fun(y); 
x=y;
[m,n]=size(x); %size of image
mean1=round(mean(x(:))); %mean of an image
h_l=zeros(1,256);   
h_u=zeros(1,256);
for i=1:m  % first go through row
    for j=1:n  %second go through column
        g_val =x(i,j);
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
new_i=zeros(size(x));
rl=[1 mean1];
ru=[(mean1+1) 255];
for i=1:m
    for j=1:n
         g_val =x(i,j);
         if(g_val<mean1)
         new_i(i,j)=rl(1)+((rl(2)-rl(1))*cdf_l(g_val+1));
         else
             new_i(i,j)=ru(1)+((ru(2)-ru(1))*cdf_u(g_val+1));
         end
    end
end
EI=uint8(new_i);
u=EI;