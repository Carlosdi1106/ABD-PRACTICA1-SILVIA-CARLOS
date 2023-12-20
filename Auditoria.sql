--Pregunta 01. ¿Cuál es el resultado obtenido por la consulta anterior?


En MariaDB, la auditoría se puede habilitar utilizando el plugin de auditoría de MariaDB llamado `server_audit`. Aquí hay una guía básica para activar la auditoría en MariaDB:

1. **Verificar la existencia del plugin:**
   Asegúrate de que el plugin `server_audit` está instalado. Puedes verificar esto ejecutando el siguiente comando:

   ```sql
   SHOW PLUGINS;
   ```

   Busca una línea que contenga `server_audit`. Si no lo encuentras, es posible que necesites instalarlo.

2. **Instalar el plugin `server_audit`:**
   Si no encuentras el plugin, puedes instalarlo usando el siguiente comando:

   ```sql
   INSTALL SONAME 'server_audit';
   ```

3. **Configurar el plugin `server_audit`:**
   Después de instalar el plugin, debes configurarlo. Puedes hacer esto mediante la modificación del archivo de configuración de MariaDB (generalmente `my.cnf` o `my.ini`). Añade las siguientes líneas al archivo de configuración:

   ```ini
   [server]
   server_audit_logging=FORCE_PLUS_PERMANENT
   server_audit_events=CONNECT,QUERY,TABLE
   ```

   Estas líneas activarán la auditoría de eventos de conexión, consultas y cambios en las tablas. Puedes ajustar estas opciones según tus necesidades.

4. **Reiniciar el servidor MariaDB:**
   Después de realizar cambios en el archivo de configuración, reinicia el servidor MariaDB para aplicar los cambios.

5. **Consultar los registros de auditoría:**
   Puedes consultar los registros de auditoría ejecutando consultas en la tabla `server_audit_events`. Por ejemplo:

   ```sql
   SELECT * FROM mysql.server_audit_events;
   ```

   Esto te dará detalles sobre los eventos que se han auditado.

Ten en cuenta que la disponibilidad y la configuración exacta pueden variar según la versión específica de MariaDB que estés utilizando. Además, ten en cuenta que la auditoría puede generar registros significativos y puede afectar el rendimiento, por lo que debes configurarla cuidadosamente según tus necesidades y requisitos de seguridad.

--Pregunta 02. ¿Cuántas políticas de auditoría están definidas en el sistema? Indica las consultas utilizadas y los resultados obtenidos.




--Pregunta 03. ¿Cuántas políticas de auditoría están activas en el sistema? ¿Cuál es la configuración de dichas políticas de auditoría activas? Indica las consultas utilizadas y los resultados obtenidos.



--Pregunta 04. ¿Cuántos registros de auditoría existen en el sistema actualmente? Describe la información que almacena alguno de los más recientes. Indica las consultas utilizadas y los resultados obtenidos



--Pregunta 05. Después de ejecutar este código PL/SQL, ¿cuántos registros de auditoría existen ahora en el sistema? Indica las consultas utilizadas y los resultados obtenidos.



  --A continuación, vamos a provocar que se añada un nuevo registro de auditoría. Para esto, activa (si no lo está ya) la auditoría predefinida Logon Failures (es decir, ORA_LOGON_FAILURES) y, utilizando el usuario ABDxy, realiza un intento de inicio de sesión usando una contraseña incorrecta.




--Pregunta 06. ¿Cuántos registros de auditoría existen ahora en el sistema actualmente? ¿Se ha añadido algún nuevo registro? Si es así, ¿cuál? Indica las consultas utilizadas y los resultados obtenidos.



--Pregunta 07. ¿Cuántos registros de auditoría existen ahora en el sistema actualmente? ¿Se ha añadido algún nuevo registro? Si es así, ¿cuál(es)? Indica las consultas utilizadas y los resultados obtenidos

  

--Pregunta 08. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que utilizar para crear una nueva política de auditoría llamada CREATE_TABLE_PRIVxy y que sirva para registrar todo uso del privilegio de sistema CREATE TABLE.? Comprueba que la nueva política de auditoría se ha guardado y consulta su información en las tablas del diccionario de datos. Indica lasconsultas utilizadas y los resultados obtenidos

  

--Pregunta 09. ¿Cuáles son las opciones con las que se ha habilitado la política de auditoría? Indica las consultas utilizadas y los resultados obtenidos.




--Pregunta 10. ¿Cuántos registros de auditoría existen ahora en el sistema actualmente? ¿Se ha añadido algún nuevo registro? Si es así, ¿cuál(es)? Indica las consultas utilizadas y los resultados obtenidos.



--Pregunta 11. ¿Cuántos registros de auditoría existen ahora en el sistema actualmente? ¿Se ha añadido algún nuevo registro? Si es así, ¿cuál(es)? Indica las consultas utilizadas y los resultados obtenidos.



--Pregunta 12. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que utilizar para crear una nueva política de auditoría llamada SELECT_ACTIONxy y que sirva para registrar toda ejecución de la operación SELECT sobre la vista AUDVIEWxy.? Comprueba que la nueva política de auditoría se ha guardado y consulta su información en las tablas del diccionario de datos. Indica las consultas utilizadas y los resultados obtenidos



--Pregunta 13. ¿Cuáles son las opciones con las que se ha habilitado la política de auditoría? Indica las consultas utilizadas y los resultados obtenidos

  --SYS USER


--Pregunta 14. Con respecto a las siguientes operaciones, indica sucesivamente cuáles de ellas provocan que se cree un nuevo registro de auditoría con su ejecución y cuáles no. Indica todas lasconsultas utilizadas y los resultados obtenidos en cada una de ellas.



--Pregunta 15. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que utilizar para crear una nueva política de auditoría llamada UPDATE_PER_SESSIONxy y que sirva para registrar toda ejecución de la operación UPDATE sobre la tabla AUDTABLExy en sesiones iniciadas utilizando el usuario USERxy? Comprueba que la nueva política de auditoría se ha guardado y consulta su información en las tablas del diccionario de datos. Indica las consultas utilizadas y los resultados obtenidos.



--Pregunta 16. ¿Cuáles son las opciones con las que se ha habilitado la política de auditoría? Indica las consultas utilizadas y los resultados obtenidos.



--Pregunta 17. Con respecto a las siguientes operaciones (¡Importante! Fíjate bien la sesión desde la cual se ejecuta cada una), indica sucesivamente cuáles de ellas provocan que se cree un nuevo registro de auditoría con su ejecución y cuáles no. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas



--Pregunta 18. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que utilizar para crear una nueva política de auditoría llamada DELETE_PER_STATEMENTxy y que sirva para registrar toda ejecución de la operación DELETE sobre la tabla AUDTABLExy desde una sesión iniciada usando la aplicación SQL*Plus? Comprueba que la nueva política de auditoría se ha guardado y consulta su información en las tablas del diccionario de datos. Indica las consultas utilizadas y los resultados obtenidos.



--Pregunta 19. ¿Cuáles son las opciones con las que se ha habilitado la política de auditoría? Indica las consultas utilizadas y los resultados obtenidos.



--Pregunta 20. Ejecuta repetidamente la siguiente sentencia desde una sesión iniciada usando la aplicación SQL*Plus y también desde una sesión iniciada usando la aplicación SQL Developer, e indica sucesivamente cuáles de las sentencias provocan que se cree un nuevo registro de auditoría con su ejecución y cuáles no. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.




--Pregunta 21. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencias hay que ejecutar para deshabilitar las políticas de auditoría CREATE_TABLE_PRIVxy, SELECT_ACTIONxy, UPDATE_PER_SESSIONxy y DELETE_PER_STATEMENTxy? Deshabilita las políticas de auditoría anteriores y comprueba que ya no se están aplicando. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas



--Pregunta 22. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que ejecutar para habilitar la política de auditoría SELECT_ACTIONxy exclusivamente para el usuario USERxy? Habilita la política de auditoría como se describe en la pregunta y comprueba las características con las que se está aplicando. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.



--Pregunta 23. Con respecto a las siguientes operaciones (¡Importante! Fíjate bien la sesión desde la cual se ejecuta cada una), indica sucesivamente cuáles de ellas provocan que se cree un nuevo registro de auditoría con su ejecución y cuáles no. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.



--Pregunta 24. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que ejecutar para desactivar la política de auditoría habilitada en la Pregunta 22? Deshabilita la política de auditoría indicada en la pregunta y comprueba que ya no está activa. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.



--Pregunta 25. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que ejecutar para habilitar la política de auditoría SELECT_ACTIONxy para todos los usuarios excepto USERxy? Habilita la política de auditoría como se describe en la pregunta y comprueba las características con las que se está aplicando. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.



--Pregunta 26. Con respecto a las siguientes operaciones (¡Importante! Fíjate bien la sesión desde la cual se ejecuta cada una), indica sucesivamente cuáles de ellas provocan que se cree un nuevo registro de auditoría con su ejecución y cuáles no. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.



--Pregunta 27. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que ejecutar para habilitar la política de auditoría SELECT_ACTIONxy para todos los usuarios excepto USERxy y ABDxy, teniendo en cuenta que la política de auditoría ya se habilitó en la Pregunta 25? Habilita la política de auditoría como se describe en la pregunta y comprueba las características con las que se está aplicando. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.



--Pregunta 28. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que ejecutar para desactivar la política de auditoría habilitada en la Pregunta 27? Deshabilita la política de auditoría indicada en la pregunta y comprueba que ya no está activa. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas



--Pregunta 29. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que ejecutar para habilitar la política de auditoría CREATE_TABLE_PRIVxy exclusivamente para aquellas operaciones que terminan correctamente? Habilita la política de auditoría como se describe en la pregunta y comprueba las características con las que se está aplicando. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.




--Pregunta 30. Con respecto a las siguientes operaciones (¡Importante! Fíjate bien la sesión desde la cual se ejecuta cada una), indica sucesivamente cuáles de ellas provocan que se cree un nuevo registro de auditoría con su ejecución y cuáles no. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.



--Pregunta 31. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que ejecutar para desactivar la política de auditoría habilitada en la Pregunta 29? Deshabilita la política de auditoría indicada en la pregunta y comprueba que ya no está activa. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.




--Pregunta 32. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que ejecutar para habilitar la política de auditoría CREATE_TABLE_PRIVxy exclusivamente para aquellas operaciones que terminan en error? Habilita la política de auditoría como se describe en la pregunta y comprueba las características con las que se está aplicando. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas. 



--Pregunta 33. Con respecto a las siguientes operaciones (¡Importante! Fíjate bien la sesión desde la cual se ejecuta cada una), indica sucesivamente cuáles de ellas provocan que se cree un nuevo registro de auditoría con su ejecución y cuáles no. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas.




--Pregunta 34. Desde una sesión iniciada utilizando el usuario SYS, ¿qué sentencia hay que ejecutar para desactivar la política de auditoría habilitada en la Pregunta 32? Deshabilita la política de auditoría indicada en la pregunta y comprueba que ya no está activa. Indica todas las consultas utilizadas y los resultados obtenidos en cada una de ellas

