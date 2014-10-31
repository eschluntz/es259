function [  ] = draw_sp( pred, nodes )
%draw_sp draws shortest path through nodes
% assumes we start at index 1 and go to index 2

i = 2;
while i ~= 1
    plot([nodes(i,1),nodes(pred(i),1)], [nodes(i,2),nodes(pred(i),2)],'r','LineWidth',2);
    i = pred(i);
end

