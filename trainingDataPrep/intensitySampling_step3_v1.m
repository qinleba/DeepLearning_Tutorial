
close all; clear all; clc;

%% Sample foreground intensity
rawImageFolder = 'images_raw_ER';
rawMaskFolder = 'masks_raw_ER';
allRawMasks = dir(fullfile(rawMaskFolder, '*.tif')); 

% imageHeight = 200; imageWidth = 200;
%objIntensity = zeros(length(allRawMasks),imageHeight,imageWidth);
intensityPooled = [];
for iFile = 1:length(allRawMasks)
    
    %--- Load image and mask
    maskName = allRawMasks(iFile).name;
    mask = imread(fullfile(rawMaskFolder,maskName));
    
    imageName = strsplit(maskName,'mask');
    imageName = ['image' imageName{2}];
    image = imread(fullfile(rawImageFolder,imageName));
       
    
    %--- Sample intensity
    intensityPooled = [intensityPooled; image(mask>0)];
     
end
% figure, histogram(intensityPooled)

% Fit kernel distribution object to data
fgPd = fitdist(intensityPooled,'Kernel');
% figure
% x = 0:1:max(intensityPooled*1.01);
% y = pdf(kernelPd,x);
% plot(x,y,'LineWidth',2)

%% Sampling background
backgroundImageFolder = 'background_ER';
allBackgroundImage = dir(fullfile(backgroundImageFolder,'*.tif'));

bgIntensityPooled = [];
for iFile = 1:length(allBackgroundImage)
    bgImageName = allBackgroundImage(iFile).name;
    bgImage = imread(fullfile(backgroundImageFolder,bgImageName));
    bgIntensityPooled = [bgIntensityPooled;bgImage(:)]; 
end
% figure, hist(im2double(bgIntensityPooled))

noiseLevel = mean(bgIntensityPooled);

save('intensitySampled.mat', 'fgPd','noiseLevel');


















