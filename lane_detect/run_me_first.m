
%observation;
clear;
clc;
tic

t=0.066;

obs_l = load('best_l.txt');
obs_r = load('best_r.txt');

% 1-perfect, NN   2-OK, NN  3-poor, Zonal  4-aweful, Zonal
flag_farleft = 1;
flag_left = 1;
flag_right = 1;

merge_count = 0;

% fl_rho_radius = 30;
% fl_theta_radius = 10;
l_rho_radius = 30;
l_theta_radius = 10;
r_rho_radius = 30;
r_theta_radius = 10;

% fl_rho = zeros(1,finish-start+1);
% fl_theta = zeros(1,finish-start+1);
obs_l_rho = obs_l(:,1);
obs_l_theta = obs_l(:,2);
obs_r_rho = obs_r(:,1);
obs_r_theta = obs_r(:,2);

sz = size(obs_l);

out_l = zeros(size(obs_l));
out_r = zeros(size(obs_r));

% estimated initial location of detected lines
% init_far_left = [1180 165]; 
init_left = [300 -40];
init_right = [200 25];

var_q_rho_l = 12.35;
var_q_theta_l = 0.844;

var_q_rho_r = 7.455;
var_q_theta_r = 0.81;

s_l.A = [ 1  t  0  0;
           0  1  0  0;
           0  0  1  t;
           0  0  0  1];

% Define the measurement matrix: measure rho and theta only
s_l.H = [ 1  0 0 0;
           0  0 1 0];
% Define a measurement error (stdev) of rho and theta:
s_l.R = [ 5 0;0 5]; % variance, hence stdev^2
% Do not define any system input (control) functions:
s_l.B = 0;
s_l.u = 0;
% Specify an initial state:
s_l.x = [init_left(1) -1 init_left(2) 0]';
s_l.P = [ 100 0  0  0;
           0  0  0  0;
           0  0  1  0;
           0  0  0  0];

s_l.Q = [[ t^2/3 t/2;t/2  1] * var_q_rho_l, [0 0;0 0];[0 0;0 0],[ t^2/3 t/2;t/2  1] * var_q_theta_l];
s_l.x = [init_left(1) -1 init_left(2) 0]';

s_r = s_l;
s_r.Q = [[ t^2/3 t/2;t/2  1] * var_q_rho_r, [0 0;0 0];[0 0;0 0],[ t^2/3 t/2;t/2  1] * var_q_theta_r];
s_r.x = [init_right(1) -1 init_right(2) 0]';




% ---------------
%  EXPLANATION
% ---------------
% s.x = state vector estimate. In the input struct, this is the
%       "a priori" state estimate (prior to the addition of the
%       information from the new observation). In the output struct,
%       this is the "a posteriori" state estimate (after the new
%       measurement information is included).
% s.z = observation vector
% s.u = input control vector, optional (defaults to zero).
% s.A = state transition matrix (defaults to identity).
% s.P = covariance of the state vector estimate. In the input struct,
%       this is "a priori," and in the output it is "a posteriori."
%       (required unless autoinitializing as described below).
% s.B = input matrix, optional (defaults to zero).
% s.Q = process noise covariance (defaults to zero).
% s.R = measurement noise covariance (required).
% s.H = observation matrix (defaults to identity).

is_l_NN = 1;
is_r_NN = 1;

fid_l = fopen('obs_l.txt','r');
fid_r = fopen('obs_r.txt','r');

for tt=1:sz(1)

%% -- left tracking --
 
   % create a priori estimate
   if tt==1
       s_l.x = [init_left(1) ; -1 ; init_left(2) ; 0];      
   else
       s_l.x = new_s_l.x;
   end
   
   s_l.z = obs_l(tt,:)'; % create a measurement
       
   [new_s_l proj dist0]=kalmanf(s_l); % proj has only two elements

   if (is_l_NN==1) % choose NN
       min_dist = 100; % big enough for any dist
       the_one = zeros(1,2);
       while 1
           tline = fgetl(fid_l);
           if (tline(1)=='n')
               break;
           else
               A = sscanf(tline,'%g %g %*g');  
               dista = abs(proj(1)-A(1))/abs(proj(1)) + abs(proj(2)-A(2))/abs(proj(2)); % percentile diff dtc + percentile diff theta
               if dista<min_dist
                   min_dist = dista;
                   the_one = A';
               end
           end
       end
       out_l(tt,:) = the_one;
   else % choose original posterio filter output
       out_l(tt,:) = [new_s_l.x(1)  new_s_l.x(3)];
   end
 
   
   
%% -- right tracking --
 
   % create a priori estimate
   if tt==1
       s_r.x = [init_right(1) ; -1 ; init_right(2) ; 0];      
   else
       s_r.x = new_s_r.x;
   end
   
   s_r.z = obs_r(tt,:)'; % create a measurement
       
   [new_s_r proj dist0]=kalmanf(s_r);
   
   if (is_r_NN==1) % choose NN
       min_dist = 100; % big enough for any dist
       the_one = zeros(1,2);
       while 1
           tline = fgetl(fid_r);
           if (tline(1)=='n')
               break;
           else
               A = sscanf(tline,'%g %g %*g');
               dista = abs(proj(1)-A(1))/abs(proj(1)) + abs(proj(2)-A(2))/abs(proj(2)); % percentile diff dtc + percentile diff theta
               if dista<min_dist
                   min_dist = dista;
                   the_one = A';
               end
           end
       end
       out_r(tt,:) = the_one;
   else % choose original posterio filter output
       out_r(tt,:) = [new_s_r.x(1)  new_s_r.x(3)];
   end



%% -- relationships --

%    if abs(fl_rho(tt)-l_rho(tt))<20 && abs(fl_theta(tt)-l_theta(tt))<5 % left and farleft appear to merge
%        merge_count = 1;
%    else
%        merge_count = 0;
%    end
%    
%    if merge_count == 1
%       if ~is_meet_mid_point(fl_rho(tt),fl_theta(tt),round(c_x/2)) % farleft merges into left
%           fl_rho(tt) = 0; fl_theta(tt) = 0;
%       else % left merges into farleft
%           l_rho(tt) = 0; l_theta(tt) = 0;
%       end
%    end
   
   %[x y success] = find_intercept(l_rho(tt-start+1),l_theta(tt-start+1),r_rho(tt-start+1),r_theta(tt-start+1),c_x,c_y)

end


% save 'far_left_edge_data.mat' fl_rho fl_theta;
% save 'left_edge_data.mat' l_rho l_theta;
% save 'right_edge_data.mat' r_rho r_theta;
% 
% fid_fl = fopen('fl_data.txt','w');
% fid_l = fopen('l_data.txt','w');
% fid_r = fopen('r_data.txt','w');
% 
% for i=start:finish
%     fprintf(fid_fl,'%f %f\n',fl_rho(i-start+1),fl_theta(i-start+1));
%     fprintf(fid_l,'%f %f\n',l_rho(i-start+1),l_theta(i-start+1));
%     fprintf(fid_r,'%f %f\n',r_rho(i-start+1),r_theta(i-start+1));
% end
% status_fl = fclose(fid_fl);
% status_l = fclose(fid_l);
% status_r = fclose(fid_r);
% 
% if status_fl~=0 || status_l~=0 || status_r~=0
%     error('Error closing files!');
% end

save kal_l.txt out_l -ascii 
save kal_r.txt out_r -ascii 

figure;
toc
t = toc
title(t)
