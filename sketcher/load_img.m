function [edge_im] = load_img(name)
    edge_im = double(imread(name));
    edge_im = edge_im / max(edge_im(:));
    edge_im = edge_im .* (edge_im > .1);
    se = strel('disk',1);
    edge_im = imclose(edge_im,se);
    imshow(edge_im);
    hold on;
    pause(.01);
end