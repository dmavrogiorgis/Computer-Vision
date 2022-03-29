clear; close all; clc;

%% Initialization
path_to_img = './Data/fishes.jpg';
img = imread(path_to_img);
figure;
imshow(img);
img = im2double(rgb2gray(img));


%% Algorithm's properties
tic;
layers = 15;
sigma = 2;
threshold = 0.005;

isDownsamplingImg = true;

%scale multiplication constant
k = sqrt(sqrt(2)); 

%% Algorithm implementation
blobs = blobDetection(img, layers, sigma, k, threshold, isDownsamplingImg);

%% Retrieve and display circles
blob_circle_pos = retrieveBlobs(blobs, sigma, k);
toc;

x_pos = blob_circle_pos(:,1); %col positions
y_pos = blob_circle_pos(:,2); %row positions
radius = blob_circle_pos(:,3); %radius

show_all_circles(img, x_pos, y_pos, radius, 'r', .5); 