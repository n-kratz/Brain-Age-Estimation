% a helper function that calculates the volume of the 209 labled regions
function vol = find_vol(img)
vol = zeros(1,209);
for i = 1:192
    for j = 1:224
        for k = 1:192
            a = img(i,j,k)+1;
            vol(a) = vol(a)+1;
        end
    end
end

