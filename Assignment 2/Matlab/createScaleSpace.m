function [scale_space] = createScaleSpace(image, layers, sigma, k, isDownsamplingImg)

    % each cell is a layer of the pyramid
    scale_space = cell(1,layers);
    
    if isDownsamplingImg
        % odd filter size
        filter_size = 2*ceil(sigma*3)+1;

        % Create a Laplacian of Gaussian 
        LOG_filter = fspecial( 'log', filter_size, sigma );

        % Scale Normalize Laplacian
        LOG_filter=(sigma.^2)*LOG_filter;  

        % downsample the image multiple times
        for ii=1:layers
            if ii==1
                downsampled_img = image;
            else
                downsampled_img = imresize(image, 1/(k^(ii-1)), 'bicubic');
            end

            % create the laplacian response
            filtered_image = imfilter(downsampled_img, LOG_filter,'same', 'replicate');
            
            % Save square of Laplacian response
            filtered_image = filtered_image.^2;

            % upsample the laplacian response, to be reusable
            upsampled_img = imresize(filtered_image, size(image), 'bicubic');
            
            scale_space{ii} = upsampled_img;
        end
    else
        for ii = 1:layers
            %Compute the scaled std and resize the filter
            scaled_sigma = sigma*k^(ii-1);
            
            filter_size = 2*ceil(scaled_sigma*3)+1;  %+1 to guarantee odd filter size
            
            % Create a Laplacian of Gaussian filter
            LOG_filter = fspecial( 'log', filter_size, scaled_sigma );
            
            % Nomrmalize the filter 
            LOG_filter = scaled_sigma.^2*LOG_filter;      

            % Filter the image 
            filtered_image = imfilter(image, LOG_filter,'same', 'replicate');
            
            % Save square of Laplacian response
            filtered_image = filtered_image.^2;

            % Store it at the appropriate level in the scale space
            scale_space{ii} = filtered_image; 
        end
    end 
end

