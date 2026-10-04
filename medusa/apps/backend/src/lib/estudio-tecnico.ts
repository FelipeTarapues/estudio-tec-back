import { Pool } from "pg";

const projectId = "00000000-0000-0000-0000-000000000001";
const pool = new Pool({ connectionString: process.env.DATABASE_URL });

const queries = {
  proyecto: "SELECT id, nombre_producto AS \"nombreProducto\", empresa, unidad_masa AS \"unidadMasa\", masa_total AS \"masaTotal\", densidad_leche AS \"densidadLeche\", densidad_crema AS \"densidadCrema\" FROM proyectos WHERE id = $1",
  ficha: "SELECT producto, fabricante, modelo, marca, presentacion, descripcion_producto AS \"descripcionProducto\", especificaciones_tecnicas AS \"especificacionesTecnicas\", instrucciones_uso AS \"instruccionesUso\", beneficios, advertencias, composicion, empaque, rotulado, lugar_elaboracion AS \"lugarElaboracion\", fecha_elaboracion AS \"fechaElaboracion\", unidad_venta AS \"unidadVenta\" FROM fichas_tecnicas WHERE proyecto_id = $1",
  materias: "SELECT id, nombre, unidad, cantidad_requerida AS \"cantidadRequerida\", descripcion_costo AS \"descripcionCosto\", costo_unitario AS \"costoUnitario\" FROM materias_primas WHERE proyecto_id = $1 ORDER BY id",
  empaques: "SELECT id, nombre, unidad, cantidad_requerida AS \"cantidadRequerida\", precio_general AS \"precioGeneral\", descripcion_costo AS \"descripcionCosto\", costo_unitario AS \"costoUnitario\" FROM materiales_empaque WHERE proyecto_id = $1 ORDER BY id",
  recursosTangibles: "SELECT id, nombre, costo, categoria FROM recursos_tangibles WHERE proyecto_id = $1 ORDER BY id",
  recursosIntangibles: "SELECT id, nombre, costo, categoria FROM recursos_intangibles WHERE proyecto_id = $1 ORDER BY id",
  parametrosNomina: "SELECT salario_minimo_legal AS \"salarioMinimoLegal\", auxilio_transporte AS \"auxilioTransporte\", porcentaje_salud AS \"porcentajeSalud\", porcentaje_pension AS \"porcentajePension\" FROM parametros_nomina WHERE proyecto_id = $1",
  empleadosNomina: "SELECT id, rol, salario_basico AS \"salarioBasico\", dias_liquidados AS \"diasLiquidados\", salario_devengado AS \"salarioDevengado\", horas_extras AS \"horasExtras\", recargos_nocturnos AS \"recargosNocturnos\", dom_festivo AS \"domFestivo\", auxilio_transporte_auto AS \"auxilioTransporteAuto\", auxilio_transporte_manual AS \"auxilioTransporteManual\", fondo_solidaridad AS \"fondoSolidaridad\", retencion_fuente AS \"retencionFuente\", otras_deducciones AS \"otrasDeducciones\", sena, icbf, caja_compensacion AS \"cajaCompensacion\", aporte_salud_empleador AS \"aporteSaludEmpleador\" FROM empleados_nomina WHERE proyecto_id = $1 ORDER BY id",
  inversiones: "SELECT concepto, valor FROM inversiones WHERE proyecto_id = $1 ORDER BY id",
  capitalTrabajo: "SELECT mes, total, mano_obra AS \"manoObra\", gastos_admin AS \"gastosAdmin\" FROM capital_trabajo WHERE proyecto_id = $1 ORDER BY id",
  materiasPrimasProyeccion: "SELECT nombre, gramos, costo_proveedor AS \"costoProveedor\", costo_unidad AS \"costoUnd\" FROM materias_primas_proyeccion WHERE proyecto_id = $1 ORDER BY id",
  proyecciones: "SELECT id, ano FROM proyecciones_anuales WHERE proyecto_id = $1 ORDER BY ano",
  demanda: "SELECT p.ano, d.cantidad, d.ingreso, d.provision, d.credito, d.contado FROM proyeccion_demanda d JOIN proyecciones_anuales p ON p.id = d.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano",
  costos: "SELECT p.ano, c.costo_mp_anual AS \"costoMpAnual\", c.margen_bruto_pct AS \"margenBrutoPct\", c.pago_contado_mp AS \"pagoContadoMp\", c.pago_credito_mp AS \"pagoCreditoMp\", c.mano_obra_produccion_anual AS \"manoObraProduccionAnual\" FROM proyeccion_costos c JOIN proyecciones_anuales p ON p.id = c.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano",
  cif: "SELECT p.ano, c.energia_electrica AS \"energiaElectrica\", c.agua, c.total FROM proyeccion_cif c JOIN proyecciones_anuales p ON p.id = c.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano",
  gastosAdmin: "SELECT p.ano, g.nomina_administracion AS \"nominaAdministracion\", g.publicidad, g.total FROM proyeccion_gastos_admin g JOIN proyecciones_anuales p ON p.id = g.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano",
  resultados: "SELECT p.ano, r.ventas, r.costo_mercancia AS \"costoMercancia\", r.utilidad_bruta AS \"utilidadBruta\", r.gastos_admin_ventas AS \"gastosAdminVentas\", r.provision_deudas AS \"provisionDeudas\", r.utilidad_antes_impuestos AS \"utilidadAntesImpuestos\", r.impuesto_renta AS \"impuestoRenta\", r.utilidad_neta AS \"utilidadNeta\", r.reserva_legal AS \"reservaLegal\", r.dividendos, r.utilidad_neta_final AS \"utilidadNetaFinal\" FROM proyeccion_resultados r JOIN proyecciones_anuales p ON p.id = r.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano",
  flujoCaja: "SELECT p.ano, f.ventas_contado AS \"ventasContado\", f.total_ingresos AS \"totalIngresos\", f.pago_mp_contado AS \"pagoMpContado\", f.mano_obra AS \"manoObra\", f.cif, f.gastos_admin AS \"gastosAdmin\", f.impuesto_renta AS \"impuestoRenta\", f.total_egresos AS \"totalEgresos\", f.efectivo_generado AS \"efectivoGenerado\", f.inversion_inicial AS \"inversionInicial\" FROM proyeccion_flujo_caja f JOIN proyecciones_anuales p ON p.id = f.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano",
  indicadores: "SELECT tasa_interes_oportunidad AS \"tasaInteresOportunidad\", tir, vpn FROM indicadores_financieros WHERE proyecto_id = $1",
} as const;

export type EstudioTecnicoSection = keyof typeof queries;

export function isEstudioTecnicoSection(value: string): value is EstudioTecnicoSection {
  return value in queries;
}

export async function getEstudioTecnico(section?: EstudioTecnicoSection) {
  const sections = section ? [section] : (Object.keys(queries) as EstudioTecnicoSection[]);
  const entries = await Promise.all(sections.map(async (name) => {
    const result = await pool.query(queries[name], [projectId]);
    return [name, name === "proyecto" || name === "ficha" || name === "parametrosNomina" || name === "indicadores" ? result.rows[0] ?? null : result.rows] as const;
  }));

  return Object.fromEntries(entries);
}