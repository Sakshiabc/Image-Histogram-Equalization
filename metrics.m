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
clear all;
close all;

%PSNR, MSE value and image contrast%

[PSNR_Value, MSE_Value]=psnr((enhanced_image),(original_image));
results=sprintf('1. PSNR value is %f\n2. MSE value is %f',PSNR_Value, MSE_Value);
msgbox(results,'Results')

image_contrast = max(enhanced_image(:)) - min(enhanced_image(:))