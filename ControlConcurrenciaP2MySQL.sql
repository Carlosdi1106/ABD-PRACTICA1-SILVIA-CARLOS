-- Pregunta 01. Inicia sesión con los 3 usuarios arriba indicados de la forma descrita y obtén el identificador de sesión para cada una de las sesiones abiertas. Hazlo también cada vez que se reinicie alguna de las sesiones.

  SYS > CREATE USER 'USERA0712'@'localhost' IDENTIFIED BY 'usera0712';
  SYS > CREATE USER 'USERB0712'@'localhost' IDENTIFIED BY 'userb0712';
  .\mysql -u USERA0712 -p
  .\mysql -u USERB0712 -p
SELECT USER, ID FROM information_schema.processlist WHERE USER IS NOT NULL;
/*
+-----------+----+
| USER      | ID |
+-----------+----+
| USERB0712 |  8 |
| USERA0712 |  6 |
| root      |  3 |
+-----------+----+
3 rows in set (0.050 sec)
*/

-- Obtener información sobre bloqueos activos
SHOW ENGINE INNODB STATUS;
-- Obtener información sobre transacciones en curso
SELECT * FROM information_schema.innodb_trx;
-- Obtener información sobre bloqueos de filas
SELECT * FROM information_schema.innodb_locks;
-- Obtener información sobre bloqueos de transacciones
SELECT * FROM information_schema.innodb_lock_waits;


SYS > GRANT CREATE, INSERT ON ABD.CCTEST TO 'USERA0712'@'localhost';

USERA0712 > CREATE TABLE ABD.CCTEST (X INT PRIMARY KEY, Y INT);
USERA0712 > INSERT INTO ABD.CCTEST VALU1111ES(1,10);
USERA0712 > INSERT INTO ABD.CCTEST VALUES(2,20);

GRANT SELECT, INSERT ON ABD.CCTEST TO 'USERB0712'@'localhost';

-- Pregunta 02. ¿Existe ahora alguna reserva activa del usuario USERA07? Indica las reservas existentes y su tipo.

SELECT @@autocommit;
SET autocommit = 1;  -- para habilitar
SET autocommit = 0;  -- para deshabilitar


-- Configurar el tiempo de espera para bloqueos en InnoDB (en segundos)
SET innodb_lock_wait_timeout = 60;


-- Iniciar una transacción
START TRANSACTION;

-- Bloquear toda la tabla para realizar operaciones de actualización
LOCK TABLES mi_tabla WRITE;

-- Realizar operaciones de actualización o inserción en mi_tabla

-- Desbloquear la tabla
UNLOCK TABLES;

-- Confirmar la transacción si es necesario
COMMIT;

-- Pregunta 03. ¿Y ahora existe alguna reserva activa del usuario USERA07? Indica las reservas existentes y su tipo.

SET GLOBAL innodb_lock_wait_timeout = 31536000;  -- 1 año
SET GLOBAL innodb_lock_wait_timeout = 50;

-- Pregunta 04. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes y su tipo
LOCK TABLES CCTEST READ; 
-- Pregunta 05. ¿Existe ahora alguna reserva activa del usuario USERA07? ¿Qué ha pasado? Indica las reservas existentes y su tipo.

-- Pregunta 06. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes y su tipo.

-- Pregunta 07. Consulta el valor actual de las tuplas en la tabla CCTEST: desde las sesiones de los usuarios USERA07 y USERB07. ¿Qué está sucediendo?

-- Pregunta 08. ¿Qué sucede? Justifica tu respuesta utilizando la información sobre reservas realizadas por el usuario USERA07.

-- Pregunta 09. ¿Qué sucede ahora con la actualización del usuario USERB07? ¿Cuáles son los valores actuales de la tabla desde las sesiones de los usuarios USERA07 y USERB07?


-- Pregunta 10. ¿Existe alguna reserva activa? Indica las reservas existentes y su tipo. ¿Qué hay que realizar para liberar dichas reservas activas?


-- Pregunta 11. ¿Cuál es la sesión bloqueada y cuál es la sesión que está bloqueando? Indica las consultas utilizadas y el resultado obtenido

SELECT ID AS SID, USER AS USERNAME, blocking_pid AS BLOCKING_SESSION
FROM information_schema.processlist
WHERE USER IS NOT NULL AND blocking_pid IS NOT NULL;


-- Pregunta 12. ¿Qué hay que hacer para liberar todas las reservas activas? Libera todas las reservas activas.


-- Pregunta 13. ¿Qué ha sucedido? ¿Cuáles son las reservas activas? Indica las reservas existentes y su tipo. ¿Qué hay que realizar para liberar dichas reservas activas? Libera todas las reservas activas.


-- Pregunta 14. ¿Hay alguna diferencia con las reservas que se realizaban en los pasos anteriores (Pasos 2.1, 2.2, 2.3 y 2.4)?


-- Pregunta 15. ¿Se puede consultar la tabla CCTEST desde la sesión del usuario USERB07? ¿Qué valores se obtienen?


-- Pregunta 16. ¿Es posible realizar las actualizaciones anteriores? ¿Cuáles son las reservas activas? ¿Qué hay que hacer para liberar dichas reservas? Libera todas las reservas activas.


-- Pregunta 17. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes junto con su su tipo y compara la información obtenida en esta ocasión con la información que se obtenía en los pasos anteriores (Pasos 2.1, 2.2, 2.3, 2.4 y 2.5).


-- Pregunta 18. ¿Se puede consultar la tabla CCTEST desde la sesión del usuario USERB07? ¿Qué valores se obtienen?



-- Pregunta 19. ¿Es posible realizar las actualizaciones anteriores? ¿Cuáles son las reservas activas? ¿Qué hay que hacer para liberar dichas reservas? Libera todas las reservas activas.



-- Pregunta 20. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes junto con su su tipo y compara la información obtenida en esta ocasión con la información que se obtenía en los pasos anteriores (Pasos 2.1, 2.2, 2.3, 2.4, 2.5 y 3.1).


-- Pregunta 21. ¿Existe ahora alguna reserva activa del usuario USERA07? Indica las reservas existentes junto con su su tipo y compara la información obtenida en esta ocasión con la información que se obtenía en los pasos anteriores (Pasos 2.1, 2.2, 2.3, 2.4, 2.5 y 3.1).


-- Pregunta 22. ¿Se puede consultar la tabla CCTEST desde la sesión del usuario USERB07? ¿Qué valores se obtienen?


-- Pregunta 23. ¿Es posible realizar las actualizaciones anteriores? ¿Cuáles son las reservas activas? ¿Qué hay que hacer para liberar dichas reservas? Libera todas las reservas activas.


-- Pregunta 24. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes junto con su su tipo y compara la información obtenida en esta ocasión con la información que se obtenía en los pasos anteriores (Pasos 2.1, 2.2, 2.3, 2.4, 2.5, 3.1 y 3.2)


-- Pregunta 25. ¿Se puede consultar la tabla CCTEST desde la sesión del usuario USERB07? ¿Qué valores se obtienen?


-- Pregunta 26. ¿Es posible realizar las actualizaciones anteriores? ¿Cuáles son las reservas activas? ¿Qué hay que hacer para liberar dichas reservas? Libera todas las reservas activas.


-- Pregunta 27. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6 y 8) y razona/justifica por qué se obtienen dichos resultados.

--USERA07
SET TRANSACTION READ ONLY;
SELECT * FROM CCTEST;  -- <- 2
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
| 204 |   20 |
+-----+------+
*/
--USERB07
INSERT INTO ABD.CCTEST VALUES (9,30);
--USERA07
SELECT * FROM CCTEST; -- <- 4
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
| 204 |   20 |
+-----+------+
12 rows in set (0.000 sec)
*/
--USERB07
COMMIT;
--USERA07
SELECT * FROM CCTEST; -- <- 6
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
| 204 |   20 |
+-----+------+
*/
COMMIT;
SELECT * FROM CCTEST; -- <- 8
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
| 204 |   20 |
+-----+------+
13 rows in set (0.000 sec)
*/
-- READ ONLY se comporta igual que ORACLE

-- Pregunta 28. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 9, 11, 13, 14, 17, 19, 20, 22 y 23) y razona/justifica por qué se obtienen dichos resultados.

--USERA07
SET TRANSACTION READ WRITE; -- <- 1
SELECT * FROM CCTEST; -- <- 2
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
| 204 |   20 |
+-----+------+
13 rows in set (0.000 sec)
*/
--USERB07
SET TRANSACTION READ WRITE; -- <- 3
SELECT * FROM ABD.CCTEST; -- <- 4
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
| 204 |   20 |
+-----+------+
13 rows in set (0.000 sec)
*/
--USERA07
INSERT INTO CCTEST VALUES (40,40); -- <- 5
SELECT * FROM CCTEST; -- <- 6
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
| 204 |   20 |
+-----+------+
14 rows in set (0.000 sec)
*/
--USERB07
INSERT INTO ABD.CCTEST VALUES (50,50); -- <- 7
SELECT * FROM ABD.CCTEST; -- <- 8
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  50 |   50 |
| 204 |   20 |
+-----+------+
14 rows in set (0.000 sec)
*/
--USERA07
SELECT * FROM CCTEST; -- <- 9
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
| 204 |   20 |
+-----+------+
14 rows in set (0.000 sec)
*/
COMMIT; -- <- 10
SELECT * FROM CCTEST; -- <- 11
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
| 204 |   20 |
+-----+------+
14 rows in set (0.000 sec)
*/
INSERT INTO CCTEST VALUES (60,60); -- <- 12
SELECT * FROM CCTEST; -- <- 13
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  60 |   60 |
| 204 |   20 |
+-----+------+
15 rows in set (0.000 sec)
*/
--USERB07
SELECT * FROM ABD.CCTEST; -- <- 14
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  50 |   50 |
| 204 |   20 |
+-----+------+
14 rows in set (0.000 sec)
*/
COMMIT; -- <- 15
--USERA07
COMMIT; -- <- 16
--USERB07
SELECT * FROM ABD.CCTEST; -- <- 17
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
| 204 |   20 |
+-----+------+
16 rows in set (0.000 sec)
*/
INSERT INTO ABD.CCTEST VALUES (70,70); -- <- 18
--USERA07	
SELECT * FROM CCTEST; -- <- 19
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
| 204 |   20 |
+-----+------+
*/
--USERB07
SELECT * FROM ABD.CCTEST; -- <- 20
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
COMMIT; -- <- 21
--USERA07	
SELECT * FROM CCTEST; -- <- 22
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
| 204 |   20 |
+-----+------+
16 rows in set (0.000 sec)
*/
--USERB07
SELECT * FROM ABD.CCTEST; -- <- 23
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/

-- HASTA QUE LAS DOS TRANSACCIONES NO HAGAN COMMIT, NO APARECERAN LOS ELEMENTOS.

-- Pregunta 29. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 10, 12, 14 y 15) y razona/justifica por qué se obtienen dichos resultados. ¿Se ha producido el problema de lecturas no-repetibles? De ser así, indica en qué pasos.

--USERA07
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 1
SELECT * FROM CCTEST; -- <- 2
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERB07
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 3
SELECT * FROM ABD.CCTEST; -- <- 4
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERA07
UPDATE CCTEST SET Y = Y*10 WHERE X = 1; -- <- 5
SELECT * FROM CCTEST; -- <- 6
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERB07
UPDATE ABD.CCTEST SET Y = Y*20 WHERE X = 2; -- <- 7
SELECT * FROM ABD.CCTEST; -- <- 8
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |   10 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERA07
COMMIT; -- <- 9
--USERB07	
SELECT * FROM ABD.CCTEST; -- <- 10
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERA07
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 11
SELECT * FROM CCTEST; -- <- 12
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |   20 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERB07
COMMIT; -- <- 13
--USERA07
SELECT * FROM CCTEST; -- <- 14
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERB07
SELECT * FROM ABD.CCTEST; -- <- 15
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERA07
COMMIT; -- <- 16

-- Pregunta 30. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 10, 12, 14 y 16) y razona/justifica por qué se obtienen dichos resultados. ¿Se ha producido el problema de lecturas fantasmas? De ser así, indica en qué pasos.

--USERA07
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 1
SELECT * FROM CCTEST; -- <- 2
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERB07
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 3
SELECT * FROM ABD.CCTEST; -- <- 4
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
| 204 |   20 |
+-----+------+
17 rows in set (0.000 sec)
*/
--USERA07
INSERT INTO CCTEST VALUES (80,80); -- <- 5
SELECT * FROM CCTEST; -- <- 6
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
|  80 |   80 |
| 204 |   20 |
+-----+------+
18 rows in set (0.000 sec)
*/
--USERB07
INSERT INTO ABD.CCTEST VALUES (90,90); -- <- 7
SELECT * FROM ABD.CCTEST; -- <- 8
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
|  90 |   90 |
| 204 |   20 |
+-----+------+
18 rows in set (0.000 sec)
*/
--USERA07
COMMIT; -- <- 9
--USERB07
SELECT * FROM ABD.CCTEST; -- <- 10
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
|  80 |   80 |
|  90 |   90 |
| 204 |   20 |
+-----+------+
19 rows in set (0.000 sec)
*/
--Lectura fantasma 8 80
--USERA07
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 11
SELECT * FROM CCTEST; -- <- 12
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
|  80 |   80 |
| 204 |   20 |
+-----+------+
18 rows in set (0.000 sec)
*/
--USERB07
COMMIT; -- <- 13
--USERA07
SELECT * FROM CCTEST; -- <- 14
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
|  80 |   80 |
|  90 |   90 |
| 204 |   20 |
+-----+------+
19 rows in set (0.000 sec)
*/
--Lectura fantasma 
--USERB07
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 15
SELECT * FROM ABD.CCTEST; -- <- 16
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
|  80 |   80 |
|  90 |   90 |
| 204 |   20 |
+-----+------+
19 rows in set (0.000 sec)
*/
--USERA07
COMMIT; -- <- 17
--USERB07
COMMIT; -- <- 18

-- Pregunta 31. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 10, 12, 14, 15 y 17) y razona/justifica por qué se obtienen dichos resultados. ¿Se han ejecutado las dos transacciones completa y correctamente? ¿Se ha producido algún problema debido a la ejecución concurrente de las transacciones?

--USERA07
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 1
SELECT * FROM CCTEST; -- <- 2
/*
+---+------+
| X | Y    |
+---+------+
| 1 |    4 |
| 2 |   10 |
| 3 |   30 |
| 5 |   50 |
| 6 |   60 |
+---+------+
5 rows in set (0.000 sec)
*/
--USERB07
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 3
SELECT * FROM ABD.CCTEST; -- <- 4
/*
+---+------+
| X | Y    |
+---+------+
| 1 |    4 |
| 2 |   10 |
| 3 |   30 |
| 5 |   50 |
| 6 |   60 |
+---+------+
5 rows in set (0.000 sec)
*/
--USERA07
UPDATE CCTEST SET Y = Y/10 WHERE X = 1; -- <- 5
-----BLOQUEOOOO-------------------------------------------------------------------------------------
SELECT * FROM CCTEST; -- <- 6
/*
  3	30
  5	50
  7	70
  8	80
  1	90
  2	400
  9	90
  4	40
  6	60
*/
--USERB07
UPDATE "USERA07".CCTEST SET X = X*100 WHERE X = 1; -- <- 7
-- No se ha podido ejecutar, problema de concurrencia
SELECT * FROM "USERA07".CCTEST; -- <- 8
/*
  3	30
  5	50
  7	70
  8	80
  1	900
  2	400
  9	90
  4	40
  6	60
*/
--USERA07
COMMIT; -- <- 9
--USERB07
SELECT * FROM "USERA07".CCTEST; -- <- 10
/*
  3	30
  5	50
  7	70
  8	80
  1	900
  2	400
  9	90
  4	40
  6	60
*/
-- Seria Serializable porque aunque USERA realize COMMIT USERB no ve los cambios.
--USERA07
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 11
SELECT * FROM CCTEST; -- <- 12
/*
  3	30
  5	50
  7	70
  8	80
  1	90
  2	400
  9	90
  4	40
  6	60
*/
--USERB07
COMMIT; -- <- 13
--USERA07
SELECT * FROM CCTEST; -- <- 14
/*
  3	30
  5	50
  7	70
  8	80
  1	90
  2	400
  9	90
  4	40
  6	60
*/
--USERB07
SELECT * FROM "USERA07".CCTEST; -- <- 15
/*
  3	30
  5	50
  7	70
  8	80
  1	90
  2	400
  9	90
  4	40
  6	60
*/
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 16
SELECT * FROM "USERA07".CCTEST; -- <- 17
/*
  3	30
  5	50
  7	70
  8	80
  1	90
  2	400
  9	90
  4	40
  6	60
*/
--USERA07
COMMIT; -- <- 18
--USERB07
COMMIT; -- <- 19

-- Pregunta 32. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 10, 12, 14 y 15) y razona/justifica por qué se obtienen dichos resultados. ¿Se han ejecutado las dos transacciones completa y correctamente? ¿Se ha producido algún problema debido a la ejecución concurrente de las transacciones?

--USERA07
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 1
SELECT * FROM CCTEST; -- <- 2
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
|  80 |   80 |
|  90 |   90 |
| 204 |   20 |
+-----+------+
19 rows in set (0.000 sec)
*/
--USERB07
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 3
SELECT * FROM "USERA07".CCTEST; -- <- 4
/*
+-----+------+
| X   | Y    |
+-----+------+
|   1 |  100 |
|   2 |  400 |
|   4 |   20 |
|   5 |   10 |
|   6 |   20 |
|   7 |   10 |
|   8 |   20 |
|   9 |   30 |
|  10 |   20 |
|  20 |   20 |
|  22 |   20 |
|  23 |   20 |
|  40 |   40 |
|  50 |   50 |
|  60 |   60 |
|  70 |   70 |
|  80 |   80 |
|  90 |   90 |
| 204 |   20 |
+-----+------+
19 rows in set (0.000 sec)
*/
--USERA07
UPDATE CCTEST SET Y = Y*10 WHERE X = 1; -- <- 5
--------------------------BLOQUO-----------------------------------------------
SELECT * FROM CCTEST; -- <- 6
/*
  3	30
  5	50
  7	70
  8	80
  1	900
  2	400
  9	90
  4	40
  6	60
*/
--USERB07
UPDATE "USERA07".CCTEST SET Y = Y*20 WHERE X = 2; -- <- 7
SELECT * FROM "USERA07".CCTEST; -- <- 8
/*
  3	30
  5	50
  7	70
  8	80
  1	90
  2	8000
  9	90
  4	40
  6	60
*/
--USERA07
COMMIT; -- <- 9
--USERB07
SELECT * FROM "USERA07".CCTEST; -- <- 10
/*
  3	30
  5	50
  7	70
  8	80
  1	90
  2	8000
  9	90
  4	40
  6	60
*/
--USERA07
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 11
SELECT * FROM CCTEST; -- <- 12
/*
  3	30
  5	50
  7	70
  8	80
  1	900
  2	400
  9	90
  4	40
  6	60
*/
--USERB07
COMMIT; -- <- 13
--USERA07
SELECT * FROM CCTEST; -- <- 14
/*
  3	30
  5	50
  7	70
  8	80
  1	900
  2	400
  9	90
  4	40
  6	60
*/
--USERB07
SELECT * FROM "USERA07".CCTEST; -- <- 15
/*
  3	30
  5	50
  7	70
  8	80
  1	900
  2	8000
  9	90
  4	40
  6	60
*/
--USERA07
COMMIT; -- <- 16

-- Pregunta 33. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 10, 12, 14, 16 y 20) y razona/justifica por qué se obtienen dichos resultados. ¿Se han ejecutado las dos transacciones completa y correctamente? ¿Se ha producido algún problema debido a la ejecución concurrente de las transacciones?