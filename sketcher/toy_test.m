% Toy script
% tests the pipeline with a small toy example

clear;
close all;
addpath('matlab_bgl');
% fake data
%img = tril(ones(500));
%img = [ones(100,25), zeros(100,75)];

img = imresize(rgb2gray(imread('data/raw/steve.jpg')),[100,100]);
%edge_im = double(imread('data/pb/pb_1.png'));
%edge_im = edge_im / max(edge_im(:));
%edge_im = edge_im .* (edge_im > .1);
edge_im = edge(img);

% connect image
se = strel('disk',1);
edge_im = imclose(edge_im,se);

% data structure
G = sparse(numel(img),numel(img));
Curves = zeros(1000,50);

% create edges
disp('generating edges');
%[G] = generate_segments(G,edge_im);
generate_segments;

% find longest
disp('finding paths');
long_search;
