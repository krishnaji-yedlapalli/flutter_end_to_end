CREATE TABLE school (schoolId INTEGER PRIMARY KEY, schoolName TEXT, location TEXT, country TEXT);
CREATE TABLE school_details (schoolId INTEGER PRIMARY KEY, schoolName TEXT, country TEXT, location TEXT, image TEXT, studentCount INTEGER, employeeCount INTEGER, hostelAvailability INTEGER);
CREATE TABLE student (id INTEGER PRIMARY KEY, schoolId INTEGER, studentName TEXT, standard TEXT, studentLocation TEXT);
