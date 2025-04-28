%g=      const  gmin    armijo
%gMethod== 1     2       3
%gInput==  g     -       s
function[fvalues, X, k] = SteepestDescent(xo,yo,gMethod, gInput)

epsilon = 0.001;

syms x y G
f(x,y) = x^5*exp(-x^2-y^2);
gradF(x,y) = gradient(f,[x y]);


X=zeros(2,100);
d = zeros(2,100);
g= zeros(100,1);
minimumG = zeros(1,2);

X(1,1) = xo;
X(2,1) = yo;

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
   
    d(:,k) = -gradF(X(1,k),X(2,k));
    if gMethod == 1
        g(k) = gInput;
    
    elseif gMethod == 2
        FI(G) = f(X(1,k)+G*d(1,k), X(2,k)+G*d(2,k));
        minimumG = FibonacciMin(0,8,FI);
        %minimumG = DixotomosDer(0,8,FI);
        g(k) = (minimumG(1,1)+minimumG(1,2))/2;
    else
        %ARMIJO
        a=10^-2;
        b=1/2; 
        s = gInput;
        g(k) = s;
        dTk = transpose(d(:,k));
        while(1)
            if f(X(1,k)+g(k)*d(1,k),X(2,k)+g(k)*d(2,k)) <= f(X(1,k),X(2,k)) + a*g(k)* dTk*gradF(X(1,k),X(2,k))
                break;
            else
                g(k) = b*g(k);
            end
        end
    end
    X(:,k+1) = X(:,k) + g(k)*d(:,k);
    k = k+1;
end
X = X(:,1:k);
fvalues = double(f(X(1,1:k),X(2,1:k)));

% figure(1);
% plot(fvalues,'-o');
% hold on;
% %title('g=const');
% xlabel('k');
% ylabel('f(xk)');
% 
% fprintf('Min f: %.4f\n',f_star);
% fprintf('X: %.4f\n',x_star);
% fprintf('Y: %.4f\n',y_star);

end