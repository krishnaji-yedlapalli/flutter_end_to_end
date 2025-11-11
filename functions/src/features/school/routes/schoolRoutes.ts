import {Router} from "express";
import studentRoutes from "./studentRoutes";
import {
  createSchoolController,
  getSchoolController,
  updateSchoolController,
  deleteSchoolController,
} from "../controllers/schoolController";

// eslint-disable-next-line new-cap
const router = Router();

// Routes for /school
router.post("/", createSchoolController);
router.get("/:id", getSchoolController);
router.put("/:id", updateSchoolController);
router.delete("/:id", deleteSchoolController);

// Mount student routes under /:schoolId/students
router.use("/:schoolId/students", studentRoutes);

export default router;
