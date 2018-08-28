 clear all; clc;close all;
addpath function

%%% Crop background %%%
originalImageFolder = 'deconvolved_ER';

croppedImageFolder = 'background_ER'; 
if ~(exist(croppedImageFolder,'dir')==7)
    mkdir(croppedImageFolder)
end
% cropWidth = 200-1; cropHeight = 200-1; % Decide size of mask & image

allOriginalImages = dir(fullfile(originalImageFolder,'*.tif'));

idx_plus = input('Index for the first cropped background image?');
idx = idx_plus-1;

cropHistory_xmin = []; cropHistory_ymin = [];
for iFile = 1:length(allOriginalImages)
    
    %--- Load images ('X.tif' ) and manual segmentation ('x_seg.tif')
    originalImageName = allOriginalImages(iFile).name;
    originalImage = imread(fullfile(originalImageFolder, originalImageName));
    
    figure, imshow(originalImage,[])
    hold on
    
    %--- crop multiple background from 1 original mask
    ifContinueCrop = input('Crop a background region from this image? y/n','s');
    idx0 = idx+1;
    while ifContinueCrop == 'y'  
        idx = idx+1;
        
        disp('Specify a rectangle for cropping')
        cropRectXYHandle = imrect;
        rectCrop = cropRectXYHandle.getPosition(); 
        
        background = imcrop(originalImage,rectCrop);
        imwrite(background,fullfile(croppedImageFolder,['background_' num2str(idx) '.tif'])) 
        
        xmin = rectCrop(1); ymin = rectCrop(2);
        cropWidth = rectCrop(3); cropHeight = rectCrop(4); 
        plot([xmin, xmin+cropWidth,xmin+cropWidth, xmin, xmin],...
            [ymin,ymin,ymin+cropHeight,ymin+cropHeight, ymin],'r')
        
        %--- record cropping history
        cropHistory_xmin(end+1,1) = ceil(xmin);
        cropHistory_ymin(end+1,1) = ceil(ymin);
        
        ifContinueCrop = input('Crop more background images from this mask? y/n','s');
    end
    
    indices = idx0:idx;
    saveas(gcf, ['bgCropSnap_' originalImageName '.fig'])
    save(['bgCropHistory_' originalImageName '.mat'],'cropHistory_xmin','cropHistory_ymin','indices');
    
end









