# ERsegmentation_Unet
Demo implementation of U-Net for segemntation of Endoplasmic Reticulum in mammalian cells, based on the methodology established in the following paper:

Chai, X., Ba, Q. and Yang, G. (2018). Characterizing robustness and sensitivity of convolutional neural
networks in segmentation of fluorescence microscopy images. 2018 IEEE International Conference on
Image Processing (ICIP). Accepted. github repository: https://github.com/ccdlcmu/mitosegmentation


"trainingDataPrep": Cropping image patches and generating synthetic images of various image conditions, i.e. different SNR and spatial variant/invariant blurring.

"segmentation_UNet": implementation of UNet. 
Training data: manually segmented images ("masks_ER") and synthetic images ("images_ER").

"evaluation_area_similarity.m": Matlab script for evaluating segmentation results

Training data: manually segmented images ("masks_ER") and synthetic images ("images_ER").


