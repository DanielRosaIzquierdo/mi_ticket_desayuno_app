# Mi Ticket Desayuno

Cómo usar la aplicación:

# Manual de Administrador

## Dashboard del Establecimiento

Se compone de 3 pantallas principales indicadas en la barra de navegación inferior, y en la parte superior derecha un botón de logout para cerrar sesión.

---

### Descuentos

En esta pantalla se muestran los descuentos activos del establecimiento.  
Se pueden borrar pulsando el botón del contenedor, y se pedirá confirmación.

Además, esta pantalla cuenta con un **pull to refresh** para traer los datos actualizados en cualquier momento.

También se puede añadir un nuevo descuento pulsando el botón **“Nuevo descuento”**, que redirige al formulario.  
El primer elemento es un desplegable para seleccionar el tipo de descuento (**por gasto**, **por compra**).

![image](https://github.com/user-attachments/assets/a4eee79f-c453-483b-a1e3-50c007322830)


---

### Compras

Esta pantalla muestra el histórico de todas las compras realizadas.  

- Todas las compras se pueden borrar con el icono del contenedor en la parte superior derecha. Esto es útil si se quieren incluir nuevos descuentos en la app, para que los usuarios empiecen desde cero su progreso.  
- Para borrarlas, se pide confirmación.

Para añadir una compra:
1. Pulsar el botón en la parte inferior derecha → redirige a la pantalla “Nueva compra”.
2. En esa pantalla se pueden seleccionar los productos ofrecidos por la cafetería.
3. El precio se actualiza automáticamente en la parte inferior.
4. Si no hay productos seleccionados, el botón para escanear QR estará deshabilitado.
5. Una vez seleccionados los productos y escaneado el QR, la app solicitará permisos para acceder a la cámara. Si se conceden, esta se abrirá.

![image](https://github.com/user-attachments/assets/ec07a2e3-1631-46e1-a87d-aa5c0b869225)


Cuando se escanea el QR, se pasa al **resumen de compra**, en el cual aparecen:
- Los datos del usuario,
- Los productos seleccionados,
- El descuento si el usuario ha decidido aplicarlo.



---

### Estadísticas

Esta pantalla cuenta con dos secciones:
- Usuarios que más han gastado (basado en el histórico de compras actual).
- Usuarios que más han visitado la tienda.

Cuenta con **pull to refresh** para actualizar los datos.

![image](https://github.com/user-attachments/assets/05ae2397-1ed2-4538-88c9-90a58819c248)


---

# Manual de Usuario

---

## Login y Registro

Los siguientes formularios controlan la autenticación de la aplicación.  
La sesión se guarda por seguridad solo durante **7 días**, después será necesario volver a autenticarse.

Ambos formularios cuentan con:
- Validación de email.
- Contraseña con un mínimo de **6 dígitos**.

En el caso de la pantalla de registro, esta redirige directamente al **dashboard** una vez el registro es exitoso.

![image](https://github.com/user-attachments/assets/590e1d93-c8da-47d0-9238-1d2f58c8c60c)


---

## Dashboard de Cliente y Código QR

Esta pantalla muestra los **descuentos disponibles** del cliente.  
Si ya ha usado algún descuento, **no se mostrará más** porque no puede volver a canjearlo.

Funciones destacadas:

- Los descuentos se pueden filtrar en base al **tipo de descuento**.
- Cuando el cliente completa el progreso de un descuento, este se **marca en verde** y puede ser **seleccionado**.
- Cuando está seleccionado aparece un **check azul** arriba a la derecha del descuento.
- Si está seleccionado y se pulsa el botón para mostrar QR, el **QR incluirá el descuento**.
- Mientras se muestre el QR, el **brillo de la pantalla subirá al máximo** para facilitar el escaneo.
- **Solo se puede seleccionar un descuento por compra**.
- Esta pantalla dispone de **pull to refresh** para traer los descuentos actualizados.

### Información de cada descuento:

- **Tipo de descuento** (arriba a la izquierda): puede ser por gasto o por número de compras.
- **Descuento** (arriba a la derecha): valor que se aplicará a la compra.
- **Condiciones del descuento** (centro).
- **Progreso del usuario** (abajo).

![image](https://github.com/user-attachments/assets/8d5e03cb-b29e-4405-9f11-a1b92691f844)


