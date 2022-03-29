function [blobs] = blobDetection(image, layers, sigma, k, threshold, isDownsamplingImg)
 
scaleSpace = createScaleSpace(image, layers, sigma, k, isDownsamplingImg);


%% 2D Non-Maximum Suppression
nms_scale_space = cell(1,layers);
for i = 1:layers
    nms_scale_space{i} = ordfilt2(scaleSpace{i}, 9, ones(3,3)); %implements a 3-by-3 maximum filter
end

%% 3D Non-Maximum Suppression
maxima_scale_space = cell(1,layers);
for i = 1:layers
    if i == 1
        %concatenate in 3 dimensions
        neighborhood =  cat(3,nms_scale_space{i},nms_scale_space{i+1});
    elseif i < layers
        %concatenate in 3 dimensions
        neighborhood =  cat(3,nms_scale_space{i-1},nms_scale_space{i},nms_scale_space{i+1});
    else
        %concatenate in 3 dimensions
        neighborhood =  cat(3,nms_scale_space{i-1},nms_scale_space{i});
    end
    %computes the maximum over the 3 dimensions
    maxima_scale_space{i} = max(neighborhood,[],3);
    
end

% conver to arrays
maxima_array = cellToArray(maxima_scale_space);
scaleSpace_array = cellToArray(scaleSpace);

% mark the max values as 1 otherwise 0
extrema_marker_vals = maxima_array == scaleSpace_array;
nms_3D_scale_space = maxima_array .* extrema_marker_vals;

%% Threshold
isBiggerThanThreshold = nms_3D_scale_space > threshold;
nms_3D_scale_space = nms_3D_scale_space .* isBiggerThanThreshold;

blobs = nms_3D_scale_space;
end