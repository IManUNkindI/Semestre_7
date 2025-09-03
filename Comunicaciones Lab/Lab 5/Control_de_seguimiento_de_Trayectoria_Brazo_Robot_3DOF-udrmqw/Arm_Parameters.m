function Arm_Parameters(scale)


global Robot;
if nargin < 1
    scale = 1;
end
global scale_arm;


scale_arm = scale;
% base1 30cm
th=pi/4:0.3:2*pi+pi/4;

x=1.4142*cos(th)*0.15*scale_arm;
y=1.4142*sin(th)*0.15*scale_arm;
z=0*ones(1,length(th));


base1=[x' y' z'];

zh=0.15*scale_arm;
Robot.Base1{1}=[base1' ; ones(1,length(base1))];
Robot.Base1{2}=[[x' y' z'+zh]' ; ones(1,length(base1))];

% 4 soporte
x=1.4142*cos(th)*0.02*scale_arm;
y=1.4142*sin(th)*0.02*scale_arm;

soporte1=[x'-0.12*scale_arm y' z'];

for k=1:length(soporte1(:,1))-1
    Robot.Soporte{k}=[soporte1(k,1) soporte1(k,2) soporte1(k,3) 1;soporte1(k+1,1) soporte1(k+1,2) soporte1(k,3) 1; soporte1(k+1,1) soporte1(k+1,2) zh 1; soporte1(k,1)  soporte1(k,2) zh 1]';
if k==length(soporte1(:,1))-1
    Robot.Soporte{k+1}=[soporte1(length(soporte1(:,1)),1) soporte1(length(soporte1(:,1)),2) soporte1(1,3) 1; soporte1(1,1) soporte1(1,2) soporte1(1,3) 1; soporte1(1,1) soporte1(1,2) zh 1;soporte1(length(soporte1(:,1)),1) soporte1(length(soporte1(:,1)),2) zh 1]';
end
end

soporte1=[x'+0.12*scale_arm y' z'];
for j=1:length(soporte1(:,1))-1
    Robot.Soporte{k+j}=[soporte1(j,1) soporte1(j,2) soporte1(j,3) 1;soporte1(j+1,1) soporte1(j+1,2) soporte1(j,3) 1; soporte1(j+1,1) soporte1(j+1,2) zh 1; soporte1(j,1)  soporte1(j,2) zh 1]';
if j==length(soporte1(:,1))-1
    Robot.Soporte{k+j+1}=[soporte1(length(soporte1(:,1)),1) soporte1(length(soporte1(:,1)),2) soporte1(1,3) 1; soporte1(1,1) soporte1(1,2) soporte1(1,3) 1; soporte1(1,1) soporte1(1,2) zh 1;soporte1(length(soporte1(:,1)),1) soporte1(length(soporte1(:,1)),2) zh 1]';
end
end

soporte1=[x' y'-0.12*scale_arm z'];
for i=1:length(soporte1(:,1))-1
    Robot.Soporte{k+j+i}=[soporte1(i,1) soporte1(i,2) soporte1(i,3) 1;soporte1(i+1,1) soporte1(i+1,2) soporte1(i,3) 1; soporte1(i+1,1) soporte1(i+1,2) zh 1; soporte1(i,1)  soporte1(i,2) zh 1]';
if i==length(soporte1(:,1))-1
    Robot.Soporte{k+j+i+1}=[soporte1(length(soporte1(:,1)),1) soporte1(length(soporte1(:,1)),2) soporte1(1,3) 1; soporte1(1,1) soporte1(1,2) soporte1(1,3) 1; soporte1(1,1) soporte1(1,2) zh 1;soporte1(length(soporte1(:,1)),1) soporte1(length(soporte1(:,1)),2) zh 1]';
   
end
end

soporte1=[x' y'+0.12*scale_arm z'];
for b=1:length(soporte1(:,1))-1
    Robot.Soporte{k+j+i+b}=[soporte1(b,1) soporte1(b,2) soporte1(b,3) 1;soporte1(b+1,1) soporte1(b+1,2) soporte1(b,3) 1; soporte1(b+1,1) soporte1(b+1,2) zh 1; soporte1(b,1)  soporte1(b,2) zh 1]';
if b==length(soporte1(:,1))-1
    Robot.Soporte{k+j+i+b+1}=[soporte1(length(soporte1(:,1)),1) soporte1(length(soporte1(:,1)),2) soporte1(1,3) 1; soporte1(1,1) soporte1(1,2) soporte1(1,3) 1; soporte1(1,1) soporte1(1,2) zh 1;soporte1(length(soporte1(:,1)),1) soporte1(length(soporte1(:,1)),2) zh 1]';
end
end

% laterales de eslabón 1
basel=[-3.803 0 1.019;
-3.937 0 0;
-3.937 0 -3.937;
0 0 -3.937;
0 0 -3.954;
3.937 0 -3.954;
3.937 0 0;
3.803 0 1.019;
3.41 0 1.969;
2.784 0 2.784;
1.969 0 3.41;
1.019 0 3.803;
0 0 3.937;
-1.019 0 3.803;
-1.969 0 3.41;
-2.784 0 2.784;
-3.41 0 1.969]*1/(3.937*15);

Robot.lateral{1}=[[basel(:,1) basel(:,2)-0.06 basel(:,3)+0.23]'*scale_arm ; ones(1,length(basel))];
Robot.lateral{2}=[[basel(:,1) basel(:,2)+0.06 basel(:,3)+0.23]'*scale_arm ; ones(1,length(basel))];

 % huecos laterales de eslabón 1

x=1.4142*cos(th)*0.02;
z=1.4142*sin(th)*0.02;
y=0*ones(1,length(th));

Robot.hueco1{1}=[[x' y'-0.07 z'+0.23]'*scale_arm ; ones(1,length(x))];
Robot.hueco1{2}=[[x' y'+0.07 z'+0.23]'*scale_arm ; ones(1,length(x))];

% eslabón 1
eslabon=[-1.019 0 -3.803;
-1.969 0 -3.41;
-2.784 0 -2.784;
-3.41 0 -1.969;
-3.803 0 -1.019;
-3.937 0 -0;
-3.803 0 1.019;
-3.41 0 1.969;
-2.784 0 2.784;
-1.969 0 3.41;
-1.019 0 3.803;
0 0 3.937;
39.37 0 3.937;
40.389 0 3.803;
41.339 0 3.41;
42.154 0 2.784;
42.78 0 1.969;
43.173 0 1.019;
43.307 0 0;
43.173 0 -1.019;
42.78 0 -1.969;
42.154 0 -2.784;
41.339 0 -3.41;
40.389 0 -3.803;
39.37 0 -3.937;
0 0 -3.937]*0.5/(39.37);

eslabon(:,2)=eslabon(:,2)-0.05;

Robot.eslabon1{1}=[[eslabon(:,3) eslabon(:,2) eslabon(:,1)]'*scale_arm ; ones(1,length(eslabon))];
Robot.eslabon1{2}=[[eslabon(:,3) eslabon(:,2)+0.1 eslabon(:,1)]'*scale_arm ; ones(1,length(eslabon))];

% eslabón 2
eslabon=[4.921 0 3.937;
0 0 3.937;
-1.019 0 3.803;
-1.969 0 3.41;
-2.784 0 2.784;
-3.41 0 1.969;
-3.803 0 1.019;
-3.937 0 -0;
-3.803 0 -1.019;
-3.41 0 -1.969;
-2.784 0 -2.784;
-1.969 0 -3.41;
-1.019 0 -3.803;
0 0 -3.937;
4.921 0 -3.937;
5.317 0 -3.797;
5.716 0 -3.667;
6.119 0 -3.547;
6.524 0 -3.438;
6.933 0 -3.34;
7.343 0 -3.252;
7.756 0 -3.175;
8.171 0 -3.109;
8.587 0 -3.053;
9.005 0 -3.009;
9.423 0 -2.975;
9.843 0 -2.953;
29.528 0 -2.953;
29.947 0 -2.975;
30.365 0 -3.009;
30.783 0 -3.053;
31.199 0 -3.109;
31.614 0 -3.175;
32.027 0 -3.252;
32.437 0 -3.34;
32.846 0 -3.438;
33.251 0 -3.547;
33.654 0 -3.667;
34.053 0 -3.797;
34.449 0 -3.937;
39.37 0 -3.937;
40.389 0 -3.803;
41.339 0 -3.41;
42.154 0 -2.784;
42.78 0 -1.969;
43.173 0 -1.019;
43.307 0 0;
43.173 0 1.019;
42.78 0 1.969;
42.154 0 2.784;
41.339 0 3.41;
40.389 0 3.803;
39.37 0 3.937;
34.449 0 3.937;
34.053 0 3.797;
33.654 0 3.667;
33.251 0 3.547;
32.846 0 3.438;
32.437 0 3.34;
32.027 0 3.252;
31.614 0 3.175;
31.199 0 3.109;
30.783 0 3.053;
30.365 0 3.009;
29.947 0 2.975;
29.528 0 2.953;
9.843 0 2.953;
9.423 0 2.975;
9.005 0 3.009;
8.587 0 3.053;
8.171 0 3.109;
7.756 0 3.175;
7.343 0 3.252;
6.933 0 3.34;
6.524 0 3.438;
6.119 0 3.547;
5.716 0 3.667;
5.317 0 3.797]*0.5/(39.37);


eslabon(:,2)=eslabon(:,2)-0.045;
eslabon(:,1)=eslabon(:,1)*0.8;

Robot.eslabon2{1}=[[eslabon(:,3) eslabon(:,2) eslabon(:,1)]'*scale_arm ; ones(1,length(eslabon))];
Robot.eslabon2{2}=[[eslabon(:,3) eslabon(:,2)+0.08 eslabon(:,1)]'*scale_arm ; ones(1,length(eslabon))];

%soporte 
x=1.4142*cos(th)*0.02;
z=1.4142*sin(th)*0.02;
y=-0.05*ones(1,length(th));


Robot.soporte2{1}=[[x' y'-0.01 z']'*scale_arm ; ones(1,length(x))];
Robot.soporte2{2}=[[x' y'+0.105 z']'*scale_arm ; ones(1,length(x))];


% eslabón 3
eslabon=[0 0 -3.937;
10.621 0 -3.937;
10.621 0 0.012;
2.461 0 3.937;
0 0 3.937;
-1.019 0 3.803;
-1.969 0 3.41;
-2.784 0 2.784;
-3.41 0 1.969;
-3.803 0 1.019;
-3.937 0 -0;
-3.803 0 -1.019;
-3.41 0 -1.969;
-2.784 0 -2.784;
-1.969 0 -3.41;
-1.019 0 -3.803]*0.5/(39.37);


eslabon(:,2)=eslabon(:,2)-0.045;

Robot.eslabon3{1}=[[eslabon(:,3) eslabon(:,2) eslabon(:,1)]'*scale_arm ; ones(1,length(eslabon))];
Robot.eslabon3{2}=[[eslabon(:,3) eslabon(:,2)+0.08 eslabon(:,1)]'*scale_arm ; ones(1,length(eslabon))];

%pinza
pinza=[-0.787 0 1.969;
-0.828 0 1.663;
-0.946 0 1.378
-1.133 0 1.133;
-1.378 0 0.946;
-1.663 0 0.828;
-1.969 0 0.787;
-2.274 0 0.828;
-2.559 0 0.946;
-2.804 0 1.133;
-2.991 0 1.378;
-3.109 0 1.663;
-3.15 0 1.969;
-3.109 0 2.274;
-2.991 0 2.559;
-2.804 0 2.804;
-2.559 0 2.991;
-2.274 0 3.109;
-1.969 0 3.15;
1.343 0 4.474;
4.921 0 2.754;
8.858 0 2.754;
8.858 0 1.572;
4.921 0 1.572;
4.921 0 1.591;
1.343 0 3.047]*1/(3.937*15);

pinza1=[pinza(:,3) pinza(:,2)-0.045 pinza(:,1)]*scale_arm  ;

zb=0.05*scale_arm ;

Robot.Pinza{1}=[[pinza1(:,1) pinza1(:,2) pinza1(:,3)]' ; ones(1,length(pinza))];
Robot.Pinza{2}=[[pinza1(:,1) pinza1(:,2)+0.08*scale_arm pinza1(:,3)]' ; ones(1,length(pinza))];

a=0*scale_arm ;
for k=1:length(pinza1)-1
    Robot.PinzaL{k}=[pinza1(k,1) pinza1(k,2) pinza1(k,3)+a 1;pinza1(k+1,1) pinza1(k,2) pinza1(k+1,3)+a 1; pinza1(k+1,1) zb pinza1(k+1,3)+a 1; pinza1(k,1) zb pinza1(k,3)+a 1]';
 if k==length(pinza1)-1
    Robot.PinzaL{k+1}=[pinza1(length(pinza1),1) pinza1(1,2) pinza1(length(pinza1),3)+a 1; pinza1(1,1) pinza1(1,2) pinza1(1,3)+a 1; pinza1(1,1) zb pinza1(1,3)+a 1;pinza1(length(pinza1),1) zb pinza1(length(pinza1),3)+a 1]';
end
end


pinza=[4.921 0 -3.316;
4.921 0 -3.276;
8.858 0 -3.276;
8.858 0 -2.095;
4.921 0 -2.095;
1.343 0 -2.953;
-0.787 0 -1.969;
-0.828 0 -1.663;
-0.946 0 -1.378;
-1.133 0 -1.133;
-1.378 0 -0.946;
-1.663 0 -0.828;
-1.969 0 -0.787;
-2.274 0 -0.828;
-2.559 0 -0.946;
-2.804 0 -1.133;
-2.991 0 -1.378;
-3.109 0 -1.663;
-3.15 0 -1.969;
-3.109 0 -2.274;
-2.991 0 -2.559;
-2.804 0 -2.804;
-2.559 0 -2.991;
-2.274 0 -3.109;
-1.969 0 -3.15;
1.343 0 -4.474]*1/(3.937*15);

pinza1=[pinza(:,3) pinza(:,2)-0.045 pinza(:,1)]*scale_arm  ;

zb=0.05*scale_arm ;

Robot.Pinza{3}=[[pinza1(:,1) pinza1(:,2) pinza1(:,3)]' ; ones(1,length(pinza))];
Robot.Pinza{4}=[[pinza1(:,1) pinza1(:,2)+0.08*scale_arm pinza1(:,3)]' ; ones(1,length(pinza))];


a=0*scale_arm ;
for k=1:length(pinza1)-1
    Robot.PinzaL1{k}=[pinza1(k,1) pinza1(k,2) pinza1(k,3)+a 1;pinza1(k+1,1) pinza1(k,2) pinza1(k+1,3)+a 1; pinza1(k+1,1) zb pinza1(k+1,3)+a 1; pinza1(k,1) zb pinza1(k,3)+a 1]';
 if k==length(pinza1)-1
    Robot.PinzaL1{k+1}=[pinza1(length(pinza1),1) pinza1(1,2) pinza1(length(pinza1),3)+a 1; pinza1(1,1) pinza1(1,2) pinza1(1,3)+a 1; pinza1(1,1) zb pinza1(1,3)+a 1;pinza1(length(pinza1),1) zb pinza1(length(pinza1),3)+a 1]';
end
end






