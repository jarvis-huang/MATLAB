    i = imread(['curve_left/Video 3_0', num2str(531),'.jpe']);

    img = i(:,185:1096,:); % cut off left and right black film strip
    img = img(1:360,:,:);
    sz = size(img);
    imshow(img);figure;
    out = zeros(sz(1),sz(2));
    for i = 1:sz(1)
        for j = 1:sz(2)
            if double(img(i,j,1))/double(img(i,j,3)) > 1.05 && double(img(i,j,2))/double(img(i,j,3)) > 1.05
                out(i,j)=1;
            end
        end
    end
    
%     ma = max(max(out));
%     mi = min(min(out));
%     for i=1:sz(1)
%         for j=1:sz(2)
%              out(i,j)=(out(i,j)-mi) / (ma-mi); % normalize value(brightness)
%              %i_hsv(i,j,3) = sqrt(i_hsv(i,j,3)); % brightness boost
%         end
%     end
    imshow(out);

