clear;
clc;
tic
start = 631;
finish = 690;

th_low = 0.02;
th_high = 0.1;

img = imread(['curve_left/Video 4_0', num2str(start),'.jpe']);
i = img;
i = i(:,185:1096,:); % cut off left and right black film strip
sz = size(i);
i = i(1:sz(1)/2,:,:); % remove lower half
sz = size(i);

edge_data = zeros(finish-start+1,sz(1),sz(2));

for tt=start:finish
 
   img = imread(['curve_left/Video 4_0', num2str(tt),'.jpe']);
   i = img;
   i = i(:,185:1096,:); % cut off left and right black film strip
   sz = size(i);
   i_hsv = rgb2hsv(i);
   
   i_cut = i_hsv(1:sz(1)/2,:,:); % remove lower half
   i_canny_v = edge(i_cut(:,:,3),'canny', [th_low, th_high], 3);
   edge_data(tt-start+1,:,:) = i_canny_v;
end

save 'edge_data.mat' edge_data;

figure;
toc
t = toc
title(t)