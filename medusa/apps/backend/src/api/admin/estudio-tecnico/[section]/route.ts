import { MedusaRequest, MedusaResponse } from "@medusajs/framework/http";
import { getEstudioTecnico, isEstudioTecnicoSection } from "../../../../lib/estudio-tecnico";

export async function GET(req: MedusaRequest, res: MedusaResponse) {
  const section = req.params.section;
  if (!isEstudioTecnicoSection(section)) {
    res.status(404).json({ message: "Sección de estudio técnico no encontrada" });
    return;
  }

  try {
    res.json({ data: await getEstudioTecnico(section) });
  } catch (error) {
    console.error("Error leyendo sección del estudio técnico", error);
    res.status(500).json({ message: "No fue posible obtener la sección solicitada" });
  }
}