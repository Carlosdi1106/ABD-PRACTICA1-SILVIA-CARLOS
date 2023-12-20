-- MySQL
-- Control de acceso

--	CARLOS DIEZ Y SILVIA LEON

-- Configuración de la base de datos.

SYS > SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+

SYS > CREATE DATABASE ABD;
SYS > SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| abd                |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
SYS > USE ABD;

--Pregunta 01. ¿Cuántos tablespaces existen inicialmente? ¿Cuáles son sus nombres?
/*
MariaDB no tiene la misma estructura que oracle, no tiene tablespaces, en cambio la información de los tablespaces se puede encontrar en las bases de datos que tiene por defecto, en information_schema se encuentra información equivalente al tablespace SYSTEM, SYSAUX, y en la bd de mysql está la equivalente a USERS.
*/


select * from information_schema.tables where table_schema='ABD';
select * from information_schema.tables;
select * from information_schema.tables WHERE TABLE_NAME="TABLESPACES";

--SYSTEM
SELECT TABLE_SCHEMA, TABLE_NAME, DATA_LENGTH, INDEX_LENGTH
FROM information_schema.tables
WHERE TABLE_SCHEMA = 'mysql'; 
--SYSAUX
SELECT TABLE_SCHEMA, TABLE_NAME, DATA_LENGTH, INDEX_LENGTH
FROM information_schema.tables
WHERE TABLE_SCHEMA != 'mysql';
--UNDOTBS1
SHOW VARIABLES LIKE 'innodb_undo%';



--Pregunta 02. ¿Cuántos usuarios existen inicialmente en todo el sistema? ¿Cuáles son sus nombres?

SYS > SELECT User, Host FROM mysql.user;
/*
+-------------+--------------+
| User        | Host         |
+-------------+--------------+
| root        | 127.0.0.1    |
| root        | ::1          |
| root        | carlosdi1106 |
| mariadb.sys | localhost    |
| root        | localhost    |
+-------------+--------------+
*/

SYS > CREATE USER 'ABD0712'@'localhost' IDENTIFIED BY 'abd0712';


--Pregunta 03. ¿Es posible iniciar una nueva sesión utilizando el usuario ABDxy? ¿Qué sucede?
SYS > mysql -u ABD0712 -p
/*
Si se puede conectar al servidor pero no se puede acceder a la base de datos ABD, por no tener ningun permiso.
*/  
SYS > GRANT SELECT ON abd.* TO 'ABD0712'@'localhost';
SYS > FLUSH PRIVILEGES; --actualizar permisos

SYS > CREATE USER 'DUMMY0712'@'localhost' IDENTIFIED BY 'dummy0712';
SYS > ALTER USER 'DUMMY0712'@'localhost' IDENTIFIED BY 'abd0712';

SYS > mysql -u DUMMY0712 -p--Conectamos con Dummy
  
SYS > DROP USER 'DUMMY0712'@'localhost';

--Pregunta 04. ¿Es posible eliminar directamente el usuario DUMMYxy.
/*
Se borra aunque se tenga el usuario conectado
Si el usuario intenta connectarse:
ERROR 1045 (28000): Access denied for user 'DUMMY0712'@'localhost' (using password: YES)
*/
--Ya esta borrado
SYS > SELECT User, Host FROM mysql.user;
/*
+-------------+--------------+
| User        | Host         |
+-------------+--------------+
| ABD0712     | %            |
| root        | 127.0.0.1    |
| root        | ::1          |
| root        | carlosdi1106 |
| ABD0712     | localhost    |
| mariadb.sys | localhost    |
| root        | localhost    |
+-------------+--------------+
*/

--Pregunta 05. ¿Qué consulta al diccionario de datos hay que ejecutar para comprobar los privilegios concedidos? Indica la consulta y el resultado obtenido.
SYS > SHOW GRANTS FOR 'ABD0712'@'localhost';
/*
+----------------------------------------------------------------------------------------------------------------+
| Grants for ABD0712@localhost                                                                                   |
+----------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ABD0712`@`localhost` IDENTIFIED BY PASSWORD '*' |
| GRANT SELECT ON `abd`.* TO `ABD0712`@`localhost`                                                               |
+----------------------------------------------------------------------------------------------------------------+
*/
SYS > SHOW GRANTS;
/*
GRANT ALL PRIVILEGES ON *.* TO `root`@`localhost` IDENTIFIED BY PASSWORD '*4ACFE3202A5FF5CF467898FC58AAB1D615029441' WITH GRANT OPTION 
GRANT PROXY ON ''@'%' TO 'root'@'localhost' WITH GRANT OPTION                                    
*/
SYS > GRANT CREATE ON ABD.COURSES TO 'ABD0712'@'localhost';---- no existe la opción de create table, en cambio se puede especificar sobre que base de datos y que tabla. Esta tabla puede ser una tabla que todavía no exista.
SYS > FLUSH PRIVILEGES;
 -- al haber varias bases de datos, al contrario que en oracle, hay que especificar en que bd.
ABD0712 > CREATE TABLE COURSES (CODE INT PRIMARY KEY, NAME VARCHAR(20)); -- en vez de number -> INT
--Pregunta 06. ¿Qué consulta al diccionario de datos hay que ejecutar para comprobar los privilegios concedidos? Indica la consulta y el resultado obtenido.
SYS > SHOW GRANTS FOR 'ABD0712'@'localhost';
/*
+----------------------------------------------------------------------------------------------------------------+
| Grants for ABD0712@localhost                                                                                   |
+----------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ABD0712`@`localhost` IDENTIFIED BY PASSWORD '*' |
| GRANT SELECT, CREATE ON `abd`.* TO `ABD0712`@`localhost`                                                       |
+----------------------------------------------------------------------------------------------------------------+
*/

SYS > CREATE USER 'USER0712'@'localhost' IDENTIFIED BY 'user0712';
SYS > GRANT CREATE ON ABD.AUXCOURSES1 TO 'USER0712'@'localhost';
SYS > FLUSH PRIVILEGES;
USER0712 > CREATE TABLE ABD.AUXCOURSES1 (CODE INT, NAME VARCHAR(20));
USER0712 > CREATE TABLE ABD.AUXCOURSES2 (CODE INT, NAME VARCHAR(20)); --no permite crearlo (correcto)
--Pregunta 07. ¿Qué consulta al diccionario de datos hay que ejecutar para comprobar los privilegios concedidos? Indica la consulta y el resultado obtenido.
SYS > SHOW GRANTS FOR 'USER0712'@'localhost';
+-----------------------------------------------------------------------------------------------------------------+
| Grants for USER0712@localhost                                                                                   |
+-----------------------------------------------------------------------------------------------------------------+
| GRANT CREATE ON `abd`.`auxcourses1` TO `USER0712`@`localhost`                                                   |
+-----------------------------------------------------------------------------------------------------------------+
--Pregunta 08. ¿Qué sucede?
-- no existe quotas, para poder insertar una tupla hay q concederle el privilegio (aunq haya creado el la tabla)
SYS >  GRANT INSERT ON ABD.COURSES TO 'ABD0712'@'localhost';
SYS > FLUSH PRIVILEGES;
ABD0712 > INSERT INTO ABD.COURSES VALUES(1,'ABD');

--Pregunta 09. ¿Qué consulta al diccionario de datos hay que ejecutar para comprobar los cambios realizados? Indica la consulta y el resultado obtenido.
SYS > SHOW GRANTS FOR 'ABD0712'@'localhost';
/*
+----------------------------------------------------------------------------------------------------------------+
| Grants for ABD0712@localhost                                                                                   |
+----------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `ABD0712`@`localhost` IDENTIFIED BY PASSWORD '*' |
| GRANT SELECT ON `abd`.* TO `ABD0712`@`localhost`                                                               |
| GRANT INSERT, CREATE ON `abd`.`courses` TO `ABD0712`@`localhost`                                               |
+----------------------------------------------------------------------------------------------------------------+
*/
SYS > revoke SELECT on ABD.* from 'ABD0712'@'localhost';
SYS > SHOW GRANTS FOR 'ABD0712'@'localhost';
/*
ERROR 1142 (42000): INSERT command denied to user 'AUX0712'@'localhost' for table `abd`.`courses`
*/
/*
+----------------------------------------------------------------------------------------------------------------+
| Grants for ABD0712@localhost                                                                                   |
+----------------------------------------------------------------------------------------------------------------+
| GRANT INSERT, CREATE ON `abd`.`courses` TO `ABD0712`@`localhost`                                               |
+----------------------------------------------------------------------------------------------------------------+
*/

--Pregunta 10. ¿Qué consulta al diccionario de datos hay que ejecutar para comprobar los privilegios concedidos? Indica la consulta y el resultado obtenido.



--Pregunta 11. ¿Es posible conceder los privilegios de lectura (READ o SELECT) a nivel de columna? Inténtalo y describe lo que sucede.
 SYS >  GRANT INSERT ON ABD.COURSES TO 'ABD0712'@'localhost' WITH GRANT OPTION;

ABD0712 >  GRANT INSERT ON ABD.COURSES TO 'USER0712'@'localhost';
USER0712 > INSERT INTO ABD.COURSES VALUES (2,'DBA');

SYS >  GRANT SELECT ON ABD.COURSES TO 'ABD0712'@'localhost' WITH GRANT OPTION;


ABD0712 >  GRANT SELECT(CODE) ON COURSES TO 'USER0712'@'localhost';

--Pregunta 12. ¿Qué consultas al diccionario de datos hay que ejecutar para comprobar los privilegios concedidos? Indica las consultas y los resultados obtenidos.
-- Consulta para verificar los privilegios SELECT en la tabla



--Pregunta 13. El usuario USERxy ha recibido dicho privilegio en el paso anterior (Paso 3.4), pero ¿puede concedérselo al usuario AUXxy? ¿Qué sucede al intentarlo y por qué?



--Pregunta 14. ¿Qué consultas al diccionario de datos hay que ejecutar para comprobar los privilegios concedidos? Indica las consultas y los resultados obtenidos.

SYS > CREATE USER 'AUX0712'@'localhost' IDENTIFIED BY 'aux0712';
ABD0712 >  GRANT INSERT ON ABD.COURSES TO 'AUX0712'@'localhost';
AUX0712 > INSERT INTO ABD.COURSES VALUES (2,'DBA');
ABD0712 > revoke insert on ABD.COURSES FROM 'AUX0712'@'localhost';
AUX0712 > INSERT INTO ABD.COURSES VALUES (6,'DBA');
/*
+----------------------------------------------------------------------------------------------------------------+
| Grants for AUX0712@localhost                                                                                   |
+----------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `AUX0712`@`localhost` IDENTIFIED BY PASSWORD '*' |07573C29B19BEC929B6B8FD906CABBDFBBA7DA32
+----------------------------------------------------------------------------------------------------------------+
*/
--Pregunta 15. ¿Puede ahora consultar el usuario AUXxy la tabla "ABDxy".COURSES? ¿Por qué?



--Pregunta 16. ¿Qué privilegios tienen ahora los usuarios USERxy y AUXxy?

--
--Pregunta 17. ¿Cuántos roles existen inicialmente? ¿Cuáles son sus nombres?
SYS > SELECT * FROM mysql.user WHERE CONVERT(is_role USING utf8mb4) = 'Y';
/*
Empty set (0.001 sec)
*/
  --Desde una sesión iniciada utilizando el usuario SYS, crea un nuevo rol de nombre ROLExy y concédeselo al usuario AUXxy.
SYS > CREATE ROLE ROLE0712;
SYS >  GRANT ROLE0712 TO 'AUX0712'@'localhost';
AUX0712 > SET ROLE ROLE0712;
AUX0712 > SELECT CURRENT_ROLE;
/*
+--------------+
| CURRENT_ROLE |
+--------------+
| ROLE0712     |
+--------------+
*/
SYS > SELECT USER FROM mysql.user WHERE CONVERT(is_role USING utf8mb4) = 'Y';
/*
+----------+
| User     |
+----------+
| ROLE0712 |
+----------+
*/

--Pregunta 18. ¿Qué consultas al diccionario de datos hay que ejecutar para comprobar los cambios realizados? Indica las consultas y los resultados obtenidos.

  --A continuación, desde la sesión iniciada por el usuario SYS intenta conceder al role ROLExy el privilegio SELECT sobre la tabla "ABDxy".COURSES
SYS > GRANT SELECT ON ABD.COURSES TO ROLE0712;

--Pregunta 19. ¿Qué consultas al diccionario de datos hay que ejecutar para comprobar los privilegios concedidos? Indica las consultas y los resultados obtenido.

--Pregunta 20. ¿Puede el usuario AUXxy consultar la tabla "ABDxy".COURSES?

  --Prueba a ejecutar una de las sentencias

--Pregunta 21. ¿Cuántos perfiles existen inicialmente? ¿Cuáles son sus nombres?

--Pregunta 22. ¿Qué consulta al diccionario de datos hay que ejecutar para comprobar el perfil asignado al usuario ABDxy? Indica la consulta y el resultado obtenido.


--Pregunta 23. ¿Qué consulta al diccionario de datos hay que ejecutar para comprobar los valores establecidos para el perfil DEFAULT? Indica la consulta y el resultado obtenido.

  --A continuación, comprueba que el usuario ABDxy puede mantener 2 o más sesiones abiertas al mismo tiempo. 

  --Crea un nuevo perfil de nombre PROFILExy y que tan solo permita mantener 1 sesión abierta a sus usuarios. Asigna el nuevo perfil al usuario ABDxy.

--Pregunta 24. ¿Qué consultas al diccionario de datos hay que ejecutar para comprobar los cambios realizados? Indica las consultas y los resultados obtenidos.
