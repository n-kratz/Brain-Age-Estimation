%a helper method specifically to deal with image sets unavailable 
%after segmentation

function M = takeoutmiss(miss,B)
counterM = 1;
counterB = 1;
M = zeros(1,123);
for i = 1:270
    if i == miss(counterB)
        if counterB < length(miss)
            counterB = counterB + 1;
        end
    else
        M(counterM) = B(i);
        counterM = counterM + 1;
    end
end
