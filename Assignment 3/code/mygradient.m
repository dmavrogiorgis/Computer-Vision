function [mag,ori] = mygradient(I)
%
% compute image gradient magnitude and orientation at each pixel
%
%
assert(ndims(I)==2,'input image should be grayscale');

sobel_y = (-1)*fspecial('sobel');
sobel_x = sobel_y';

dx = imfilter(I, sobel_x, 'replicate');
dy = imfilter(I, sobel_y, 'replicate');

mag = sqrt(dx.^2 + dy.^2);
ori = atan2(dy, dx);

assert(all(size(mag)==size(I)),'gradient magnitudes should be same size as input image');
assert(all(size(ori)==size(I)),'gradient orientations should be same size as input image');

figure;
colorbar;
colormap jet;
imagesc(mag);
title('Magnitude');

figure;
imagesc(ori);
colorbar;
colormap hsv;
title('Orientation');

end 

