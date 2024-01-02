function T = threshold(Vol)

%set low initial threshold so that only the background falls below it
Tlast = 0.2;
n = 1;
while n < 2 %until there are 2 clumps of pixels in the image
    Tlast = Tlast + .006; %increment threshold
    skull = Vol >= Tlast; 
    binary = Vol*0;
    binary(skull) = 1; %set everything in image above threshold to 1, below threshold to 0
    newbinary = bwareaopen(binary, 10000); %remove pixel clumps smaller than 10000
    [~, n] = bwlabeln(newbinary); %find number of pixel clumps
end
T = Tlast; %update threshold to lowest value with 2 pixel clumps
end