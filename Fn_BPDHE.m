function [ map, brightness_gray_img ] = Fn_BPDHE(y_img, R, C)

fprintf('BPDHE time : ');
tic;

%  [R, C, X]= size(y_img);
  
pdf = (imhist(uint8(y_img)))'/(R*C);
% cdf = cumsum(pdf);
%% 1*3 Gaussian low pass filtering
g=fspecial('gaussian', [1 3], 5);
avg_pdf = filter(g,1,pdf);
%% calculate local maximum
dif1 = diff(avg_pdf); 
sign = dif1 > 0;
m_sign = medfilt1(double(sign),3);
local_max = zeros(1, 256);

for k=8:251
    if m_sign(k-7)==1 && m_sign(k-6)==1  && m_sign(k-5)==1 && m_sign(k-4)==1 && m_sign(k-3)==1 && m_sign(k-2)==1 && ...
            m_sign(k-1)==1 && m_sign(k)==1 && m_sign(k+1)==0 && m_sign(k+2)==0 && m_sign(k+3)==0 && m_sign(k+4)==0
        local_max(k) = 1;
    end
end
peak_pos = find(local_max);
%% Gray Level Allocation
   %--find span--%
 [z, avg_pdf_idx] = find(avg_pdf);
 m_low = avg_pdf_idx(1); m_high = avg_pdf_idx(end); %처음과 끝 값
 m = [m_low peak_pos m_high];
 span = zeros(1, length(m)-1);
for i=2:length(m)
    span(i-1) = m(i)-m(i-1);
end
   %--find range--%
total_span = sum(span);
max_level=255;
range = zeros(1, length(m)-1);
for i=1:length(m)-1
     range(i) = round((span(i)/total_span) * max_level);
end
map=zeros(1,256);
start_p=cumsum([1,range]); 

   %--find mapping functioin--%
cdf_data=zeros(1,256);
for i=2:length(m)
    temp = cumsum(pdf(m(i-1)+1:m(i)));
    cdf_data(m(i-1)+1:m(i)) = temp/temp(end);
    map(m(i-1)+1:m(i))=cdf_data(m(i-1)+1:m(i))*(range(i-1))+start_p(i-1);
end
gray_img=zeros(R,C);
for i=1:R
    for j=1:C
        gray_img(i,j) = uint8(fix(map((y_img(i,j))+1)));
    end
end

%% Nomalize the image brightness
M_i = mean2(y_img);
M_o = mean2(gray_img);
brightness_gray_img=(M_i/M_o).*(gray_img);

toc;
fprintf('\n');

end

