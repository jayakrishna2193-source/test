create  database jaya;
drop table patients;
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patientname VARCHAR(100),
    age INT,
    gender ENUM('male', 'female', 'others')
);
CREATE TABLE Doctor (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    doctorName VARCHAR(100),
    Specialization VARCHAR(100)
);
drop table Appointments;
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    DoctorID INT,
    AppointmentDate DATE,
    Diagnosis VARCHAR(255),
    Fees DECIMAL(10 , 2 ),
    FOREIGN KEY (Patient_ID)
        REFERENCES Patients (Patient_ID),
    FOREIGN KEY (DoctorID)
        REFERENCES Doctor (DoctorID)
);

iNSERT INTO Patients (patientName, Age, Gender) VALUES
('John Doe', 30, 'Male'),
('Jane Smith', 45, 'Female'),
('Emily Davis', 28, 'Female');

INSERT INTO Doctor (doctorName, Specialization) VALUES
('Dr. Robert Wilson', 'Cardiologist'),
('Dr. Lisa Brown', 'Dermatologist'),
('Dr. Mark Johnson', 'Neurologist');

INSERT INTO Appointments (Patient_ID, DoctorID, AppointmentDate, Diagnosis, Fees) VALUES
( 1, 1, '2024-03-01', 'Hypertension', 200.00),
( 2, 2, '2024-03-05', 'Skin Rash', 150.00),
( 1, 3, '2024-03-10', 'Migraine', 250.00),
( 3, 1, '2024-03-15', 'Chest Pain', 300.00);

-- Write a stored procedure GetPatientAppointments that takes a PatientID as input and returns all appointments for that patient,-- 
 -- including Appointment Date, Doctor Name, Specialization, Diagnosis, and Fees.-- 
 drop procedure gpa;
 delimiter $
 create procedure gpa (patient_id int)
 begin
	select A.appointmentdate,
			d.doctorname,
			D.specialization,
            A.diagnosis,
            A.fees
	from appointments A join doctor d on
    A.doctorid=D.doctorid
    where A.patient_id=patient_id;
 end $
 
 delimiter ;
 call gpa(1);
 
 -- Q 2 
-- Write a stored procedure GetDoctorAppointments that takes a DoctorID as input and returns all appointments for that doctor,
--  including Patient Name, Appointment Date, and Diagnosis.-- 

delimiter $ 
 create procedure gda (doctorid int)
 begin
		select 
        p.patientname,
        A.appointmentdate,
        A.diagnosis
	from appointments A join patients p on A.Patient_ID=p.patient_id
    where A.doctorid=DoctorID;
 end $
 delimiter ;
 call gda(1)
 
 -- Q 3:
-- Write a stored procedure GetAppointmentsInRange that takes two dates as input and returns all appointments within that range, 
-- including Patient Name, Doctor Name, and Diagnosis.

 delimiter $ 
 CREATE PROCEDURE GAInR(StartDate DATE,
    EndDate DATE)
BEGIN
    SELECT 
        A.AppointmentDate,
        P.PatientName,
        D.DoctorName,
        A.Diagnosis
    FROM Appointments A
    JOIN Patients P ON A.Patient_ID = P.Patient_ID
    JOIN Doctor D ON A.DoctorID = D.DoctorID
    WHERE A.AppointmentDate BETWEEN StartDate AND EndDate;
END$

delimiter ;
call GAInr("2024-03-01" , "2024-03-15");

-- Q 4:
-- Write a stored procedure GetTotalEarningsByDoctor that takes a DoctorID as input
--  and returns the total earnings from all appointments for that doctor.

delimiter $
CREATE PROCEDURE TotalEarningsByD
    (DoctorID INT)
BEGIN
    SELECT 
        D.DoctorName,
        SUM(A.Fees) AS TotalEarnings
    FROM Appointments A
    JOIN Doctor D ON A.DoctorID = D.DoctorID
    WHERE A.DoctorID = DoctorID
    GROUP BY D.DoctorName;
END$
delimiter ;
call  TotalEarningsByD(1);

-- Q 5 
-- Write a stored procedure GetMostVisitedDoctor that returns the doctor with the highest number of appointments, 
-- along with the total number of patients seen.

delimiter $
CREATE PROCEDURE GetMostVisitedDoctor()
BEGIN
    SELECT 
		D.DoctorName,
        COUNT(A.AppointmentDate) TotalAppointments,
        COUNT(DISTINCT A.Patient_ID) TotalPatients
    FROM Appointments A
    JOIN Doctor D ON A.DoctorID = D.DoctorID
    GROUP BY D.DoctorName
    ORDER BY  COUNT(A.AppointmentDate)DESC
    limit 1;
END$

call  GetMostVisitedDoctor();