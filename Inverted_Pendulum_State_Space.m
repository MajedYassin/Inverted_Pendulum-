M= 0.5;
m= 0.2;
b= 0.1;
L= 0.3;
g= 9.8;
I= 0.006; 
p= I*(M+m)+M*m*L^2;
A = [ 0  1  0  0 
0  -(I+m*L^2)*b/p  (m^2*g*L^2)/p  0 
0  0  0  1
0  -(m*L*b)/p  (M+m)*m*g*L/p  0];
B= [ 0;
(I+m*L^2)/p;
0;
m*L/p];
C= [1 0 0 0;
0 0 1 0];
D= [ 0; 0];
states={'x' 'x_dot' 'phi' 'phi_dot'};
inputs={'u'};
outputs={'x', 'phi'};
sys_ss= ss(A, B, C, D, 'statename', states, 'inputname', inputs, 'outputname', outputs);

%To test the repsonse of the system for an arbitrary impulsive force. 
t=0:0.01:1;
impulse(sys_ss, t);
title('Open-Loop Impulse Response')