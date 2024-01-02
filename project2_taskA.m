%% Skull Stripping
inimg = '526_T1';
Vol = niftiread(strcat(inimg, '.nii.gz'));
mask = niftiread('526_T1_bet_mask.nii.gz'); %read in hd-bet mask if our skull stripping method does not work

%use our skullstripbw function to get the mask and comment out the mask
%above if our skull stripping function works for that image.
%mask = skullstripbw(strcat((inimg), '.nii.gz'));
Vol(~mask) = 0;
%% Registration
%read in 6 random atlases
label1 = niftiread(fullfile(pwd, '\delineated\manual\', strcat(string(randi([10 40])), '_LABELS_MNI.nii.gz')));
label2 = niftiread(fullfile(pwd, '\delineated\manual\', strcat(string(randi([10 40])), '_LABELS_MNI.nii.gz')));
label3 = niftiread(fullfile(pwd, '\delineated\manual\', strcat(string(randi([10 40])), '_LABELS_MNI.nii.gz')));
label4 = niftiread(fullfile(pwd, '\delineated\manual\', strcat(string(randi([10 40])), '_LABELS_MNI.nii.gz')));
label5 = niftiread(fullfile(pwd, '\delineated\manual\', strcat('0',string(randi(9)), '_LABELS_MNI.nii.gz')));
label6 = niftiread(fullfile(pwd, '\delineated\manual\', strcat(string(randi([10 40])), '_LABELS_MNI.nii.gz')));

%tune registration parameters to manage time vs. accuracy tradeoff
[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.01;
optimizer.Epsilon = 1.5e-6;
optimizer.GrowthFactor = 1.09;
optimizer.MaximumIterations = 100;

%affine registration on each of the labels
label1_reg = imregister(label1, Vol, 'affine', optimizer, metric);
label2_reg = imregister(label2, Vol, 'affine', optimizer, metric);
label3_reg = imregister(label3, Vol, 'affine', optimizer, metric);
label4_reg = imregister(label4, Vol, 'affine', optimizer, metric);
label5_reg = imregister(label5, Vol, 'affine', optimizer, metric);
label6_reg = imregister(label6, Vol, 'affine', optimizer, metric);

%show some of the registered images overlaid on original to check
%progress/see results of registration
figure,
D = imfuse(Vol(:,:,100), label1_reg(:,:,100));
imshow(D);

figure,
D = imfuse(Vol(:,:,100), label2_reg(:,:,100));
imshow(D);
%% Label Fusion

%create empty image to put the segmentation into
segment = Vol*0;

%initialize empty array for a prediction at each voxel from each of the 5
%manual segmentation images
predictions = zeros(1, 6);

%iterate through each voxel in the image
for x = 1:192
    for y = 1:224
        for z = 1:192
            %store the predictions from each label in the predictions array
            predictions(1, 1) = label1_reg(x,y,z);
            predictions(1, 2) = label2_reg(x,y,z);
            predictions(1, 3) = label3_reg(x,y,z);
            predictions(1, 4) = label4_reg(x,y,z);
            predictions(1, 5) = label5_reg(x,y,z);
            predictions(1, 6) = label6_reg(x,y,z);
            
            %take the mode of the array for each voxel and write that to
            %the segmented image
            segment(x,y,z) = mode(predictions);
        end
    end
end

%show a slice of the segmentation result
figure
imagesc(flipud(segment(:,:,100))) % z = 155, flip so head facing up
colormap gray
colorbar 
axis image
axis off
title('Segmented Axial Slice')
%%
%write out the segmentation result as a nifti file to gunzip later
filename = strcat(inimg, '_segmentation');
niftiwrite(segment,filename)