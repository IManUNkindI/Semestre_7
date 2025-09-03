clc
clear app
clear all
close all

% Condiciones iniciales del manipulador 
l1 = 0.5;
l2 = 0.65;
h = 0.25;

q1(1) =  0*(pi/180);             
q2(1) =  90*(pi/180);  
q3(1) =  30*(pi/180); 

% Crear la figura
fig = figure;
set(fig,'position',[10 60 980 600]);
axis square; 
cameratoolbar
grid on;
axis([-1.5 1.5 -1.5 1.5 0 1.5]); 

% Parámetros del brazo
Arm_Parameters;

% Dibujar el brazo en la posición inicial
M1 = Arm_Plot3D(0, 0, 0, 0, 0, q1(1), q2(1), q3(1), 0);
view(45,45)

% Configurar conexión con el Arduino
HOST = '192.168.215.251';  % Dirección IP del servidor
PORT = 65432;  % Puerto

% Crear objeto tcpclient
t = tcpclient(HOST, PORT);

% Conectar con el servidor
if ~isempty(t)
    disp('Conexión establecida con el servidor');
else
    error('No se pudo establecer la conexión con el servidor');
end

% Inicializar filtro de Kalman para cada eje
A = 1; H = 1; Q = 1; R = 1;
x_est = 0; P_est = 1;

Ay = 1; Hy = 1; Qy = 1; Ry = 1;
y_est = 0; Py_est = 1;

Az = 1; Hz = 1; Qz = 1; Rz = 1;
z_est = 0; Pz_est = 1;

num_datos = 30

% Vectores para almacenar datos originales y filtrados
original_data = zeros(num_datos, 1);
filtered_data = zeros(num_datos, 1);
original_datay = zeros(num_datos, 1);
filtered_datay = zeros(num_datos, 1);
original_dataz = zeros(num_datos, 1);
filtered_dataz = zeros(num_datos, 1);

for i = 1:num_datos
    % Leer datos del servidor
    data_str = readline(t);
    data_parts = strsplit(data_str, ',');
    vol_x = str2double(data_parts{1});
    vol_y = str2double(data_parts{2});
    vol_z = str2double(data_parts{3});
    
    % Calcular ángulos de los ejes X, Y y Z
    Vol_x = (((vol_x * 2.95) / 4095) - 1.30)-0.08;
    Vol_y = (vol_x * 2.95) / 1935;
    Vol_z = (0.0014416 * vol_y) - 2.95;
   
    
    % Corregir los ángulos según las condiciones
    if Vol_x < 0
        Vol_x = 0;
    end
    
    if Vol_y > 2.95
        Vol_y = 2.95;
    end
   


     % Mostrar ángulos
%     disp(['Voltajes- X: ', num2str(Vol_x), ', Y: ', num2str(Vol_y), ', Z: ', num2str(Vol_z)]);
    
    % Aplicar el filtro de Kalman a las medidas para cada eje
    
    % Paso de predicción
    x_pred = A * x_est;
    P_pred = A * P_est * A' + Q;

    % Paso de actualización
    K = P_pred * H' * inv(H * P_pred * H' + R);
    x_est = x_pred + K * (Vol_x - H * x_pred);
    P_est = (1 - K * H) * P_pred;

    original_data(i) = Vol_x;
    filtered_data(i) = x_est;
    anglex = 1.188 * x_est - 0.4547;
    
    % Aplicar filtro de Kalman a las medidas para el eje y
    % Paso de predicción
    y_pred = Ay * y_est;
    P_predy = Ay * Py_est * Ay' + Qy;

    % Paso de actualización
    Ky = P_predy * Hy' * inv(Hy * P_predy * Hy' + Ry);
    y_est = y_pred + Ky * (Vol_y - Hy * y_pred);
    Py_est = (1 - Ky * Hy) * P_predy;

    original_datay(i) = Vol_y;
    filtered_datay(i) = y_est;
    angley = 1.0577 * Vol_y - 0.1553;
    
    % Aplicar filtro de Kalman a las medidas para el eje z
    % Paso de predicción
    z_pred = Az * z_est;
    P_predz = Az * Pz_est * Az' + Qz;

    % Paso de actualización
    Kz = P_predz * Hz' * inv(Hz * P_predz * Hz' + Rz);
    z_est = z_pred + Kz * (Vol_z - Hz * z_pred);
    Pz_est = (1 - Kz * Hz) * P_predz;

    original_dataz(i) = Vol_z;
    filtered_dataz(i) = z_est;
    anglez = 1.0464 * Vol_z - 0.0235;
    % Inicializar vectores para almacenar ángulos
% angles_x = zeros(num_datos, 1);  % Vector columna para ángulos X
% angles_y = zeros(num_datos, 1);  % Vector columna para ángulos Y
% angles_z = zeros(num_datos, 1);  % Vector columna para ángulos Z
% dato_num = zeros(num_datos, 1);

    % Mover el brazo del robot con los ángulos calculados
    figure(fig);
    delete(M1);
    M1 = Arm_Plot3D(0, 0, 0, 0, 0, anglez, angley, anglex, 0);
    hold on;
 angles_x(i) = anglex;
    angles_y(i) = angley;
    angles_z(i) = anglez;
dato_num(i) = i;  % El número de dato es simplemente el índice actual (i)
end
% Graficar eje x
figure;
plot(dato_num, angles_x, 'o-');
xlabel('Datos');
ylabel('Ángulo para el eje x (Rad)');
title('Eje x');
grid on;
filename_x = 'angulo_eje_x.png';
saveas(gcf, filename_x);

% Graficar eje y
figure;
plot(dato_num, angles_y, 'o-');
xlabel('Datos');
ylabel('Ángulo para el eje y (Rad)');
title('Eje y');
grid on;
filename_y = 'angulo_eje_y.png';
saveas(gcf, filename_y);

% Graficar eje z
figure;
plot(dato_num, angles_z, 'o-');
xlabel('Datos');
ylabel('Ángulo para el eje z (Rad)');
title('Eje z');
grid on;
filename_z = 'angulo_eje_z.png';
saveas(gcf, filename_z);




close(t);
disp('Conexión cerrada');