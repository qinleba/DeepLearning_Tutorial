close all; clear all; clc;


rawMaskFolder = 'masks_raw_ER';
augmentedMaskFolder = 'masks_ER';mkdir(augmentedMaskFolder)

allRawMasks = dir(fullfile(rawMaskFolder,'*.tif'));

idx = 0;
for iFile = 1:length(allRawMasks)
    idx = idx+1;
    rawMaskFile = dir(fullfile(rawMaskFolder,['mask_raw' num2str(iFile) '.tif']));
    rawMaskName = rawMaskFile.name;
    rawMask = imread(fullfile(rawMaskFolder,rawMaskName));
    rawMask = logical(rawMask);
    imwrite(rawMask,fullfile(augmentedMaskFolder, [num2str(idx) '.tif']))
    
    %--- data augmentation
    idx = idx+1;
    newMask1 = fliplr(rawMask); % left-right reflection
    imwrite(newMask1,fullfile(augmentedMaskFolder, [num2str(idx) '.tif']))
    
    idx = idx+1;
    newMask2 = flipud(rawMask); % up-down reflection 
    imwrite(newMask2,fullfile(augmentedMaskFolder, [num2str(idx) '.tif']))
   
    idx = idx+1;
    newMask3 = imrotate(rawMask,90);  % 90 degree rotation
    imwrite(newMask3,fullfile(augmentedMaskFolder, [num2str(idx) '.tif']))
   
    idx = idx+1;
    newMask4 = imrotate(rawMask,180);  % 180 degree rotation
    imwrite(newMask4,fullfile(augmentedMaskFolder, [num2str(idx) '.tif']))
    
    idx = idx+1;
    newMask5 = imrotate(rawMask,270);  % 270 degree rotation
    imwrite(newMask5,fullfile(augmentedMaskFolder, [num2str(idx) '.tif']))
end

