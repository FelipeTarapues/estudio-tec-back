CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS proyectos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre_producto VARCHAR(255) NOT NULL,
  empresa VARCHAR(255) NOT NULL,
  unidad_masa VARCHAR(50) NOT NULL DEFAULT 'unidades',
  masa_total NUMERIC(14, 3) NOT NULL DEFAULT 0,
  densidad_leche NUMERIC(10, 4) NOT NULL DEFAULT 1.03,
  densidad_crema NUMERIC(10, 4) NOT NULL DEFAULT 1.022,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS fichas_tecnicas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL UNIQUE REFERENCES proyectos(id) ON DELETE CASCADE,
  producto TEXT NOT NULL,
  fabricante TEXT NOT NULL,
  modelo TEXT NOT NULL,
  marca TEXT NOT NULL,
  presentacion TEXT NOT NULL,
  descripcion_producto TEXT NOT NULL,
  especificaciones_tecnicas TEXT NOT NULL,
  instrucciones_uso TEXT NOT NULL,
  beneficios TEXT NOT NULL,
  advertencias TEXT NOT NULL,
  composicion TEXT NOT NULL,
  empaque TEXT NOT NULL,
  rotulado TEXT NOT NULL,
  lugar_elaboracion TEXT NOT NULL,
  fecha_elaboracion TEXT NOT NULL,
  unidad_venta TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS materias_primas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
  nombre VARCHAR(255) NOT NULL,
  unidad VARCHAR(50) NOT NULL,
  cantidad_requerida NUMERIC(14, 4) NOT NULL DEFAULT 0,
  descripcion_costo TEXT NOT NULL DEFAULT '',
  costo_unitario NUMERIC(14, 4) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS materiales_empaque (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
  nombre VARCHAR(255) NOT NULL,
  unidad VARCHAR(50) NOT NULL,
  cantidad_requerida NUMERIC(14, 4) NOT NULL DEFAULT 1,
  precio_general NUMERIC(14, 4) NOT NULL DEFAULT 0,
  descripcion_costo TEXT NOT NULL DEFAULT '',
  costo_unitario NUMERIC(14, 4) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS recursos_tangibles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
  categoria VARCHAR(30) NOT NULL CHECK (categoria IN ('maquinaria', 'equipos', 'herramientas', 'infraestructura')),
  nombre VARCHAR(255) NOT NULL,
  costo NUMERIC(14, 4) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS recursos_intangibles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
  categoria VARCHAR(40) NOT NULL CHECK (categoria IN ('softwares', 'conocimiento_tecnico', 'licencias_permisos', 'procesos_metodos')),
  nombre VARCHAR(255) NOT NULL,
  costo NUMERIC(14, 4) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS parametros_nomina (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL UNIQUE REFERENCES proyectos(id) ON DELETE CASCADE,
  salario_minimo_legal NUMERIC(14, 4) NOT NULL,
  auxilio_transporte NUMERIC(14, 4) NOT NULL,
  porcentaje_salud NUMERIC(8, 6) NOT NULL,
  porcentaje_pension NUMERIC(8, 6) NOT NULL
);

CREATE TABLE IF NOT EXISTS empleados_nomina (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
  rol VARCHAR(255) NOT NULL,
  salario_basico NUMERIC(14, 4) NOT NULL,
  dias_liquidados NUMERIC(6, 2) NOT NULL,
  salario_devengado NUMERIC(14, 4) NOT NULL,
  horas_extras NUMERIC(14, 4) NOT NULL DEFAULT 0,
  recargos_nocturnos NUMERIC(14, 4) NOT NULL DEFAULT 0,
  dom_festivo NUMERIC(14, 4) NOT NULL DEFAULT 0,
  auxilio_transporte_auto BOOLEAN NOT NULL DEFAULT TRUE,
  auxilio_transporte_manual NUMERIC(14, 4) NOT NULL DEFAULT 0,
  fondo_solidaridad NUMERIC(14, 4) NOT NULL DEFAULT 0,
  retencion_fuente NUMERIC(14, 4) NOT NULL DEFAULT 0,
  otras_deducciones NUMERIC(14, 4) NOT NULL DEFAULT 0,
  sena NUMERIC(14, 4),
  icbf NUMERIC(14, 4),
  caja_compensacion NUMERIC(14, 4),
  aporte_salud_empleador NUMERIC(14, 4)
);

CREATE TABLE IF NOT EXISTS proyecciones_anuales (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
  ano SMALLINT NOT NULL,
  UNIQUE (proyecto_id, ano)
);

CREATE TABLE IF NOT EXISTS proyeccion_demanda (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyeccion_id UUID NOT NULL UNIQUE REFERENCES proyecciones_anuales(id) ON DELETE CASCADE,
  cantidad NUMERIC(16, 4) NOT NULL,
  ingreso NUMERIC(16, 4) NOT NULL,
  provision NUMERIC(16, 4) NOT NULL,
  credito NUMERIC(16, 4) NOT NULL,
  contado NUMERIC(16, 4) NOT NULL
);

CREATE TABLE IF NOT EXISTS proyeccion_costos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyeccion_id UUID NOT NULL UNIQUE REFERENCES proyecciones_anuales(id) ON DELETE CASCADE,
  costo_mp_anual NUMERIC(18, 4) NOT NULL,
  margen_bruto_pct NUMERIC(10, 4) NOT NULL,
  pago_contado_mp NUMERIC(18, 4) NOT NULL,
  pago_credito_mp NUMERIC(18, 4) NOT NULL,
  mano_obra_produccion_anual NUMERIC(18, 4) NOT NULL
);

CREATE TABLE IF NOT EXISTS proyeccion_cif (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyeccion_id UUID NOT NULL UNIQUE REFERENCES proyecciones_anuales(id) ON DELETE CASCADE,
  energia_electrica NUMERIC(18, 4) NOT NULL,
  agua NUMERIC(18, 4) NOT NULL,
  total NUMERIC(18, 4) NOT NULL
);

CREATE TABLE IF NOT EXISTS proyeccion_gastos_admin (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyeccion_id UUID NOT NULL UNIQUE REFERENCES proyecciones_anuales(id) ON DELETE CASCADE,
  nomina_administracion NUMERIC(18, 4) NOT NULL,
  publicidad NUMERIC(18, 4) NOT NULL,
  total NUMERIC(18, 4) NOT NULL
);

CREATE TABLE IF NOT EXISTS proyeccion_resultados (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyeccion_id UUID NOT NULL UNIQUE REFERENCES proyecciones_anuales(id) ON DELETE CASCADE,
  ventas NUMERIC(18, 4) NOT NULL,
  costo_mercancia NUMERIC(18, 4) NOT NULL,
  utilidad_bruta NUMERIC(18, 4) NOT NULL,
  gastos_admin_ventas NUMERIC(18, 4) NOT NULL,
  provision_deudas NUMERIC(18, 4) NOT NULL,
  utilidad_antes_impuestos NUMERIC(18, 4) NOT NULL,
  impuesto_renta NUMERIC(18, 4) NOT NULL,
  utilidad_neta NUMERIC(18, 4) NOT NULL,
  reserva_legal NUMERIC(18, 4) NOT NULL,
  dividendos NUMERIC(18, 4) NOT NULL,
  utilidad_neta_final NUMERIC(18, 4) NOT NULL
);

CREATE TABLE IF NOT EXISTS proyeccion_flujo_caja (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyeccion_id UUID NOT NULL UNIQUE REFERENCES proyecciones_anuales(id) ON DELETE CASCADE,
  ventas_contado NUMERIC(18, 4) NOT NULL,
  total_ingresos NUMERIC(18, 4) NOT NULL,
  pago_mp_contado NUMERIC(18, 4) NOT NULL,
  mano_obra NUMERIC(18, 4) NOT NULL,
  cif NUMERIC(18, 4) NOT NULL,
  gastos_admin NUMERIC(18, 4) NOT NULL,
  impuesto_renta NUMERIC(18, 4) NOT NULL,
  total_egresos NUMERIC(18, 4) NOT NULL,
  efectivo_generado NUMERIC(18, 4) NOT NULL,
  inversion_inicial NUMERIC(18, 4) NOT NULL
);

CREATE TABLE IF NOT EXISTS inversiones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
  concepto VARCHAR(255) NOT NULL,
  valor NUMERIC(18, 4) NOT NULL
);

CREATE TABLE IF NOT EXISTS capital_trabajo (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
  mes VARCHAR(30) NOT NULL,
  total NUMERIC(18, 4) NOT NULL,
  mano_obra NUMERIC(18, 4) NOT NULL,
  gastos_admin NUMERIC(18, 4) NOT NULL
);

CREATE TABLE IF NOT EXISTS indicadores_financieros (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL UNIQUE REFERENCES proyectos(id) ON DELETE CASCADE,
  tasa_interes_oportunidad NUMERIC(10, 6) NOT NULL,
  tir NUMERIC(10, 6) NOT NULL,
  vpn NUMERIC(18, 4) NOT NULL
);

CREATE TABLE IF NOT EXISTS materias_primas_proyeccion (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proyecto_id UUID NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
  nombre VARCHAR(255) NOT NULL,
  gramos NUMERIC(14, 4) NOT NULL,
  costo_proveedor NUMERIC(14, 4) NOT NULL,
  costo_unidad NUMERIC(18, 4) NOT NULL
);