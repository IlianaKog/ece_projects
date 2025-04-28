close all;
clear all;
 
a11 = -0.25;
a12 = 3;
a21 = -5;
a22 = 0;

b1 = 0.5;
b2 = 1.5;

%set g1,g2
g1 = 60;
g2 = 40;
    
tspan = 0:0.01:30;
v0 = zeros(10,1);

[t, vsol] = ode45(@(t,y)systemM(t,y,g1,g2),tspan, v0);

x1 = vsol(:,1);
x2 = vsol(:,2);
x1_est = vsol(:,3);
x2_est = vsol(:,4);
a11_est = vsol(:,5);
a12_est = vsol(:,6);
a21_est = vsol(:,7);
a22_est = vsol(:,8);
b1_est = vsol(:,9);
b2_est = vsol(:,10);

set(groot,'defaultAxesXGrid','on');
set(groot,'defaultAxesYGrid','on');

figure();
plot(t,x1);
hold on;
plot(t,x1_est);
hold on;
legend("x1", "x1_{est}");
xlabel("t (s)");

figure();
plot(t,x2);
hold on;
plot(t,x2_est);
hold on;
legend("x2", "x2_{est}");
xlabel("t (s)");

figure();
plot(t,a11_est);
hold on;
yline(a11);

plot(t,a12_est);
hold on;
yline(a12);

plot(t,a21_est);
hold on;
yline(a21);

plot(t,a22_est);
hold on;
yline(a22);
legend("a11", "a12", "a21", "a22");
xlabel("t (s)");

figure();
plot(t,b1_est);
hold on;
plot(t,b2_est);
hold on;
yline(b1);
yline(b2);
legend("b1", "b2");
xlabel("t (s)");

function dvdt = systemM(t, vsol,g1,g2)

%set input
    u = 3.5*sin(7.2*t) + 2*sin(11.7*t);
    
    a11 = -0.25;
    a12 = 3;
    a21 = -5;
    a22 = 0;
    b1 = 0.5;
    b2 = 1.5;
    
    x1 = vsol(1);
    x2 = vsol(2);
    x1_est = vsol(3);
    x2_est = vsol(4);
    a11_est = vsol(5);
    a12_est = vsol(6);
    a21_est = vsol(7);
    a22_est = vsol(8);
    b1_est = vsol(9);
    b2_est = vsol(10);
    
    e1 = x1 - x1_est;
    e2 = x2 - x2_est;
    
    %set th_m
    thm = [5, 1; 1, 5];

    
    dvdt(1) = a11 * x1 + a12 * x2 + b1 * u; %x1dot
    dvdt(2) = a21 * x1 + a22 * x2 + b2 * u; %x2dot
    dvdt(3) = a11_est * x1_est + a12_est * x2_est + b1_est * u + thm(1,1) * e1 + thm(1,2) * e2; %x1est_dot
    dvdt(4) = a21_est * x1_est + a22_est * x2_est + b2_est * u + thm(2,1) * e1 + thm(2,2) * e2; %x2est_dot
    dvdt(5) = g1 * x1* e1; %a11est_dot
    dvdt(6) = g1 * x2 * e1; %a12est_dot
    dvdt(7) = g1 * x1 * e2; %a21est_dot
    dvdt(8) = g1 * x2 * e2; %a22est_dot
    dvdt(9) = g2 * e1 * u; %b1est_dot
    dvdt(10) = g2 * e2 * u; %b2est_dot
    dvdt = dvdt.';

end