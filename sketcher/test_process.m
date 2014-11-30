clear;
close all;

root = 'data/raw/';
files = {'taj.jpg','pyramid.jpg'};
     
for j = 1:size(files,2)
    img = imread(strcat(root,files{j}));
    
    % resize to have largest dimension be 500
    d = max(size(img));
    img = imresize(img, 700/d);
    %figure;
    %imshow(img);
    gray = rgb2gray(img);
    %figure;
    %imshow(gray);
    %BW = edge(gray, 'canny', .2, 1);
    
    max_px = double(max(img(:)));
    min_px = double(min(img(:)));
    img = (double(img) - min_px) / (max_px - min_px);
    BW = pbCGTG(img);
    imwrite(BW, strcat('data/pb/pb_',num2str(j+8),'.png'));
    disp('finished photo');
    figure;
    imshow(BW);
    pause(1);
    
    % finds edgelets
    [H,theta,rho] = hough(BW, 'Theta', -90:.1:89);
    
    P = houghpeaks(H,1,'threshold',ceil(0.1*max(H(:))));
    lines = houghlines(BW,theta,rho,P,'FillGap',5,'MinLength',7);
    
    figure, imshow(img), hold on;
    cla;
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',1,'Color','green');

       % Plot beginnings and ends of lines
       %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end
    
end
    
