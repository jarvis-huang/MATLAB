function [P] = algo_param_right(img,rho_c,rho_r,theta_c,theta_r) % c-center, r-radius

i = img;
i = i(:,185:1096,:); % cut off left and right black film strip
sz = size(i);
%subplot(3,3,1);imshow(i);

i_hsv = rgb2hsv(i);
% min_v = min(min(i_hsv(:,:,3)));
% max_v = max(max(i_hsv(:,:,3)));
% sz=size(i_hsv);
% for i=1:sz(1)
%     for j=1:sz(2)
%          i_hsv(i,j,3)=(i_hsv(i,j,3)-min_v) / (max_v-min_v); % normalize value(brightness)
%          i_hsv(i,j,3) = sqrt(i_hsv(i,j,3)); % brightness boost
%     end
% end
%subplot(3,3,2);imshow(i_hsv(:,:,1));title('H');
%subplot(3,3,3);imshow(i_hsv(:,:,2));title('S');
%subplot(3,3,4);imshow(i_hsv(:,:,3));title('V');


i_cut = i_hsv(1:sz(1)/2,:,:); % remove lower half
[c_x c_y c_z] = size(i_cut);
i_cut(1:round(c_x/3),:,3) = 0; % remove top third
i_cut(:,1:round(c_y/2),3) = 0; % remove left half
%subplot(3,3,9);imshow(hsv2rgb(i_cut));title('after cut');
th_low = 0.02;
th_high = 0.1;

%i_canny_h = edge(i_cut(:,:,1),'canny', [th_low, th_high], 3);
%i_canny_s = edge(i_cut(:,:,2),'canny', [th_low, th_high], 3);
i_canny_v = edge(i_cut(:,:,3),'canny', [th_low, th_high], 3);
%subplot(3,3,5);imshow(i_canny_h);title('H');
%subplot(3,3,6);imshow(i_canny_s);title('S');
%subplot(3,3,7);imshow(i_canny_v);title('V');

while (1)
    BW = i_canny_v; % use v can provide best distinguishing effect
    [H,theta,rho] = hough(BW,'RhoResolution',1,'ThetaResolution',1);
    H(:,1:10) = 0; H(:,80:180) = 0; % slope has to be [10 80]
    H(:,1:round(theta_c)-theta_r) = 0; H(:,round(theta_c)+theta_r:180) = 0; % restrict theta
    ss = size(H);
    H_right = H;
    
    H_right(1:round(ss(1)/4),:) = 0; % restrict dist to middle half
    

    % -- right marking --
    H_right(round(rho_c)+rho_r:ss(1),:) = 0; % restrict rho
    H_right(1:round(rho_c)-rho_r,:) = 0;
    
    

    P = houghpeaks(H_right,3,'threshold',ceil(0.05*max(H_right(:)))); % find 3 peaks

    szp = size(P);
    if szp(1)<3
        theta_r = round(theta_r*1.2);
        rho_r = round(rho_r*1.2);
        if theta_c-theta_r<=0 || theta_c+theta_r>180 || rho_c-rho_r<=0 || rho_c+rho_r>ss(1)
            error('HJW');
        end
        continue;
    else
        break;
    end
end


%{
lines = houghlines(BW,theta,rho,pick,'FillGap',10,'MinLength',5);
subplot(3,3,8), imshow(BW), hold on
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
%}
%lll(1,numera-35)=pick(1);
%lll(2,numera-35)=pick(2);


%figure; mesh(H)

%{
% -- right marking --
H_right(round(ss(1)*3/4):ss(1),:) = 0; % restrict dist to middle half
H_right(1:round(ss(1)/4),:) = 0;
H_right(:,80:180) = 0; % restrict slope
P = houghpeaks(H_right,3,'threshold',ceil(0.1*max(H_right(:)))); % find 3 peaks

pick1 = P(1,:); % pick the left-most edge, i.e. with smallest rho
pick2 = P(2,:);
pick3 = P(3,:);

if pick1(1)<pick2(1) && pick1(1)<pick3(1)
    pick = pick1;
else if pick2(1)<pick1(1) && pick2(1)<pick3(1)
        pick = pick2;
    else
        pick = pick3;
    end
end

lines = houghlines(BW,theta,rho,pick,'FillGap',10,'MinLength',5);
%subplot(3,3,9), imshow(BW), hold on
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
rrr(1,numera-35)=pick(1);
rrr(2,numera-35)=pick(2);
end

% figure;
% subplot(1,3,1);imshow(i(:,:,1));title('R');
% subplot(1,3,2);imshow(i(:,:,2));title('G');
% subplot(1,3,3);imshow(i(:,:,3));title('B');
%}

