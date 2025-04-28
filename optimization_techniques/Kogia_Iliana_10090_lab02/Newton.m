clear all;
close all;

epsilon = 0.001;
%SELECT METHOD


syms x y G
f(x,y) = x^5*exp(-x^2-y^2);
gradF(x,y) = gradient(f,[x y]);
HessF(x,y) = hessian(f,[x y]);

X=zeros(2,100);
d = zeros(2,100);
g= zeros(100,1);
minimumG = zeros(1,2);
h=zeros(2,2);
X(1,1) =-1;
X(2,1) = 1;

k=1;
f_star = 0;
x_star = 0;
y_star = 0;

while(1)
    if abs(gradF(X(1,k),X(2,k))) <= epsilon
        x_star = X(1,k);
        y_star = X(2,k);
        f_star = double(f(x_star,y_star));
        break;
    end
    try chol(HessF(X(1,k),X(2,k)))
        disp('einai thetika orismenos')
    catch ME
        disp('oxi thetika orismenos')
    end
    
    h = -inv(HessF(X(1,k),X(2,k)));
    grad = gradF(X(1,k),X(2,k));
    temp = h*grad;
    d(:,k) = temp;
    
    g(k)=0.47;
    
%     FI(G) = f(X(1,k)+G*d(1,k), X(2,k)+G*d(2,k));
%     minimumG = FibonacciMin(0,6,FI);
%     g(k) = (minimumG(1,1)+minimumG(1,2))/2;
    

    %ARMIJO
%     a=10^-2;
%     b=1/2; 
%     s=5;
%     g(k) = s;
%     dTk = transpose(d(:,k));
%     tempo = dTk * grad;
%     while(1)
%         if f(X(1,k)+g(k)*d(1,k),X(2,k)+g(k)*d(2,k)) <= f(X(1,k),X(2,k)) + a*g(k)* dTk*grad
%             break;
%         else
%             g(k) = b*g(k);
%         end
%     end
   
    X(:,k+1) = X(:,k) + g(k)*d(:,k);
    k = k+1;
end

fprintf('%.4f\n',f_star);
fprintf('%.4f\n',x_star);
fprintf('%.4f\n',y_star);