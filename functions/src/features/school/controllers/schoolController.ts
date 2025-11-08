import {Request, Response} from "express";
import * as schoolService from "../services/schoolService";

export const createSchoolController = async (req: Request, res: Response) => {
  try {
    const schoolData = req.body;
    // Basic validation
    if (!schoolData.name || !schoolData.addressLine1) {
      return res.status(400).send({message: "Name and address are required."});
    }
    const newSchool = await schoolService.createSchool(schoolData);
    return res.status(201).send(newSchool);
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return res.status(500).send({
      message: "Error creating school",
      error: message,
    });
  }
};

export const getSchoolController = async (req: Request, res: Response) => {
  try {
    const {id} = req.params;
    const school = await schoolService.getSchool(id);
    if (!school) {
      return res.status(404).send({message: "School not found."});
    }
    return res.status(200).send(school);
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return res.status(500).send({
      message: "Error fetching school",
      error: message,
    });
  }
};

export const updateSchoolController = async (req: Request, res: Response) => {
  try {
    const {id} = req.params;
    const schoolData = req.body;
    const updatedSchool = await schoolService.updateSchool(id, schoolData);
    if (!updatedSchool) {
      return res.status(404).send({message: "School not found."});
    }
    return res.status(200).send(updatedSchool);
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return res.status(500).send({
      message: "Error updating school",
      error: message,
    });
  }
};

export const deleteSchoolController = async (req: Request, res: Response) => {
  try {
    const {id} = req.params;
    const deleted = await schoolService.deleteSchool(id);
    if (!deleted) {
      return res.status(404).send({
        message: "School not found or could not be deleted.",
      });
    }
    return res.status(204).send(); // No content for successful deletion
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return res.status(500).send({
      message: "Error deleting school",
      error: message,
    });
  }
};
