clc
clear all
close all

ts=0.1;
t=0:ts:60;


% 1. Condiciones iniciales del manipulador 
        l1=0.5;
        l2=0.65;
        h=0.25;
        
        q1(1) =  0*(pi/180);             
        q2(1) =  30*(pi/180);  
        q3(1) =  30*(pi/180); 

        xr(1)=l1*cos(q2(1))*cos(q1(1))+l2*cos(q2(1)+q3(1))*cos(q1(1));
        yr(1)=l1*cos(q2(1))*sin(q1(1))+l2*cos(q2(1)+q3(1))*sin(q1(1));
        zr(1)=h+l1*sin(q2(1))+l2*sin(q2(1)+q3(1));

% 3) Referencias deseadas
%         xrd = 0.5;
%         yrd = -0.8;
%         zrd = 0.2;
        
        xrd = .6*cos(0.2*t);
        yrd = .6*sin(0.2*t);
        zrd = 0.7*ones(1,length(t));
%         zrd =0.7+0.01*t;
                
        xrd_p= -.6*0.2*sin(0.2*t);
        yrd_p= .6*0.2*cos(0.2*t);
%         zrd_p = 0.01*ones(1,length(t));
        
        zrd_p= 0*ones(1,length(t));
  
for k=1:length(t)
    
    %a) Errores de control
    xre(k) = xrd(k) - xr(k);
    yre(k) = yrd(k) - yr(k);
    zre(k) = zrd(k) - zr(k);

    e = [xre(k);yre(k);zre(k)];
    
    %b) Matriz Jacobiana
    J=[ -l1*cos(q2(k))*sin(q1(k))-l2*cos(q2(k)+q3(k))*sin(q1(k)) -l1*cos(q1(k))*sin(q2(k))-l2*cos(q1(k))*sin(q2(k)+q3(k)) -l2*cos(q1(k))*sin(q2(k)+q3(k));...
        l1*cos(q2(k))*cos(q1(k))+l2*cos(q2(k)+q3(k))*cos(q1(k)) -l1*sin(q1(k))*sin(q2(k))-l2*sin(q1(k))*sin(q2(k)+q3(k)) -l2*sin(q1(k))*sin(q2(k)+q3(k));...
        0 l1*cos(q2(k))+l2*cos(q2(k)+q3(k)) l2*cos(q2(k)+q3(k))];
       
    %c) Matriz de ganancia
    K = [0.2 0 0;...
         0 0.2 0;...
         0 0 0.2];

    %d) Ley de control    
%     v = inv(J)*K*e;
    
    hd_p=[xrd_p(k) yrd_p(k) zrd_p(k)]';
    
    %d) Ley de control  
    v = inv(J)*(hd_p+K*tanh(e));
    
    q1p_ref(k)=v(1);
    q2p_ref(k)=v(2);
    q3p_ref(k)=v(3);
    
    
    q1(k+1)=q1(k)+q1p_ref(k)*ts;
    q2(k+1)=q2(k)+q2p_ref(k)*ts;
    q3(k+1)=q3(k)+q3p_ref(k)*ts;
  
        xr(k+1)=l1*cos(q2(k+1))*cos(q1(k+1))+l2*cos(q2(k+1)+q3(k+1))*cos(q1(k+1));
        yr(k+1)=l1*cos(q2(k+1))*sin(q1(k+1))+l2*cos(q2(k+1)+q3(k+1))*sin(q1(k+1));
        zr(k+1)=h+l1*sin(q2(k+1))+l2*sin(q2(k+1)+q3(k+1));
end


pasos=5;  fig=figure;
set(fig,'position',[10 60 980 600]);
axis square; cameratoolbar
grid on;
axis([-3 3 -3 3 0 1.5]); 

Arm_Parameters;

M1=Arm_Plot3D(0,0,0,0,0,q1(1),q2(1),q3(1),0);

for i=1:pasos:length(t)
    
    delete (M1)
    M1=Arm_Plot3D(0,0,0,0,0,q1(i),q2(i),q3(i),0);hold on;
    plot3(xr(1:i),yr(1:i),zr(1:i),'r','linewidth',3);
    pause(0.1)
    
end
% 
%% Graficas
figure('Name','Errores')
subplot(311)
plot(t,xre,'linewidth',2), grid on
legend('Error en x')
xlabel('Tiempo'), ylabel('Error  [m]')
subplot(312)
plot(t,yre,'g','linewidth',2), grid on
legend('Error en y')
xlabel('Tiempo'), ylabel('Error  [m]')
subplot(313)
plot(t,zre,'g','linewidth',2), grid on
legend('Error en z')
xlabel('Tiempo'), ylabel('Error  [m]')

figure('Name','Acciones de control')
subplot(311)
plot(t,q1p_ref,'linewidth',2), grid on
legend('Velocidad q1')
xlabel('Tiempo'), ylabel('Velocidad [rad/s]')
subplot(312)
plot(t,q2p_ref,'g','linewidth',2), grid on
legend('Velocidad q2')
xlabel('Tiempo'), ylabel('Velocidad  [rad/s]')
subplot(313)
plot(t,q3p_ref,'g','linewidth',2), grid on
legend('Velocidad q3')
xlabel('Tiempo'), ylabel('Velocidad  [rad/s]')


