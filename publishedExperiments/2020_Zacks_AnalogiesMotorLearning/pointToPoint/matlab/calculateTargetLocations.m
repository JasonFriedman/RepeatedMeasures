% calculate where the targets should be for the scaled (50%) version

targetlocations = [1400 410;
    720 500;
    480 700;
    860 230;];

screenwidth = 1920;
screenheight = 1080;
scalefactor = 0.5;

scaled(:,1) = (targetlocations(:,1) - screenwidth/2) * scalefactor + screenwidth/2;
scaled(:,2) = (targetlocations(:,2) - screenheight/2) * scalefactor + screenheight/2;

plot(scaled(:,1),scaled(:,2),'*');
axis equal