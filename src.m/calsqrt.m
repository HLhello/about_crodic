function [sqrt_value] = calsqrt(a)

NormKn = ceil(log2(a)) - 1;
fprintf('Normalization input data is %d NormKn data is %d\n',a/2^NormKn,NormKn);

a = a/2^NormKn;
Kn = sqrt(2^NormKn);
fprintf('Kn data is %d\n',Kn);

y1 = (a-1/4)*2^20; 
yn_1 = y1;
x1 = (a+1/4)*2^20; 
xn_1 = x1;

for i =1 : 10
    if(yn_1/2^20 <= 0)
        di = 1;
    else
        di = -1;
    end
    xn = xn_1 + di*((2^(-i))*2^10 * yn_1/2^10);
    yn = yn_1 + di*((2^(-i))*2^10 * xn_1/2^10);
    fprintf('%d %d \n',i ,yn_1/2^20);
    xn_1 = xn;
    yn_1 = yn;
end

sqrt_value = xn_1/0.829782*Kn;
fprintf('%f\n',y1/x1);
fprintf('sqrt:%f yn:%f\n',sqrt_value/2^20,yn);


 