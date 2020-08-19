% /*
% * @Author: ZLK
% * @Date:   2018-10-31 10:00:17
% * @Last Modified by:   ZLK
% * @Last Modified time: 2018-10-31 13:50:05
% */
function a = cordic_hr(x1,y1,z1,mode,it)
% mode: 0 rotation mode, 1 vectoring mode.
% it: iteration number.
if it<4
	error('Iterations must be greater than 3');
end
if mode==0
	if abs(z1)>1.1181
		error('In rotation mode abs(zl)<1.1181');
	end
else
	if abs(y1/x1)>0.8069
		error('In vectoring mode abs(yl/xl)<0.8069');
	end
end
myit = cordic_hr_it(it);
len_myit = length(myit);
x = zeros(len_myit+1,1);
y = zeros(len_myit+1,1);
z = zeros(len_myit+1,1);
x(1) = x1;
y(1) = y1;
z(1)= z1;
di = 0;
for k=1:len_myit
	if mode==0
		di = sign(z(k));
	else
		di = sign(-y(k));
	end
	x(k+1) = x(k)+ y(k)*di*2^(-myit(k));
	y(k+1) = y(k)+ x(k)*di*2^(-myit(k));
	z(k+1) = z(k)- di*atanh(2^(-myit(k)));
end

kn = 1/prod(sqrt(1-2.^(-2*myit)));
xn = kn*x(it+1);
yn = kn*y(it+1);
zn = z(it+1);

if mode==0
	xt = x1*cosh(z1)+y1*sinh(z1);
	yt = y1*cosh(z1)+x1*sinh(z1);
	zt = 0;
else
	xt = sqrt(x1^2-y1^2);
	yt = 0;
	zt = z1+atanh(y1/x1);
end

a = [xn, xt,yn,yt,zn,zt];
