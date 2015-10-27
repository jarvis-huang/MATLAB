I = imread('curve_left/Video 4_0672.jpe');
II = rgb2hsv(I);
II = II(:,185:1096,:);
sz= size(II);
II = II(1:sz(1)/2,:,:);
sz = size(II);
h1 = squeeze(II(:,:,1));
h2 = squeeze(II(:,:,2));
h3 = squeeze(II(:,:,3));
II1 = medfilt2(h1,[5 5]);
II2 = medfilt2(h2,[5 5]);
II3 = medfilt2(h3,[5 5]);
III(:,:,1) = II1;
III(:,:,2) = II2;
III(:,:,3) = II3;
IIII = III;
for i = 1:sz(1)
    for j=1:sz(2)
        if III(i,j,2) > 0.02 && III(i,j,3) > 0.2
            IIII(i,j,1) = III(i,j,1);
        else
            IIII(i,j,:) = 0;
        end
    end
end
%imshow(hsv2rgb(IIII))
J = squeeze(IIII(:,:,3));
JJ = regiongrowing(J,200,462,0.3); 
imshow(JJ);figure; imshow(II(:,:,3));