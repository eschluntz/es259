% Toy script
% tests the pipeline with a small toy example

clear;
close all;

addpath('myqueue_1.1');
% fake data
%img = tril(ones(500));
img = [ones(100,25), zeros(100,75)];
%img = imresize(rgb2gray(imread('data/raw/steve.jpg')),[500,500]);
edge_im = edge(img);

A = 5;

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
