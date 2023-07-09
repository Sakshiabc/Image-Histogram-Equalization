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
InputImage = imread('t3.jpg');
[R, C, X]= size(InputImage);
[ map, brightness_gray_img ] = Fn_BPDHE(InputImage, R, C);
brightness_gray_img=uint8(brightness_gray_img);

subplot(2,2,1)
imshow(InputImage);
title('Input image');
subplot(2,2,2)
imhist(InputImage);
title('Histogram of input image');
subplot(2,2,3)
imshow(brightness_gray_img);
title('BPDHE');
subplot(2,2,4)
imhist(brightness_gray_img);
title('Histogram of BPDHE image');
