%#############
%This file uses Hough Transform to detect left/right edge of the lane
%#############

select_left = 0; % left=1, right=0

%lll and rrr store the output edge info
lll = zeros(2,400);
rrr = zeros(2,400);

for numera = 2690:2770 % 248 ---> 328
    i = imread(['img\Video 3_', num2str(numera),'.jpe']);
    i = i(:,185:1096,:); % cut off left and right black film strip
    sz = size(i);

    i_hsv = rgb2hsv(i);
    % i_hsv(:,:,1) - H component
    % i_hsv(:,:,2) - S component
    % i_hsv(:,:,3) - V component

    i_cut = i_hsv(1:sz(1)/2,:,:); % remove lower half

    th_low = 0.1;
    th_high = 0.2;

    % use v for best distinguishing effect
    i_canny_v = edge(i_cut(:,:,3),'canny', [th_low, th_high], 3);

    BW = i_canny_v; 
    [H,theta,rho] = hough(BW,'RhoResolution',1,'ThetaResolution',1);
    H(:,1:10) = 0; H(:,80:100) = 0; H(:,170:180) = 0; % slope has to be [+-10 +-80]
    ss = size(H);
    H_left = H;
    H_right = H;

    if select_left==1 
        % -- left marking --
        H_left(round(ss(1)*3/4):ss(1),:) = 0; % restrict dist to middle half
        H_left(1:round(ss(1)/4),:) = 0;

        H_left(:,1:100) = 0; % restrict slope
        P = houghpeaks(H_left,3,'threshold',ceil(0.1*max(H_left(:)))); % find 3 peaks

        pick1 = P(1,:); % pick the right-most edge, i.e. with greatest rho
        pick2 = P(2,:);
        pick3 = P(3,:);

        if pick1(1)>pick2(1) && pick1(1)>pick3(1)
            pick = pick1;
        else if pick2(1)>pick1(1) && pick2(1)>pick3(1)
                pick = pick2;
            else
                pick = pick3;
            end
        end

        lll(1,numera)=pick(1);
        lll(2,numera)=pick(2);
    else
        % -- right marking --
        H_right(round(ss(1)*3/4):ss(1),:) = 0; % restrict dist to middle half
        H_right(1:round(ss(1)/4),:) = 0;
        H_right(:,80:180) = 0; % restrict slope
        P = houghpeaks(H_right,3,'threshold',ceil(0.1*max(H_right(:)))); % find 3 peaks

        pick1 = P(1,:); % pick the right-most edge, i.e. with greatest rho
        pick2 = P(2,:);
        pick3 = P(3,:);

        if pick1(1)>pick2(1) && pick1(1)>pick3(1)
            pick = pick1;
        else if pick2(1)>pick1(1) && pick2(1)>pick3(1)
                pick = pick2;
            else
                pick = pick3;
            end
        end

        rrr(1,numera-35)=pick(1);
        rrr(2,numera-35)=pick(2);
    end

    lines = houghlines(BW,theta,rho,pick,'FillGap',10,'MinLength',5);
    imshow(hsv2rgb(i_cut));hold on;
    rho = pick(1)-980;
    theta = (pick(2)-90)/180*pi;
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

    plot(x,y,'LineWidth',2,'Color','green');
    hold off;
    pause(0.5);
    clf
end

close(gcf)

%To display Hough transform matrix
%figure; mesh(H)

%To save output image
%saveas(gcf,['out_wo_NN_', num2str(numera),'.jpe']);



