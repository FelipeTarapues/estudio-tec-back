import { MedusaRequest, MedusaResponse } from "@medusajs/framework/http";
import { getEstudioTecnico } from "../../../lib/estudio-tecnico";

export async function GET(_req: MedusaRequest, res: MedusaResponse) {
  try {
    res.json({ data: await getEstudioTecnico() });
  } catch (error) {
    console.error("Error leyendo estudio técnico", error);
    res.status(500).json({ message: "No fue posible obtener el estudio técnico" });
  }
}