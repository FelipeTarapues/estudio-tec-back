BEGIN;

INSERT INTO proyectos (id, nombre_producto, empresa, unidad_masa, masa_total, densidad_leche, densidad_crema)
VALUES ('00000000-0000-0000-0000-000000000001', 'Dulce Aroma de la montaña', 'Colanta', 'unidades', 200, 1.03, 1.022)
ON CONFLICT (id) DO UPDATE SET nombre_producto = EXCLUDED.nombre_producto, empresa = EXCLUDED.empresa,
  unidad_masa = EXCLUDED.unidad_masa, masa_total = EXCLUDED.masa_total,
  densidad_leche = EXCLUDED.densidad_leche, densidad_crema = EXCLUDED.densidad_crema,
  updated_at = NOW();

DELETE FROM proyeccion_demanda WHERE proyeccion_id IN (SELECT id FROM proyecciones_anuales WHERE proyecto_id = '00000000-0000-0000-0000-000000000001');
DELETE FROM proyeccion_costos WHERE proyeccion_id IN (SELECT id FROM proyecciones_anuales WHERE proyecto_id = '00000000-0000-0000-0000-000000000001');
DELETE FROM proyeccion_cif WHERE proyeccion_id IN (SELECT id FROM proyecciones_anuales WHERE proyecto_id = '00000000-0000-0000-0000-000000000001');
DELETE FROM proyeccion_gastos_admin WHERE proyeccion_id IN (SELECT id FROM proyecciones_anuales WHERE proyecto_id = '00000000-0000-0000-0000-000000000001');
DELETE FROM proyeccion_resultados WHERE proyeccion_id IN (SELECT id FROM proyecciones_anuales WHERE proyecto_id = '00000000-0000-0000-0000-000000000001');
DELETE FROM proyeccion_flujo_caja WHERE proyeccion_id IN (SELECT id FROM proyecciones_anuales WHERE proyecto_id = '00000000-0000-0000-0000-000000000001');
DELETE FROM proyecciones_anuales WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM fichas_tecnicas WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM materias_primas WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM materiales_empaque WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM recursos_tangibles WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM recursos_intangibles WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM parametros_nomina WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM empleados_nomina WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM inversiones WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM capital_trabajo WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM indicadores_financieros WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';
DELETE FROM materias_primas_proyeccion WHERE proyecto_id = '00000000-0000-0000-0000-000000000001';

INSERT INTO fichas_tecnicas (proyecto_id, producto, fabricante, modelo, marca, presentacion, descripcion_producto, especificaciones_tecnicas, instrucciones_uso, beneficios, advertencias, composicion, empaque, rotulado, lugar_elaboracion, fecha_elaboracion, unidad_venta)
VALUES ('00000000-0000-0000-0000-000000000001', 'Dulce Aroma de la montaña', 'Colanta', 'HD-2026', 'Cooperativa Colanta', '200 g',
'Helado artesanal elaborado con mezcla de tres leches (entera, condensada y crema de leche), saborizado con crema de ron, con textura cremosa y homogénea. Producto congelado listo para consumo.',
$$Tipo de producto: Postre helado gourmet.

Sistema de envasado: Envase plástico grado alimenticio con tapa hermética y etiqueta impresa.

Vida útil y almacenamiento: 6 meses bajo congelación a -18 °C. Mantener en cadena de frío continua.

Porción estándar: 200 g (1 unidad)$$,
'Consumir directamente del envase o servir en copas/postres. Mantener congelado hasta el momento de consumo. No volver a congelar una vez descongelado. Consumir lo antes posible después de su apertura.',
$$Producto innovador con perfil gourmet.

Textura cremosa y sabor balanceado con notas de ron.

Cumple con estándares de higiene y calidad.$$,
$$Mantener fuera del alcance de menores de edad por su contenido alcohólico (mínimo 1–2%).

No consumir si el envase está dañado o presenta alteraciones.

El consumo excesivo puede generar efectos por el contenido de alcohol.$$,
$$Leche entera pasteurizada: 40 %
Leche condensada: 20 %
Crema de leche: 20 %
Azúcar refinada: 10 %
Crema de ron: 5 %
Estabilizantes/emulsificantes permitidos: 5 %$$,
$$Envases plásticos de 200 g, cajas de cartón corrugado de 25 kg
Material: polipropileno grado alimenticio, reciclable.
Etiquetado conforme a Resolución 5109 de 2005 (rotulado de alimentos en Colombia).$$,
$$Registro sanitario INVIMA: [pendiente de trámite].
Registro de marca: [pendiente de SIC].
Código EAN: [definir según lote].$$,
'Carrera 49 # 40 - 86, San Pedro, San Pedro de los Milagros, Antioquia', '27 de marzo de 2026', 'Caja con 24 unidades de 200 g');

INSERT INTO materias_primas (proyecto_id, nombre, unidad, cantidad_requerida, descripcion_costo, costo_unitario) VALUES
('00000000-0000-0000-0000-000000000001','Leche entera','Litros',80,'$500 X Litro',500),
('00000000-0000-0000-0000-000000000001','Leche en polvo entera','Kilogramos',40,'Costo por kg',26),
('00000000-0000-0000-0000-000000000001','Crema de leche','Kilogramos',30,'Costo por kg',200),
('00000000-0000-0000-0000-000000000001','Grasa vegetal o animal','Kilogramos',5,'Costo por 25 kg',8.75),
('00000000-0000-0000-0000-000000000001','Suero','Kilogramos',5,'Costo por kg',125),
('00000000-0000-0000-0000-000000000001','Azúcar','Kilogramos',10,'Costo por kg',12),
('00000000-0000-0000-0000-000000000001','Dextrosa','Kilogramos',5,'Costo por kg',35),
('00000000-0000-0000-0000-000000000001','Estabilizantes','Kilogramos',3,'Costo por kg',12),
('00000000-0000-0000-0000-000000000001','Emulsificantes','Kilogramos',2,'Costo por kg',4),
('00000000-0000-0000-0000-000000000001','Esencias','ml',5,'Costo por 500 ml',150),
('00000000-0000-0000-0000-000000000001','Crema de ron Medellín 8 años','Litros',15,'Costo por 0.75 L',1027.40);

INSERT INTO materiales_empaque (proyecto_id, nombre, unidad, cantidad_requerida, precio_general, descripcion_costo, costo_unitario) VALUES
('00000000-0000-0000-0000-000000000001','Fibra de caña (biodegradable)','Unidad',1,100000,'100 por caja',1000),
('00000000-0000-0000-0000-000000000001','Cucharas de bioplástico','Unidad',1,23000,'100 por caja',230),
('00000000-0000-0000-0000-000000000001','Cajas de cartón corrugado','Unidad',1,8000,'25 cajas por precio',320);

INSERT INTO recursos_tangibles (proyecto_id, categoria, nombre, costo) VALUES
('00000000-0000-0000-0000-000000000001','maquinaria','Máquinas de helado',8000000),
('00000000-0000-0000-0000-000000000001','maquinaria','Batidora industrial',3000000),
('00000000-0000-0000-0000-000000000001','maquinaria','Pasteurizador',10000000),
('00000000-0000-0000-0000-000000000001','equipos','Congeladores y cámaras de refrigeración',5000000),
('00000000-0000-0000-0000-000000000001','equipos','Moldes y recipientes para helado',1500000),
('00000000-0000-0000-0000-000000000001','equipos','Dosificadores para la crema de ron',2000000),
('00000000-0000-0000-0000-000000000001','herramientas','Espátulas, cucharas y palas de helado',300000),
('00000000-0000-0000-0000-000000000001','herramientas','Termómetros de cocina',200000),
('00000000-0000-0000-0000-000000000001','herramientas','Báscula para gramaje de materiales',120000),
('00000000-0000-0000-0000-000000000001','herramientas','Cuchillos y utensilios de repostería',150000),
('00000000-0000-0000-0000-000000000001','infraestructura','Cocina con buena ventilación',5000000),
('00000000-0000-0000-0000-000000000001','infraestructura','Área de almacenamiento en frío',7000000),
('00000000-0000-0000-0000-000000000001','infraestructura','Espacio para empaque y etiquetado',4000000),
('00000000-0000-0000-0000-000000000001','infraestructura','Sistema de higiene y control',3000000);

INSERT INTO recursos_intangibles (proyecto_id, categoria, nombre, costo) VALUES
('00000000-0000-0000-0000-000000000001','softwares','Software de la empresa (información del producto hasta el cliente)',2000000),
('00000000-0000-0000-0000-000000000001','conocimiento_tecnico','Desarrollo de la receta',700000),
('00000000-0000-0000-0000-000000000001','conocimiento_tecnico','Ajuste de sabor de la crema de ron',1200000),
('00000000-0000-0000-0000-000000000001','conocimiento_tecnico','Técnica para elaborar helados artesanales',700000),
('00000000-0000-0000-0000-000000000001','conocimiento_tecnico','Control de cremosidad y textura',600000),
('00000000-0000-0000-0000-000000000001','licencias_permisos','Registro sanitario para la producción y venta',1500000),
('00000000-0000-0000-0000-000000000001','licencias_permisos','Cumplimiento de normas sanitarias para alimentos',1300000),
('00000000-0000-0000-0000-000000000001','licencias_permisos','Licencias para incorporación de alcohol en alimentos',2000000),
('00000000-0000-0000-0000-000000000001','licencias_permisos','Licencias de control de maquinaria y calidad',4000000),
('00000000-0000-0000-0000-000000000001','licencias_permisos','Registro de marca',1200000),
('00000000-0000-0000-0000-000000000001','procesos_metodos','Métodos de pasteurización y conservación',3000000),
('00000000-0000-0000-0000-000000000001','procesos_metodos','Proceso estandarizado de batido y congelación',3000000),
('00000000-0000-0000-0000-000000000001','procesos_metodos','Sistema de empaque y conservación en frío',5000000);

INSERT INTO parametros_nomina (proyecto_id, salario_minimo_legal, auxilio_transporte, porcentaje_salud, porcentaje_pension)
VALUES ('00000000-0000-0000-0000-000000000001',1750905,249095,0.04,0.04);

INSERT INTO empleados_nomina (proyecto_id, rol, salario_basico, dias_liquidados, salario_devengado, horas_extras, recargos_nocturnos, dom_festivo, auxilio_transporte_auto, auxilio_transporte_manual, fondo_solidaridad, retencion_fuente, otras_deducciones, sena, icbf, caja_compensacion, aporte_salud_empleador)
SELECT '00000000-0000-0000-0000-000000000001', rol, salario, dias, salario, 0, recargo, 0, FALSE, auxilio, 0, 0, 0, sena, icbf, caja, salud
FROM (VALUES
('Operador de máquina de helado',1750905::numeric,26::numeric,97225.734375::numeric,249095::numeric,NULL::numeric,NULL::numeric,NULL::numeric,NULL::numeric),
('Operador de máquina de helado',1750905,26,97225.734375,249095,NULL,NULL,NULL,NULL),
('Operador de pasteurizador y mezclado',1750905,26,0,249095,NULL,NULL,NULL,NULL),
('Operador de empaque',1750905,26,97225.734375,249095,NULL,NULL,NULL,NULL),
('Operador de empaque',1750905,26,97225.734375,249095,NULL,NULL,NULL,NULL),
('Auxiliar en línea',1750905,26,97225.734375,249095,NULL,NULL,NULL,NULL),
('Auxiliar en línea',1750905,26,97225.734375,249095,NULL,NULL,NULL,NULL),
('Supervisor de producción',2626357.5,26,0,249095,NULL,NULL,NULL,NULL),
('Inspector sanitario interno',2101086,22,0,249095,NULL,NULL,NULL,NULL),
('Analista de calidad e inocuidad',2451267,22,0,249095,NULL,NULL,NULL,NULL),
('Técnico de mantenimiento mecánico',2188631.25,26,121532.16796875,249095,NULL,NULL,NULL,NULL),
('Técnico de mantenimiento mecánico',2188631.25,26,121532.16796875,249095,NULL,NULL,NULL,NULL),
('Técnico eléctrico/electrónico',2188631.25,26,121532.16796875,249095,NULL,NULL,NULL,NULL),
('Técnico eléctrico/electrónico',2188631.25,26,121532.16796875,249095,NULL,NULL,NULL,NULL),
('Encargado de almacén y frío',2013540.75,26,111809.59453125,249095,NULL,NULL,NULL,NULL),
('Encargado de almacén y frío',2013540.75,26,111809.59453125,249095,NULL,NULL,NULL,NULL),
('Conductor de distribución',2188631.25,26,0,249095,NULL,NULL,NULL,NULL),
('Ayudante de distribución',1750905,26,0,249095,NULL,NULL,NULL,NULL),
('Promocionador',2276176.5,22,0,249095,NULL,NULL,NULL,NULL),
('Secretaria',1925995.5,22,0,249095,NULL,NULL,NULL,NULL),
('Gerente',4377262.5,22,0,0,87545.25,131317.875,175090.5,372067.3125)
) AS rows(rol, salario, dias, recargo, auxilio, sena, icbf, caja, salud);

INSERT INTO inversiones (proyecto_id, concepto, valor) VALUES
('00000000-0000-0000-0000-000000000001','Edificaciones',19000000),('00000000-0000-0000-0000-000000000001','Maquinaria y equipo',29500000),
('00000000-0000-0000-0000-000000000001','Muebles y enseres',770000),('00000000-0000-0000-0000-000000000001','Vehículos',0),
('00000000-0000-0000-0000-000000000001','Equipos de cómputo y telecomunicaciones',26200000),('00000000-0000-0000-0000-000000000001','Diferidos',0);

INSERT INTO capital_trabajo (proyecto_id, mes, total, mano_obra, gastos_admin) VALUES
('00000000-0000-0000-0000-000000000001','Mes 1',30973224,26423224,4550000),
('00000000-0000-0000-0000-000000000001','Mes 2',31113224,26423224,4690000),
('00000000-0000-0000-0000-000000000001','Mes 3',29923224,26423224,3500000);

INSERT INTO materias_primas_proyeccion (proyecto_id, nombre, gramos, costo_proveedor, costo_unidad) VALUES
('00000000-0000-0000-0000-000000000001','Leche entera',80,3883.5,310680),('00000000-0000-0000-0000-000000000001','Leche en polvo entera',40,26,1040),
('00000000-0000-0000-0000-000000000001','Crema de leche',30,200,6000),('00000000-0000-0000-0000-000000000001','Grasa vegetal o animal',5,8.75,43.75),
('00000000-0000-0000-0000-000000000001','Suero',5,125,625),('00000000-0000-0000-0000-000000000001','Azúcar',10,12,120),
('00000000-0000-0000-0000-000000000001','Dextrosa',5,35,175),('00000000-0000-0000-0000-000000000001','Estabilizantes',3,12,36),
('00000000-0000-0000-0000-000000000001','Emulsificantes',2,4,8),('00000000-0000-0000-0000-000000000001','Esencias',5,150,750),
('00000000-0000-0000-0000-000000000001','Crema de ron Medellín 8 años',15,1027.4,15411);

INSERT INTO indicadores_financieros (proyecto_id, tasa_interes_oportunidad, tir, vpn)
VALUES ('00000000-0000-0000-0000-000000000001',0.12,0.4085,145449508);

INSERT INTO proyecciones_anuales (proyecto_id, ano) VALUES
('00000000-0000-0000-0000-000000000001',2025),('00000000-0000-0000-0000-000000000001',2026),('00000000-0000-0000-0000-000000000001',2027),
('00000000-0000-0000-0000-000000000001',2028),('00000000-0000-0000-0000-000000000001',2029),('00000000-0000-0000-0000-000000000001',2030);

INSERT INTO proyeccion_demanda (proyeccion_id, cantidad, ingreso, provision, credito, contado)
SELECT p.id, v.cantidad, v.ingreso, v.provision, v.credito, v.contado FROM proyecciones_anuales p JOIN (VALUES
(2025,9910,69370000,2081100,27748000,41622000),(2026,12883,90181000,2705430,36072400,54108600),
(2027,16747.9,117235300,3517059,46894120,70341180),(2028,18422.69,128958830,3868765,51583532,77375298),
(2029,20264.959,141854713,4255641,56741885,85112828),(2030,22291.455,156040184,4681206,62416074,93624111)
) AS v(ano,cantidad,ingreso,provision,credito,contado) ON p.ano = v.ano AND p.proyecto_id = '00000000-0000-0000-0000-000000000001';

INSERT INTO proyeccion_costos (proyeccion_id, costo_mp_anual, margen_bruto_pct, pago_contado_mp, pago_credito_mp, mano_obra_produccion_anual)
SELECT p.id, v.costo_mp, v.margen, 929249303.5, 2389498209, 165937375.625 FROM proyecciones_anuales p JOIN (VALUES
(2025,3318747512.5,-46.84),(2026,3318747512.5,-35.8),(2027,3318747512.5,-27.31),
(2028,3318747512.5,-24.73),(2029,3318747512.5,-22.4),(2030,3318747512.5,-20.27)
) AS v(ano,costo_mp,margen) ON p.ano=v.ano AND p.proyecto_id='00000000-0000-0000-0000-000000000001';

INSERT INTO proyeccion_cif (proyeccion_id, energia_electrica, agua, total)
SELECT p.id, v.energia, v.agua, v.total FROM proyecciones_anuales p JOIN (VALUES
(2025,1850000,2534808,4384808),(2026,1926035,2638988,4565023),(2027,2005195,2747451,4752646),
(2028,2087609,2860371,4947980),(2029,2173409,2977932,5151342),(2030,2262736,3100325,5363062)
) AS v(ano,energia,agua,total) ON p.ano=v.ano AND p.proyecto_id='00000000-0000-0000-0000-000000000001';

INSERT INTO proyeccion_gastos_admin (proyeccion_id, nomina_administracion, publicidad, total)
SELECT p.id, v.nomina, v.publicidad, v.total FROM proyecciones_anuales p JOIN (VALUES
(2025,72577104,28118124,100695228),(2026,74028646,28680486,102709133),(2027,75509219,29254096,104763315),
(2028,77019403,29839178,106858582),(2029,78559791,30435962,108995753),(2030,80130987,31044681,111175668)
) AS v(ano,nomina,publicidad,total) ON p.ano=v.ano AND p.proyecto_id='00000000-0000-0000-0000-000000000001';

INSERT INTO proyeccion_resultados (proyeccion_id, ventas, costo_mercancia, utilidad_bruta, gastos_admin_ventas, provision_deudas, utilidad_antes_impuestos, impuesto_renta, utilidad_neta, reserva_legal, dividendos, utilidad_neta_final)
SELECT p.id, v.ventas, v.costo, v.bruta, v.gastos, v.provision, v.antes, v.impuesto, v.neta, v.reserva, v.dividendos, v.final FROM proyecciones_anuales p JOIN (VALUES
(2025,69370000,-3484684888,-3415314888,-100695228,-2081100,-3518091216,1231331926,-2286759290,228675929,228675929,-1829407432),
(2026,90181000,-3484684888,-3394503888,-102709133,-2705430,-3499918451,1224971458,-2274946993,227494699,227494699,-1819957594),
(2027,117235300,-3484684888,-3367449588,-104763315,-3517059,-3475729962,1216505487,-2259224476,225922448,225922448,-1807379580),
(2028,128958830,-3484684888,-3355726058,-106858582,-3868765,-3466453405,1213258692,-2253194713,225319471,225319471,-1802555770),
(2029,141854713,-3484684888,-3342830175,-108995753,-4255641,-3456081570,1209628549,-2246453020,224645302,224645302,-1797162416),
(2030,156040184,-3484684888,-3328644704,-111175668,-4681206,-3444501578,1205575552,-2238926025,223892603,223892603,-1791140820)
) AS v(ano,ventas,costo,bruta,gastos,provision,antes,impuesto,neta,reserva,dividendos,final) ON p.ano=v.ano AND p.proyecto_id='00000000-0000-0000-0000-000000000001';

INSERT INTO proyeccion_flujo_caja (proyeccion_id, ventas_contado, total_ingresos, pago_mp_contado, mano_obra, cif, gastos_admin, impuesto_renta, total_egresos, efectivo_generado, inversion_inicial)
SELECT p.id, v.ventas_contado, v.ingresos, v.pago_mp, v.mano_obra, v.cif, v.gastos, v.impuesto, v.egresos, v.efectivo, CASE WHEN p.ano=2025 THEN -167479672 ELSE 0 END FROM proyecciones_anuales p JOIN (VALUES
(2025,41622000,41622000,929249304,165937376,4384808,100695228,-1231331926,-31065211,72687211),
(2026,54108600,54108600,929249304,165937376,4565023,102709133,-1224971458,-22510623,76619223),
(2027,70341180,70341180,929249304,165937376,4752646,104763315,-1216505487,-11802847,82144027),
(2028,77375298,77375298,929249304,165937376,4947980,106858582,-1213258692,-6265451,83640749),
(2029,85112828,85112828,929249304,165937376,5151342,108995753,-1209628549,-294776,85407603),
(2030,93624111,93624111,929249304,165937376,5363062,111175668,-1205575552,6149857,87474254)
) AS v(ano,ventas_contado,ingresos,pago_mp,mano_obra,cif,gastos,impuesto,egresos,efectivo) ON p.ano=v.ano AND p.proyecto_id='00000000-0000-0000-0000-000000000001';

COMMIT;