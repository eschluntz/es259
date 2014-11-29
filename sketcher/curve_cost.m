function [c,l] = curve_cost(curve)
    % curve_cost returns a scalar cost of a given curve
    % curve should be a matrix of successive continuous segments
    % seg = [x1, y1, x2, y2, Fs, l]

    A = 10;

    seg_costs = 0;
    l = 0;
    for j = 1:size(curve,1)
        seg_costs = seg_costs + -log(curve(j,5));
        l = l + curve(j,6);
    end

    bend_costs = 0;
    for j = 1:size(curve,1)-1
        bend_costs = bend_costs + bend_cost(curve(j,:), curve(j+1,:));
    end

    c = A + seg_costs + bend_costs;
end