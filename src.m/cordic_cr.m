% /*
% * @Author: ZLK
% * @Date:   2018-10-30 16:30:29
% * @Last Modified by:   ZLK
% * @Last Modified time: 2018-10-30 17:13:55
% */
function a = cordic_cr(x0,y0,z0,mode,it)
% Circular Rotation.
% mode 0: roatation mode; 1: vectoring mode.
% vectoring mode: z0=0.
% z0: expected rotation angle with rad instead of degree.
% In rotation mode z0 ranges from -pi to pi.
% it: iteration count
%% cordic_cr_pre
[x0_p,y0_p,z0_p]=cordic_cr_pre(x0,y0,z0,mode);
x = zeros(it+1,1);
y = zeros(it+1,1);
z = zeros(it+1,1);
x(1)= x0_p;
y(1)= y0_p;
z(1)= z0_p;
di = 0;
%% iteration
for k=1:it
	if mode==0
		di = sign(z(k)); % rotation mode
	else
		di = sign(-y(k));% vectoring mode
	end
	x(k+1) = x(k)-y(k)*di*2^(-(k-1));
	y(k+1) = y(k)+x(k)*di*2^(-(k-1));
	z(k+1) = z(k)-di*atan(2^(-(k-1)));
end
kn = 1/prod(sqrt(1+2.^(-2*(0:it-1)))); % scale factor
xn_p = kn*x(it+1);
yn_p = kn*y(it+1);
zn_p = z(it+1);
%% cordic_cr_ post
[xn,yn,zn]=cordic_cr_post(x0,y0,z0,xn_p,yn_p,zn_p,mode);
%% true result
if mode==0
	xt = x0*cos(z0)-y0*sin(z0);
	yt = y0*cos(z0)+x0*sin(z0);
	zt = 0;
else
	xt = sqrt(x0^2+y0^2);
	yt = 0;
	zt = z0+atan2(y0,x0); % atan2 rang from -pi to pi
end
a = [xn,xt,yn,yt,zn,zt];
