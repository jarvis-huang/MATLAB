function plot_line_on_img(i_cut,theta,rho,color)
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

plot(x,y,'LineWidth',2,'Color',color);