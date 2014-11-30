function [G] = generate_segments(G, edge_im)
% generates all possible segments from an image
% Each pixel has 8 neighbors

    

    %{
        RI: G(p1,p2) p1 < p2
    %}

    max_x = size(edge_im,2);
    max_y = size(edge_im,1);

    % each pixel
    for x = 1:size(edge_im,2)
        for y = 1:size(edge_im,1)
            if (edge_im(y,x)) % skip non edges
                % add neighbors in spiral
                dxs = [-1, 0, 1, 1, 1, 0, -1, -1];
                dys = [-1, -1, -1, 0, 1, 1, 1, 0];
                for j = 1:8
                    nx = x + dxs(j);
                    ny = y + dys(j);
                    if valid_px(x,y,nx,ny, max_x, max_y)
                        if edge_im(ny,nx)
                            % add edge
                            p1 = sub2ind(size(edge_im),y,x);
                            p2 = sub2ind(size(edge_im),ny,nx);
                            assert((edge_im(y,x) + edge_im(ny,nx))/2 >= 0);
                            assert((edge_im(y,x) + edge_im(ny,nx))/2 <= 1);
                            G(p1,p2) = (edge_im(y,x) + edge_im(ny,nx))/2;
                            G(p2,p1) = (edge_im(y,x) + edge_im(ny,nx))/2;
                        end
                    end
                end
            end
        end
    end
    
end
            