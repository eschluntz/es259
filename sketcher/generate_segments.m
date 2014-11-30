function [M, Starts, Ends] = generate_segments(edge_im)
% generates all possible segments from an image
% Each pixel has 16 segments leaving it, 2 neighbors away

    %{
        RI: M is sorted by the (x,y) position of the start of the seg
        RI: only and all Seg(Starts(a,b):Ends(a,b)-1) = [a,b,...]
    %}

    debug = false;
    max_x = size(edge_im,2);
    max_y = size(edge_im,1);

    Segs = zeros(16 * max_x * max_y, 6);
    Starts = zeros(size(edge_im));
    Ends = zeros(size(edge_im));
    id = 1;
    
    % each pixel
    for x = 1:size(edge_im,2)
        for y = 1:size(edge_im,1)
            Starts(x,y) = id;
            if (edge_im(y,x)) % skip non edges
                % add neighbors in spiral
                dxs = [-1, 0, 1, 1, 1, 0, -1, -1];
                dys = [-1, -1, -1, 0, 1, 1, 1, 0];
                for j = 1:8
                    nx = x + dxs(j);
                    ny = y + dys(j);
                    if valid_px(x,y,nx,ny, max_x, max_y)
                        if edge_im(ny,nx)
                            Segs(id,:) = [x,y, nx, ny, 0, 0];
                            id = id + 1;
                        end
                    end
                end
            end
            Ends(x,y) = id;
        end
    end
    
    
    % trimming Segs
    M = Segs(1:id-1,:);
    
    size(M,1)

    if debug
        draw_segs(Segs);
        pause(.1);
    end
end
            