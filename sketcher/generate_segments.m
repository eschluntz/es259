function [M, Starts, Ends] = generate_segments(img)
% generates all possible segments from an image
% Each pixel has 16 segments leaving it, 2 neighbors away

    debug = false;
    max_x = size(img,2);
    max_y = size(img,1);

    Segs = zeros(16 * max_x * max_y, 6);
    Starts = zeros(size(img));
    Ends = zeros(size(img));
    id = 1;
    
    % each pixel
    for x = 1:size(img,2)
        for y = 1:size(img,1)
            Starts(x,y) = id;
            % add neighbors in spiral
            for dp = -1:2

                % top
                nx = x + dp;
                ny = y + 2;
                [Segs, id] = add_seg(x,y,nx,ny, Segs, id, max_x, max_y);

                % right
                nx = x + 2;
                ny = y - dp;
                [Segs, id] = add_seg(x,y,nx,ny, Segs, id, max_x, max_y);

                % bottom
                nx = x - dp;
                ny = y - 2;
                [Segs, id] = add_seg(x,y,nx,ny, Segs, id, max_x, max_y);

                % left
                nx = x - 2;
                ny = y + dp;
                [Segs, id] = add_seg(x,y,nx,ny, Segs, id, max_x, max_y);
            end
            Ends(x,y) = id-1;
        end
    end
    
    % trimming Segs
    M = Segs(1:id-1,:);

    if debug
        draw_segs(Segs);
        pause(.1);
    end
end
            