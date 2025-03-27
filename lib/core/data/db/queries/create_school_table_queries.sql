CREATE TABLE schools (id TEXT PRIMARY KEY, schoolName TEXT, location TEXT, country TEXT, createdDate INTEGER, updatedDate INTEGER);
CREATE TABLE school_details (id TEXT PRIMARY KEY, schoolName TEXT, country TEXT, location TEXT, image TEXT, studentCount INTEGER, employeeCount INTEGER, hostelAvailability INTEGER, createdDate INTEGER, updatedDate INTEGER);
CREATE TABLE students (id TEXT PRIMARY KEY, schoolId TEXT, studentName TEXT, standard TEXT, studentLocation TEXT, createdDate INTEGER, updatedDate INTEGER);
