function [ blob_circle_pos ] = retrieveBlobs( scale_space, sigma, k)
    %create a total_circle x 3 matrix where column 1 is x, column 2 is y pos,
    %and column 3 is radius
    
    [~,~,layers] = size(scale_space);
    blob_circle_pos = [];
    for i = 1:layers
        %find indices where values are not 0 => maximum values
        [new_row, new_col] = find(scale_space(:,:,i));
        
        new_circles = [new_col, new_row];
        new_circles(:,3) = sqrt(2)*sigma*k^(i-1);
        
        %append the calculated positions/radius for this slice to the
        %entire collection (transpose of course)
        blob_circle_pos = [blob_circle_pos; new_circles];       
    end

end
