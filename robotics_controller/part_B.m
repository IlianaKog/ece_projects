%Iliana Kogia 10090
%Robotics 2023
%PART B

close all;
clear all;

set(groot,'defaultAxesXGrid','on')
set(groot,'defaultAxesYGrid','on')

Ts = 0.002;

q0 = [-0.140, -1.556, -1.359, +1.425, -1.053, -1.732]; %rad
qr_dot_MAX = [120; 120; 180; 180; 180; 180];
qr_dot_MAX = deg2rad(qr_dot_MAX);
qr_DDot_MAX = 250;
Zball = zeros(1,1);
Yball = zeros(1,1);

robot = mdl_ur10e();
wspace = Wspace();

%initial t == 0
[p_cb, v_cb, w_cb] = wspace.sim_ball(0);
Yball(1,1) = p_cb(2); 
Zball(1,1) = p_cb(3) + 0.2;

ForwardKin = robot.fkine(q0);
Roe_0 = ForwardKin.R;
poe_0 = ForwardKin.t;

%find initial Rcb
theta = - acos(0.9351 / 1); %apo yb arxiki dieuthinsi
Rcb = rotx(rad2deg(theta));
%Rcb = rotx(rad2deg(theta),'deg'); %if Peter Corke toolbox

%orientation
Rbe = roty(180); %dinete o epi8umhtos Rot(y,180)
%Rbe = roty(180,'deg'); %if Peter Corke toolbox

Rd_0 = Rcb * Rbe; %dioti isxuei gia to Rob == Roc * Rcb = Rcb

Qdprev = rotm2quat(Rd_0).';

%position
p_be_desired = [0; 0; 0.45]; %const, dinetai
p_oc = [0.4; 0; 0.2]; %const

p_ob = p_oc + p_cb; %Roc = I
pd_0 = p_ob + Rcb * p_be_desired; %poe = pob + Rob*pbe

%init

pd = zeros(3,1);
pd_dot = zeros(3,1);
p = zeros(3,1);
p_dot = zeros(3,1);
p_BE = zeros(3,1); 
q = zeros(6,1);
qr_dot = zeros(6,1);
qr_ddot = zeros(6,1);
e_l = zeros(3,1);
Rbe_kx = zeros(1,1);
Rbe_ky = zeros(1,1);
Rbe_kz = zeros(1,1);
theta_be = zeros(1,1);

%FOR k == 1, t == 0, initialize:
pd(:,1) =  pd_0;
q(:,1) = q0.';
p(:,1) = poe_0;
p_BE(:,1) = transpose(Rcb) * (poe_0 - p_ob);
Rbe_k_th = rotm2axang(Rbe);
Rbe_kx(1,1) = Rbe_k_th(1);
Rbe_ky(1,1) = Rbe_k_th(2);
Rbe_kz(1,1) = Rbe_k_th(3); 
theta_be(1,1) = Rbe_k_th(4);

%t1 = t0 + Ts = Ts:
k = 2; 

%gain
Kp = 50; 
Ko = 70;

qr_dot_filtered_prev = 0;
Roe_current = Roe_0;

stop_time = 10;

tic;
for t = Ts:Ts:stop_time % t = t + Ts
    t0 = 0;
    tf = 6;
    if t >= t0 && t < tf
         tf = tf - t0;
         k0 = p_BE(3,1);
         k1 = 0;
         k2 = (3/tf^2) * (0.06 - 0.45);
         k3 = (-2/tf^3) * (0.06 - 0.45);
         pz = k0 + k1 * (t - t0) + k2 * (t - t0)^2 + k3*(t - t0)^3; 
         p_be_desired = [0, 0, pz].';
    else
        if t < (tf + 1)
           p_be_desired = [0, 0, pz].'; % for t>tf --> pz = 0.06 
        else
            stop_time = t - Ts; %passed 1 sec, so break
            break;
        end
    end

    q_current = q(:,k-1).';

    [p_cb, v_cb, w_cb] = wspace.sim_ball(Ts);

    Yball(1,k) = p_cb(2); 
    Zball(1,k) = p_cb(3) + 0.2;

    %find theta between yb and yc
    theta = acos(abs(v_cb(2)) / norm(v_cb));
    if v_cb(3) <0 && v_cb(2)>0
        theta = - theta;
    elseif v_cb(3) >0 && v_cb(2)<0
        theta = - theta;
    end

    theta = rad2deg(theta);
    Rcb = rotx(theta);
    %Rcb = rotx(theta,'deg'); %if Peter Corke toolbox

    p_ob = p_oc + p_cb; %Roc = I
    
    pd(:,k) = p_ob + Rcb * p_be_desired; %desired poe
    
    pd_dot(:,k) = (pd(:,k) - pd(:,k-1)) / Ts; %dpref == Dp_d/dt
    
    p_dot(:,k) = pd_dot(:,k) - Kp * (p(:,k-1) - pd(:,k-1)); %dp
    
%%    
    %orientation
    Roe_d = Rcb * Rbe; %desired 
    Qd = rotm2quat(Roe_d).';

    %current
    Q = rotm2quat(Roe_current).';
    
    Qd_inv = quatinv(Qd.').';
   
    Qe = quatmultiply(Q.' ,Qd_inv.').';
    
    Re_k_th = quat2axang(Qe.');
    theta_e = Re_k_th(4);
    ke = Re_k_th(1:3).'; %unit vector ke

    %log orientation error
    e_l(:,k) = theta_e * ke;
    %J_log = (-skew(ke) * skew(ke) * (theta_e/2) * cos(theta_e/2)/ sin(theta_e/2) - (theta_e/2)*skew(ke) + ke * ke.');

    hd = Qd(1,1);
    epsilond = Qd(2:4,1);
    S_epsilond = skew(epsilond);
    J_Qd = [-epsilond.'; hd * eye(3) - S_epsilond];

    wd = 2*J_Qd.' * (Qd - Qdprev) / Ts;
   
    Re = quat2rotm(Qe.').';
    %Re = eye(3) + 2*Qe(1,1)*skew(Qe(2:4,1)) + 2*skew(Qe(2:4,1))^2;

    u2 = Re*wd - Ko * e_l(:,k);
    
    Qdprev = Qd;
%%
    %find p_be and Rbe:
    p_BE(:,k) = transpose(Rcb) * (p(:,k-1) - p_ob); 
    Rbe_current = transpose(Rcb) * Roe_current;
    R_BE = rotm2axang(Rbe_current);
    Rbe_kx(1,k) = R_BE(1);
    Rbe_ky(1,k) = R_BE(2);
    Rbe_kz(1,k) = R_BE(3); 
    theta_be(1,k) = R_BE(4);
    if Rbe_ky(1,k) <0  % Rk,th == R-k,-th
        Rbe_ky(1,k) = - Rbe_ky(1,k);
        theta_be(1,k) = 2*pi - theta_be(1,k);
    end
%%
    % u = V
    u = [p_dot(:,k); u2];
    J = robot.jacob0(q_current);
    
    %qr_dot, entoli elegxou taxutitas arthrosewn
    qr_dot(:,k) =  inv(J) * u;

    %saturation to velocity
    qr_dot(:,k) = min(max(qr_dot(:,k), -qr_dot_MAX), +qr_dot_MAX);

    %low pass filter
    alpha = 0.158;
    
    qr_dot_filtered = (1-alpha) * qr_dot_filtered_prev + alpha * qr_dot(:,k);
    qr_dot(:,k) = qr_dot_filtered;
    qr_dot_filtered_prev = qr_dot_filtered;

    %accelaration
    qr_ddot(:,k) = (qr_dot(:,k) - qr_dot(:,k-1)) / Ts;

    %Euler integration, update q after the input u to CLIK
    q(:,k) = q(:,k-1) + qr_dot(:,k) * Ts; 

    %forward Kinematics q --> p, R
    fwk = robot.fkine(q(:,k).');
    p(:,k) = fwk.t;
    Roe_current = fwk.R;

    k = k+1;
    
end
time_elapsed = toc;

%Graphs
t = 0:Ts:stop_time;

figure();
plot(t, p(1,:).' - pd(1,:).');
hold on;
plot(t, p(2,:).' - pd(2,:).');
hold on;
plot(t, p(3,:).' - pd(3,:).');
hold on;
legend("p_{x}-pd_{x}", "p_{y}-pd_{y}","p_{z}-pd_{z}");
xlabel("t (sec)"); 
title("position error - e_{p}");

figure();
plot(t,e_l);
xlabel("t (sec)"); 
title("orientation error - e_{l}");

figure();
plot(p(2,:),p(3,:))
hold on;
plot(Yball,Zball);
hold on;
ylabel("Z");
xlabel("Y");
title("p_{OB} , p_{OE}");


figure();
plot(t,q);
xlabel("t (sec)"); 
ylabel("q (rad)");
title("q");


figure();
grid off;
yline(3.1416);
hold on;
yline(2.0944);
hold on;
yline(-3.14);
hold on;
yline(-2.0944);
hold on;
plot(t,qr_dot);
hold on;
xlabel("t (sec)"); 
ylabel("$\dot{q}_{r}$ (rad/sec)","Interpreter","latex");
title("$\dot{q}_{r}$", "Interpreter","latex");

figure();
grid off;
yline(250);
hold on;
yline(-250);
hold on;
plot(t,qr_ddot);
xlabel("t (sec)"); 
ylabel("$\ddot{q} (rad / sec^{2})$","Interpreter","latex");
title("$\ddot{q}$", "Interpreter","latex");

figure();
plot(t,p_BE(1,:));
hold on;
plot(t,p_BE(2,:));
hold on;
plot(t,p_BE(3,:));
hold on;
xlabel("t (sec)");
title("p_{be}");
legend("p_{x}", "p_{y}","p_{z}");

figure();
plot(t,Rbe_kx);
hold on;
plot(t,Rbe_ky);
hold on;
plot(t,Rbe_kz);
legend('kx','ky','kz');
xlabel("t (sec)"); 
title("R_{BE} - axis");

figure();
plot(t,theta_be);
xlabel("t (sec)"); 
ylabel("$\theta (rad) $","Interpreter","latex");
title("R_{BE} - angle");

figure();
f = wspace.visualize(robot ,q, [90,0]);

