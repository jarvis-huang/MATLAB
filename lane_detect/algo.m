lll = zeros(2,3000);
rrr = zeros(2,3000);

for numera = 526:526 % 248 ---> 328
    %figure;
    i = imread(['curve_left/Video 3_0', num2str(numera),'.jpe']);

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
    figure;imshow(hsv2rgb(i_cut));hold on;
    [lines max_one success] = get_far_left_zone (i_cut,0);
    if success==1
       plot_line_on_img(i_cut,(max_one.theta)/180*pi,max_one.rho,'red');
    end
    [lines max_one success] = get_left_zone (i_cut,0);
    if success==1
        plot_line_on_img(i_cut,(max_one.theta)/180*pi,max_one.rho,'green');
    end
    [lines min_one success] = get_right_zone (i_cut,0);
    if success==1
        plot_line_on_img(i_cut,(min_one.theta)/180*pi,min_one.rho,'blue');
    end
    title(numera);
end
%close all;
% figure;
% subplot(1,3,1);imshow(i(:,:,1));title('R');
% subplot(1,3,2);imshow(i(:,:,2));title('G');
% subplot(1,3,3);imshow(i(:,:,3));title('B');
