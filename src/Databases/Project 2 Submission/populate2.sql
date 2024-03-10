-- AI suggestions

-- Inserting data into Bakery table
INSERT INTO Bakery (idBakery, Name, Address, ContactInformation, ManagerId)
VALUES
    (1, 'Bakery A', '123 Main St', '123-456-7890', 1),
    (2, 'Bakery B', '456 Elm St', '987-654-3210', NULL);

-- Inserting data into Manager table
INSERT INTO Manager (idManager, Name, ContactInformation)
VALUES
    (1, 'John Doe', '456 Oak St');

-- Inserting data into StaffMember table
INSERT INTO StaffMember (idStaff, Name, DateOfBirth, Address, Gender, Nationality, Role, idBakery)
VALUES
    (1, 'John Doe', '1990-05-15', '456 Oak St', 'Male', 'American', 'Manager', 1),
    (2, 'Jane Smith', '1988-09-22', '789 Pine St', 'Female', 'British', 'Baker', 1),
    (3, 'Alice Johnson', '1995-12-10', '321 Cedar St', 'Female', 'Canadian', 'Cashier', 2);

-- Inserting data into Client table
INSERT INTO Client (idClient, Name, Address, ContactInformation)
VALUES
    (1, 'Client 1', '101 Client St', '111-222-3333'),
    (2, 'Client 2', '202 Customer Ave', '444-555-6666');

-- Inserting data into Feedback table
INSERT INTO Feedback (idFeedback, Rating, Comments, idClient)
VALUES
    (1, 4, 'Great service!', 1),
    (2, 3, 'Could improve cleanliness.', 2);

-- Inserting data into Product table
INSERT INTO Product (idProduct, Name, Description, Price, idBakery)
VALUES
    (1, 'Cake', 'Chocolate cake', 20.00, 1),
    (2, 'Bread', 'Whole wheat bread', 5.50, 2);

-- Inserting data into Factory table
INSERT INTO Factory (idFactory, Name, TotalCapacity, Address)
VALUES
    (1, 'Factory 1', 1500, '789 Factory Rd'),
    (2, 'Factory 2', 2000, '456 Industrial Blvd');
