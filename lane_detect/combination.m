for i = 2690:2770
    i1 = imread(['out_wo_NN_', num2str(i),'.jpe']);
    i2 = imread(['out_', num2str(i),'.jpe']);
    subplot(1,2,1);
    imshow(i1);title('w/o NN KF')
    subplot(1,2,2);
    imshow(i2);title('with NN KF');
    saveas(gcf,['comb_', num2str(i),'.jpe']);
    close;
end