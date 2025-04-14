GO
USE master;
GO
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'MilkTeaMeDB')
BEGIN
    DROP DATABASE MilkTeaMeDB;
END
GO
CREATE DATABASE MilkTeaMeDB;
GO
USE MilkTeaMeDB;
GO

-- Product Category Table
CREATE TABLE Category (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(10) UNIQUE NOT NULL CHECK (Name IN ('milktea', 'combo', 'topping'))
);
GO

-- Size Table
CREATE TABLE Size (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(10) UNIQUE NOT NULL CHECK (Name IN ('S', 'M', 'L'))
);

-- Product Table
CREATE TABLE Product (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10,2) NULL,
    CategoryId INT NOT NULL,
    ImageUrl NVARCHAR(500),
    SoldCount INT DEFAULT 0,
    Status VARCHAR(10) CHECK (Status IN ('active', 'inactive', 'deleted')) DEFAULT 'active',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoryId) REFERENCES Category(Id) ON DELETE NO ACTION
);
GO

-- Product Size Table
CREATE TABLE ProductSize (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT NOT NULL,
    SizeId INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Product(Id) ON DELETE CASCADE,
    FOREIGN KEY (SizeId) REFERENCES Size(Id) ON DELETE CASCADE,
    UNIQUE (ProductId, SizeId)
);

-- Product Combo Table
CREATE TABLE ProductCombo (
    ComboId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
	ProductSizeId INT NULL,
    PRIMARY KEY (ComboId, ProductId),
    FOREIGN KEY (ComboId) REFERENCES Product(Id) ON DELETE NO ACTION,
    FOREIGN KEY (ProductId) REFERENCES Product(Id) ON DELETE NO ACTION,
    FOREIGN KEY (ProductSizeId) REFERENCES ProductSize(Id) ON DELETE NO ACTION
);
GO

-- User Table
CREATE TABLE [User] (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL,
    Password NVARCHAR(50) NULL,
    Role VARCHAR(10) CHECK (Role IN ('manager', 'staff', 'customer')),
    Phone NVARCHAR(15) UNIQUE NULL,
    Email NVARCHAR(255) UNIQUE NULL,
    Status VARCHAR(10) CHECK (Status IN ('active', 'inactive', 'resigned')) DEFAULT 'active',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Order Table
CREATE TABLE [Order] (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    TotalPrice DECIMAL(10,2) NOT NULL,
    Status VARCHAR(10) CHECK (Status IN ('pending', 'completed', 'cancelled')) DEFAULT 'pending',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Order Detail Table
CREATE TABLE OrderDetail (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    Price DECIMAL(10,2) NOT NULL,
	SizeId INT NULL,
	ParentId INT NULL,
    FOREIGN KEY (OrderId) REFERENCES [Order](Id) ON DELETE NO ACTION,
    FOREIGN KEY (ProductId) REFERENCES Product(Id) ON DELETE NO ACTION,
	FOREIGN KEY (SizeId) REFERENCES Size(Id) ON DELETE NO ACTION,
	FOREIGN KEY (ParentId) REFERENCES [OrderDetail](Id) ON DELETE NO ACTION
);
GO

-- Payment Method Table
CREATE TABLE PaymentMethod (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(10) UNIQUE NOT NULL CHECK (Name IN ('vnpay', 'cash'))
);
GO

-- Payment Table
CREATE TABLE Payment (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    PaymentMethodId INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    TransactionCode NVARCHAR(50) NULL,
    Status VARCHAR(10) CHECK (Status IN ('pending', 'completed', 'failed')) DEFAULT 'pending',
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (OrderId) REFERENCES [Order](Id) ON DELETE NO ACTION,
    FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethod(Id) ON DELETE NO ACTION
);
GO

-- Sample Data for Category
INSERT INTO Category (Name) VALUES ('milktea'), ('combo'), ('topping');
GO

-- Sample Data for Payment Method
INSERT INTO PaymentMethod (Name) VALUES ('vnpay'), ('cash');
GO

-- Sample Data for Size
INSERT INTO Size (Name) VALUES ('S'), ('M'), ('L');

-- Sample Data for Product
INSERT INTO Product (Name, Description, Price, CategoryId, ImageUrl, Status, SoldCount)
VALUES 
(N'Classic Milk Tea', N'Popular drink with a rich tea flavor and sweet creamy milk, perfect for all ages.', NULL, 1, 'https://toigingiuvedep.vn/wp-content/uploads/2021/06/hinh-anh-tra-sua-dep-ngon.jpeg', 'active', 1),
(N'Matcha Milk Tea', N'Refreshing Japanese matcha green tea with creamy milk for a unique and delicious flavor.', NULL, 1, 'https://cf.shopee.vn/file/115b108e80bd3d48179938d1248ac30b', 'active', 2),
(N'Taro Milk Tea', N'Sweet, creamy, and fragrant taro blended with refreshing milk tea for a delightful drink.', NULL, 1, 'https://th.bing.com/th/id/OIP.WqrCdDU4dwF5q-Dz6D5M2QHaHa?rs=1&pid=ImgDetMain', 'active', 2),
(N'Chocolate Milk Tea', N'Rich chocolate aroma and balanced sweetness with smooth milk tea, an unforgettable experience.', NULL, 1, 'https://th.bing.com/th/id/OIP.l3isdgVDMi6k8rKCdXd02QHaHa?rs=1&pid=ImgDetMain', 'active', 1),
(N'Strawberry Milk Tea', N'Natural strawberry flavor with a sweet and tangy twist, blended with delicious milk tea.', NULL, 1, 'https://png.pngtree.com/png-clipart/20210912/original/pngtree-strawberry-pearl-milk-tea-png-image_6742466.jpg', 'active', 2),
(N'Thai Green Milk Tea', N'Distinctive Thai tea flavor blended with creamy milk for a new and exciting taste.', NULL, 1, 'https://phunuketnoi.com/wp-content/uploads/2021/11/tra-thai-xanh-45645544.jpg', 'active', 3),
(N'Black Tea with Kumquat and Honey', N'Black tea with refreshing kumquat and sweet honey for a revitalizing drink.', NULL, 1, 'https://blog.tiemphonui.com/wp-content/uploads/2022/05/tra-tac-mat-ong-giai-nhiet.jpg', 'active', 1),
(N'Soursop Tea', N'Soursop tea with a balance of natural sourness and sweetness for a refreshing experience.', NULL, 1, 'https://th.bing.com/th/id/OIP.OeyB3Hr4As_Qk_PteLFt9gHaHa?rs=1&pid=ImgDetMain', 'active', 1),

(N'Black Pearl', N'Chewy black pearls made from glutinous rice flour, a perfect addition to milk tea.', 3000, 3, 'https://th.bing.com/th/id/OIP.8pDSylnxgjbjxjWHO-wlsAHaHa?rs=1&pid=ImgDetMain', 'active', 1),
(N'White Pearl', N'Transparent, chewy white pearls, a delightful companion for your milk tea.', 3000, 3, 'https://th.bing.com/th/id/R.9b8db31195f809e2ed31cf886327ca98?...', 'active', 1),
(N'Golden Pearl', N'Golden, shiny pearls paired with sweet syrup for a unique combination.', 6000, 3, 'https://vn-test-11.slatic.net/p/c723e2cc42d44bd07a77122bdbf59b59.jpg', 'active', 0),
(N'Coconut Jelly', N'Crunchy and chewy coconut jelly with various flavors and colors.', 4000, 3, 'https://th.bing.com/th/id/OIP.vLJbaj6AMrSiJrd5CNJmRwHaHV?rs=1&pid=ImgDetMain', 'active', 0),
(N'Flan Cake', N'Soft, creamy flan with a delightful aroma of matcha, egg, or caramel.', 5000, 3, 'https://th.bing.com/th/id/OIP.qCtmYbQFsm3Plju9WqXLpgHaHa?w=600&h=600&rs=1&pid=ImgDetMain', 'active', 0),
(N'Milk Foam', N'Rich, white milk foam added on top of milk tea to enhance flavor.', 3000, 3, 'https://th.bing.com/th/id/OIP.WeLQhOjqGOTtPcwwBNAISgHaHa?rs=1&pid=ImgDetMain', 'active', 0),

(N'Combo Classic', N'1 Classic Milk Tea (M) + 1 Matcha Milk Tea (M)', 65000, 2, 'https://icon-library.com/images/combo-icon/combo-icon-8.jpg', 'active', 0),
(N'Combo Chocolate Matcha', N'1 Chocolate Milk Tea (S) + 1 Matcha Milk Tea (S) + 2 Black Pearls', 80000, 2, 'https://static.vecteezy.com/system/resources/thumbnails/014/435/706/...', 'active', 0),
(N'Combo Thai Green & Soursop', N'1 Thai Green Milk Tea (M) + 1 Soursop Tea (M) + 2 White Pearls', 85000, 2, 'https://icon-library.com/images/combo-icon/combo-icon-0.jpg', 'active', 0),
(N'Combo 3 Milk Tea Flavors', N'1 Taro Milk Tea (M) + 1 Strawberry Milk Tea (M) + 1 Thai Green Milk Tea (M) + 3 Coconut Jellies', 120000, 2, 'https://th.bing.com/th/id/OIP.l7Pa-DvOFOHs_JJ4HN_fKAHaHa?rs=1&pid=ImgDetMain', 'active', 0);
GO

-- Product Size Mapping
INSERT INTO ProductSize (ProductId, SizeId, Price) VALUES
(1, 1, 30000), (1, 2, 35000), (1, 3, 40000),
(2, 1, 35000), (2, 2, 40000), (2, 3, 45000),
(3, 1, 33000), (3, 2, 38000), (3, 3, 43000),
(4, 1, 37000), (4, 2, 42000), (4, 3, 47000),
(5, 1, 34000), (5, 2, 39000), (5, 3, 44000),
(6, 1, 33000), (6, 2, 38000), (6, 3, 43000),
(7, 1, 31000), (7, 2, 36000), (7, 3, 41000),
(8, 1, 30000), (8, 2, 35000), (8, 3, 40000);
GO

-- Combo Product Mapping
INSERT INTO ProductCombo (ComboId, ProductId, Quantity, ProductSizeId) VALUES 
(15, 1, 1, 2), (15, 2, 1, 5), 
(16, 4, 1, 10), (16, 2, 1, 4), (16, 9, 2, null), 
(17, 6, 1, 17), (17, 8, 1, 20), (17, 10, 2, null),
(18, 3, 1, 8), (18, 5, 1, 14), (18, 6, 1, 17), (18, 12, 3, null);
GO

-- Sample Data for User Table
INSERT INTO [User] (Username, Password, Role, Phone, Email, Status)
VALUES 
('manager', '1','manager','0901234567', 'admin1@example.com', 'active'),
('staff', '1','staff','09012345678', 'staff@example.com', 'active'),
('customer', '1','customer','09012345679', 'customer@example.com', 'active');
GO

-- Sample Data for Orders
INSERT INTO [Order] (TotalPrice, Status, CreatedAt, UpdatedAt) VALUES
(63000, 'completed', GETDATE(), GETDATE()),  
(75000, 'completed', DATEADD(DAY, -1, GETDATE()), DATEADD(DAY, -1, GETDATE())),  
(82000, 'completed', DATEADD(DAY, -2, GETDATE()), DATEADD(DAY, -2, GETDATE())),  
(54000, 'completed', DATEADD(DAY, -3, GETDATE()), DATEADD(DAY, -3, GETDATE())),  
(98000, 'completed', DATEADD(DAY, -4, GETDATE()), DATEADD(DAY, -4, GETDATE())),  
(72000, 'completed', DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -5, GETDATE())),  
(89000, 'completed', DATEADD(DAY, -6, GETDATE()), DATEADD(DAY, -6, GETDATE()));  
GO  

-- Sample Data for Order Details
INSERT INTO OrderDetail (OrderId, ProductId, Quantity, Price, SizeId, ParentId) VALUES
(1, 1, 1, 30000, 1, NULL),  
(1, 3, 1, 33000, 2, NULL),

(2, 2, 2, 35000, 1, NULL),  
(2, 6, 1, 38000, 2, NULL),

(3, 5, 1, 34000, 1, NULL),  
(3, 8, 2, 35000, 2, NULL),

(4, 4, 1, 37000, 2, NULL),  
(4, 7, 1, 31000, 3, NULL),

(5, 6, 1, 33000, 1, NULL),  
(5, 9, 3, 4000, NULL, NULL),

(6, 3, 2, 33000, 1, NULL),  
(6, 10, 2, 3000, NULL, NULL),

(7, 2, 1, 35000, 2, NULL),  
(7, 5, 1, 34000, 3, NULL);
GO
