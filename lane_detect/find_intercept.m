function [x y success] = find_intercept(l_rho,l_theta,r_rho,r_theta,c_x,c_y)

l_rho = l_rho-980;
l_theta = (l_theta-90)/180*pi;

r_rho = r_rho-980;
r_theta = (r_theta-90)/180*pi;

% intercept

x = (r_rho * cos(l_theta) - l_rho * cos(r_theta)) / (sin(r_theta) * cos(l_theta) - sin(l_theta) * cos(r_theta));
x = round(x);

y = round ((l_rho-(x-1)*sin(l_theta))/cos(l_theta)+1);

if x>=1 && x<=c_x && y>=1 && y<=c_y
    success = 1;
else
    success = 0;
end
