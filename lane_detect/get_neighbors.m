function [P success] = get_neighbors(i_cut,rho_c,rho_r,theta_c,theta_r,low_bound_slope,up_bound_slope) % c-center, r-radius
% assume the i_cut is already the top half of original img, of course, film
% strips has been removed already
% assume i_cut is also cropped to suit particular goal (farleft/left/right)

success = 0;
P = 0;
th_low = 0.02;
th_high = 0.1;

i_canny_v = i_cut;

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
        P = zeros(length(lines),2);
        for j = 1:length(lines)
            line = lines(j);
            P(j,1) = line.rho+980;
            P(j,2) = line.theta+90;
        end
    end

%     szp = size(P);
%     if szp(1)<3
%         theta_r = round(theta_r*1.2);
%         rho_r = round(rho_r*1.2);
%         if theta_c-theta_r<=0 || theta_c+theta_r>180 || rho_c-rho_r<=0 || rho_c+rho_r>ss(1)
%             error('HJW');
%         end
%         continue;
%     else
%         success = 1;
%         break;
%     end
% end