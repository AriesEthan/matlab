clc; close all;
rgb_letv=importfile('./rgb_letv.csv',',','%f%f%f%f');
rgb_innolux=importfile('./rgb_innolux50.csv',',','%f%f%f%f');
REF=rgb_letv(:,1);
REF_norm=REF./255;
R=rgb_letv(:,2);
G=rgb_letv(:,3);
B=rgb_letv(:,4);
R_innolux=rgb_innolux(:,2);
G_innolux=rgb_innolux(:,3);
B_innolux=rgb_innolux(:,4);
REF1=REF_norm;
x=(31:1:255)'/255;
R_norm=R./max(R);
G_norm=G./max(G);
B_norm=B./max(B);
R_innolux_norm=R_innolux./max(R_innolux);
G_innolux_norm=G_innolux./max(G_innolux);
B_innolux_norm=B_innolux./max(B_innolux);

R_norm1=R_norm;
G_norm1=G_norm;
B_norm1=B_norm;
R_innolux_norm1=R_innolux_norm;
G_innolux_norm1=G_innolux_norm;
B_innolux_norm1=B_innolux_norm;

y_r_norm=fit(REF1,R_norm1,'poly4');
y_g_norm=fit(REF1,G_norm1,'poly4');
y_b_norm=fit(REF1,B_norm1,'poly4');

y_r_norm_innolux=fit(REF1,R_innolux_norm1,'poly4');
y_g_norm_innolux=fit(REF1,G_innolux_norm1,'poly4');
y_b_norm_innolux=fit(REF1,B_innolux_norm1,'poly4');

y_r_norm_innolux_inv=fit(y_r_norm_innolux(x),x,'splineinterp');
y_g_norm_innolux_inv=fit(y_g_norm_innolux(x),x,'splineinterp');
y_b_norm_innolux_inv=fit(y_b_norm_innolux(x),x,'splineinterp');

x1_r=round(y_r_norm_innolux_inv(y_r_norm(x)));
x1_g=round(y_g_norm_innolux_inv(y_g_norm(x)));
x1_b=round(y_b_norm_innolux_inv(y_b_norm(x)));

figure(1);
plot(x,y_r_norm(x)); 
hold on; 
%plot(x,y_r_norm_innolux(x)); 
scatter(x,y_r_norm_innolux(x1_r));
legend('r\_letv','r\_innolux','r\_innolux1');

figure(2);
plot(x,y_g_norm(x)); 
hold on; 
%plot(x,y_g_norm_innolux(x)); 
scatter(x,y_g_norm_innolux(x1_g));
legend('g\_letv','g\_innolux','g\_innolux1');

figure(3);
plot(x,y_b_norm(x)); 
hold on; 
%plot(x,y_b_norm_innolux(x)); 
scatter(x,y_b_norm_innolux(x1_b));
legend('b\_letv','b\_innolux','b\_innolux1');

rgb_new=[x,x1_r,x1_g,x1_b];

%{
rgb_factor=[r_factor,g_factor,b_factor];
rgb_new=[x,x,x].*rgb_factor;
figure(1);
plot(x,y_r_norm(x)); hold on; plot(x,y_r_norm_innolux(x)); legend('r\_letv','r\_innolux');
figure(2);
plot(x,y_g_norm(x)); hold on; plot(x,y_g_norm_innolux(x)); legend('g\_letv','g\_innolux');
figure(3);
plot(x,y_b_norm(x)); hold on; plot(x,y_b_norm_innolux(x)); legend('b\_letv','b\_innolux');
figure(4);
plot(x,y_r_norm(x),'r'); hold on; plot(x,y_g_norm(x),'g'); plot(x,y_b_norm(x),'b');
figure(5);
plot(x,y_r_norm_innolux(x),'r-'); hold on; plot(x,y_g_norm_innolux(x),'g-'); plot(x,y_b_norm_innolux(x),'b-');
%}