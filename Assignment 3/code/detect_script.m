%
% This is a simple test script to exercise the detection code.
%
% It assumes that the template is exactly 16x16 blocks = 128x128 pixels.
% You will want to modify it so that the template size in blocks is a
% variable you can specify in order to run on your own test examples
% where you will likely want to use a different sized template
%

close all; clear all;

% pics : 
% data/faces1.jpg
% data/faces2.jpg
% data/car1.jpg
% data/car2.jpg
% data/test1.jpg
% data/test3.jpg

path_to_train_image = 'data/car2.jpg';
path_to_test_image = 'data/car1.jpg';

% load a training example image
Itrain = im2double(rgb2gray(imread(path_to_train_image)));

template_width = 15;
template_height = 11;

[left_limit_template_width, right_limit_template_width] = get_limits(template_width);
[left_limit_template_height, right_limit_template_height] = get_limits(template_height);

% block size is 8 pixels
patch_width = template_width * 8;
patch_height = template_height * 8;

[left_limit_patch_width, right_limit_patch_width] = get_limits(patch_width);
[left_limit_patch_height, right_limit_patch_height] = get_limits(patch_height);


%have the user click on some training examples.
% If there is more than 1 example in the training image (e.g. faces), you could set nclicks higher here and average together
nclick = 4;
figure(1); clf;
imshow(Itrain);
title('Choose positive training examples');
[x,y] = ginput(nclick); %get nclicks from the user

%compute 8x8 block in which the user clicked
blockx = round(x/8);
blocky = round(y/8);

%visualize image patch that the user clicked on
% the patch shown will be the size of our template
% since the template will be 16x16 blocks and each
% block is 8 pixels, visualize a 128pixel square
% around the click location.
figure(2); clf; suptitle('Positive patches');
for i = 1:nclick
  patch = Itrain(8*blocky(i)+(left_limit_patch_height:right_limit_patch_height),8*blockx(i)+(left_limit_patch_width:right_limit_patch_width));
  figure(2); subplot(3,2,i); imshow(patch);
end

% compute the hog features
f = hog(Itrain);

% compute the average template for the user clicks
postemplate = zeros(template_width,template_height,9);
for i = 1:nclick
  postemplate = postemplate + f(blocky(i)+(left_limit_template_width:right_limit_template_width),blockx(i)+(left_limit_template_height:right_limit_template_height),:);
end
postemplate = postemplate/nclick;


% TODO: also have the user click on some negative training
% examples.  (or alternately you can grab random locations
% from an image that doesn't contain any instances of the
% object you are trying to detect).

Ineg_train = im2double(rgb2gray(imread(path_to_train_image)));

figure(5); clf;
imshow(Ineg_train);
title('Choose negative training examples');
[x_neg,y_neg] = ginput(nclick); %get nclicks from the user

%compute 8x8 block in which the user clicked
blockx_neg = round(x_neg/8);
blocky_neg = round(y_neg/8);

figure(6);
suptitle('Negative patches');
for i = 1:nclick
  patch = Ineg_train(8*blocky_neg(i)+(left_limit_patch_height:right_limit_patch_height),8*blockx_neg(i)+(left_limit_patch_width:right_limit_patch_width));
  subplot(3,2,i); imshow(patch);
end

% now compute the average template for the negative examples
negtemplate = zeros(template_width,template_height,9);
for i = 1:nclick
  negtemplate = negtemplate + f(blocky_neg(i)+(left_limit_template_width:right_limit_template_width),blockx_neg(i)+(left_limit_template_height:right_limit_template_height),:);
end
negtemplate = negtemplate/nclick;

% our final classifier is the difference between the positive
% and negative averages
template = postemplate - negtemplate;

%
% load a test image
%
Itest = im2double(rgb2gray(imread(path_to_test_image)));


% find top 8 detections in Itest
ndet = 8;
[x,y,score] = detect(Itest,template,ndet);
ndet = length(x);

%display top ndet detections
figure; clf; imshow(Itest);
for i = 1:ndet
  % draw a rectangle.  use color to encode confidence of detection
  %  top scoring are green, fading to red
  hold on;
  % left center corner is x(i) - right_limit_patch_width ,y(i) - right_limit_patch_width which is
  % patch_width devided by two +- 1
  h = rectangle('Position',[x(i)-right_limit_patch_width y(i)-right_limit_patch_width patch_width patch_height],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]);
  hold off;
end
