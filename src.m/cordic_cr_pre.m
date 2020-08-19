% /*
% * @Author: ZLK
% * @Date:   2018-10-30 16:30:29
% * @Last Modified by:   ZLK
% * @Last Modified time: 2018-10-30 16:44:24
% */
function [x0_p,y0_p,z0_p]=cordic_cr_pre(x0,y0,z0,mode)
% vector (x0,y0)
% mode : 0 : rotation; else vectoring
if z0<-pi||z0>pi
	error('Rotation angle must range from -pi to pi.');
end

if x0==0 && y0==0
	error('Both x0 and y0 can not be zeros at the same time.');
end

if mode==0
	s = sign(z0);
	if z0>pi/2||z0<-pi/2
	x0_p= -s*y0;
	y0_p = s*x0;
	z0_p = z0 - s*pi/2;
else
	x0_p = x0;
	y0_p = y0;
	z0_p = z0;
end
else
	x0_p = abs(x0);
	y0_p = abs(y0);
	z0_p = 0;
end
