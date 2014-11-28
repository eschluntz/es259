function [M, id] = add_seg(x, y, nx, ny, M, id, max_x, max_y)
%add_seg adds segment to matrix if valid
    if (x > 0 && x <= max_x && y > 0 && y <= max_y && ...
        nx > 0 && nx <= max_x && ny > 0 && ny <= max_y)
        M(id,:) = [x,y, nx, ny, 0, 0];
        id = id + 1;
    end
end