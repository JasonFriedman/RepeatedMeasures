%Name:             SAMPLE8PLOT.M

%Description:
%    This is an addition to OPTOTRAK sample8.m:
%    - Plots the 3D data file C#001.S08 using Matlab.

%Read data file:
data=optotrak('Read3DFileToMatlab','C#001.S08');

%... and plot it:
figure
hold on
plot3(data.Markers{1}(1,:),data.Markers{1}(2,:),data.Markers{1}(3,:),'r*')
plot3(data.Markers{2}(1,:),data.Markers{2}(2,:),data.Markers{2}(3,:),'g*')
plot3(data.Markers{3}(1,:),data.Markers{3}(2,:),data.Markers{3}(3,:),'b*')
plot3(data.Markers{4}(1,:),data.Markers{4}(2,:),data.Markers{4}(3,:),'m*')

