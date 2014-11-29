function [segs] = assign_fs(segs, edge_im)
    % assigns a filter respones to each segment in the image
    % based on the average PB response at those pixels under the seg

    % Segs = [x1, y1, x2, y2, Fs, l]...
    % edge_im = edge detected image, double
    N = 10;

    result = zeros(size(segs,1),1);

    % for each segment
    for j = 1:size(segs,1)
        sg = segs(j,:);
        % sample 10 points between p1 and p2
        xs = linspace(sg(1), sg(3), N);
        ys = linspace(sg(2), sg(4), N);
        vals = interp2(double(edge_im), xs, ys);

        % storing the average as Fs
        result(j) = mean(vals(:));
    end

    % storing result
    segs(:,5) = result;
    segs(:,6) = 1;
end
