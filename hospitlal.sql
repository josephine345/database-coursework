CREATE DATABASE IF NOT EXISTS vhosptial;
USE vhosptial;

-- Geographical Location Table
CREATE TABLE geographical_location (
    Location_ID INT PRIMARY KEY AUTO_INCREMENT,
    Village VARCHAR(100),
    Sub_County VARCHAR(100),
    County VARCHAR(100),
    Region VARCHAR(50),
    Population INT,
    Coordinates VARCHAR(100),
    Malaria_Risk_Level VARCHAR(50),
    Health_Facilities_Count INT,
    ITN_Coverage DECIMAL(5, 2),
    Reported_Cases INT,
    Update_Date DATE
);

-- Facility Type Table
CREATE TABLE facility_type (
    Facility_Type_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Description TEXT,
    Date_Updated DATE
);

-- Health Facility Table
CREATE TABLE health_facility (
    Facility_ID INT PRIMARY KEY AUTO_INCREMENT,
    Facility_Name VARCHAR(100),
    Location_ID INT,
    Facility_Type INT,
    Contact_Details VARCHAR(100),
    Added_Date DATE,
    Updated_Date DATE,
    FOREIGN KEY (Location_ID) REFERENCES geographical_location(Location_ID) ON DELETE CASCADE,
    FOREIGN KEY (Facility_Type) REFERENCES facility_type(Facility_Type_ID) ON DELETE SET NULL
);

-- Resource Table
CREATE TABLE resource (
    Resource_ID INT PRIMARY KEY AUTO_INCREMENT,
    Facility_ID INT,
    Resource_Type VARCHAR(50),
    Quantity INT,
    Description TEXT,
    Added_Date DATE,
    Update_Date DATE,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE
);

-- Supply Chain Table
CREATE TABLE supply_chain (
    Supply_ID INT PRIMARY KEY AUTO_INCREMENT,
    Resource_ID INT,
    Facility_ID INT,
    Quantity_Shipped INT,
    Shipment_Date DATE,
    Expected_Arrival_Date DATE,
    Shipped_By VARCHAR(50),
    Status VARCHAR(50),
    Update_Date DATE,
    FOREIGN KEY (Resource_ID) REFERENCES resource(Resource_ID) ON DELETE CASCADE,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE
);

-- Roles Table
CREATE TABLE roles (
    Role_ID INT PRIMARY KEY AUTO_INCREMENT,
    Role_Name VARCHAR(50),
    Role_Description TEXT,
    Update_Date DATE
);

-- User Table
CREATE TABLE v_user (
    User_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Preferred_Name VARCHAR(50),
    Role_ID INT,
    Username VARCHAR(50),
    Password VARCHAR(100),
    Facility_ID INT,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE,
    FOREIGN KEY (Role_ID) REFERENCES roles(Role_ID) ON DELETE SET NULL
);

-- Epidemiological Data Table
CREATE TABLE epidemiological_data (
    Data_ID INT PRIMARY KEY AUTO_INCREMENT,
    Record_Date DATE,
    Cases_Per_Thousand_People INT,
    Rainfall INT,
    Average_Temperature DECIMAL(5, 2),
    Added_By INT,
    Update_Date DATE,
    FOREIGN KEY (Added_By) REFERENCES v_user(User_ID) ON DELETE SET NULL
);

-- Training Table
CREATE TABLE training (
    Training_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT,
    Training_Type VARCHAR(100),
    Training_Date DATE,
    Completion_Status VARCHAR(50),
    FOREIGN KEY (User_ID) REFERENCES v_user(User_ID) ON DELETE CASCADE
);

-- Patient Data Table
CREATE TABLE patient_data (
    Patient_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Date_of_Birth DATE,
    Gender VARCHAR(10),
    Contact_Info VARCHAR(100),
    Next_of_Kin VARCHAR(100),
    Location_ID INT,
    Date_Added DATE,
    FOREIGN KEY (Location_ID) REFERENCES geographical_location(Location_ID) ON DELETE SET NULL
);

-- Malaria Type Table
CREATE TABLE malaria_type (
    Type_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50),
    Description TEXT,
    Added_Date DATE
);

-- Treatment Table
CREATE TABLE treatment (
    Treatment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Treatment_Name VARCHAR(100),
    Treatment_Description TEXT,
    Dosage VARCHAR(50),
    Side_Effects TEXT,
    Date_Added DATE,
    Update_Date DATE
);

-- Treatment Outcomes Table
CREATE TABLE treatment_outcomes (
    Outcome_ID INT PRIMARY KEY AUTO_INCREMENT,
    Treatment_ID INT,
    Outcome_Description TEXT,
    Added_By INT,
    Added_Date DATE,
    Update_Date DATE,
    FOREIGN KEY (Treatment_ID) REFERENCES treatment(Treatment_ID) ON DELETE CASCADE,
    FOREIGN KEY (Added_By) REFERENCES v_user(User_ID) ON DELETE SET NULL
);

-- Malaria cases Table
CREATE TABLE malaria_cases (
    Case_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Date_of_Diagnosis DATE,
    Type_of_Malaria INT,
    Treatment_ID INT,
    Treatment_Outcome_ID INT,
    Facility_ID INT,
    FOREIGN KEY (Patient_ID) REFERENCES patient_data(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Type_of_Malaria) REFERENCES malaria_type(Type_ID) ON DELETE SET NULL,
    FOREIGN KEY (Treatment_ID) REFERENCES treatment(Treatment_ID) ON DELETE CASCADE,
    FOREIGN KEY (Treatment_Outcome_ID) REFERENCES treatment_outcomes(Outcome_ID) ON DELETE SET NULL,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE
);

-- Laboratory Tests Table
CREATE TABLE laboratory_tests (
    Test_ID INT PRIMARY KEY AUTO_INCREMENT,
    Case_ID INT,
    Test_Name VARCHAR(100),
    Test_Result VARCHAR(100),
    Test_Date DATE,
    Technician_ID INT,
    FOREIGN KEY (Case_ID) REFERENCES malaria_cases(Case_ID) ON DELETE CASCADE,
    FOREIGN KEY (Technician_ID) REFERENCES v_user(User_ID) ON DELETE SET NULL
);

-- System Log Table
CREATE TABLE system_log (
    Log_ID INT PRIMARY KEY AUTO_INCREMENT,
    User_ID INT,
    Activity TEXT,
    Timestamp DATETIME,
    IP_Address VARCHAR(50),
    Location VARCHAR(100),
    FOREIGN KEY (User_ID) REFERENCES v_user(User_ID) ON DELETE CASCADE
);

-- Interventions Table
CREATE TABLE interventions (
    Intervention_ID INT PRIMARY KEY AUTO_INCREMENT,
    Type VARCHAR(100),
    Location_ID INT,
    Start_Date DATE,
    End_Date DATE,
    Outcome VARCHAR(100),
    Date_Added DATE,
    Update_Date DATE,
    FOREIGN KEY (Location_ID) REFERENCES geographical_location(Location_ID) ON DELETE CASCADE
);

-- Visit Record Table
CREATE TABLE visit_record (
    Visit_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Visit_Number INT,
    Visit_Date DATE,
    Date_Added DATE,
    Update_Date DATE,
    Facility_ID INT,
    FOREIGN KEY (Patient_ID) REFERENCES patient_data(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Facility_ID) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE
);

-- Referral Table
CREATE TABLE referral (
    Referral_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT,
    Referred_From INT,
    Referred_To INT,
    Referred_By INT,
    Referral_Date DATE,
    Update_Date DATE,
    Reason TEXT,
    Treatment_Outcome_ID INT,
    FOREIGN KEY (Patient_ID) REFERENCES patient_data(Patient_ID) ON DELETE CASCADE,
    FOREIGN KEY (Referred_From) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE,
    FOREIGN KEY (Referred_To) REFERENCES health_facility(Facility_ID) ON DELETE CASCADE,
    FOREIGN KEY (Referred_By) REFERENCES v_user(User_ID) ON DELETE SET NULL,
    FOREIGN KEY (Treatment_Outcome_ID) REFERENCES treatment_outcomes(Outcome_ID) ON DELETE SET NULL
);


