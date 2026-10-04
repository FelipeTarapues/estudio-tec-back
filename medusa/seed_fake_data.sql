-- Datos falsos adicionales para demostrar la nómina (proyecto 00000000-0000-0000-0000-000000000001)
-- Ejecutar con: PGPASSWORD=1234 psql -U medusa_user -d medusa_db -h localhost -f seed_fake_data.sql
-- Si ya existen, los borra y re-inserta por rol único de demo

BEGIN;

-- Limpiar falsos previos (por rol con prefijo [DEMO])
DELETE FROM empleados_nomina WHERE proyecto_id = '00000000-0000-0000-0000-000000000001' AND rol LIKE '[DEMO]%';

INSERT INTO empleados_nomina (proyecto_id, rol, salario_basico, dias_liquidados, salario_devengado, horas_extras, recargos_nocturnos, dom_festivo, auxilio_transporte_auto, auxilio_transporte_manual, fondo_solidaridad, retencion_fuente, otras_deducciones, sena, icbf, caja_compensacion, aporte_salud_empleador)
VALUES
-- 1. Practicante SENA - bajo costo, con auxilio automático (sí aplica, salario < 2*SMMLV)
('00000000-0000-0000-0000-000000000001', '[DEMO] Practicante SENA', 1300000, 26, 1300000, 0, 0, 0, TRUE, 0, 0, 0, 12000, NULL, NULL, NULL, NULL),
-- 2. Jefe de Logística - salario alto (>2*SMMLV, sin auxilio), con recargos y deducciones visibles
('00000000-0000-0000-0000-000000000001', '[DEMO] Jefe de Logística', 3850000, 26, 3850000, 85000, 145000, 65000, TRUE, 0, 45000, 78000, 25000, NULL, NULL, NULL, NULL),
-- 3. Vendedor Zona Norte - con horas extras y fondo solidaridad (para que rojo de Deducciones se note)
('00000000-0000-0000-0000-000000000001', '[DEMO] Vendedor Zona Norte', 2100000, 26, 2100000, 120000, 0, 42000, FALSE, 249095, 35000, 25000, 18000, NULL, NULL, NULL, NULL),
-- 4. Auxiliar Contable - nómina admin, con auxilio manual
('00000000-0000-0000-0000-000000000001', '[DEMO] Auxiliar Contable', 2050000, 22, 2050000, 0, 0, 0, FALSE, 249095, 0, 15000, 10000, NULL, NULL, NULL, NULL),
-- 5. Operario Turno Noche - muchos recargos nocturnos, destaca en gráfica horizontal
('00000000-0000-0000-0000-000000000001', '[DEMO] Operario Turno Noche', 1750905, 26, 1750905, 0, 185000, 0, TRUE, 0, 0, 0, 5000, NULL, NULL, NULL, NULL);

-- Opcional: añadir 1 materia prima y 1 empaque de demo para que resumen cambie
INSERT INTO materias_primas (proyecto_id, nombre, unidad, cantidad_requerida, descripcion_costo, costo_unitario)
SELECT '00000000-0000-0000-0000-000000000001', '[DEMO] Saborizante Vainilla Premium', 'Kilogramos', 2, 'Costo por kg demo', 45000
WHERE NOT EXISTS (SELECT 1 FROM materias_primas WHERE proyecto_id='00000000-0000-0000-0000-000000000001' AND nombre='[DEMO] Saborizante Vainilla Premium');

INSERT INTO materiales_empaque (proyecto_id, nombre, unidad, cantidad_requerida, precio_general, descripcion_costo, costo_unitario)
SELECT '00000000-0000-0000-0000-000000000001', '[DEMO] Etiquetas Premium x100', 'Unidad', 1, 45000, '100 por caja demo', 450
WHERE NOT EXISTS (SELECT 1 FROM materiales_empaque WHERE proyecto_id='00000000-0000-0000-0000-000000000001' AND nombre='[DEMO] Etiquetas Premium x100');

COMMIT;

-- Verificación: muestra nuevos totales
SELECT 'empleados_total' AS tabla, count(*)::text AS valor FROM empleados_nomina WHERE proyecto_id='00000000-0000-0000-0000-000000000001'
UNION ALL
SELECT 'empleados_demo', count(*)::text FROM empleados_nomina WHERE rol LIKE '[DEMO]%'
UNION ALL
SELECT 'total_devengado_demo', sum(salario_devengado + horas_extras + recargos_nocturnos + dom_festivo + CASE WHEN auxilio_transporte_auto THEN CASE WHEN salario_basico <= 2*1750905 THEN 249095 ELSE 0 END ELSE auxilio_transporte_manual END)::text
FROM empleados_nomina WHERE rol LIKE '[DEMO]%';
