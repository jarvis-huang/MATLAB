
% 526 -> 545
clear;
clc;
start = 912;
finish = 944;

img = imread(['curve_left/Video 3_0', num2str(start),'.jpe']);
i = img(:,185:1096,:);
sz = size(i);
i_cut = i(1:sz(1)/2,:,:);
[x,y,A,rect] = imcrop(i_cut); % A is the output of cropping

A = rgb2hsv(A);
h = round(rect(4));
w = round(rect(3));
std_bin_h = zeros(1,11);
std_bin_s = zeros(1,11);
std_bin_v = zeros(1,11);

for i=1:rect(4)
    for j=1:rect(3)
        if A(i,j,2) > 0.1 && A(i,j,3) > 0.2
            which_bin = round(A(i,j,1)/0.1)+1;
            std_bin_h(which_bin) = std_bin_h(which_bin)+1;
            which_bin = round(A(i,j,2)/0.1)+1;
            std_bin_s(which_bin) = std_bin_s(which_bin)+1;
            which_bin = round(A(i,j,3)/0.1)+1;
            std_bin_v(which_bin) = std_bin_v(which_bin)+1;
        end
    end
end

std_bin_h = std_bin_h/sum(std_bin_h);
std_bin_s = std_bin_s/sum(std_bin_s);
std_bin_v = std_bin_v/sum(std_bin_v);

last_x = round(rect(2));
last_y = round(rect(1));

for num = start+1:finish
    
    img = imread(['curve_left/Video 3_0', num2str(num),'.jpe']);
    i = img(:,185:1096,:);
    sz = size(i);
    i_cut = i(1:sz(1)/2,:,:);
    sz = size(i_cut);
    A = rgb2hsv(i_cut);
    
    sel_x = 0;
    sel_y = 0;
    min_dist = Inf;
    
    for i=last_x-20:last_x+20
        for j=last_y-20:last_y+20
            if i<1 || i>sz(1)-h || j<1 || j>sz(2)-w
                continue;
            end
            bin_h = zeros(1,11);
            bin_s = zeros(1,11);
            bin_v = zeros(1,11);
            for ii=i:i+h-1
                for jj=j:j+w-1
                    if A(ii,jj,2) > 0.1 && A(ii,jj,3) > 0.2
                        which_bin = round(A(ii,jj,1)/0.1)+1;
                        bin_h(which_bin) = bin_h(which_bin)+1;
                        which_bin = round(A(ii,jj,2)/0.1)+1;
                        bin_s(which_bin) = bin_s(which_bin)+1;
                        which_bin = round(A(ii,jj,3)/0.1)+1;
                        bin_v(which_bin) = bin_v(which_bin)+1;
                    end
                end
            end
            if sum(bin_h)==0 || sum(bin_s)==0 || sum(bin_v)==0
                continue;
            end
            bin_h = bin_h/sum(bin_h);
            bin_s = bin_s/sum(bin_s);
            bin_v = bin_v/sum(bin_v);
            dist = sum((std_bin_h - bin_h).^2 + (std_bin_s - bin_s).^2 + (std_bin_v - bin_v).^2);
            if dist < min_dist
                min_dist = dist;
                sel_x = i;
                sel_y = j;
            end
        end
    end
    imshow(i_cut);hold on;
    plot(sel_y:sel_y+w-1,sel_x,'LineWidth',2,'Color','red');
    plot(sel_y:sel_y+w-1,sel_x+h-1,'LineWidth',2,'Color','red');
    plot(sel_y,sel_x:sel_x+h-1,'LineWidth',2,'Color','red');
    plot(sel_y+w-1,sel_x:sel_x+h-1,'LineWidth',2,'Color','red');
    
    last_x = sel_x;
    last_y = sel_y;
    pause(0.5);
end
            
                    
    
