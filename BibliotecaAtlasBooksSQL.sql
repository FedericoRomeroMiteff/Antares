USE[AtlasBooks]
GO

--Estructura (1)

IF OBJECT_ID('Branches,Lounges,Shelvings,Shelves,Role,User,Sections,Loan,Book') IS NOT NULL
   drop table Branches,Lounges,Shelvings,Shelves,[Role],[User],Sections,Loan,Book;

CREATE TABLE [Branches](
       BranchID      int identity(1,1) not null,
	   BranchCode    varchar(30)       not null,
	   City          varchar(30)       not null,
	   CreatedAt     datetime          not null,
	   ModifiedAt    datetime          not null,
	   IsActive      bit               not null,
	   PRIMARY KEY   (BranchID)
)
GO
CREATE TABLE [Lounges](
       LoungeID      int identity(1,1) not null,
       [Description] varchar(255)      not null,
	   BranchID      int               not null,
	   CreatedAt     datetime          not null,
	   ModifiedAt    datetime          not null,
	   IsActive      bit               not null,
	   PRIMARY KEY   (LoungeID)
)
GO
CREATE TABLE [Shelvings](
       ShelvingID    int identity(1,1) not null,
	   [Description] varchar(255)      not null,
	   LoungeID      int               not null,
	   CreatedAt     datetime          not null,
	   ModifiedAt    datetime          not null,
	   IsActive      bit               not null,
	   PRIMARY KEY   (ShelvingID)
)
GO
CREATE TABLE [Shelves](
       ShelfID       int identity(1,1) not null,
	   [Description] varchar(255)      not null,
	   ShelvingID    int               not null,
	   CreatedAt     datetime          not null,
	   ModifiedAt    datetime          not null,
	   IsActive      bit               not null,
	   PRIMARY KEY   (ShelfID)
)
GO
CREATE TABLE [Sections](
       SectionID     int identity(1,1)  not null,
	   [Description] varchar(255)       not null,
	   ShelfID       int                not null,
	   CreatedAt     datetime           not null,
	   ModifiedAt    datetime           not null,
	   IsActive      bit                not null,
	   PRIMARY KEY   (SectionID)
)
GO
CREATE TABLE [Book](
       BookID        int identity(1,1)  not null,
       Title         varchar(40)        not null,
	   Synopsis      varchar(300)       not null,
	   Rating        decimal(3,1)       not null,
	   IsAvailable   bit                not null,
	   CreatedAt     datetime           not null,
	   ModifiedAt    datetime           not null,
	   IsActive      bit                not null,
	   SectionID     int                not null,
	   PRIMARY KEY  (BookID)
)
GO
CREATE TABLE [Role](
       RoleID        int identity(1,1)  not null,
	   [Name]        varchar(20)        not null,
	   [Description] Varchar(255)       not null,
	   CreatedAt     datetime           not null,
	   ModifiedAt    datetime           not null,
	   IsActive      bit                not null,
	   PRIMARY KEY   (RoleID)
)
GO
CREATE TABLE [User]( 
       UserID        int identity(1,1)  not null,
	   Identification varchar(20)       not null,
	   FirstName     varchar(20)        not null,
	   Surname       varchar(20)        not null,
	   Birthdate     date               not null,
	   PhoneNumber   varchar(11)        not null,
	   Email         varchar(40)        not null,
	   RoleID        int                not null,
	   CreatedAt     datetime           not null,
	   ModifiedAt    datetime           not null,
	   IsActive      bit                not null,
	   PRIMARY KEY   (UserID)
)
GO
CREATE TABLE [Loan](
       LoanID        int identity(1,1) not null,
	   LoanDate      datetime          not null,
	   ReturnDate    datetime          not null,
	   UserID        int               not null,
	   BookID        int               not null,
	   CreatedAt     datetime          not null,
	   ModifiedAt    datetime          not null,
	   IsActive      bit               not null,
	   LoanStatus    int               not null,
	   PRIMARY KEY   (LoanID)
);

ALTER TABLE Shelvings
ADD CONSTRAINT FK_Shelvings_LoungeID
FOREIGN KEY(LoungeID) REFERENCES Lounge (LoungeID)
GO

ALTER TABLE Shelves
ADD CONSTRAINT FK_Shelves_ShelvingID
FOREIGN KEY(ShelvingID) 
REFERENCES Shelvings(ShelvingID);
GO

ALTER TABLE Sections
ADD CONSTRAINT FK_Sections_ShelfID
FOREIGN KEY(ShelfID)
REFERENCES Shelves (ShelfID);
GO

ALTER TABLE Book
ADD CONSTRAINT FK_Book_SectionID
FOREIGN KEY(SectionID)
REFERENCES Sections(SectionID);
GO

ALTER TABLE Loan
ADD CONSTRAINT FK_Loan_UserID
FOREIGN KEY(UserID)
REFERENCES [User] (UserID);
GO

ALTER TABLE Loan
ADD CONSTRAINT FK_Loan_BookID
FOREIGN KEY(BookID)
REFERENCES Book (BookID);
GO

ALTER TABLE [User]
ADD CONSTRAINT FK_User_RoleID
FOREIGN KEY(RoleID)
REFERENCES [Role] (RoleID)
GO

ALTER TABLE Shelvings
ADD CONSTRAINT FK_Shelvings_LoungeID
FOREIGN KEY(LoungeID)
REFERENCES Lounges (LoungeID);
GO
-- Vistas (3)
CREATE VIEW LoanedBooks AS 
	SELECT * FROM Book
	WHERE BookID IN(SELECT BookID FROM Loan WHERE LoanStatus = 1);
GO 
CREATE VIEW AvailableBooks AS 
	SELECT * FROM Book 
	WHERE BookID NOT IN (SELECT BookID FROM Loan WHERE Loanstatus = 1);
GO
CREATE VIEW UsersWithLoans AS 
	SELECT * FROM [User]
	WHERE UserID IN(SELECT UserID FROM Loan WHERE Loanstatus = 1);
GO
CREATE VIEW UsersWithoutLoans AS
	SELECT * FROM [User] 
	WHERE UserID NOT IN(SELECT UserID FROM Loan WHERE LoanStatus = 1);
GO

CREATE VIEW BooksLocations 
AS
SELECT  
        B.BookID , 
		B.Title AS BookName,
		S.SectionID AS SectionId, S.[Description] AS SectionName, 
		SH.ShelfID AS ShelfId, sh.[Description] as ShelfName, 
		SV.ShelvingID AS ShelvingId, SV.[Description] AS ShelvingsName,
		Lo.LoungeID AS LoungeId, Lo.[Description] AS LoungeName,
		Br.BranchID AS BranchId, br.[BranchCode] AS BranchName
FROM   Book AS B
INNER JOIN  SECTIONS AS S ON B.SectionID = S.SectionID AND S.IsActive <>0
INNER JOIN  SHELVES AS SH ON S.ShelfID = SH.ShelfID AND SH.IsActive <>0
INNER JOIN  Shelvings AS SV  ON SV.ShelvingID = SV.ShelvingID AND SV.IsActive <>0
INNER JOIN  LOUNGES AS LO ON SV.LoungeID = LO.LoungeID and LO.IsActive <>0
INNER JOIN  Branches AS BR ON LO.LoungeID = Br.BranchID And br.IsActive<>0
GO

-- Funciones(4)
IF Object_ID('CheckUserRole') IS NOT NULL
    DROP FUNCTION CheckUserRole
GO
CREATE FUNCTION CheckUserRole(@UserID int, @RoleID int) RETURNS bit
BEGIN
	if exists(SELECT * FROM [User] as U
		INNER JOIN Role as R ON U.RoleId = R.RoleID
		WHERE U.UserID =@UserId AND R.RoleID = @RoleID)
	BEGIN
		RETURN 1;
	END;
	RETURN 0;
END;
GO
IF Object_ID('AllBooksInBranch') IS NOT NULL
    DROP FUNCTION AllBooksInBranch
GO
CREATE FUNCTION allBooksInBranch (@BranchId int, @BookID int, @Title varchar(40))
RETURNS @BookInBranch table (BookID int, Title varchar(40))
AS
BEGIN
	INSERT @BookInBranch
		SELECT BookID, BookName FROM BooksLocations
		WHERE BranchId = @BranchID
	RETURN
END;
GO
IF Object_ID('AllBooksInLounge') IS NOT NULL
    DROP FUNCTION AllBooksInLounge
GO
CREATE FUNCTION allBooksInLounge (@LoungeId int) 
RETURNS @BooksInLounge table (bookId int, Title varchar(30))
AS
BEGIN
	INSERT @BooksInLounge 
		SELECT BookID, BookName FROM BooksLocations
		WHERE LoungeID = @LoungeID
	RETURN
END;
GO
IF Object_ID('AllBooksInShelvings') IS NOT NULL
    DROP FUNCTION AllBooksInShelvings
GO
CREATE FUNCTION allBooksInShelvings (@ShelvingID int) 
RETURNS @BooksInShelvings table (bookId int, Title varchar(40))
AS
BEGIN
	INSERT @BooksInShelvings
		SELECT BookId, BookName FROM BooksLocations
		WHERE ShelvingID = @ShelvingID
	RETURN
END;
GO
IF Object_ID('AllBooksInShelf') IS NOT NULL
    DROP FUNCTION AllBooksInShelf
GO
CREATE FUNCTION allBooksInShelf (@ShelfId int) 
RETURNS @BooksInShelf table (bookId int, BookTitle varchar(40))
AS
BEGIN
	INSERT @BooksInShelf
		SELECT BookId, BookName FROM BooksLocations
		WHERE ShelfId = @ShelfID
	RETURN
END;
GO
IF Object_ID('AllBooksInSection') IS NOT NULL
    DROP FUNCTION AllBooksInSection
GO
CREATE FUNCTION allBooksInSection (@SectionId int) 
RETURNS @BooksInSection table (bookId int, BookTitle varchar(40))
AS
BEGIN
	INSERT @BooksInSection
		SELECT BookId, BookName FROM BooksLocations
		WHERE SectionId = @sectionId
	RETURN
END;
GO
IF Object_ID('SearchBooksByName') IS NOT NULL
    DROP FUNCTION SearchBooksByName
GO
CREATE FUNCTION searchBooksByName (@Title varchar(40))
RETURNS @BooksByName table (bookId int, Title varchar(40), sectionId int)
AS
BEGIN
	INSERT @BooksByName
		SELECT BookID, title, SectionId FROM Book
		WHERE title = @Title
	RETURN
END;
GO
IF object_id('SearchBook') IS NOT NULL
    DROP FUNCTION SearchBook
GO
CREATE FUNCTION SearchBook (@BookID int)
RETURNS @Ubication table 
(bookId int, Title varchar(40), 
sectionId int, sectionName varchar(30),
shelfId int, shelfName varchar(30),
rackId int, rackName varchar(30),
roomId int, roomName varchar(30),
branchId int, branchName varchar(30))
BEGIN
	INSERT @Ubication 
		SELECT * FROM BooksLocations
		WHERE BookId = @BookID;
	RETURN
END;
GO
IF object_id('isBookAvailable') IS NOT NULL
    DROP FUNCTION isBookAvailable
GO
CREATE FUNCTION IsBookAvailable (@BookID int)
RETURNS BIT
AS 
BEGIN
      RETURN (SELECT IsAvailable from Book WHERE BookID = @BookID);
END 
GO

IF object_id('getLoanDateDiff') IS NOT NULL
    DROP FUNCTION getLoanDateDiff
GO
CREATE FUNCTION getLoanDateDiff (@LoanID int)
RETURNS INT
AS
BEGIN
       DECLARE @LoanDate Datetime = (SELECT LoanDate FROM Loan WHERE LoanID = @LoanID)
	   DECLARE @ReturnDate Datetime = (SELECT ReturnDate FROM Loan WHERE LoanID = @LoanID)

	   RETURN datediff(day, @LoanDate, @ReturnDate);
END
GO
IF object_id('getbooklocation') is not null
    DROP FUNCTION getbooklocation
GO
CREATE FUNCTION getBookLocation (@BookID int)
RETURNS TABLE
AS
    RETURN (SELECT BookID, BookName, BranchID, LoungeID, ShelvingID, ShelfID, SectionID FROM BooksLocations WHERE BookID = @BookID);
GO
IF object_id('UserHasALoan') is not null
   DROP FUNCTION UserHasALoan
GO
CREATE FUNCTION userHasALoan(@UserID int) RETURNS bit
BEGIN
	if exists(SELECT * FROM Loan
				WHERE userId = @UserID AND LoanStatus = 1)
		RETURN 1;
	RETURN 0;
END;
GO


-- Stored Procedures (2)
---Branches
IF OBJECT_ID('InsBranches') IS NOT NULL
    DROP PROCEDURE InsBranches
GO
CREATE PROCEDURE insBranches @CreatorId int, @BranchCode varchar(30), @City varchar(30)
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Branches (BranchCode, city)
	VALUES (@BranchCode,@City)
END;
GO
IF OBJECT_ID('DelBranches') IS NOT NULL
    DROP PROCEDURE DelBranches
GO
CREATE PROCEDURE delBranches @DeleterId int, @BranchID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Branches set IsActive = 0, ModifiedAt = GETDATE()
	WHERE BranchID = @BranchID
END;
GO
IF OBJECT_ID('UpdBranches') IS NOT NULL
    DROP PROCEDURE UpdBranches
GO
CREATE PROCEDURE updBranches @ModifierId int, @BranchID int, @BranchCode varchar(30) = NULL, @City varchar(30) = NULL
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	if (@BranchCode is  NULL) SET @BranchCode = (SELECT BranchCode FROM Branches WHERE BranchID = @BranchID);
	if (@City is NULL) SET @City = (SELECT city FROM Branches WHERE BranchID = @BranchID);
	UPDATE Branches SET BranchCode = @BranchCode, city = @City, ModifiedAt= GETDATE()
	WHERE BranchID = @BranchID
END;
GO
---Lounges
IF OBJECT_ID('InsLounges') IS NOT NULL
    DROP PROCEDURE InsLounges
GO

CREATE PROCEDURE insLounges @CreatorId int, @LoungeID varchar(30), @BranchId int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Administrator'))=1)
BEGIN
	INSERT INTO Lounges(LoungeID, BranchID)
	VALUES (@LoungeID,@BranchID)
END;
GO
IF OBJECT_ID('DelLounges') IS NOT NULL
    DROP PROCEDURE DelLounges
GO

CREATE PROCEDURE delLounges @DeleterId int, @LoungeID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator'))=1)
BEGIN
	UPDATE Shelvings SET IsActive = 0, ModifiedAt = getdate()
	WHERE LoungeID = @LoungeID
END;
GO
IF OBJECT_ID('UpdLounges') IS NOT NULL
    DROP PROCEDURE UpdLounges
GO
CREATE PROCEDURE updLounges @ModifierId int, @LoungeID int, @BranchId int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name = 'Administrator'))=1)
BEGIN
	UPDATE Lounges
	SET BranchID = @BranchId, ModifiedAt= GETDATE()
	WHERE LoungeID = @LoungeID
END;
GO
---Shelvings
IF OBJECT_ID('InsShelving') IS NOT NULL
    DROP PROCEDURE InsShelving
GO
CREATE PROCEDURE insShelving
@CreatorId int, @ShelvingID varchar(30), @LoungeID int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Shelvings (ShelvingID , LoungeID)
	VALUES (@ShelvingID , @LoungeID)
END;
GO
IF OBJECT_ID('DelShelving') IS NOT NULL
    DROP PROCEDURE DelShelving
GO
CREATE PROCEDURE delShelving @DeleterId int, @ShelvingID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelvings SET IsActive =0, ModifiedAt = getdate()
	WHERE ShelvingID = @ShelvingID
END;
GO
IF OBJECT_ID('UpdShelving') IS NOT NULL
    DROP PROCEDURE UpdShelving
GO
CREATE PROCEDURE updShelving @ModifierId int, @ShelvingID int, @LoungeID int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelvings SET LoungeID = @LoungeID, ModifiedAt = GETDATE()
	WHERE ShelvingID = @ShelvingID
END;
GO
---Shelves
IF OBJECT_ID('InsShelf') IS NOT NULL
    DROP PROCEDURE InsShelf
GO
CREATE PROCEDURE insShelf @CreatorId int,@ShelfID varchar(30), @ShelvingID int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Shelves (ShelfID,ShelvingID)
	VALUES (@ShelfID , @ShelvingID)
END;
GO
IF OBJECT_ID('DelShelf') IS NOT NULL
    DROP PROCEDURE DelShelf
GO
CREATE PROCEDURE delShelf @DeleterId int, @ShelfID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelves SET IsActive = 0, ModifiedAt = getdate()
	WHERE ShelfID = @ShelfID
END;
GO
IF OBJECT_ID('UpdShelf') IS NOT NULL
    DROP PROCEDURE UpdShelf
GO
CREATE PROCEDURE updShelf @ModifierId int, @ShelfID int, @ShelvingID int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelves SET ShelvingID = @ShelvingID , ModifiedAt = GETDATE()
	WHERE ShelvingID = @ShelvingID
END;
GO
---Sections
IF OBJECT_ID('InsSection') IS NOT NULL
    DROP PROCEDURE InsSection
GO
CREATE PROCEDURE insSection @CreatorId int, @SectionID varchar(30), @ShelfID int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Sections (SectionID , ShelfID)
	VALUES (@SectionID, @ShelfID)
END;
GO
IF OBJECT_ID('DelSection') IS NOT NULL
    DROP PROCEDURE DelSection
GO
CREATE PROCEDURE delSection @DeleterId int, @SectionID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Sections SET IsActive =0, ModifiedAt = getdate()
	WHERE SectionID = @SectionID
END;
GO
IF OBJECT_ID('UpdSection') IS NOT NULL
    DROP PROCEDURE UpdSection
GO
CREATE PROCEDURE updSection @ModifierId int, @SectionID int, @ShelfID int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Sections SET ShelfID = @ShelfID, ModifiedAt = GETDATE()
	WHERE SectionID = @SectionID
END;
GO
---Books
IF OBJECT_ID('InsBooks') IS NOT NULL
    DROP PROCEDURE InsBooks
GO
CREATE PROCEDURE insBooks @CreatorId int, @SectionId int, @Title varchar(40), @Synopsis varchar (300), @Rating decimal
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Book (SectionId, Title, Synopsis, Rating)
	VALUES (@SectionId, @Title, @Synopsis, @Rating)
END;
GO
IF OBJECT_ID('DelBooks') IS NOT NULL
    DROP PROCEDURE DelBooks
GO
CREATE PROCEDURE delBooks @DeleterId int, @BookID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Book SET IsActive = 0, ModifiedAt = getdate()
	WHERE BookID = @BookID
END;
GO
IF OBJECT_ID('UpdBooks') IS NOT NULL
    DROP PROCEDURE UpdBooks
GO
CREATE PROCEDURE UpdBooks @ModifierId int, @BookID int, 
	@SectionId int = NULL,
	@Title varchar(40) = NULL,
	@Synopsis varchar(300) = NULL,
	@Rating decimal = NULL
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name =  'Adminstrator')) = 1)
BEGIN
	if (@SectionId is NULL) SET @SectionId = (SELECT sectionId from Book WHERE BookID = @BookID);
	if (@Title is NULL) SET @Title = (SELECT title from Book WHERE BookID = @BookID);
	if (@Synopsis is NULL) SET @Synopsis = (SELECT synopsis from Book WHERE BookID = @BookID);
	if (@Rating is NULL) SET @Rating = (SELECT rating from Book WHERE BookID = @BookID);
	UPDATE Book SET SectionId = @SectionId, Title = @Title, Synopsis = @Synopsis, Rating = @Rating, ModifiedAt = GETDATE()
	WHERE BookID = @BookID
END;
GO

-- Triggers(5)

IF OBJECT_ID('TrigUpdLoan') IS NOT NULL
    DROP TRIGGER TrigUpdLoan
GO
CREATE TRIGGER TrigUpdBranch
ON Loan
FOR UPDATE
AS 
   IF UPDATE(ReturnDate)
      BEGIN
	        DECLARE @UpdReturnDate DATETIME = (SELECT ReturnDate From inserted);

			IF (@UpdReturnDate = GetDate())
			     BEGIN
				       UPDATE Book SET IsAvailable = 1 WHERE BookID = (SELECT BookID FROM inserted)
				 END
	  END
GO

IF OBJECT_ID('TriggerInsertLoan') IS NOT NULL
    DROP TRIGGER TriggerInsertLoan
GO

CREATE TRIGGER TriggerInsertLoan
ON Loan
FOR INSERT
AS
    DECLARE @TriggerInsertUserID int = (SELECT UserID FROM inserted);
	PRINT @TriggerInsertUserID;

	IF (dbo.UserHasALoan(@TriggerInsertUserID)=0)
	    BEGIN 
		      raiserror('El Usuario está en préstamo',16,1);
			  rollback transaction
		END
IF OBJECT_ID('TriggerInsertBookID') IS NOT NULL
    DROP TRIGGER TriggerInsertBookID
GO
CREATE TRIGGER TriggerInsertBookID
ON Loan
FOR INSERT
AS
	DECLARE @TriggerInsertBookID INT = (SELECT BookID FROM inserted);
	IF (dbo.IsBookAvailable(@TriggerInsertBookID)=0)
	    BEGIN
		      RAISERROR('El libro no está disponible',16,1);
			  ROLLBACK TRANSACTION
		END

	UPDATE Book SET IsAvailable = 0 WHERE BookID = (SELECT BookID FROM inserted);
GO

IF OBJECT_ID('TriggerUpdatesBranch') IS NOT NULL
   DROP TRIGGER TrigUpdatesBranches
GO

CREATE TRIGGER TriggerUpdatesBranches
ON Branches
FOR UPDATE
AS
    UPDATE Branches SET ModifiedAt = GETDATE() WHERE BranchID = (SELECT BranchID FROM inserted)
GO

IF OBJECT_ID('TriggerUpdatesLounge') IS NOT NULL
   DROP TRIGGER TrigUpdLounges
GO

CREATE TRIGGER TriggerUpdatesLounge
ON Lounges
FOR UPDATE
AS
    UPDATE Lounges SET ModifiedAt = GETDATE() WHERE LoungeID = (SELECT LoungeID FROM inserted)
GO
IF OBJECT_ID('TriggerUpdatesShelvings') IS NOT NULL
   DROP TRIGGER TriggerUpdatesShelvings
GO

CREATE TRIGGER TriggerUpdatesShelvings
ON Shelvings
FOR UPDATE
AS
    UPDATE Shelvings SET ModifiedAt = GETDATE() WHERE ShelvingID = (SELECT ShelvingID FROM inserted)
GO

IF OBJECT_ID('TriggerUpdatesShelves') IS NOT NULL
   DROP TRIGGER TrigUpdatesShelves
GO

CREATE TRIGGER TriggerUpdatesShelves
ON Shelves
FOR UPDATE
AS
    UPDATE Shelves SET ModifiedAt = GETDATE() WHERE ShelfID = (SELECT ShelfID FROM inserted)
GO



