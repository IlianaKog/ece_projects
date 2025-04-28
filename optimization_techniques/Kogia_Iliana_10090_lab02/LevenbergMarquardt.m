%g=      const  gmin    armijo
%gMethod== 1     2       3
%gInput==  g      -       s
function[fvalues, X, k] = LevenbergMarquardt(xo,yo,gMethod, gInput)

epsilon = 0.001;

syms x y G
f(x,y) = x^5*exp(-x^2-y^2);
gradF(x,y) = gradient(f,[x y]);
HessF(x,y) = hessian(f,[x y]);

X=zeros(2,100);
d = zeros(2,100);
g= zeros(100,1);
minimumG = zeros(1,2);
h1=zeros(2,2);

X(1,1) = xo;
X(2,1) = yo;
I = [1 0;0 1];

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
    m_k=0;
    C = HessF(X(1,k),X(2,k)) + m_k * I;
    [~,flag] = chol(C);
    while(flag~=0)
        m_k = m_k + 1;
        C = HessF(X(1,k),X(2,k)) + m_k * I;
        [~,flag] = chol(C);
    end   
    
    h1 = -inv(HessF(X(1,k),X(2,k)) + m_k * I);
    grad = gradF(X(1,k),X(2,k));
    temp = h1*grad;
    d(:,k) = temp;
    
    %kritiria 3 kai 4 
    try chol(-transpose(grad)*d(:,k));
    catch ME
        disp('Probmhma me kritirio 3 kai 4');
        break;
    end
    
    if gMethod == 1
        g(k) = gInput;
    
    elseif gMethod == 2
        FI(G) = f(X(1,k)+G*d(1,k), X(2,k)+G*d(2,k));
        minimumG = FibonacciMin(0,8,FI);
        g(k) = (minimumG(1,1)+minimumG(1,2))/2;
    
    else
        %ARMIJO
        a=10^-2;
        b=1/2; 
        s=gInput;
        g(k) = s;
        dTk = transpose(d(:,k));
        while(1)
            if f(X(1,k)+g(k)*d(1,k),X(2,k)+g(k)*d(2,k)) <= f(X(1,k),X(2,k)) + a*g(k)*dTk*grad
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


% fprintf('%.4f\n',f_star);
% fprintf('%.4f\n',x_star);
% fprintf('%.4f\n',y_star);
% fprintf('%.4f\n',k);

%-------------------------2os tropos gia tin euresi tou mk-----------%
%     m_k = 0.1;
%     C = HessF(X(1,k),X(2,k)) + m_k * I;
%     [~,flag] = chol(C);
%     eigens = eig(HessF(X(1,k),X(2,k)));
%     maxEig = max(abs(eigens));
%     while(flag~=0)
%         m_k = m_k + maxEig;
%         C = HessF(X(1,k),X(2,k)) + m_k * I;
%         [~,flag] = chol(C);
%     end
