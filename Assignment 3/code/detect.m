function [x,y,score] = detect(I,template,ndet)
%
% return top ndet detections found by applying template to the given image.
%   x,y should contain the coordinates of the detections in the image
%   score should contain the scores of the detections
%


% compute the feature map for the image
f = hog(I);

nori = size(f,3);

% cross-correlate template with feature map to get a total response
R = zeros(size(f,1),size(f,2));
for i = 1:nori
  R = R + imfilter(f(:,:,i), template(:,:,i));
end

% now return locations of the top ndet detections

% sort responses from high to low
[val,ind] = sort(R(:),'descend');

% work down the list of responses, removing overlapping detections as we go
i = 1;
detcount = 0;
x = zeros(ndet,1);
y = zeros(ndet,1);
score = zeros(ndet,1);
while ((detcount < ndet) & (i <= length(ind)))
  % convert ind(i) back to (i,j) values to get coordinates of the block
  [yblock,xblock] =  ind2sub(size(R), ind(i));

  assert(val(i)==R(yblock,xblock)); %make sure we did the indexing correctly

  % now convert yblock,xblock to pixel coordinates
  ypixel = 8*yblock;

  xpixel = 8*xblock;

  % check if this detection overlaps any detections which we've already added to the list
  % you should do this by comparing the x,y coordinates of the new candidate detection to all
  % the detections previously added to the list and check if the distance between the
  % detections is less than 70% of the template width/height
  overlap = false;

  limit = 0.7*size(template,2)*8;

  % there is no overlap in the first time.
  if i ~= 1
        for ii = 1:size(x,1)
            for jj = 1:size(y,1)
                points = [xpixel,ypixel ; x(ii), y(jj)];
                
                %calculate distance between each point
                d = pdist(points,'euclidean');
                if(d < limit)
                  overlap = true;
                end
            end
        end
  end

  % if not, then add this detection location and score to the list we return
  if (~overlap)
    detcount = detcount+1;
    x(detcount) = xpixel;
    y(detcount) = ypixel;
    score(detcount) = R(yblock,xblock);
  end
  i = i + 1;
end


% the while loop may terminate before we find the desired number
% of detections... in that case you should shrink the vectors
% x,y,score down to the correct size

% detcount never greater.
if(length(x) > detcount)
    x = x(1:detcount);
    y = y(1:detcount);
    score = score(1:detcount);
end

assert(length(x)==detcount);
assert(length(y)==detcount);
assert(length(score)==detcount);

end
