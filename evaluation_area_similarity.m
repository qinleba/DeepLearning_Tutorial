% intersection over union accuracy 
clear;close all;clc

resultFolder = 'seg_result_real';mkdir(resultFolder)

% mat file is converted from npy file
predict_file = 'result_test/unet_predict.mat';
load(predict_file,'img_predict')
mask_file = 'result_test/unet_imgs_mask_test.mat';
load(mask_file,'img_test')

as_acc = zeros(size(img_test,1),1);

for i=1:size(img_test,1)
    im1 = squeeze(img_test(i,:,:));
	figure,imshow(im1)
    imwrite(im1, fullfile(resultFolder,['mask' num2str(i) '.tif']))
    im2 = squeeze(img_predict(i,:,:));
    im2 = double(im2); im2(im2>=0.5)=1; im2(im2<0.5)=0;
    figure,imshow(im2,[])
    imwrite(im2, fullfile(resultFolder,['seg' num2str(i) '.tif']))
    e1 = length(find((im1+im2)==2));
    e2 = length(find((im1+im2)>=1));
    as_acc(i) = e1/e2;
end

as_m = mean(as_acc) 
ss_sem = std(as_acc)/sqrt(size(img_test,1))
