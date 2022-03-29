function [array] = cellToArray(cell_array)
% Converts a cell array to multidimension-array (layers X width X height)

layers = size(cell_array,2);
[width,height] = size(cell_array{1});
array=zeros(width,height,layers);
for i=1:size(cell_array,2)
    array(:,:,i) = cell_array{i};
end

end

