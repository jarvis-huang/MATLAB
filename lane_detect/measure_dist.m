clc
load far_left_edge_data
load left_edge_data
load right_edge_data
load true_edge_data

start = 660;
finish = 690;

fl_rho_err = pdist([fl_rho;true_fl_rho'])/(finish-start+1);
fl_theta_err = pdist([fl_theta;true_fl_theta'])/(finish-start+1);
l_rho_err = pdist([l_rho;true_l_rho'])/(finish-start+1);
l_theta_err = pdist([l_theta;true_l_theta'])/(finish-start+1);
r_rho_err = pdist([r_rho;true_r_rho'])/(finish-start+1);
r_theta_err = pdist([r_theta;true_r_theta'])/(finish-start+1);
fl_rho_err
fl_theta_err
l_rho_err
l_theta_err
r_rho_err
r_theta_err