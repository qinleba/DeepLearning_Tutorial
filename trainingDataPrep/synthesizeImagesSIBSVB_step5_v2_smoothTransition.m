
clear;clc;close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Input 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load estimated background noise level "noiseLevel" and 
% sampled foreground intensities "fgPd"
load('intensitySampled.mat')

% Estimate Rayleigh limit: 3*sigma = 0.61*wavelength/NA/pixelSize;
sigma = 0.61*0.576/1.4/3/0.065; % TRITC channel; NA:1.4;pixelsize:65nm

mode = 'test'; % 'test', 'train','val'

% Image condition
SNR = 4;
conditionType = 'SVB'; %'SIB'
conditionSpec = 3;% range of sigma: e.g., sigmaForSynth = conditionSpec*sigma
regionDivide = 5; % Under SVB, Horizontally divide the images into four regions

maskFolder = 'masks_ER';
syntheticImageFolder = fullfile(...
    sprintf([conditionType '1to%dsigma_SNR%d_mages_ER'],...
    conditionSpec,SNR),maskFolder); 
mkdir(syntheticImageFolder)

% Noise level: SNR = (mean_fg - mean_bg)/sigma_bg
meanNoiseLevel = noiseLevel;%600,500,300

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allMasks = dir(fullfile(maskFolder,'*.tif'));
for idx = 1:length(allMasks)
    close all
    
    % Load mask
    maskName = allMasks(idx).name;
    mask = imread(fullfile(maskFolder,maskName));
    
    [height,width] = size(mask);
    image = zeros(height,width);
    
    % Simulate intensity from kernel distribution
    num = sum(sum(mask)); % number of foreground pixels 
    temp = random(fgPd,[num,1]);
    image(mask) = temp;
    
    blurredImageRegionStack = zeros(height,width,regionDivide);
    if strcmp(conditionType,'SVB')
        for iRegion = 1:regionDivide
            sigmaSpec = sigma*( 1+iRegion*(conditionSpec-1)/(regionDivide-1) );
            heightRange = height/regionDivide.*[iRegion-1;iRegion];
            heightRange(1)=heightRange(1)+1; % range of height each strip
            imageRegion = zeros(height,width);
            imageRegion(heightRange(1):heightRange(2),:) =...
                image(heightRange(1):heightRange(2),:);
            blurredImageRegionStack(:,:,iRegion)...
                = imgaussfilt(imageRegion,sigmaSpec);
        end
        blurredImage = sum(blurredImageRegionStack,3); 
    elseif strcmp(conditionType,'SIB')
        sigmaSpec = conditionSpec*sigma;
        blurredImage = imgaussfilt(image,sigmaSpec);
    end
%     figure,imshow(blurredImage,[])
%     figure,imshow(blurredImageRegionStack(:,:,3),[])
%     figure,imshow(image2,[])
    
% Add noise
    sigmaNoise = (mean(temp)- meanNoiseLevel)/SNR;
    noise = normrnd(meanNoiseLevel,sigmaNoise,[height,width]);
    image2 = blurredImage+noise;
    
    % Write image
    img2 = uint16(image2);
    %figure,imshow(image2,[])
    imwrite(img2,fullfile(syntheticImageFolder,maskName));
   
end

