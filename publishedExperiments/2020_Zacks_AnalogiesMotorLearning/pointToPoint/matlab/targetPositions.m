% TARGET POSITIONS

smallwidth = 40;
largewidth = 160;

targetcenters = [...
    1420 430;
    740 520;
    500 720;
    880 250];

fprintf('All small\n');

bottomleft = targetcenters - smallwidth/2
    
fprintf('Large D\n');

bottomleft = [targetcenters(1:3,:) - smallwidth/2;
    targetcenters(4,:) - largewidth/2]

                 
    