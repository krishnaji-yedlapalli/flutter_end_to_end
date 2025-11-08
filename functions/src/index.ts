/* eslint-disable */

/**
 * Main entry point for Firebase Cloud Functions.
 * This file imports and re-exports functions from feature modules.
 */

// Import and re-export functions from feature modules
// export * from './features/school';
// export * from './features/student';
// export * from './features/teacher';

// Example of how to import and export a specific function
// import { mySchoolFunction } from './features/school';
// export { mySchoolFunction };

// You can also import and re-export all functions from app.ts if using a single Express app
import {app} from "./app";
import {
  onRequest,
} from "firebase-functions/v2/https";

export const api = onRequest(app);
