% ES 259 pset 6: image segmentation
clear;
close all;
files = {'ducks.jpg','butterflies.jpg'};
     
for j = 1:size(files,2)
    figure;
    img = imread(files{j});
    subplot(2,2,1);
    imshow(img);
    
    % take smallest of three colors
    % to make objects stand out as much as possible from white
    gray = min(img,[],3);
    subplot(2,2,2);
    imshow(gray);
    
    % threshold
    bw = gray < 200;
    
    % select the background (largest black scc)
    back = ~bw;
    labels = bwlabel(back);
    stats = regionprops(labels);
    [areas, ids] = sort([stats.Area]); % increasing order
    ids = fliplr(ids);
    areas = fliplr(areas);
    
    % only taking background chunks greater than 500px
    bg_ids = ids(areas > 500);
    
    % assemble total background
    back = 0*back;
    for i = 1:size(bg_ids,2);
        back = (back > 0) + (labels == bg_ids(i));
    end
    
    se = strel('disk',2);
    back = imclose(back,se);
    back = imdilate(back,se);

    fg = ~back;
    subplot(2,2,3);
    imshow(fg);
    
    % separating the foreground
    labels = bwlabel(fg);
    stats = regionprops(labels);
    
    % getting objects
    [areas, ids] = sort([stats.Area]); % increasing order
    ids = fliplr(ids);
    areas = fliplr(areas);
    fg_ids = ids(areas > 50);
    
    % showing largest object
    subplot(2,2,4);
    imshow(labels == fg_ids(1));
    hold on;
    % outputting statistics
    disp(files{j});
    number_of_objects = numel(fg_ids)
    location = stats(fg_ids(1)).Centroid
    area = stats(fg_ids(1)).Area
    bb = stats(fg_ids(1)).BoundingBox;
    length = bb(3)
    plot(location(1), location(2), 'r+');
    plot([bb(1),bb(1) + bb(3)], [bb(2)+bb(4), bb(2)+bb(4)], 'g-');
    
end