function [valid] = valid_px(x, y, nx, ny, max_x, max_y)
%add_seg adds segment to matrix if valid
    valid = (x > 0 && x <= max_x && y > 0 && y <= max_y && ...
        nx > 0 && nx <= max_x && ny > 0 && ny <= max_y);
end