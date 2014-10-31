function [] = draw(A, nodes)
%draw draws the valid paths on the screen

    figure;
    hold on;
    scatter(nodes(:,1), nodes(:,2));
    
    [n1,n2,v] = find(A);
    for i = 1:size(n1,1)
        plot([nodes(n1(i),1),nodes(n2(i),1)], [nodes(n1(i),2),nodes(n2(i),2)],'k');
    end

end

