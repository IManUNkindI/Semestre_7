import serial
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# Configurar el puerto serial
ser = serial.Serial('COM6', 9600, timeout=1)

# Inicializar las listas para almacenar los valores de voltaje
voltajes_serial = []
voltajes_i2c = []
voltajes_spi = []

# Función de actualización que se ejecutará cada segundo
def update(frame):
    # Leer la línea recibida por el puerto serial
    line = ser.readline().decode('utf-8').strip()

    # Verificar el tipo de comunicación y actualizar la lista correspondiente
    if "Voltaje recibido por Serial:" in line:
        voltaje_serial = float(line.split(":")[1].strip())
        voltajes_serial.append(voltaje_serial)

    elif "Voltaje recibido por I2C:" in line:
        voltaje_i2c = float(line.split(":")[1].strip())
        voltajes_i2c.append(voltaje_i2c)

    elif "Voltaje recibido por SPI:" in line:
        voltaje_spi = float(line.split(":")[1].strip())
        voltajes_spi.append(voltaje_spi)

    # Actualizar las gráficas
    ax1.clear()
    ax1.plot(voltajes_serial, label='Serial')
    ax1.legend()

    ax2.clear()
    ax2.plot(voltajes_i2c, label='I2C')
    ax2.legend()

    ax3.clear()
    ax3.plot(voltajes_spi, label='SPI')
    ax3.legend()

# Configurar la figura y los subgráficos
fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(10, 8))

# Configurar el título y etiquetas de los ejes
ax1.set_title('Comunicación Serial')
ax1.set_ylabel('Voltaje (V)')

ax2.set_title('I2C')
ax2.set_ylabel('Voltaje (V)')

ax3.set_title('SPI')
ax3.set_xlabel('Datos recibidos (#)')
ax3.set_ylabel('Voltaje (V)')

# Configurar la animación para ejecutarse cada segundo
ani = FuncAnimation(fig, update, interval=100, cache_frame_data=False)

# Mostrar la ventana de la interfaz
plt.show()

# Cerrar el puerto serial al cerrar la interfaz
ser.close()
