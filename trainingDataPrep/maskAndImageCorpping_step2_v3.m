 clear all; clc;%close all;
addpath function

%%% Crop mask & image %%%

originalMaskFolder = 'manualSegmented_ER';
originalImageFolder = 'deconvolved_ER';
croppedMaskFolder = 'masks_raw_ER'; mkdir(croppedMaskFolder)
croppedImageFolder = 'images_raw_ER'; mkdir(croppedImageFolder)
cropWidth = 200-1; cropHeight = 200-1; % Decide size of mask & image

allOriginalImages = dir(fullfile(originalImageFolder,'*.tif'));

idx_plus = input('Index for the cropped mask?');
idx = idx_plus-1;
idx0 = idx+1;
cropHistory_xmin = []; cropHistory_ymin = [];
for iFile = 3:length(allOriginalImages)
    
    %--- Load images ('X.tif' ) and manual segmentation ('x_seg.tif')
    originalImageName = allOriginalImages(iFile).name;
    originalImage = imread(fullfile(originalImageFolder, originalImageName));
    originalMaskName = strsplit(originalImageName,'.tif');
    originalMaskName = [originalMaskName{1} '_seg.tif'];
    originalMask = imread(fullfile(originalMaskFolder, originalMaskName));
    
    figure, imshow(originalMask)
    hold on
    
    %--- crop multiple masks from 1 original mask
    ifContinueCrop = input('Crop a mask from this original mask? y/n','s');
    while ifContinueCrop == 'y'  
        idx = idx+1;
        disp('Specify a point for the upper right corner of mask cropping')
        cropPointXYHandle = impoint;
        pointXY = cropPointXYHandle.getPosition(); 
        
        xmin = pointXY(1)-cropWidth; 
        ymin = pointXY(2); 
        rectCrop = [xmin,ymin,cropWidth,cropHeight]; 
        
        rawMask = imcrop(originalMask,rectCrop);
        imwrite(im2double(rawMask),fullfile(croppedMaskFolder,['mask_raw' num2str(idx) '.tif'])) 
        rawImage = imcrop(originalImage,rectCrop);
        imwrite(rawImage,fullfile(croppedImageFolder,['image_raw' num2str(idx) '.tif']))
        
        plot([xmin, xmin+cropWidth,xmin+cropWidth, xmin, xmin],...
            [ymin,ymin,ymin+cropHeight,ymin+cropHeight, ymin],'r')
        
        %--- record cropping history
        cropHistory_xmin(end+1,1) = ceil(xmin);
        cropHistory_ymin(end+1,1) = ceil(ymin);
        
        ifContinueCrop = input('Crop more masks from this mask? y/n','s');
    end
    
    indices = idx0:idx;
    saveas(gcf, ['croppingSnap_' originalMaskName '.fig'])
    save(['cropHistory_' originalMaskName '.mat'],'cropHistory_xmin','cropHistory_ymin','indices');
    
end


