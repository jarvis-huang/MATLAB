% %figure;
% i = imread(['curve_left/Video 4_0', num2str(545),'.jpe']);
% 
% i = i(:,185:1096,:); % cut off left and right black film strip
% i = i(1:360,:,:);
% sz = size(i);
% %subplot(2,2,1);imshow(i);
% i_hsv = rgb2hsv(i);
% [i_x i_y i_z] = size(i_hsv);
% 
% % for i = 1:i_x
% %     for j = 1:i_y
% %         i_hsv(i,j,1) = round(i_hsv(i,j,1)/0.1) * 0.1 ;
% %     end
% % end
% %subplot(2,2,2);imshow(i_hsv(:,:,1));title('H');
% 
% % for i = 5:i_x-4
% %     for j = 5:i_y-4
% %         %i_hsv(i,j,2) = abs ( mean(i_hsv(i,j-4:j-1,1)) - mean (i_hsv(i,j+1:j+4,1)) ) + abs ( mean(i_hsv(i,j-4:j-1,3)) - mean (i_hsv(i,j+1:j+4,3)) );
% %         if abs ( mean(i_hsv(i,j-4:j-1,1)) - mean (i_hsv(i,j+1:j+4,1)) ) >= 0.15 || abs ( mean(i_hsv(i,j-4:j-1,3)) - mean (i_hsv(i,j+1:j+4,3)) ) >= 0.15
% %             i_hsv(i,j,2) = 1;
% %         else
% %             i_hsv(i,j,2) = 0;
% %         end
% %     end
% % end
% %i_hsv(:,:,2) = i_hsv(:,:,2) / max(max(i_hsv(:,:,2)));
% %subplot(2,2,3);imshow(i_hsv(:,:,2));title('S');
% 
% % for i = 1:i_x
% %     for j = 1:i_y
% %         i_hsv(i,j,3) = round(i_hsv(i,j,3)/0.1) * 0.1 ;
% %     end
% % end
% %subplot(2,2,4);imshow(i_hsv(:,:,3));title('V');
% imshow(i_hsv(:,:,3))






i = imread(['curve_left/Video 4_0', num2str(545),'.jpe']);
i = i(:,185:1096,:); % cut off left and right black film strip
i = i(1:360,:,:);
% sz = size(i);
% %subplot(2,2,1);imshow(i);
i_hsv = rgb2hsv(i);
i_cut = i_hsv;

[c_x c_y c_z] = size(i_cut);
i_cut(1:round(c_x/3),:,3) = 0; % remove top third
i_cut(:,1:round(c_y/2),3) = 0; % remove left half

th_low = 0.02;
th_high = 0.1;

rho_r = 50;
theta_r = 10;
rho_c = 1080;
theta_c = 35;
low_bound_slope = 10;
up_bound_slope = 80;

i_canny_v = edge(i_cut(:,:,3),'canny', [th_low, th_high], 3);

% while (1)
    BW = i_canny_v; % use v can provide best distinguishing effect
    [H,theta,rho] = hough(BW,'RhoResolution',1,'ThetaResolution',1);
    H(:,1:low_bound_slope) = 0; H(:,up_bound_slope:180) = 0;
    H(:,1:round(theta_c)-theta_r) = 0; H(:,round(theta_c)+theta_r:180) = 0; % restrict theta
    ss = size(H);
    H(round(ss(1)*3/4):ss(1),:) = 0; % restrict dist to middle half, common sense
    H(1:round(ss(1)/4),:) = 0;
    H(round(rho_c)+rho_r:ss(1),:) = 0; % restrict rho
    H(1:round(rho_c)-rho_r,:) = 0;

    PP = houghpeaks(H,3,'threshold',ceil(0.05*max(H(:)))); % find 3 peaks
    lines = houghlines(BW,theta,rho,PP,'FillGap',10,'MinLength',50);
    
    if isempty(lines) || ~isfield(lines(1), 'rho')
        success = 0;
    else
        success = 1;
        figure;imshow(i_cut(:,:,3));hold on;
        max_len = 0;
        for k = 1:length(lines)
           xy = [lines(k).point1; lines(k).point2];
           plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

           % Plot beginnings and ends of lines
           plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
           plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

           % Determine the endpoints of the longest line segment 
           len = norm(lines(k).point1 - lines(k).point2);
           if ( len > max_len)
              max_len = len;
              xy_long = xy;
           end
        end
    end
