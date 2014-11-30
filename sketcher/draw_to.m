function [xyz, cur] = draw_to(cur_pos, xs, ys, bw, z, sample_rate)
    % draw_to creates a trajectory along a given path
    % direction of path is set by bw (backwards)

    xs = xs(isfinite(xs));
    ys = ys(isfinite(ys));

    if (bw)
        xs = flipud(xs);
        ys = flipud(ys);
    end

    n = size(xs,1);

    xyz = [];
    for i = 1:sample_rate:n
        xyz = [xyz; [xs(i),ys(i),z]];
    end
    xyz = [xyz; [xs(n), ys(n), z]];
    cur = [xs(n), ys(n)];
end