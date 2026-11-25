% From Miall et al., 1993

t = 0:1/60:30; % 30 seconds

f = [0.073 0.117 0.205 0.278];

v = sin((2*pi*f)'*t);
vtotal = sum(v);

plot(t,sum(v))