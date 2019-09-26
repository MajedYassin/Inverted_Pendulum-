M= 0.5;
m= 0.2;
b= 0.1;
L= 0.3;
g= 9.8;
I= 0.006; 
s=tf('s');
q= (M+m)*(I+m*L^2)-(m*L)^2;
P_cart= ((((I+m*L^2)*s^2)/q)-(g*m*L/q))/(s^4+((b*(I+m*L^2)*s^3)/q)-((M+m)*(m*g*L*s^2)/q)-((b*m*g*L*s)/q));
P_pend= (m*L*s/q)/ (s^3+(b*s^2*(I+m*L^2)/q)-((M+m)*m*g*L*s/q)-(b*m*g*L/q));

sys_tf=[P_cart; P_pend];
input={'u'};
output={'x', 'phi'};
set(sys_tf, 'inputname', inputs);
set(sys_tf, 'outputname', outputs);

%Testing the impluse of the system to an arbitrary impulsive force%
t=0:0.01:1;
impulse(sys_tf, t);
title('Open-Loop Impulse Response')

%Compute zeroes and poles of the trasfer functions for cart positon output
[zerosc, polesc]= zpkdata(P_cart,'v');

%compute zeros and poles of the system for a pendulum position are output
[zeros, poles]= zpkdata(P_pend,'v');

%Open-Loop step response
%Use 'lsim' command to simulate the response of the LTI(Linear Time Invariant) 
%models to arbitrary inputs and verify whether the response is unbounded (unstable)
t= 0:0.05:10;
u= ones(size(t));
[y,t] = lsim(sys_tf, u, t);
plot(t,y)
title('Open-Loop Step Response')
axis([0 3 0 50])
legend ('x','phi')

% Use 'lsiminfo' command to identify charactersitics of the response

step_info = lsiminfo(y,t);
cart_info = step_info(1);
pend_info = step_info(2);

% PID Controller

Ki=1;
Kd=1;
Kp=1;
C=pid(Kp,Ki,Kd);
T=feedback(P_pend,C);
% To visualize the response of the system, define a time and plot T vs time
%Time array example: t=0:0.01:10;
impulse(T,t) 
%modify axis parameters and properties e.g. axis([0, 2, -0.5, 0.5])
%title({'Response of an inverted Pendulum to an impulse distrubance...'})

%Verifying effect of Pendulum PID controller on the position of the cart
T2=feedback(1,P_pend*C)*P_cart;
t=0:0.01:5;
impulse(T2,t)




