function y_or_n = is_meet_mid_point(fl_rho,fl_theta,ref)

rho = fl_rho-980;
theta = (fl_theta-90)/180*pi;

if  abs(rho*sin(theta)-ref) / ref < 0.2 
    y_or_n = 1;
else
    y_or_n = 0;
end