export type SchoolType = "cbse" | "icse" | "stateBoard";

export interface School {
  id?: string;
  name: string;
  location: string;
  schoolType: SchoolType;
  phone?: string;
  email?: string;
  website?: string;
  addressLine1: string;
  addressLine2?: string; // Optional
  city: string;
  state: string;
  isActive: boolean;
  logoUrl?: string; // Optional
  description?: string; // Optional
  maxCapacity?: number; // Optional
  locallyCreatedAt?: number; // Unix timestamp from client
  locallyUpdatedAt?: number; // Unix timestamp from client
//   createdAt?: admin.firestore.FieldValue; // Server timestamp
//   updatedAt?: admin.firestore.FieldValue; // Server timestamp
}
