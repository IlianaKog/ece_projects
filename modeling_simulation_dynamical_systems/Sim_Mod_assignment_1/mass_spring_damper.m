clear all;
close all;

%initial conditions
yo = 0;
dyo = 0;

%parameters
m = 10;
b = 0.5;
k = 2.5;

%Real system
dt = 0.1;
ts = 10;
tspan  = 0:dt:ts;
y0 = [yo; dyo];
[t, y_sol] = ode45(@odefun, tspan, y0);

figure(1);
plot(t,y_sol(:,1));
hold on;
plot(t,y_sol(:,2));
title('Mass Spring Damper System - Simulation');
xlabel('t (s)');
grid on;
hold on;
legend('y','dy/dt');

%Least squares method
%filter poles
p1 = 0.7;
p2 = 0.7;

%suntelestes
l1 = p1+p2;
l2 = p1*p2;

u = 15*sin(3*t) + 8;

%create phi-matrix 

z1 = lsim(tf([-1 0],[1 (p1+p2) p1*p2]),y_sol(:,1),t);
z2 = lsim(tf(-1,[1 (p1+p2) p1*p2]),y_sol(:,1),t);
z3 = lsim(tf(+1,[1 (p1+p2) p1*p2]),u,t);

phiMtrx(:,1) = z1;
phiMtrx(:,2) = z2;
phiMtrx(:,3) = z3;

phiT = phiMtrx.';
phiTphi = phiT * phiMtrx;
yTphi = y_sol(:,1).' * phiMtrx;
th0 = yTphi / phiTphi

%estimations
m_est = 1/th0(3);
b_est = m_est*(th0(1) + l1);
k_est = m_est*(th0(2) + l2);

em = m - m_est;
eb = b - b_est;
ek = k - k_est;

y_est = phiMtrx * th0.';
error = y_sol(:,1) - y_est;

figure(2);
plot(t,y_sol(:,1));
hold on;

plot(t,y_est);
hold on;

plot(t,error);
hold on; 

title('Mass Spring Damper System - Comparison');
xlabel('t (s)');
grid on;
legend('y', 'yest','e');

results = [m_est k_est b_est];
disp("Ektimiseis:");
disp("    m_est    k_est    b_est:");
disp(results);

function dydt = odefun(t,y)
    m = 10;
    b = 0.5;
    k = 2.5;
    
    u = 15*sin(3*t) + 8;

    dydt = zeros(2,1);
    dydt(1) = y(2);
    dydt(2) = -(b/m) * y(2) -(k/m) * y(1) +(1/m) * u;
   
end
