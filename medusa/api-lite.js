/**
 * API Lite para /store/estudio-tecnico — conexión limpia sin Medusa ni Redis
 * Usa las mismas queries que apps/backend/src/lib/estudio-tecnico.ts
 * Ejecuta: node api-lite.js   (puerto 9000)
 * Requiere: DATABASE_URL en apps/backend/.env y PG en node_modules
 */
require('dotenv').config({ path: require('path').join(__dirname, 'apps/backend/.env') });
const http = require('http');
const { Pool } = require('pg');

const PORT = 9000;
const projectId = '00000000-0000-0000-0000-000000000001';
const pool = new Pool({ connectionString: process.env.DATABASE_URL });

const queries = {
  proyecto: 'SELECT id, nombre_producto AS "nombreProducto", empresa, unidad_masa AS "unidadMasa", masa_total AS "masaTotal", densidad_leche AS "densidadLeche", densidad_crema AS "densidadCrema" FROM proyectos WHERE id = $1',
  ficha: 'SELECT producto, fabricante, modelo, marca, presentacion, descripcion_producto AS "descripcionProducto", especificaciones_tecnicas AS "especificacionesTecnicas", instrucciones_uso AS "instruccionesUso", beneficios, advertencias, composicion, empaque, rotulado, lugar_elaboracion AS "lugarElaboracion", fecha_elaboracion AS "fechaElaboracion", unidad_venta AS "unidadVenta" FROM fichas_tecnicas WHERE proyecto_id = $1',
  materias: 'SELECT id, nombre, unidad, cantidad_requerida AS "cantidadRequerida", descripcion_costo AS "descripcionCosto", costo_unitario AS "costoUnitario" FROM materias_primas WHERE proyecto_id = $1 ORDER BY id',
  empaques: 'SELECT id, nombre, unidad, cantidad_requerida AS "cantidadRequerida", precio_general AS "precioGeneral", descripcion_costo AS "descripcionCosto", costo_unitario AS "costoUnitario" FROM materiales_empaque WHERE proyecto_id = $1 ORDER BY id',
  recursosTangibles: 'SELECT id, nombre, costo, categoria FROM recursos_tangibles WHERE proyecto_id = $1 ORDER BY id',
  recursosIntangibles: 'SELECT id, nombre, costo, categoria FROM recursos_intangibles WHERE proyecto_id = $1 ORDER BY id',
  parametrosNomina: 'SELECT salario_minimo_legal AS "salarioMinimoLegal", auxilio_transporte AS "auxilioTransporte", porcentaje_salud AS "porcentajeSalud", porcentaje_pension AS "porcentajePension" FROM parametros_nomina WHERE proyecto_id = $1',
  empleadosNomina: 'SELECT id, rol, salario_basico AS "salarioBasico", dias_liquidados AS "diasLiquidados", salario_devengado AS "salarioDevengado", horas_extras AS "horasExtras", recargos_nocturnos AS "recargosNocturnos", dom_festivo AS "domFestivo", auxilio_transporte_auto AS "auxilioTransporteAuto", auxilio_transporte_manual AS "auxilioTransporteManual", fondo_solidaridad AS "fondoSolidaridad", retencion_fuente AS "retencionFuente", otras_deducciones AS "otrasDeducciones", sena, icbf, caja_compensacion AS "cajaCompensacion", aporte_salud_empleador AS "aporteSaludEmpleador" FROM empleados_nomina WHERE proyecto_id = $1 ORDER BY id',
  inversiones: 'SELECT concepto, valor FROM inversiones WHERE proyecto_id = $1 ORDER BY id',
  capitalTrabajo: 'SELECT mes, total, mano_obra AS "manoObra", gastos_admin AS "gastosAdmin" FROM capital_trabajo WHERE proyecto_id = $1 ORDER BY id',
  materiasPrimasProyeccion: 'SELECT nombre, gramos, costo_proveedor AS "costoProveedor", costo_unidad AS "costoUnd" FROM materias_primas_proyeccion WHERE proyecto_id = $1 ORDER BY id',
  proyecciones: 'SELECT id, ano FROM proyecciones_anuales WHERE proyecto_id = $1 ORDER BY ano',
  demanda: 'SELECT p.ano, d.cantidad, d.ingreso, d.provision, d.credito, d.contado FROM proyeccion_demanda d JOIN proyecciones_anuales p ON p.id = d.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano',
  costos: 'SELECT p.ano, c.costo_mp_anual AS "costoMpAnual", c.margen_bruto_pct AS "margenBrutoPct", c.pago_contado_mp AS "pagoContadoMp", c.pago_credito_mp AS "pagoCreditoMp", c.mano_obra_produccion_anual AS "manoObraProduccionAnual" FROM proyeccion_costos c JOIN proyecciones_anuales p ON p.id = c.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano',
  cif: 'SELECT p.ano, c.energia_electrica AS "energiaElectrica", c.agua, c.total FROM proyeccion_cif c JOIN proyecciones_anuales p ON p.id = c.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano',
  gastosAdmin: 'SELECT p.ano, g.nomina_administracion AS "nominaAdministracion", g.publicidad, g.total FROM proyeccion_gastos_admin g JOIN proyecciones_anuales p ON p.id = g.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano',
  resultados: 'SELECT p.ano, r.ventas, r.costo_mercancia AS "costoMercancia", r.utilidad_bruta AS "utilidadBruta", r.gastos_admin_ventas AS "gastosAdminVentas", r.provision_deudas AS "provisionDeudas", r.utilidad_antes_impuestos AS "utilidadAntesImpuestos", r.impuesto_renta AS "impuestoRenta", r.utilidad_neta AS "utilidadNeta", r.reserva_legal AS "reservaLegal", r.dividendos, r.utilidad_neta_final AS "utilidadNetaFinal" FROM proyeccion_resultados r JOIN proyecciones_anuales p ON p.id = r.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano',
  flujoCaja: 'SELECT p.ano, f.ventas_contado AS "ventasContado", f.total_ingresos AS "totalIngresos", f.pago_mp_contado AS "pagoMpContado", f.mano_obra AS "manoObra", f.cif, f.gastos_admin AS "gastosAdmin", f.impuesto_renta AS "impuestoRenta", f.total_egresos AS "totalEgresos", f.efectivo_generado AS "efectivoGenerado", f.inversion_inicial AS "inversionInicial" FROM proyeccion_flujo_caja f JOIN proyecciones_anuales p ON p.id = f.proyeccion_id WHERE p.proyecto_id = $1 ORDER BY p.ano',
  indicadores: 'SELECT tasa_interes_oportunidad AS "tasaInteresOportunidad", tir, vpn FROM indicadores_financieros WHERE proyecto_id = $1',
};

function toNumberRows(rows, keys) {
  return rows.map(r => {
    const o = { ...r };
    for (const k of keys) if (o[k] != null && typeof o[k] === 'string') {
      const n = Number(o[k]);
      o[k] = Number.isFinite(n) ? n : o[k];
    }
    return o;
  });
}
async function getEstudioTecnico() {
  const entries = await Promise.all(Object.entries(queries).map(async ([name, sql]) => {
    const result = await pool.query(sql, [projectId]);
    const single = ['proyecto','ficha','parametrosNomina','indicadores'].includes(name);
    let rows = result.rows;
    // pg devuelve NUMERIC como string -> convertir a Number para que el front no haga concatenaciones
    if (name === 'proyecto') rows = toNumberRows(rows, ['masaTotal','densidadLeche','densidadCrema']);
    if (name === 'materias') rows = toNumberRows(rows, ['cantidadRequerida','costoUnitario']);
    if (name === 'empaques') rows = toNumberRows(rows, ['cantidadRequerida','precioGeneral','costoUnitario']);
    if (name === 'recursosTangibles' || name === 'recursosIntangibles') rows = toNumberRows(rows, ['costo']);
    if (name === 'parametrosNomina') rows = toNumberRows(rows, ['salarioMinimoLegal','auxilioTransporte','porcentajeSalud','porcentajePension']);
    if (name === 'empleadosNomina') rows = toNumberRows(rows, ['salarioBasico','diasLiquidados','salarioDevengado','horasExtras','recargosNocturnos','domFestivo','auxilioTransporteManual','fondoSolidaridad','retencionFuente','otrasDeducciones','sena','icbf','cajaCompensacion','aporteSaludEmpleador']);
    if (name === 'inversiones') rows = toNumberRows(rows, ['valor']);
    if (name === 'capitalTrabajo') rows = toNumberRows(rows, ['total','manoObra','gastosAdmin']);
    if (name === 'materiasPrimasProyeccion') rows = toNumberRows(rows, ['gramos','costoProveedor','costoUnd']);
    if (name === 'demanda') rows = toNumberRows(rows, ['cantidad','ingreso','provision','credito','contado','ano']);
    if (name === 'costos') rows = toNumberRows(rows, ['ano','costoMpAnual','margenBrutoPct','pagoContadoMp','pagoCreditoMp','manoObraProduccionAnual']);
    if (name === 'cif') rows = toNumberRows(rows, ['ano','energiaElectrica','agua','total']);
    if (name === 'gastosAdmin') rows = toNumberRows(rows, ['ano','nominaAdministracion','publicidad','total']);
    if (name === 'resultados') rows = toNumberRows(rows, ['ano','ventas','costoMercancia','utilidadBruta','gastosAdminVentas','provisionDeudas','utilidadAntesImpuestos','impuestoRenta','utilidadNeta','reservaLegal','dividendos','utilidadNetaFinal']);
    if (name === 'flujoCaja') rows = toNumberRows(rows, ['ano','ventasContado','totalIngresos','pagoMpContado','manoObra','cif','gastosAdmin','impuestoRenta','totalEgresos','efectivoGenerado','inversionInicial']);
    if (name === 'indicadores') rows = toNumberRows(rows, ['tasaInteresOportunidad','tir','vpn']);
    if (name === 'proyecciones') rows = toNumberRows(rows, ['ano']);
    return [name, single ? (rows[0] ?? null) : rows];
  }));
  return Object.fromEntries(entries);
}

const server = http.createServer(async (req, res) => {
  // CORS limpio para Next.js
  res.setHeader('Access-Control-Allow-Origin', req.headers.origin || 'http://localhost:3000');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, x-publishable-api-key');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Vary', 'Origin');
  if (req.method === 'OPTIONS') { res.writeHead(204); return res.end(); }

  const url = new URL(req.url, `http://${req.headers.host}`);
  const pathname = url.pathname;

  // Salud
  if (pathname === '/health' || pathname === '/') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    return res.end(JSON.stringify({ status: 'ok', projectId }));
  }

  // Auth simple: verifica publishable key existe en api_key (token)
  const pubKey = req.headers['x-publishable-api-key'];
  if (pathname.startsWith('/store/estudio-tecnico')) {
    if (!pubKey) {
      res.writeHead(401, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ message: 'Missing x-publishable-api-key' }));
    }
    try {
      const chk = await pool.query('SELECT 1 FROM api_key WHERE token = $1 LIMIT 1', [pubKey]);
      if (chk.rowCount === 0) {
        res.writeHead(401, { 'Content-Type': 'application/json' });
        return res.end(JSON.stringify({ message: 'Invalid publishable key' }));
      }
    } catch (e) { /* si falla check, deja pasar en dev */ }

    try {
      const data = await getEstudioTecnico();
      res.writeHead(200, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ data }));
    } catch (e) {
      console.error(e);
      res.writeHead(500, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ message: 'Error leyendo estudio tecnico', error: String(e) }));
    }
  }

  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ message: 'Not found' }));
});

server.listen(PORT, () => {
  console.log(`✅ API Lite escuchando en http://localhost:${PORT}`);
  console.log(`   GET http://localhost:${PORT}/store/estudio-tecnico  (header x-publishable-api-key)`);
  console.log(`   Health: http://localhost:${PORT}/health`);
});
