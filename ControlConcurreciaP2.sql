-- CARLOS DIEZ

-- Pregunta 01. Inicia sesión con los 3 usuarios arriba indicados de la forma descrita y obtén el identificador de sesión para cada una de las sesiones abiertas. Hazlo también cada vez que se reinicie alguna de las sesiones.

  --SYS USER
  ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
  CREATE USER USERA07 IDENTIFIED BY usera07 DEFAULT TABLESPACE USERS;
  CREATE USER USERB07 IDENTIFIED BY userb07 DEFAULT TABLESPACE USERS;
  GRANT CREATE SESSION TO USERA07;
  GRANT CREATE SESSION TO USERB07;
  SELECT USERNAME, SID FROM V$SESSION WHERE USERNAME IS NOT NULL;
  /*
    SYS	10
    USERA07	45
    USERB07	292
    SYS	305
  */
  GRANT CREATE TABLE TO USERA07;
  ALTER USER USERA07 QUOTA UNLIMITED ON USERS;
  --USERA07 USER
  CREATE TABLE CCTEST (X NUMBER PRIMARY KEY, Y NUMBER);
  INSERT INTO CCTEST VALUES (1,10);
  INSERT INTO CCTEST VALUES (2,20);


-- Pregunta 02. ¿Existe ahora alguna reserva activa del usuario USERA07? Indica las reservas existentes y su tipo.

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 45;
  /*
    45	AE	138	1	4	0	390	0 		-> AE reservas del sistema
    45	TM	86285	0	3	0	36	0	-> TM es tabla.
    45	TX	655384	824	6	0	36	0	-> TX es transaccion
  */

  -- USERA07 USER
  COMMIT;

-- Pregunta 03. ¿Y ahora existe alguna reserva activa del usuario USERA07? Indica las reservas existentes y su tipo.

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 45;
  /*
    45	AE	138	1	4	0	503	0	-> AE reservas del sistema
  */

--2.2.- Transacciones con COMMIT implícito (o AUTOCOMMIT)

  --USERA07 USER
  UPDATE CCTEST SET Y = Y*3 WHERE X = 1;

-- Pregunta 04. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes y su tipo

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 45;
  /*
    45	AE	138	1	4	0	695	0		-> AE reservas del sistema
    45	TM	86285	0	3	0	41	0	-> TM es tabla.
    45	TX	327709	881	6	0	41	0	-> TX es transaccion
  */

  --USERA07 USER
  GRANT SELECT, UPDATE ON CCTEST TO "USERB07";

-- Pregunta 05. ¿Existe ahora alguna reserva activa del usuario USERA07? ¿Qué ha pasado? Indica las reservas existentes y su tipo.

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 45;
  /*
  Lo que ha pasado ha sido el AUTOCOMMIT:
    45	AE	138	1	4	0	802	0	-> AE reservas del sistema
  */

--2.3. Bloqueos entre transacciones

  --USERA07 USER
  UPDATE CCTEST SET Y = Y*3 WHERE X = 1;

-- Pregunta 06. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes y su tipo.

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 45;
  /*
  Lo que ha pasado ha sido el AUTOCOMMIT:
    45	AE	138	1	4	0	919	0		-> AE reservas del sistema
    45	TM	86285	0	3	0	16	0	-> TM es tabla.
    45	TX	131103	883	6	0	16	0	-> TX es transaccion
  */



-- Pregunta 07. Consulta el valor actual de las tuplas en la tabla CCTEST: desde las sesiones de los usuarios USERA07 y USERB07. ¿Qué está sucediendo?

  --USERA07 USER
  SELECT * FROM CCTEST;
  /*
    1	90
    2	20
  */

  --USERB07 USER
  SELECT * FROM USERA07.CCTEST;
  /*
    1	30
    2	20
  */
  --Todavia no se ha escrito en global los nuevos cambios que ha hecho USERA07

  UPDATE "USERA07".CCTEST SET Y = Y-20 WHERE X = 1;



-- Pregunta 08. ¿Qué sucede? Justifica tu respuesta utilizando la información sobre reservas realizadas por el usuario USERA07.

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 45;
  /*
    45	AE	138	1	4	0	1312	0
    45	TM	86285	0	3	0	409	0
    45	TX	131103	883	6	0	409	1
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 292;
  /*
    292	TX	131103	883	0	6	119	0
    292	AE	138	1	4	0	1299	0
    292	TM	86285	0	3	0	119	0
  */

  -- El USERB07 tiene el request 6, que esta esperando.

  --USERA07 USER
  COMMIT;


-- Pregunta 09. ¿Qué sucede ahora con la actualización del usuario USERB07? ¿Cuáles son los valores actuales de la tabla desde las sesiones de los usuarios USERA07 y USERB07?

  --En el momento en el que se ha hechoo commit, ha empezado la actalizacion de USERB07

  --USERA07 USER
  SELECT * FROM CCTEST;
  /*
    1	90
    2	20	
  */

  --USERB07 USER
  SELECT * FROM USERA07.CCTEST;
  /*
    1	70
    2	20
  */



-- Pregunta 10. ¿Existe alguna reserva activa? Indica las reservas existentes y su tipo. ¿Qué hay que realizar para liberar dichas reservas activas?

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 45;
  /*
    45	AE	138	1	4	0	1574	0
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 292;
  /*
    292	AE	138	1	4	0	1757	0
    292	TM	86285	0	3	0	350	0
    292	TX	458768	829	6	0	303	0
  */

-- Se puede hacer commit o ROLLBACK
  -- USERB07 USER
  ROLLBACK;

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 292;
  /*
    292	AE	138	1	4	0	1822	0
  */

  -- USERA07 USER
  UPDATE CCTEST SET Y = Y*3 WHERE X = 1;

  -- USERB07 USER
  UPDATE "USERA07".CCTEST SET Y = Y-20 WHERE X = 1;



-- Pregunta 11. ¿Cuál es la sesión bloqueada y cuál es la sesión que está bloqueando? Indica las consultas utilizadas y el resultado obtenido

  -- SYS USER
  SELECT SID, USERNAME, BLOCKING_SESSION FROM V$SESSION WHERE USERNAME IS NOT NULL AND BLOCKING_SESSION IS NOT NULL;
  /*
    292	USERB07	45
  */
  -- La sesion bloqueada es la 292 y esta bloqueada por 45


-- Pregunta 12. ¿Qué hay que hacer para liberar todas las reservas activas? Libera todas las reservas activas.

  --USERA07 USER
  ROLLBACK;

  --USERB07 USER
  ROLLBACK;

  -- SYS USER
  SELECT SID, USERNAME, BLOCKING_SESSION FROM V$SESSION WHERE USERNAME IS NOT NULL AND BLOCKING_SESSION IS NOT NULL;
  /*

  */

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 45;
  /*
    45	AE	138	1	4	0	2165	0
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 292;
  /*
    292	AE	138	1	4	0	2127	0
  */

-- 2.4. Bloqueo mortal (deadlock)


-- Volver a abrir las sesiones
  SELECT USERNAME, SID FROM V$SESSION WHERE USERNAME IS NOT NULL;
  /*
    SYS	9
    USERB07	50
    USERA07	57
    SYS	275
  */

  -- USERA07 
  UPDATE CCTEST SET Y = Y*3 WHERE X = 1;
  --USERB07
  UPDATE "USERA07".CCTEST SET Y = Y-20 WHERE X = 2;
  -- USERA07 
  UPDATE CCTEST SET Y = Y*4 WHERE X = 2;
  --USERB07
  UPDATE "USERA07".CCTEST SET Y = Y-40 WHERE X = 1;


-- Pregunta 13. ¿Qué ha sucedido? ¿Cuáles son las reservas activas? Indica las reservas existentes y su tipo. ¿Qué hay que realizar para liberar dichas reservas activas? Libera todas las reservas activas.

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 50;
  /*
    50	TX	589852	1010	0	6	755	0
        50	AE	138	1	4	0	1318	0
        50	TX	393229	1008	6	0	764	0
        50	TM	86285	0	3	0	764	0
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
    57	TX	589852	1010	6	0	804	1
        57	AE	138	1	4	0	1333	0
        57	TM	86285	0	3	0	804	0
  */


  --Para liberar las transacciones hay que hacer ROLLBACK
  --USERA07
  ROLLBACK;
  --USERB07
  ROLLBACK;

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 50;
  /*
    50	AE	138	1	4	0	1435	0
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
    57	AE	138	1	4	0	1446	0
  */


  -- USERA07
  SELECT Y FROM CCTEST WHERE X = 1 FOR UPDATE;


-- Pregunta 14. ¿Hay alguna diferencia con las reservas que se realizaban en los pasos anteriores (Pasos 2.1, 2.2, 2.3 y 2.4)?

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 50;
  /*
    50	AE	138	1	4	0	2829	0
  */




-- Pregunta 15. ¿Se puede consultar la tabla CCTEST desde la sesión del usuario USERB07? ¿Qué valores se obtienen?

  --USERB07
  SELECT * FROM "USERA07".CCTEST;
  /*
    1	90
    2	20
  */

  UPDATE "USERA07".CCTEST SET Y = Y-20 WHERE X = 2;
  UPDATE "USERA07".CCTEST SET Y = Y-40 WHERE X = 1;

-- Pregunta 16. ¿Es posible realizar las actualizaciones anteriores? ¿Cuáles son las reservas activas? ¿Qué hay que hacer para liberar dichas reservas? Libera todas las reservas activas.

  -- La segunda no es posible, se bloquea, debido a que lo ocupa USERA07

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 50;
  /*
        50	TX	131103	993	6	0	810	0
        50	AE	138	1	4	0	5116	0
        50	TX	524316	988	0	6	810	0
        50	TM	86285	0	3	0	810	0
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
        57	AE	138	1	4	0	5127	0
        57	TX	524316	988	6	0	2301	1
        57	TM	86285	0	3	0	2301	0
  */

  --Para liberar las transacciones hay que hacer ROLLBACK
  --USERA07
  ROLLBACK;
  --USERB07
  ROLLBACK;

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 50;
  /*
        50	AE	138	1	4	0	6422	0
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
        57	AE	138	1	4	0	6431	0
  */



-- 3.1. Reserva en modo exclusivo (X)


  --USERA07
  LOCK TABLE CCTEST IN EXCLUSIVE MODE;

-- Pregunta 17. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes junto con su su tipo y compara la información obtenida en esta ocasión con la información que se obtenía en los pasos anteriores (Pasos 2.1, 2.2, 2.3, 2.4 y 2.5).

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
        57	AE	138	1	4	0	6525	0
    57	TM	86285	0	6	0	25	0
  */


-- Pregunta 18. ¿Se puede consultar la tabla CCTEST desde la sesión del usuario USERB07? ¿Qué valores se obtienen?

  --USERB07
  SELECT * FROM "USERA07".CCTEST;
  /*
    1	90
    2	20
  */

  UPDATE "USERA07".CCTEST SET Y = Y-40 WHERE X = 1;
  UPDATE "USERA07".CCTEST SET Y = Y-20 WHERE X = 2;





-- Pregunta 19. ¿Es posible realizar las actualizaciones anteriores? ¿Cuáles son las reservas activas? ¿Qué hay que hacer para liberar dichas reservas? Libera todas las reservas activas.

  --No se puede realizar, habra que hacer rollback.
  --USERA07
  ROLLBACK;
  --USERB07
  ROLLBACK;

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 50;
  /*
        50	AE	138	1	4	0	6696	0
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
        57	AE	138	1	4	0	6708	0
  */



-- 3.2. Reserva en modo compartido a nivel de tupla (SS)

  --USERA07
  LOCK TABLE CCTEST IN ROW SHARE MODE;

-- Pregunta 20. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes junto con su su tipo y compara la información obtenida en esta ocasión con la información que se obtenía en los pasos anteriores (Pasos 2.1, 2.2, 2.3, 2.4, 2.5 y 3.1).


  -- SYS USER

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
        57	AE	138	1	4	0	6793	0
    57	TM	86285	0	2	0	27	0
  */

  --USERA07
  UPDATE CCTEST SET Y = Y*3 WHERE X = 1;




-- Pregunta 21. ¿Existe ahora alguna reserva activa del usuario USERA07? Indica las reservas existentes junto con su su tipo y compara la información obtenida en esta ocasión con la información que se obtenía en los pasos anteriores (Pasos 2.1, 2.2, 2.3, 2.4, 2.5 y 3.1).

  --SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
        57	TX	655387	908	6	0	11	0
        57	AE	138	1	4	0	6846	0
        57	TM	86285	0	3	0	11	0
  */


-- Pregunta 22. ¿Se puede consultar la tabla CCTEST desde la sesión del usuario USERB07? ¿Qué valores se obtienen?

  --USERB07
  SELECT * FROM "USERA07".CCTEST;
  /*
    1	90
    2	20
  */

  UPDATE "USERA07".CCTEST SET Y = Y-40 WHERE X = 1;
  UPDATE "USERA07".CCTEST SET Y = Y-20 WHERE X = 2;



-- Pregunta 23. ¿Es posible realizar las actualizaciones anteriores? ¿Cuáles son las reservas activas? ¿Qué hay que hacer para liberar dichas reservas? Libera todas las reservas activas.

  --No se puede realizar, habra que hacer rollback.
  --USERA07
  ROLLBACK;
  --USERB07
  ROLLBACK;

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 50;
  /*
        50	AE	138	1	4	0	6949	0
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
        57	AE	138	1	4	0	6959	0
  */


--3.3. Reserva en modo compartido (S)


  -- USERA07
  LOCK TABLE CCTEST IN SHARE MODE;


-- Pregunta 24. ¿Existe alguna reserva activa del usuario USERA07? Indica las reservas existentes junto con su su tipo y compara la información obtenida en esta ocasión con la información que se obtenía en los pasos anteriores (Pasos 2.1, 2.2, 2.3, 2.4, 2.5, 3.1 y 3.2)

  --SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
        57	AE	138	1	4	0	7301	0
    57	TM	86285	0	4	0	17	0
  */



-- Pregunta 25. ¿Se puede consultar la tabla CCTEST desde la sesión del usuario USERB07? ¿Qué valores se obtienen?

  --USERB07
  SELECT * FROM "USERA07".CCTEST;
  /*
    1	90
    2	20
  */

  UPDATE "USERA07".CCTEST SET Y = Y-40 WHERE X = 1;
  UPDATE "USERA07".CCTEST SET Y = Y-20 WHERE X = 2;



-- Pregunta 26. ¿Es posible realizar las actualizaciones anteriores? ¿Cuáles son las reservas activas? ¿Qué hay que hacer para liberar dichas reservas? Libera todas las reservas activas.

  --No se puede realizar, habra que hacer rollback.
  --USERA07
  ROLLBACK;
  --USERB07
  ROLLBACK;

  -- SYS USER
  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 50;
  /*
        50	AE	138	1	4	0	7367	0
  */

  SELECT SID, TYPE, ID1, ID2, LMODE, REQUEST, CTIME, BLOCK FROM V$LOCK WHERE SID = 57;
  /*
        57	AE	138	1	4	0	7375	0
  */


-- 4.1. READ ONLY: consistencia de lectura a nivel de transacción

  -- SYS USER


-- Pregunta 27. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6 y 8) y razona/justifica por qué se obtienen dichos resultados.

  --USERA07
  SET TRANSACTION READ ONLY;
  SELECT * FROM CCTEST;  -- <- 2
  /*
    1	90
    2	20
  */
  --USERB07
  INSERT INTO "USERA07".CCTEST VALUES (3,30);
  --USERA07
  SELECT * FROM CCTEST; -- <- 4
  /*
    1	90
    2	20
  */
  --USERB07
  COMMIT;
  --USERA07
  SELECT * FROM CCTEST; -- <- 6
  /*
    1	90
    2	20
  */
  COMMIT;
  SELECT * FROM CCTEST; -- <- 8
  /*
    3	30
    1	90
    2	20
  */

  -- Al observar como USERA solo realiza lecturas, hasta que hace commit, podemos saber que es el efecto de READ-ONLY.
  -- Todo ha funcionado correctamente.


--4.2. READ WRITE: consistencia de lectura a nivel de sentencia


-- Pregunta 28. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 9, 11, 13, 14, 17, 19, 20, 22 y 23) y razona/justifica por qué se obtienen dichos resultados.

  --USERA07
  SET TRANSACTION READ WRITE; -- <- 1
  SELECT * FROM CCTEST; -- <- 2
  /*
    3	30
    1	90
    2	20
  */
  --USERB07
  SET TRANSACTION READ WRITE; -- <- 3
  SELECT * FROM "USERA07".CCTEST; -- <- 4
  /*
    3	30
    1	90
    2	20	
  */
  --USERA07
  INSERT INTO CCTEST VALUES (4,40); -- <- 5
  SELECT * FROM CCTEST; -- <- 6
  /*
    3	30
    1	90
    2	20
    4	40
  */
  --USERB07
  INSERT INTO "USERA07".CCTEST VALUES (5,50); -- <- 7
  SELECT * FROM "USERA07".CCTEST; -- <- 8
  /*
    3	30
    5	50
    1	90
    2	20
  */
  --USERA07
  SELECT * FROM CCTEST; -- <- 9
  /*
    3	30
    1	90
    2	20
    4	40
  */
  COMMIT; -- <- 10
  SELECT * FROM CCTEST; -- <- 11
  /*
    3	30
    1	90
    2	20
    4	40
  */
  INSERT INTO CCTEST VALUES (6,60); -- <- 12
  SELECT * FROM CCTEST; -- <- 13
  /*
    3	30
    1	90
    2	20
    4	40
    6	60
  */
  --USERB07
  SELECT * FROM "USERA07".CCTEST; -- <- 14
  /*
    3	30
    5	50
    1	90
    2	20
    4	40
  */
  COMMIT; -- <- 15
  --USERA07
  COMMIT; -- <- 16
  --USERB07
  SELECT * FROM "USERA07".CCTEST; -- <- 17
  /*
    3	30
    5	50
    1	90
    2	20
    4	40
    6	60
  */
  INSERT INTO "USERA07".CCTEST VALUES (7,70); -- <- 18
  --USERA07	
  SELECT * FROM CCTEST; -- <- 19
  /*
    3	30
    5	50
    1	90
    2	20
    4	40
    6	60
  */
  --USERB07
  SELECT * FROM "USERA07".CCTEST; -- <- 20
  /*
    3	30
    5	50
    7	70
    1	90
    2	20
    4	40
    6	60
  */
  COMMIT; -- <- 21
  --USERA07	
  SELECT * FROM CCTEST; -- <- 22
  /*
    3	30
    5	50
    7	70
    1	90
    2	20
    4	40
    6	60
  */
  --USERB07
  SELECT * FROM "USERA07".CCTEST; -- <- 23
  /*
    3	30
    5	50
    7	70
    1	90
    2	20
    4	40
    6	60
  */

  -- Se puede observar que los dos han utilizado READ WRITE, que significa que pueden escribir y leer los cambios de otros, solo si han hecho commit.
  -- Todo ha funcionado correctamente.

-- 5.1. READ COMMITTED

-- Pregunta 29. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 10, 12, 14 y 15) y razona/justifica por qué se obtienen dichos resultados. ¿Se ha producido el problema de lecturas no-repetibles? De ser así, indica en qué pasos.

  --USERA07
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 1
  SELECT * FROM CCTEST; -- <- 2
  /*
    3	30
    5	50
    7	70
    1	90
    2	20
    4	40
    6	60
  */
  --USERB07
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 3
  SELECT * FROM "USERA07".CCTEST; -- <- 4
  /*
    3	30
    5	50
    7	70
    1	90
    2	20
    4	40
    6	60
  */
  --USERA07
  UPDATE CCTEST SET Y = Y*10 WHERE X = 1; -- <- 5
  SELECT * FROM CCTEST; -- <- 6
  /*
    3	30
    5	50
    7	70
    1	900
    2	20
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
    1	90
    2	400
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
    1	900
    2	400
    4	40
    6	60
  */
  --USERA07
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 11
  SELECT * FROM CCTEST; -- <- 12
  /*
    3	30
    5	50
    7	70
    1	900
    2	20
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
    1	900
    2	400
    4	40
    6	60
  */
  --USERB07
  SELECT * FROM "USERA07".CCTEST; -- <- 15
  /*
    3	30
    5	50
    7	70
    1	900
    2	400
    4	40
    6	60
  */
  --USERA07
  COMMIT; -- <- 16


  -- Todo ha ido correctamente, pero en el punto 10 y 14 ha ocurrido la lectura no repetible, esto ocurre debido a que al estar en READ COMMITED, permite ver los cambios confirmados pero no los no confirmados.


-- Pregunta 30. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 10, 12, 14 y 16) y razona/justifica por qué se obtienen dichos resultados. ¿Se ha producido el problema de lecturas fantasmas? De ser así, indica en qué pasos.


  --USERA07
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 1
  SELECT * FROM CCTEST; -- <- 2
  /*
    3	30
    5	50
    7	70
    1	900
    2	400
    4	40
    6	60
  */
  --USERB07
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 3
  SELECT * FROM "USERA07".CCTEST; -- <- 4
  /*
    3	30
    5	50
    7	70
    1	900
    2	400
    4	40
    6	60
  */
  --USERA07
  INSERT INTO CCTEST VALUES (8,80); -- <- 5
  SELECT * FROM CCTEST; -- <- 6
  /*
    3	30
    5	50
    7	70
    8	80
    1	900
    2	400
    4	40
    6	60
  */
  --USERB07
  INSERT INTO "USERA07".CCTEST VALUES (9,90); -- <- 7
  SELECT * FROM "USERA07".CCTEST; -- <- 8
  /*
    3	30
    5	50
    7	70
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
  --Lectura fantasma 8 80
  --USERA07
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 11
  SELECT * FROM CCTEST; -- <- 12
  /*
    3	30
    5	50
    7	70
    8	80
    1	900
    2	400
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
  --Lectura fantasma 
  --USERB07
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- <- 15
  SELECT * FROM "USERA07".CCTEST; -- <- 16
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
  COMMIT; -- <- 17
  --USERB07
  COMMIT; -- <- 18

  -- Todo bien, pero la lectura fantasma ocurre en el punto 10 (con 8 80) y en el punto 14 (con 9 90), esto ocurre debido a que esta a nivel READ COMMITTED.


-- 5.2. SERIALIZABLE

-- Pregunta 31. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 10, 12, 14, 15 y 17) y razona/justifica por qué se obtienen dichos resultados. ¿Se han ejecutado las dos transacciones completa y correctamente? ¿Se ha producido algún problema debido a la ejecución concurrente de las transacciones?


  --USERA07
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 1
  SELECT * FROM CCTEST; -- <- 2
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
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 3
  SELECT * FROM "USERA07".CCTEST; -- <- 4
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
  UPDATE CCTEST SET Y = Y/10 WHERE X = 1; -- <- 5
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

  -- Ha ocurrido un problema de concurrencia en 7, debido a que esta puesto a nivel de SERIALIZABLE, en el punto 10 se nota que no se ha notado ningun cambio, esto ocurre debido a que no ha confirmado sus cambios y porque esta a nivel SERIALIZABLE,

-- Pregunta 32. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 10, 12, 14 y 15) y razona/justifica por qué se obtienen dichos resultados. ¿Se han ejecutado las dos transacciones completa y correctamente? ¿Se ha producido algún problema debido a la ejecución concurrente de las transacciones?

  --USERA07
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 1
  SELECT * FROM CCTEST; -- <- 2
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
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 3
  SELECT * FROM "USERA07".CCTEST; -- <- 4
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
  UPDATE CCTEST SET Y = Y*10 WHERE X = 1; -- <- 5
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


  --Todo correcto, se puede observar las partes de nivel serializable en el punto 10, y despues en el 14, donde no cambia porque no ha confirmado sus cambios y habia vuelto a activar la SERIALIZACION.


-- Pregunta 33. Indica el resultado obtenido por cada consulta (instantes de tiempo 2, 4, 6, 8, 10, 12, 14, 16 y 20) y razona/justifica por qué se obtienen dichos resultados. ¿Se han ejecutado las dos transacciones completa y correctamente? ¿Se ha producido algún problema debido a la ejecución concurrente de las transacciones?


  --USERA07
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 1
  SELECT * FROM CCTEST; -- <- 2
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
  --USERB07
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 3
  SELECT * FROM "USERA07".CCTEST; -- <- 4
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
  INSERT INTO CCTEST VALUES (10,100); -- <- 5
  SELECT * FROM CCTEST; -- <- 6
  /*
    3	30
    5	50
    7	70
    8	80
    10	100
    1	900
    2	8000
    9	90
    4	40
    6	60
  */
  --USERB07
  INSERT INTO "USERA07".CCTEST VALUES (11,90); -- <- 7
  SELECT * FROM "USERA07".CCTEST; -- <- 8
  /*
    3	30
    5	50
    7	70
    8	80
    1	900
    2	8000
    9	90
    11	90
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
    2	8000
    9	90
    11	90
    4	40
    6	60
  */
  --Serializable
  --USERA07
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 11
  SELECT * FROM CCTEST; -- <- 12
  /*
    3	30
    5	50
    7	70
    8	80
    10	100
    1	900
    2	8000
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
    10	100
    1	900
    2	8000
    9	90
    4	40
    6	60
  */
  --USERB07
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 15
  SELECT * FROM "USERA07".CCTEST; -- <- 16
  /*
    3	30
    5	50
    7	70
    8	80
    10	100
    1	900
    2	8000
    9	90
    11	90
    4	40
    6	60
  */
  --USERA07
  COMMIT; -- <- 17
  --USERB07
  COMMIT; -- <- 18
  --USERA07
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- <- 19
  SELECT * FROM CCTEST; -- <- 20
  /*
    3	30
    5	50
    7	70
    8	80
    10	100
    1	900
    2	8000
    9	90
    11	90
    4	40
    6	60
  */
  COMMIT; -- <- 21


  -- Todo ha ido correctamente, lo que ha pasado es que despues de iniciar la SERIALIZACION, los dos USERA y USERB, han insertado una tupla, donde el USERA ha hecho commit e inmediatamente despues ha vuelto a serializarse, USERB no ha visto el cambio (10) y luego ha hecho commit, entonces USERA no ha podido ver los cambio realizados(14) pero USERB si(16),
  -- se ha serializado y luego han hecho los dos commit, entonces USERA ha podido ver los cambios. Porque los dos se han puesto de acuerdo en commit.