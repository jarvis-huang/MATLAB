clc;
start = 650;
finish = 690;

true_fl_rho = zeros(finish-start+1,1);
true_fl_theta = zeros(finish-start+1,1);
true_l_rho = zeros(finish-start+1,1);
true_l_theta = zeros(finish-start+1,1);
true_r_rho = zeros(finish-start+1,1);
true_r_theta = zeros(finish-start+1,1);



for numera = start:finish
    numera
    i = imread(['hand/Video 4_0', num2str(numera),'.jpe']);
    i = i(:,185:1096,:); % cut off left and right black film strip
    sz = size(i);
    i_cut = i(1:sz(1)/2,:,:); % remove lower half
    
    %% gen true farleft
    fl_cut = i_cut;
    [c_x c_y c_z] = size(fl_cut);
    fl_cut(1:round(c_x/3),:,:) = 0;
    fl_cut(round(c_x*2/3):c_x,:,:) = 0;
    fl_cut(:,round(c_y/4):c_y,:) = 0;
    for x = 1:c_x
        for y = 1:c_y
            if fl_cut(x,y,1)>fl_cut(x,y,2)*2 && fl_cut(x,y,1)>fl_cut(x,y,3)*2 && fl_cut(x,y,1)>100
                fl_cut(x,y,1)=1;
            else
                fl_cut(x,y,1)=0;
            end
        end
    end
    th_low = 0.02;
    th_high = 0.1;

    i_canny_v = edge(fl_cut(:,:,1),'canny', [th_low, th_high], 3);

    BW = i_canny_v; % use v can provide best distinguishing effect
    [H,theta,rho] = hough(BW,'RhoResolution',1,'ThetaResolution',1);

    H(:,1:130) = 0; H(:,175:180)=0; % restrict slope

    ss = size(H);
    H(round(ss(1)*3/4):ss(1),:) = 0; % restrict dist to middle half
    H(1:round(ss(1)/4),:) = 0;

    P = houghpeaks(H,3,'threshold',ceil(0.05*max(H(:)))); % find 3 peaks

    lines = houghlines(BW,theta,rho,P,'FillGap',10,'MinLength',50);
    disp('farleft');
    if isempty(lines) || ~isfield(lines(1), 'rho')
        true_fl_rho(numera-start+1)=0;
        true_fl_theta(numera-start+1)=0;
    else
        true_fl_rho(numera-start+1)=lines(1).rho+980;
        true_fl_theta(numera-start+1)=lines(1).theta+90;
    end

    
    
    %% gen true left
    l_cut = i_cut;
    [c_x c_y c_z] = size(l_cut);
    l_cut(1:round(c_x/2),:,:) = 0;
    l_cut(:,round(c_y/2):c_y,:) = 0;
    
    for x = 1:c_x
        for y = 1:c_y
            if l_cut(x,y,2)>l_cut(x,y,1)*2 && l_cut(x,y,2)>l_cut(x,y,3)*2 && l_cut(x,y,2)>100
                l_cut(x,y,1)=1;
            else
                l_cut(x,y,1)=0;
            end
        end
    end
    th_low = 0.02;
    th_high = 0.1;

    i_canny_v = edge(l_cut(:,:,1),'canny', [th_low, th_high], 3);
    BW = i_canny_v; % use v can provide best distinguishing effect
    [H,theta,rho] = hough(BW,'RhoResolution',1,'ThetaResolution',1);
    
    H(:,1:100) = 0; H(:,170:180)=0; % restrict slope

    ss = size(H);
    H(round(ss(1)*3/4):ss(1),:) = 0; % restrict dist to middle half
    H(1:round(ss(1)/4),:) = 0;

    P = houghpeaks(H,3,'threshold',ceil(0.05*max(H(:)))); % find 3 peaks
    
    lines = houghlines(BW,theta,rho,P,'FillGap',10,'MinLength',50);
    disp('left');
    true_l_rho(numera-start+1)=lines(1).rho+980;
    true_l_theta(numera-start+1)=lines(1).theta+90;
    
    
    %% gen true right
    r_cut = i_cut;
    [c_x c_y c_z] = size(r_cut);
    r_cut(1:round(c_x/3),:,:) = 0;
    r_cut(:,1:round(c_y/3),:) = 0;

    for x = 1:c_x
        for y = 1:c_y
            if r_cut(x,y,3)>r_cut(x,y,2)*2 && r_cut(x,y,3)>r_cut(x,y,1)*2 && r_cut(x,y,3)>100
                r_cut(x,y,1)=1;
            else
                r_cut(x,y,1)=0;
            end
        end
    end
    th_low = 0.02;
    th_high = 0.1;

    i_canny_v = edge(r_cut(:,:,1),'canny', [th_low, th_high], 3);

    BW = i_canny_v; % use v can provide best distinguishing effect
    [H,theta,rho] = hough(BW,'RhoResolution',1,'ThetaResolution',1);
    
    H(:,1:10) = 0; H(:,80:180) = 0; % slope has to be [10 80]

    ss = size(H);
    H(round(ss(1)*3/4):ss(1),:) = 0; % restrict dist to middle half
    H(1:round(ss(1)/4),:) = 0;

    P = houghpeaks(H,3,'threshold',ceil(0.05*max(H(:)))); % find 3 peaks
    
    lines = houghlines(BW,theta,rho,P,'FillGap',30,'MinLength',50);
    disp('right');
    true_r_rho(numera-start+1)=lines(1).rho+980;
    true_r_theta(numera-start+1)=lines(1).theta+90;
end

save 'true_edge_data.mat' true_fl_rho true_fl_theta true_l_rho true_l_theta true_r_rho true_r_theta;

%     BW = edge(b,'canny');
%     [H,theta,rho] = hough(BW);
%     P = houghpeaks(H,1);
%     lines = houghlines(BW,theta,rho,P,'FillGap',10,'MinLength',5);
%     p1 = lines(1).point1;
%     p2 = lines(1).point2;
%     true(1,numera) = p1(1);
%     true(2,numera) = p1(2);
%     true(3,numera) = p2(1);
%     true(4,numera) = p2(2);
% end
    
%     % check for continuity
%     count1 = 0;
%     for i=1:240
%         for j=1:320
%             current = b(i,j);
%             count = 0;
%             f_i = i; f_j = j;
%             current_i = i; current_j=j;
%             while current==0 
%                 count = count + 1;
%                 if current_i-1 > 0 && b(current_i-1,current_j)==0 
%                     current = b(current_i-1,current_j);
%                     current_i = current_i-1;
%                     current_j = current_j;
%                 else if current_j+1 <=320 && current_i-1 >0 && b(current_i-1,current_j+1)==0
%                         current = b(current_i-1,current_j+1);
%                         current_i = current_i-1;
%                         current_j = current_j+1;
%                     else if current_j+1 <=320 && b(current_i,current_j+1)==0
%                             current = b(current_i,current_j+1);
%                             current_i = current_i;
%                             current_j = current_j+1;
%                         else
%                             break;
%                         end
%                     end
%                 end
%             end
%             l_i = current_i; l_j = current_j;
%             if count>count1
%                 count1 = max(count1,count);
%                 last_i_1 = l_i;
%                 last_j_1 = l_j;
%                 first_i_1 = f_i;
%                 first_j_1 = f_j;
%             end
%         end
%     end
%     
%     count2 = 0;
%     for i=1:240
%         for j=1:320
%             current = b(i,j);
%             count = 0;
%             f_i = i; f_j = j;
%             current_i = i; current_j=j;
%             while current==0 
%                 count = count + 1;
%                 if current_i-1 > 0 && b(current_i-1,current_j)==0
%                     current = b(current_i-1,current_j);
%                     current_i = current_i-1;
%                     current_j = current_j;
%                 else if current_i-1 >0 && current_j-1 >0 && b(current_i-1,current_j-1)==0
%                         current = b(current_i-1,current_j-1);
%                         current_i = current_i-1;
%                         current_j = current_j-1;
%                     else if current_j-1 >0 && b(current_i,current_j-1)==0
%                             current = b(current_i,current_j-1);
%                             current_i = current_i;
%                             current_j = current_j-1;
%                         else
%                             break;
%                         end
%                     end
%                 end
%             end
%             l_i = current_i; l_j = current_j;
%             if count>count2
%                 count2 = max(count2,count);
%                 last_i_2 = l_i;
%                 last_j_2 = l_j;
%                 first_i_2 = f_i;
%                 first_j_2 = f_j;
%             end
%         end
%     end
%     
%     if count2>count1
%         tt(1,numera) = last_i_2;
%         tt(2,numera) = last_j_2;
%         tt(3,numera) = first_i_2;
%         tt(4,numera) = first_j_2;
%     else
%         tt(1,numera) = last_i_1;
%         tt(2,numera) = last_j_1;
%         tt(3,numera) = first_i_1;
%         tt(4,numera) = first_j_1;
%     end
%         
% end
% true = zeros(2,100);
% for i=36:76
%     y1 = tt(1,i);
%     x1 = tt(2,i);
%     y2 = tt(3,i);
%     x2 = tt(4,i);
%     
%     true(1,i) = 372 + abs(y2-y1+(x1-x2)*48-x1*y2+y1*x2) / sqrt((y2-y1)^2+(x2-x1)^2); % In obervation algorithm, 240/5=48, cut top 1/5, so origin is lower
%     true(2,i) = atan((y2-y1)/(x2-x1))/pi*180;
% end
%     
%                     
%                     
%                     