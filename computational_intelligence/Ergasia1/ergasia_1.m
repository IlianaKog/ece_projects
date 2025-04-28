close all;
clear all;

%% linear control PI

Gp = zpk([],[-1, -9], 10); %Gp(s) = 10 / (s+1)(s+9) 

Ki = 2.2;
Kp = 2; 

c = Ki/Kp; %mhdeniko
Gc = zpk(-c, 0, Kp); %Gc(s) = Kp(s+c) / s

open_loop_sys = Gp * Gc;
closed_loop_sys = feedback(open_loop_sys,1,-1);

figure();
rlocus(open_loop_sys); %?

figure();
step(closed_loop_sys, "blue");
hold on;
%xline(1.2);


%% Fuzzy PI Controller

FLC = readfis('FLC.fis');
figure();
gensurf(FLC)




