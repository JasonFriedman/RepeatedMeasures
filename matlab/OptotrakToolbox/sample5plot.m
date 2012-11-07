%Name:             SAMPLE5PLOT.M

%Description:
%    This is an addition to OPTOTRAK sample5.m and sample5convert.m:
%    - Plots the converted 3D data file C#001.S05 using Matlab.

%Read data file:
data=optotrak('Read3DFileToMatlab','C#001.S05');

%...and plot the data:
figure
hold on
plot3(data.Markers{1}(1,:),data.Markers{1}(2,:),data.Markers{1}(3,:),'r*')
plot3(data.Markers{2}(1,:),data.Markers{2}(2,:),data.Markers{2}(3,:),'g*')
plot3(data.Markers{3}(1,:),data.Markers{3}(2,:),data.Markers{3}(3,:),'b*')
plot3(data.Markers{4}(1,:),data.Markers{4}(2,:),data.Markers{4}(3,:),'m*')
plot3(data.Markers{5}(1,:),data.Markers{4}(2,:),data.Markers{4}(3,:),'y*')
plot3(data.Markers{6}(1,:),data.Markers{4}(2,:),data.Markers{4}(3,:),'c*')

