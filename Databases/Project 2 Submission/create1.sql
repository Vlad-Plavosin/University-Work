PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Bakery;
DROP TABLE IF EXISTS StaffMember;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Shift;
DROP TABLE IF EXISTS Task;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Client;
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS InventoryCheck;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Ingredient;
DROP TABLE IF EXISTS Factory;

CREATE TABLE Bakery (
    idBakery INT PRIMARY KEY, 
    Name VARCHAR(50),
    Address VARCHAR(50),
    Establishment VARCHAR(50),
    ContactInformation VARCHAR(50),
    OpeningHour TIME,
    ClosingHour TIME
);

CREATE TABLE StaffMember (
    idStaff INT PRIMARY KEY,
    Name VARCHAR(50),
    DateOfBirth DATE,
    Address VARCHAR(50),
    Gender VARCHAR(50),
    Nationality VARCHAR(50),
    Role VARCHAR(50),
    idBakery INT,
    FOREIGN KEY (idBakery) REFERENCES Bakery(idBakery)
);

CREATE TABLE Payment (
    idPayment INT PRIMARY KEY,
    Type VARCHAR(50),
    Amount REAL,
    PaymentMethod VARCHAR(50),
    TransactionDate DATE,
    idBakery INT,
    idStaff INT,
    FOREIGN KEY (idBakery) REFERENCES Bakery(idBakery),
    FOREIGN KEY (idStaff) REFERENCES StaffMember(idStaff)
);

CREATE TABLE Shift (
    idShift INT PRIMARY KEY,
    ShiftDate DATE,
    StartTime TIME,
    EndTime TIME,
    idStaff INT,
    FOREIGN KEY (idStaff) REFERENCES StaffMember(idStaff)
);

CREATE TABLE Task (
    idTask INT PRIMARY KEY,
    Name VARCHAR(50),
    Difficulty VARCHAR(5),
    Description VARCHAR(50),
    EstimatedDuration INT,
    idStaff INT,
    FOREIGN KEY (idStaff) REFERENCES StaffMember(idStaff)
);

CREATE TABLE Orders (
    idOrder INT PRIMARY KEY,
    Amount INT,
    Price REAL CHECK (Price >= 0), -- Price cannot be negative
    OrderDate DATE,
    DeliveryDate DATE,
    idBakery INT,
    idStaff INT,
    idClient INT,
    FOREIGN KEY (idBakery) REFERENCES Bakery(idBakery),
    FOREIGN KEY (idStaff) REFERENCES StaffMember(idStaff),
    FOREIGN KEY (idClient) REFERENCES Client(idClient)
);

CREATE TABLE Client (
    idClient INTEGER PRIMARY KEY,
    Name VARCHAR(50),
    Address VARCHAR(50),
    ContactInformation VARCHAR(50)
);

CREATE TABLE Feedback (
    idFeedback INT PRIMARY KEY,
    Rating INT,
    Comments VARCHAR(50),
    idClient INT,
    FOREIGN KEY (idClient) REFERENCES Client(idClient)
);

CREATE TABLE InventoryCheck (
    idEntry INT PRIMARY KEY,
    DateOfCheck DATE,
    Quantity INT,
    idBakery INT,
    idStaff INT,
    FOREIGN KEY (idBakery) REFERENCES Bakery(idBakery),
    FOREIGN KEY (idStaff) REFERENCES StaffMember(idStaff)
);

CREATE TABLE Product (
    idProduct INT PRIMARY KEY,
    Name VARCHAR(50),
    Description VARCHAR(50),
    Price REAL,
    idBakery INT,
    FOREIGN KEY (idBakery) REFERENCES Bakery(idBakery)
);

CREATE TABLE Ingredient (
    idIngredient INT PRIMARY KEY,
    Name VARCHAR(50),
    Category VARCHAR(50),
    CountOfOrigin INT,
    UnitPrice REAL,
    idBakery INT,
    idFactory INT,
    FOREIGN KEY (idBakery) REFERENCES Bakery(idBakery),
    FOREIGN KEY (idFactory) REFERENCES Factory(idFactory)
);

CREATE TABLE Factory (
    idFactory INT PRIMARY KEY,
    Name VARCHAR(50),
    TotalCapacity INT CHECK (TotalCapacity > 1000),
    Address VARCHAR(50)
);
