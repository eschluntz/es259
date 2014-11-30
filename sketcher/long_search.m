%function [] = long_search(G,edge_im)
% finds approximate longest path in image

% pick origin node
[r,c] = find(G);
origin = datasample(r,1);
%origin = 187;

% BFS
[d, pred] = shortest_paths(G, origin);

% finding local maxima
d = d < inf; % just connected components = 1
pred = nonzeros(pred);
d(pred) = 0; % zero out anything that has children

maxima = find(d);
res_d = zeros(numel(d), size(maxima,1));
res_p = zeros(numel(d), size(maxima,1));
% do BFS from each, record longest distance
for j = 1:size(maxima,1)
    [d, pred] = shortest_paths(G,maxima(j));
    d(~isfinite(d)) = -1;
    res_d(:,j) = d;
    res_p(:,j) = pred;
end

% starting point
[v1,i1] = max(max(res_d));
start = maxima(i1);

% ending point
[v2,i2] = max(res_d(:,i1));
dest = i2;

% getting path
pred = res_p(:,i1);

pathi = [dest];
while (dest ~= start)
    dest = pred(dest);
    pathi = [pathi; dest];
end

% converting to pixels
curve = zeros(size(pathi,1),2);
for j = 1:size(pathi,1)
    [y,x] = ind2sub(size(edge_im), pathi(j));
    curve(j,:) = [x,y];
end

imshow(edge_im);
hold on;
plot(curve(:,1), curve(:,2), 'linewidth',4);
%end