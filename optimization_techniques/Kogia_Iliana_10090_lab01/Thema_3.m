close all;
clear all;

syms x
f(x) = (x-2)^2 + x*log(x+3);
%f(x) = 5^x + (2-cos(x))^2;
%f(x) = exp(x)*(x^3-1) + (x-1)*sin(x);

sxima =1;
for lamda = [0.1 0.01 0.001 0.0001]
    epsilon =0.001;
    [Ak Bk] = Fibonacci(epsilon,lamda,f);
    figure(sxima);
    title(['l = ',num2str(lamda)]);
    xlabel('k');
    hold on;
    ylabel('a_k');
    hold on;
    plot(Ak,'-o','Color','r');

    figure(sxima+1);
    title(['l = ',num2str(lamda)]);
    xlabel('k');
    hold on;
    ylabel('b_k');
    hold on;
    plot(Bk,'-o');
    sxima = sxima+2;
end
N = zeros(1,7);
l = zeros(1,7);
j=1;
for lamda = [0.1 0.05 0.01 0.005 0.001 0.0005 0.0001]
    epsilon = 0.001;
    [Ak Bk n] = Fibonacci(epsilon,lamda,f);
    N(j) = n;
    l(j) = lamda;
    j=j+1;
end
figure(sxima);
plot(l,N,'-o');
xlabel('lamda');
ylabel('f calls');