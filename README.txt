READ ME

Segmentation part

1. skullstripbw.m and threshold.m are functions that we made for our skull stripping method. They did not end up working with the final segmentation test data (though they did work with most of the final age test data), but we included them anyways.
2. project2_taskA.m is the main function for task A. It includes some commented out parts calling our skull stripping function but we used the hd-bet masks here. File paths for labels 1-40 might give you some issues and we were just manually changing the inimg and hd-bet mask file names.

Age prediction part
1. segmentGW.m is a helper function for retrieving the GW and WM of a image, and find_vol.m is a helper function for retrieving the volumes of the 209 labelled regions;
2. GWseg.m is the function that retrieves the GW and WM of all the undelineated images. The size of the GM and WM matrix as well as k needs to be changed if the number of samples changes. Currently i use 270 samples. 
3. takeoutmiss.m is a helper function that only takes the information of the available segmented images.
4. volume_rec.m is the function that records the volumes of all labels of all the available segmented images. The size of volume and k is the number of segmented images available.
5. neural_network_train.m includes the command lines that take in 270 undelineated images and 123 segmented images and network training. To predict age, process the segmented image to get a 209x1 feature matrix and use the predict function
6. the network trained is saved in the net.mat as the 'net' variable.
 