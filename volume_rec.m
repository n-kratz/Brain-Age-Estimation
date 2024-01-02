%the function that records the volumes of all the labeled regions
%respectively
function vol = volume_rec

vol = zeros(123,209); %sample numbers x feature numbers, change upon requirement
% Specify the folder where the files live.
myFolder = 'C:\Users\Jiayin\Desktop\Project 2\segments';

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.nii');
theFiles = dir(filePattern);
for k = 1 : 123
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    I = niftiread(fullFileName);
    vol(k,:) = find_vol(I);
end
