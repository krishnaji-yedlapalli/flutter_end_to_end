import express, {Request, Response} from "express";
import cors from "cors";
import * as admin from "firebase-admin";
import schoolRoutes from "./features/school/routes/schoolRoutes";

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const app = express();

// Automatically allow cross-origin requests
app.use(cors({origin: true}));

// Add middleware to parse the request body as JSON
app.use(express.json());

// Mount feature routes
app.use("/school", schoolRoutes); // Use school routes

// Example route
app.get("/hello", (req: Request, res: Response) => {
  res.send("Hello from Express on Firebase!");
});

export {app};
