%a function that finds the volume of grey matter and the white matter of the original
%image datasets
function [GM, WM] = segmentGW(img)
GM = 0;
WM = 0;
for i = 1:192
    for j = 1:224
        for k = 1:192
            if img(i,j,k) > 40 && img(i,j,k) <= 58 %grey matter
                GM = GM + 1;
            elseif img(i,j,k) > 58 && img(i,j,k) < 71 %white matter
                WM = GM + 1;
            end
        end
    end
end
%GM = GM / 8257536;
%WM = WM / 8257536;