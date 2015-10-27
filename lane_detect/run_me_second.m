% -- verfify --
%test_with_acceleration;
load far_left_edge_data
load left_edge_data
load right_edge_data

count = 1;
istart = 650;
start = 650;
finish = 690;
for numera = start:finish % 2650 ->

i = imread(['curve_left/Video 4_0', num2str(numera),'.jpe']);
i = i(:,185:1096,:); % cut off left and right black film strips
sz = size(i);

i_hsv = rgb2hsv(i);

i_cut = i_hsv(1:sz(1)/2,:,:);
%i_cut = i_hsv;
%subplot(3,3,count);count=count+1;
figure;
imshow(hsv2rgb(i_cut));hold on;

%% -- for FAR LEFT edge ---

choice = 0;

switch choice
    case 0
        %true test with KF
        rho = fl_rho(numera-istart+1)-980;
        theta = (fl_theta(numera-istart+1)-90)/180*pi;
    case 1
        %test with algo without KF
        rho = lll(1,numera-35)-373;
        theta = (lll(2,numera-35)-90)/180*pi;
    case 2
        %test with hand drawn, perfect
        rho = true(1,numera)-373;
        if true(2,numera) < 0
            theta = (true(2,numera)+90)/180*pi;
        else
            theta = (true(2,numera)-90)/180*pi;
        end
    case 3
        %true test with my own algo
        rho = l_rho_new(numera-35)-373;
        theta = (l_theta_new(numera-35)-90)/180*pi;
end

x = [];
y = [];
sz = size(i_cut);
for i = 1:sz(2)
    j = round ((rho-(i-1)*cos(theta))/sin(theta)+1);
    if j>=1 && j<=sz(1)
        x(end+1)=i;
        y(end+1)=j;
    end
end
if fl_theta(numera-istart+1)~=0 && fl_rho(numera-istart+1)~=0
    plot(x,y,'LineWidth',2,'Color','red');
end

%% -- for LEFT edge ---

choice = 0;

switch choice
    case 0
        %true test with KF
        rho = l_rho(numera-istart+1)-980;
        theta = (l_theta(numera-istart+1)-90)/180*pi;
    case 1
        %test with algo without KF
        rho = lll(1,numera-35)-373;
        theta = (lll(2,numera-35)-90)/180*pi;
    case 2
        %test with hand drawn, perfect
        rho = true(1,numera)-373;
        if true(2,numera) < 0
            theta = (true(2,numera)+90)/180*pi;
        else
            theta = (true(2,numera)-90)/180*pi;
        end
    case 3
        %true test with my own algo
        rho = l_rho_new(numera-35)-373;
        theta = (l_theta_new(numera-35)-90)/180*pi;
end

x = [];
y = [];
sz = size(i_cut);
for i = 1:sz(2)
    j = round ((rho-(i-1)*cos(theta))/sin(theta)+1);
    if j>=1 && j<=sz(1)
        x(end+1)=i;
        y(end+1)=j;
    end
end
if l_theta(numera-istart+1)~=0 && l_rho(numera-istart+1)~=0
    plot(x,y,'LineWidth',2,'Color','green');
end

%% -- for RIGHT edge ---
choice = 0;
switch choice
    case 0
        %true test with KF
        rho = 980 - r_rho(numera-istart+1);
        theta = (r_theta(numera-istart+1)+90)/180*pi;
    case 1
        %test with algo without KF
        rho = lll(1,numera-35)-373;
        theta = (lll(2,numera-35)-90)/180*pi;
    case 2
        %test with hand drawn, perfect
        rho = true(1,numera)-373;
        if true(2,numera) < 0
            theta = (true(2,numera)+90)/180*pi;
        else
            theta = (true(2,numera)-90)/180*pi;
        end
    case 3
        %true test with my own algo
        rho = l_rho_new(numera-35)-373;
        theta = (l_theta_new(numera-35)-90)/180*pi;
end

x = [];
y = [];
sz = size(i_cut);
for i = 1:sz(2)
    j = round ((rho-(i-1)*cos(theta))/sin(theta)+1);
    if j>=1 && j<=sz(1)
        x(end+1)=i;
        y(end+1)=j;
    end
end
if r_theta(numera-istart+1)~=0 && r_rho(numera-istart+1)~=0
    plot(x,y,'LineWidth',2,'Color','blue');
end


title(numera);
hold off;
saveas(gcf,['out/out_', num2str(numera),'.jpe']);
% pause (0.1);
% close;
end
close all;