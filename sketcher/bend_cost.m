function [c] = bend_cost(s1, s2)
    % returns a cost for the transition between two segments
    % based on how sharp the curve is, or other parameters
    
    % checking continuity
    assert(s1(3) == s2(1));
    assert(s1(4) == s2(2));

    % s1, s2 = [x1, y1, x2, y2, Fs, l]
    v1 = [s1(1) - s1(3), s1(4) - s1(2), 0];
    v2 = [s2(1) - s2(3), s2(4) - s2(2), 0];
    th = abs(atan2(norm(cross(v1,v2)), dot(v1,v2)));

    % cost as a function of theta
    if (th > pi / 5)
        c = inf;
    else
        c = 0;
    end
    
    assert(c >= 0);
end