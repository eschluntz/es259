% Toy script
% tests the pipeline with a small toy example

clear;
close all;

% fake data
%img = tril(ones(500));
%img = [ones(100,25), zeros(100,75)];
%edge_im = edge(img);
img = rgb2gray(imread('data/raw/steve.jpg'));
edge_im = double(imread('data/pb/pb_1.png'));
edge_im = edge_im / max(edge_im(:));
edge_im = edge_im .* (edge_im > .1);

% connect image
se = strel('disk',1);
edge_im = imclose(edge_im,se);

A = 20;

% start process
disp('generating segments');
[Segs, Starts, Ends] = generate_segments(edge_im);

disp('assigning segments');
Segs = assign_fs(Segs, edge_im);

% get best curve
disp('getting best');
find_curve;

imagesc(edge_im);
hold on;
plot(curve(:,1), curve(:,2));
