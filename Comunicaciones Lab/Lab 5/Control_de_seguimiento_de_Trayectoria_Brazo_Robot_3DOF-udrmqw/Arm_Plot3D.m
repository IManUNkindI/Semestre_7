function Arm_Graph=Arm_Plot3D(dx,dy,dz,angx,angy,angz,th1,th2,th3)

global Robot;

      
global scale_arm;



% dx=0;
% dy=0;
% dz=0;
% angx=0*(pi/180);


% Matriz de rotación en cada eje
Rx=[ 1, 0, 0 0; 0, cos(angx), -sin(angx) 0; 0, sin(angx), cos(angx) 0; 0 0 0 1];
Ry=[ cos(angy), 0, sin(angy) 0; 0, 1, 0 0; -sin(angy), 0, cos(angy) 0;0 0 0 1];
Rz=[ cos(angz), -sin(angz) 0 0; sin(angz) cos(angz) 0 0; 0 0 1 0;0 0 0 1];
Rot_TheWholeArm=Rx*Ry*Rz; %Matriz rotación total esto se debe multiplicar a todos los componentes q forman el helicóptero 
Rot_TheWholeArm(1:3,4) = [dx dy dz]';

th1=90*(pi/180)+th1*-1;
th2=0*(pi/180)+th2*-1;
th3=0*(pi/180)+th3*-1;


% th1=th1;
% th2=th2;
% th3=th3;

h=0.25*scale_arm;
l1=0.5*scale_arm;
l2=0.4*scale_arm;
l3=0.15*scale_arm;

A1=[cos(th1) 0 sin(th1) 0;
    0        1 0        0;
  -sin(th1)  0 cos(th1) h;
  0          0 0        1];

A2=[cos(th1+th2) 0 sin(th1+th2) l1*sin(th1);
    0        1   0              0;
  -sin(th1+th2)  0 cos(th1+th2) l1*cos(th1)+h;
  0          0 0        1];

A3=[cos(th1+th2+th3) 0 sin(th1+th2+th3) l1*sin(th1)+l2*sin(th1+th2);
    0        1   0              0;
  -sin(th1+th2+th3)  0 cos(th1+th2+th3) l1*cos(th1)+l2*cos(th1+th2)+h;
  0          0 0        1];

A4=[cos(th1+th2+th3) 0 sin(th1+th2+th3) l1*sin(th1)+l2*sin(th1+th2)+l3*sin(th1+th2+th3);
    0        1   0              0;
  -sin(th1+th2+th3)  0 cos(th1+th2+th3) l1*cos(th1)+l2*cos(th1+th2)+l3*cos(th1+th2+th3)+h;
  0          0 0        1];
tam=0;
for ii = 1:(length(Robot.Base1))
    rArmManipulator = Rot_TheWholeArm*Robot.Base1{ii};
    Arm_Graph(ii) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[1 1 0.2],'LineWidth',1.8);
end
tam=tam+ii;
for ii = 1:(length(Robot.Soporte))
    rArmManipulator = Rot_TheWholeArm*Robot.Soporte{ii};
    Arm_Graph(tam+ii) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[0 0 0],'LineWidth',1.8);
end
tam=tam+ii;
for ii = 1:(length(Robot.lateral))
    rArmManipulator = Rot_TheWholeArm*Robot.lateral{ii};
    Arm_Graph(tam+ii) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[1 1 0.2],'LineWidth',1.8);
end
tam=tam+ii;
for ii = 1:(length(Robot.hueco1))
    rArmManipulator = Rot_TheWholeArm*Robot.hueco1{ii};
    Arm_Graph(tam+ii) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[0 0 0],'LineWidth',1.8);
end
tam=tam+ii;
for ii = 1:(length(Robot.eslabon1))
    rArmManipulator = Rot_TheWholeArm*A1*Robot.eslabon1{ii};
    Arm_Graph(tam+ii) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[1 1 0.2],'LineWidth',1.8);
end
tam=tam+ii;
for ii = 1:(length(Robot.eslabon2))
    rArmManipulator = Rot_TheWholeArm*A2*Robot.eslabon2{ii};
    Arm_Graph(tam+ii) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[1 1 0.2],'LineWidth',1.8);
    
end
tam=tam+ii;
for ii = 1:(length(Robot.soporte2))
    rArmManipulator = Rot_TheWholeArm*A2*Robot.soporte2{ii};
    Arm_Graph(tam+ii) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[0 0 0],'LineWidth',1.8);
end
tam=tam+ii;
for ii = 1:(length(Robot.eslabon3))
    rArmManipulator = Rot_TheWholeArm*A3*Robot.eslabon3{ii};
    Arm_Graph(tam+ii) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[1 1 0.2],'LineWidth',1.8);
end
tam=tam+ii;
for ii = 1:(length(Robot.soporte2))
    rArmManipulator = Rot_TheWholeArm*A3*Robot.soporte2{ii};
    Arm_Graph(tam+ii) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[0 0 0],'LineWidth',1.8);
end
tam=tam+ii;
for jj = 1:(length(Robot.Pinza))
    rArmManipulator = Rot_TheWholeArm*A4*Robot.Pinza{jj};
    Arm_Graph(tam+jj) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[1 1 0.2],'LineWidth',1.8);
end
tam=tam+jj;
for jj = 1:(length(Robot.PinzaL))
    rArmManipulator = Rot_TheWholeArm*A4*Robot.PinzaL{jj};
    Arm_Graph(tam+jj) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[0.5 0.5 0.5],'LineWidth',1.8);
end
tam=tam+jj;
for jj = 1:(length(Robot.PinzaL1))
    rArmManipulator = Rot_TheWholeArm*A4*Robot.PinzaL1{jj};
    Arm_Graph(tam+jj) = patch(rArmManipulator(1,:),rArmManipulator(2,:),rArmManipulator(3,:),[0.5 0.5 0.5],'LineWidth',1.8);
end
end