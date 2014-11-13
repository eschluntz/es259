function [start, goal] = image_detect(filename)
% image_detect takes an image filename, and locations of start and goal in
% pixels

threshold = 175;

% processing image
img = imread(filename);
img = rgb2gray(img);
img = img < threshold;

% getting two largest chunks
labels = bwlabel(img);
stats = regionprops(labels);

[~, ids] = sort([stats.Area]); % increasing order
ids = fliplr(ids);

goal = stats(ids(1)).Centroid;
start = stats(ids(2)).Centroid;

imshow(labels);
hold on;
scatter(goal(1), goal(2), 'r'); % goal
scatter(start(1), start(2), 'g') % start
