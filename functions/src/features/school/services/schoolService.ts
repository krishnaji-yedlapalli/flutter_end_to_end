import {db} from "../../../core/utils/db";
import {School} from "../models/schoolModel";
import * as admin from "firebase-admin";

const schoolsCollection = db.collection("schools");

export const createSchool = async (
  schoolData: Omit<School, "id">,
): Promise<School> => {
  const newSchoolRef = schoolsCollection.doc();
  const schoolToCreate: School = {
    ...schoolData,
    // createdAt: admin.firestore.FieldValue.serverTimestamp(),
    // updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  await newSchoolRef.set(schoolToCreate);
  return {id: newSchoolRef.id, ...schoolToCreate};
};

export const getSchool = async (id: string): Promise<School | null> => {
  const schoolDoc = await schoolsCollection.doc(id).get();
  if (!schoolDoc.exists) {
    return null;
  }
  return {id: schoolDoc.id, ...schoolDoc.data() as School};
};

export const updateSchool = async (
  id: string,
  schoolData: Partial<Omit<School, "id" | "createdAt">>,
): Promise<School | null> => {
  const schoolRef = schoolsCollection.doc(id);
  const schoolToUpdate = {
    ...schoolData,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  await schoolRef.update(schoolToUpdate);
  const updatedSchoolDoc = await schoolRef.get();
  if (!updatedSchoolDoc.exists) {
    return null;
  }
  return {id: updatedSchoolDoc.id, ...updatedSchoolDoc.data() as School};
};

export const deleteSchool = async (id: string): Promise<boolean> => {
  await schoolsCollection.doc(id).delete();
  return true;
};
