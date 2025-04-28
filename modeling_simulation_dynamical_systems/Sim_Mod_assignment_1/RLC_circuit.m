close all;
clear all;

t = 0:0.00001:15;

[VR, VC] = v(t);

figure(1);
plot(t,VR);
hold on;
plot(t,VC);
hold on;
title('Simulation VR, VC');
xlabel('t (s)');
ylabel('V');
legend( 'VR', 'VC');

u1 = 2*sin(4*t);
u2 = 4 * ones(1,length(t));

%poles
p1 = 17;
p2 = 17;

l1 = p1+p2;
l2 = p1*p2;

z1 = lsim(tf([-1 0],[1 (p1+p2) p1*p2]),VC,t);
z2 = lsim(tf(-1,[1 (p1+p2) p1*p2]),VC,t);
z3 = lsim(tf([+1 0],[1 (p1+p2) p1*p2]),u1,t);
z4 = lsim(tf(+1,[1 (p1+p2) p1*p2]),u1,t);
z5 = lsim(tf([+1 0],[1 (p1+p2) p1*p2]),u2,t);
z6 = lsim(tf(+1,[1 (p1+p2) p1*p2]),u2,t);

phiMtrx(:,1) = z1;
phiMtrx(:,2) = z2;
phiMtrx(:,3) = z3;
phiMtrx(:,4) = z4;
phiMtrx(:,5) = z5;
phiMtrx(:,6) = z6;

phiT = phiMtrx.';
phiTphi = phiT * phiMtrx;
yTphi = VC * phiMtrx;
th0 = yTphi / phiTphi;

%estimations
thstar(1) = th0(1) + l1;
thstar(2) = th0(2) + l2;
thstar(3) = th0(3);
thstar(4) = th0(4);
thstar(5) = th0(5);
thstar(6) = th0(6);

disp("th* = ");
fprintf('%g  ', thstar);
fprintf("\n");

VC_est = phiMtrx * th0.';
errorC = VC.' - VC_est;

figure(2);
plot(t,VC);
hold on;
title('Comparison - VC');
xlabel('t (s)');
ylabel('V');
plot(t,VC_est);
hold on;
plot(t,errorC);
legend( 'VC', 'VCest', 'errorC');

%VR
VR_est = u1 + u2 - VC_est.';
errorR = VR - VR_est;

figure(3);
plot(t,VR);
hold on;
plot(t,VR_est);
hold on;
plot(t,errorR);
hold on;
title('Comparison - VR');
xlabel('t (s)');
ylabel('V');
legend( 'VR', 'VRest', 'errorR');

