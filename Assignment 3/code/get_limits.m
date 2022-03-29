function [left,right] = get_limits(num)

if mod(num,2) == 0
    left = -floor((num-1)/2);
    right = num/2;
else 
    left = -floor((num)/2);
    right = floor(num/2);
end

end