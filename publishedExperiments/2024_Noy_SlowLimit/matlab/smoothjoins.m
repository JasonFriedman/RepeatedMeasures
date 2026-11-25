% SMOOTHJOINS - smooth the joins with a cubic (3rd order polynomial)
% We want the position and velocity to be smooth at the joins

%[smoothed,smoothedvel] = smoothjoins(x,vel,rng,toplot)
%
% Takes position (x), velocity (vel), range to smooth other (sample nums), toplot

function [smoothed,smoothedvel] = smoothjoins(x,vel,rng,toplot)

if toplot
    figure;
    subplot(2,1,1);
    plot(x);
    hold on;
    plot(rng,x(rng),'r');
    subplot(2,1,2);
    plot(vel);
    hold on;
    plot(rng,vel(rng),'r');
end

t = (rng - rng(1))./60;
tf = t(end);
xtf = x(rng(end)); % x(t_f)
x0 = x(rng(1));
vtf = vel(rng(end));
v0 = vel(rng(1));

% cubic: x = a t^3 + b t^2 + c t + d
d = x0;
c = v0;

% x(0) = d
% x'(0) = c

% a t_f^3 + b t_f^2 + c t_f + d = xtf => a t_f^3 + b t_f^2 = xtf - c t_f - d
% 3 a t_f^2 + 2 b t_f + c = vtf => 3 a t_f^2 + 2 b t_f = vtf - c

A = [tf^3, tf^2;
    3*tf^2, 2*tf;];

B = [xtf - c*tf - d;
    vtf - c];

result = linsolve(A,B);

a= result(1);
b = result(2);

% reconstruct the data
smoothed = x;
smoothed(rng) = a*t.^3 + b*t.^2 + c*t + d;

smoothedvel = vel;
smoothedvel(rng) = 3*a*t.^2 + 2*b*t + c;

if toplot
    subplot(2,1,1);
    hold on;
    plot(rng,smoothed(rng),'g');
    
    subplot(2,1,2);
    hold on;
    plot(rng,smoothedvel(rng),'g');
end
