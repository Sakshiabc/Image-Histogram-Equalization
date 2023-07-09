function [outputImage, transformationMap] = fcnBPDFHE(inputImage, fuzzyMembershipType, parameters)
%
%   fcnBPDFHE performs Brightness Preserving Dynamic Fuzzy Histogram
%   Equalization (BPDFHE) on an Image
%
%   OUTPUTIMAGE = fcnBPDFHE(INPUTIMAGE) performs BPDFHE on an image using
%   default parameter settings. Supported image classes for INPUTIMAGE 
%   include uint8, uint16, int16, single, double. Default execution uses a 
%   triangular membership function with support of 5. Default memberships 
%   values are [1 2 3 4 5 4 3 2 1].
%   
%   OUTPUTIMAGE = fcnBPDFHE(INPUTIMAGE,FUZZY_MEMBERSHIP_TYPE,PARAMETERS)
%   performs BPDFHE on the INPUTIMAGE using Fuzzy Memberships as defined in
%   FUZZY_MEMBERSHIP_TYPE
%       Options:
%       --------
%       triangular - uses a triangular membership function
%       gaussian - uses a gaussian membership function
%       custom - uses the  user defined membership values
%   PARAMETERS are to be specified accordingly for usage
%       Options:
%       --------
%       Width of support if 'triangular'. Suggested is 5 for uint8
%       Width of support and spread factor if 'gaussian'. Suggested is
%       [5,2] for uint8
%       User defined membership values if 'custom'. Suggested is [1 2 3 4 5 4 3 2 1]
%
%   [OUTPUTIMAGE, TRANSFORMATION_MAP] = fcnBPDFHE(...) returns also the
%   intensity transformation matrix for further usage.
% 
% Example (Grayscale Images)
% --------------------------
% inputImage = imread('cameraman.tif');
% outputImage = fcnBPDFHE(inputImage);
% figure, subplot 131, imshow(inputImage), subplot 132,
% imshow(outputImage), subplot 133, imshow(inputImage-outputImage,[])
%
% Example (Color Images)
% --------------------------
% rgbInputImage = imread('peppers.png');
% labInputImage = applycform(rgbInputImage,makecform('srgb2lab'));
% Lbpdfhe = fcnBPDFHE(labInputImage(:,:,1));
% labOutputImage = cat(3,Lbpdfhe,labInputImage(:,:,2),labInputImage(:,:,3));
% rgbOutputImage = applycform(labOutputImage,makecform('lab2srgb'));
% figure, subplot 121, imshow(rgbInputImage), subplot 122,
% imshow(rgbOutputImage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input argument support check
validateattributes(inputImage,{'uint8','uint16','int16','single','double'}, {'nonsparse','2d'}, mfilename,'I',1);

if nargin == 1
    parameters = 5;
    membership = parameters(1)-abs(-parameters(1):parameters(1));
elseif nargin == 3
    if strcmp(fuzzyMembershipType,'triangular')
        if ~(numel(parameters)==1)
            error('fcnBPDFHE supports only 1 parameter for Triangular Membership');
        end
        membership = parameters(1)-abs(-parameters(1):parameters(1));
    elseif strcmp(fuzzyMembershipType,'gaussian')
        if ~(numel(parameters)==2)
            error('fcnBPDFHE supports only 2 parameters for Gaussian Membership');
        end
        membership = exp(-(-parameters(1):parameters(1)).^2/parameters(2)^2);
    elseif strcmp(fuzzyMembershipType,'custom')
        if numel(parameters)==0
            error('fcnBPDFHE requires the membership value specification as 1-D array for Custom Membership');
        end
        membership = parameters;
    else
        error('Unsupported membership type declaration');
    end
else
    error('Unsupported calling of fcnBPDFHE');
end

imageType = class(inputImage);

% Histogram creation
if strcmp(class(inputImage),'uint8')
    [crispHistogram,grayScales] = imhist(inputImage);
elseif strcmp(class(inputImage),'uint16')
    crispHistogram = zeros([2^16 1]);
    for counter = 1:numel(inputImage)
        crispHistogram(inputImage(counter)+1) = crispHistogram(inputImage(counter)+1) + 1;
    end
    grayScales = 0:(2^16 - 1);
elseif strcmp(class(inputImage),'int16')
    crispHistogram = zeros([2^16 1]);
    for counter = 1:numel(inputImage)
        crispHistogram(inputImage(counter)+32769) = crispHistogram(inputImage(counter)+32769) + 1;
    end
    grayScales = -32768:32767;
elseif (strcmp(class(inputImage),'double')||strcmp(class(inputImage),'single'))
    maxGray = max(inputImage(:));
    minGray = min(inputImage(:));
    inputImage = im2uint8(mat2gray(inputImage));
    [crispHistogram,grayScales] = imhist(inputImage);
end

inputImage = double(inputImage);

fuzzyHistogram = zeros(numel(crispHistogram)+numel(membership)-1,1);

for counter = 1:numel(membership)
    fuzzyHistogram = fuzzyHistogram + membership(counter)*[zeros(counter-1,1);crispHistogram;zeros(numel(membership)-counter,1)];
end

fuzzyHistogram = fuzzyHistogram(ceil(numel(membership)/2):end-floor(numel(membership)/2));

del1FuzzyHistogram = [0;(fuzzyHistogram(3:end)-fuzzyHistogram(1:end-2))/2;0];
del2FuzzyHistogram = [0;(del1FuzzyHistogram(3:end)-del1FuzzyHistogram(1:end-2))/2;0];

locationIndex = (2:numel(fuzzyHistogram)-1)'+1;

maxLocAmbiguous = locationIndex(((del1FuzzyHistogram(1:end-2).*del1FuzzyHistogram(3:end))<0) & (del2FuzzyHistogram(2:end-1)<0));

counter = 1;

maxLoc = 1;

while counter < numel(maxLocAmbiguous)
    if (maxLocAmbiguous(counter)==(maxLocAmbiguous(counter+1)-1))
        maxLoc = [maxLoc ; (maxLocAmbiguous(counter)*(fuzzyHistogram(maxLocAmbiguous(counter))>fuzzyHistogram(maxLocAmbiguous(counter+1)))) + (maxLocAmbiguous(counter+1)*(fuzzyHistogram(maxLocAmbiguous(counter))<=fuzzyHistogram(maxLocAmbiguous(counter+1))))];
        counter = counter + 2;
    else
        maxLoc = [maxLoc ; maxLocAmbiguous(counter)];
        counter = counter + 1;
    end
end
if(maxLoc(end)~=numel(fuzzyHistogram))
    maxLoc = [maxLoc ; numel(fuzzyHistogram)];
end

low = maxLoc(1:end-1);
high = [maxLoc(2:end-1)-1;maxLoc(end)];
span = high-low;
cumulativeHistogram = cumsum(fuzzyHistogram);
M = cumulativeHistogram(high)-cumulativeHistogram(low);
factor = span .* log10(M);
range = max(grayScales)*factor/sum(factor);

transformationMap = zeros(numel(grayScales),1);

for counter = 1:length(low)
    for index = low(counter):high(counter)
        transformationMap(index) = round((low(counter)-1) + (range(counter)*(sum(fuzzyHistogram(low(counter):index)))/(sum(fuzzyHistogram(low(counter):high(counter))))));
    end
end

outputImage = transformationMap(inputImage+1);

outputImage = mean(inputImage(:))/mean(outputImage(:))*outputImage;

outputImage = cast(outputImage,imageType);

if strcmp(imageType,'single')
    outputImage = minGray + (maxGray-minGray)*mat2gray(outputImage);
elseif strcmp(imageType,'double')
    outputImage = minGray + (maxGray-minGray)*mat2gray(outputImage);
end