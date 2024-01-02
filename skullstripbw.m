function brain = skullstripbw(img)
Vol = niftiread(img);

%threshold the image above a certain intensity to create separation between
%brain and skull
T = threshold(Vol);
skull = Vol >= T;

binary = Vol*0;
binary(skull) = 1;


%get rid of all clumps of voxels less than 10000
newbinary = bwareaopen(binary, 10000);

[labels, ~] = bwlabeln(newbinary); %label all clumps of voxels
newbinary(ismember(labels, 1)) = 0; %set outermost voxel cluster (skull voxels) to zero
SE = strel("sphere",5); %create sphere structuring element to use to dilate the mask around the areas of interest
binaryImage = imdilate(newbinary, SE); %dilate mask so we don't lose too much brain tissue image

%show original volume and then volume with the mask over all non-brain
%elements
figure, imshow(Vol(:,:,100));
Vol(~binaryImage) = 0;
Vol(binaryImage) = 1;
figure, imshow(Vol(:,:,100));
brain = Vol;
end