function [lines max_one success] = get_left_zone (i_cut,is_plot)
max_one = 0;
[c_x c_y] = size(i_cut);

i_cut(1:round(c_x/2),:) = 0;
i_cut(:,round(c_y/2):c_y) = 0;

th_low = 0.02;
th_high = 0.1;

%i_canny_h = edge(i_cut(:,:,1),'canny', [th_low, th_high], 3);
%i_canny_s = edge(i_cut(:,:,2),'canny', [th_low, th_high], 3);
i_canny_v = i_cut;


BW = i_canny_v; % use v can provide best distinguishing effect
[H,theta,rho] = hough(BW,'RhoResolution',1,'ThetaResolution',1);

H(:,1:100) = 0; H(:,170:180)=0; % restrict slope

ss = size(H);
H(round(ss(1)*3/4):ss(1),:) = 0; % restrict dist to middle half
H(1:round(ss(1)/4),:) = 0;

P = houghpeaks(H,1,'threshold',ceil(0.05*max(H(:)))); % find 3 peaks

% pick1 = P(1,:); % pick the right-most edge, i.e. with greatest rho
% pick2 = P(2,:);
% pick3 = P(3,:);
% 
% if pick1(1)>pick2(1) && pick1(1)>pick3(1)
%     pick = pick1;
% else if pick2(1)>pick1(1) && pick2(1)>pick3(1)
%         pick = pick2;
%     else
%         pick = pick3;
%     end
% end

lines = houghlines(BW,theta,rho,P,'FillGap',10,'MinLength',50);


if isempty(lines) || ~isfield(lines(1), 'rho')
    success = 0;
else
    success = 1;
    
    max_rho = 0;
    
    for j = 1:length(lines)
        line = lines(j);
        rho = line.rho;
        if rho>max_rho
            max_rho = rho;
            max_one = line;
        end
    end
    
    if is_plot==1
        figure; imshow(BW);
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
end