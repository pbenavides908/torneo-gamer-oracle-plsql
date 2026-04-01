-- =========================================
-- 04_plsql.sql
-- TORNEO GAMER - PL/SQL
-- =========================================

SET SERVEROUTPUT ON;

-- =====================================================
-- BLOQUE 1: Mostrar información de un jugador por nickname
-- =====================================================
DECLARE
    v_nickname jugadores.nickname%TYPE := 'ShadowX';
    v_nombre   jugadores.nombre_real%TYPE;
    v_apellido jugadores.apellido_real%TYPE;
    v_pais     jugadores.pais%TYPE;
BEGIN
    SELECT nombre_real, apellido_real, pais
    INTO v_nombre, v_apellido, v_pais
    FROM jugadores
    WHERE nickname = v_nickname;

    DBMS_OUTPUT.PUT_LINE('Jugador: ' || v_nombre || ' ' || v_apellido || ' | País: ' || v_pais);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe jugador con nickname ' || v_nickname);
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Se encontraron varios jugadores con ese nickname.');
END;
/
-- =====================================================
-- FUNCIÓN 1: total de victorias de un equipo
-- =====================================================
CREATE OR REPLACE FUNCTION fn_total_victorias_equipo (
    p_equipo_id IN equipos.equipo_id%TYPE
) RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM partidas
    WHERE ganador_equipo_id = p_equipo_id
      AND estado = 'JUGADA';

    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
-- Prueba de la función
DECLARE
    v_victorias NUMBER;
BEGIN
    v_victorias := fn_total_victorias_equipo(1);
    DBMS_OUTPUT.PUT_LINE('Victorias del equipo 1: ' || v_victorias);
END;
/
-- =====================================================
-- FUNCIÓN 2: total de puntos acumulados por un equipo
-- =====================================================
CREATE OR REPLACE FUNCTION fn_total_puntos_equipo (
    p_equipo_id IN equipos.equipo_id%TYPE
) RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT NVL(SUM(puntos_obtenidos), 0)
    INTO v_total
    FROM puntajes
    WHERE equipo_id = p_equipo_id;

    RETURN v_total;
END;
/
-- Prueba de la función
DECLARE
    v_puntos NUMBER;
BEGIN
    v_puntos := fn_total_puntos_equipo(1);
    DBMS_OUTPUT.PUT_LINE('Puntos acumulados del equipo 1: ' || v_puntos);
END;
/
-- =====================================================
-- FUNCIÓN 3: clasificar un torneo según premio
-- =====================================================
CREATE OR REPLACE FUNCTION fn_categoria_premio (
    p_premio IN torneos.premio_total%TYPE
) RETURN VARCHAR2
IS
BEGIN
    IF p_premio < 300000 THEN
        RETURN 'BAJO';
    ELSIF p_premio BETWEEN 300000 AND 700000 THEN
        RETURN 'MEDIO';
    ELSE
        RETURN 'ALTO';
    END IF;
END;
/
-- Prueba de la función
DECLARE
    v_categoria VARCHAR2(20);
BEGIN
    v_categoria := fn_categoria_premio(850000);
    DBMS_OUTPUT.PUT_LINE('Categoría del premio: ' || v_categoria);
END;
/
-- =====================================================
-- PROCEDIMIENTO 1: cambiar estado de un torneo
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_actualizar_estado_torneo (
    p_torneo_id     IN torneos.torneo_id%TYPE,
    p_nuevo_estado  IN torneos.estado%TYPE
)
IS
BEGIN
    UPDATE torneos
    SET estado = p_nuevo_estado
    WHERE torneo_id = p_torneo_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el torneo con ID ' || p_torneo_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Estado del torneo actualizado correctamente.');
    END IF;
END;
/
-- Prueba del procedimiento
BEGIN
    sp_actualizar_estado_torneo(2, 'EN_CURSO');
END;
/
-- =====================================================
-- PROCEDIMIENTO 2: cambiar estado de una partida
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_actualizar_estado_partida (
    p_partida_id     IN partidas.partida_id%TYPE,
    p_nuevo_estado   IN partidas.estado%TYPE
)
IS
BEGIN
    UPDATE partidas
    SET estado = p_nuevo_estado
    WHERE partida_id = p_partida_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No existe la partida con ID ' || p_partida_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Estado de la partida actualizado.');
    END IF;
END;
/
-- Prueba del procedimiento
BEGIN
    sp_actualizar_estado_partida(11, 'JUGADA');
END;
/
-- =====================================================
-- PROCEDIMIENTO 3: registrar ganador de una partida
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_registrar_ganador_partida (
    p_partida_id         IN partidas.partida_id%TYPE,
    p_ganador_equipo_id  IN partidas.ganador_equipo_id%TYPE
)
IS
    v_local partidas.equipo_local_id%TYPE;
    v_visitante partidas.equipo_visitante_id%TYPE;
BEGIN
    SELECT equipo_local_id, equipo_visitante_id
    INTO v_local, v_visitante
    FROM partidas
    WHERE partida_id = p_partida_id;

    IF p_ganador_equipo_id NOT IN (v_local, v_visitante) THEN
        DBMS_OUTPUT.PUT_LINE('Error: el ganador no corresponde a los equipos de la partida.');
    ELSE
        UPDATE partidas
        SET ganador_equipo_id = p_ganador_equipo_id,
            estado = 'JUGADA'
        WHERE partida_id = p_partida_id;

        DBMS_OUTPUT.PUT_LINE('Ganador registrado correctamente.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe la partida indicada.');
END;
/
-- Prueba del procedimiento
BEGIN
    sp_registrar_ganador_partida(11, 1);
END;
/
-- =====================================================
-- PROCEDIMIENTO 4: mostrar ranking de equipos con cursor
-- =====================================================
CREATE OR REPLACE PROCEDURE sp_ranking_equipos
IS
    CURSOR c_ranking IS
        SELECT e.equipo_id,
               e.nombre_equipo,
               NVL(SUM(p.puntos_obtenidos), 0) AS total_puntos
        FROM equipos e
        LEFT JOIN puntajes p
            ON e.equipo_id = p.equipo_id
        GROUP BY e.equipo_id, e.nombre_equipo
        ORDER BY total_puntos DESC, e.nombre_equipo;

    v_id equipos.equipo_id%TYPE;
    v_nombre equipos.nombre_equipo%TYPE;
    v_puntos NUMBER;
BEGIN
    OPEN c_ranking;
    LOOP
        FETCH c_ranking INTO v_id, v_nombre, v_puntos;
        EXIT WHEN c_ranking%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Equipo ID: ' || v_id ||
            ' | Nombre: ' || v_nombre ||
            ' | Puntos: ' || v_puntos
        );
    END LOOP;
    CLOSE c_ranking;
END;
/
-- Prueba del procedimiento
BEGIN
    sp_ranking_equipos;
END;
/
-- =====================================================
-- BLOQUE 2: mostrar torneos y su categoría de premio
-- =====================================================
DECLARE
    CURSOR c_torneos IS
        SELECT torneo_id, nombre_torneo, premio_total
        FROM torneos
        ORDER BY premio_total DESC;

    v_id      torneos.torneo_id%TYPE;
    v_nombre  torneos.nombre_torneo%TYPE;
    v_premio  torneos.premio_total%TYPE;
BEGIN
    OPEN c_torneos;
    LOOP
        FETCH c_torneos INTO v_id, v_nombre, v_premio;
        EXIT WHEN c_torneos%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Torneo: ' || v_nombre ||
            ' | Premio: ' || TO_CHAR(v_premio, 'FM999G999G999D00') ||
            ' | Categoría: ' || fn_categoria_premio(v_premio)
        );
    END LOOP;
    CLOSE c_torneos;
END;
/
-- =====================================================
-- BLOQUE 3: mostrar estadísticas de un equipo
-- =====================================================
DECLARE
    v_equipo_id equipos.equipo_id%TYPE := 1;
    v_nombre equipos.nombre_equipo%TYPE;
    v_victorias NUMBER;
    v_puntos NUMBER;
BEGIN
    SELECT nombre_equipo
    INTO v_nombre
    FROM equipos
    WHERE equipo_id = v_equipo_id;

    v_victorias := fn_total_victorias_equipo(v_equipo_id);
    v_puntos := fn_total_puntos_equipo(v_equipo_id);

    DBMS_OUTPUT.PUT_LINE('Equipo: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Victorias: ' || v_victorias);
    DBMS_OUTPUT.PUT_LINE('Puntos acumulados: ' || v_puntos);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existe el equipo con ID ' || v_equipo_id);
END;
/