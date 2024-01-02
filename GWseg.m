%a function that calculates the grey and white matter of all the 270
%datasets we are using
function [GM,WM] = GWseg

GM = zeros(270,1);
WM = zeros(270,1);
% Specify the folder where the files live.
myFolder = 'C:\Users\Jiayin\Desktop\Project 2\volumes';

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.nii.gz');
theFiles = dir(filePattern);
for k = 1 : 270
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    I = niftiread(fullFileName);
    I = im2uint8(I);
    [gm,wm] = segmentGW(I);
    GM(k) = gm;
    WM(k) = wm;

end