USE [master]
GO
/****** Object:  Database [AtlasBooks]    Script Date: 29/9/2023 15:15:20 ******/
CREATE DATABASE [AtlasBooks]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AtlasBooks', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\AtlasBooks.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AtlasBooks_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\AtlasBooks_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [AtlasBooks] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AtlasBooks].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [AtlasBooks] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [AtlasBooks] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [AtlasBooks] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [AtlasBooks] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [AtlasBooks] SET ARITHABORT OFF 
GO
ALTER DATABASE [AtlasBooks] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [AtlasBooks] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [AtlasBooks] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [AtlasBooks] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [AtlasBooks] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [AtlasBooks] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [AtlasBooks] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [AtlasBooks] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [AtlasBooks] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [AtlasBooks] SET  DISABLE_BROKER 
GO
ALTER DATABASE [AtlasBooks] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [AtlasBooks] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [AtlasBooks] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [AtlasBooks] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [AtlasBooks] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [AtlasBooks] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [AtlasBooks] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [AtlasBooks] SET RECOVERY FULL 
GO
ALTER DATABASE [AtlasBooks] SET  MULTI_USER 
GO
ALTER DATABASE [AtlasBooks] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [AtlasBooks] SET DB_CHAINING OFF 
GO
ALTER DATABASE [AtlasBooks] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [AtlasBooks] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [AtlasBooks] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [AtlasBooks] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'AtlasBooks', N'ON'
GO
ALTER DATABASE [AtlasBooks] SET QUERY_STORE = ON
GO
ALTER DATABASE [AtlasBooks] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [AtlasBooks]
GO
/****** Object:  UserDefinedFunction [dbo].[allBooksInBranch]    Script Date: 29/9/2023 15:15:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[allBooksInBranch] (@BranchId int, @BookID int, @Title varchar(40))
RETURNS @BookInBranch table (BookID int, Title varchar(40))
AS
BEGIN
	INSERT @BookInBranch
		SELECT BookID, BookName FROM BooksLocations
		WHERE BranchId = @BranchID
	RETURN
END;
GO
/****** Object:  UserDefinedFunction [dbo].[allBooksInLounge]    Script Date: 29/9/2023 15:15:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[allBooksInLounge] (@LoungeId int) 
RETURNS @BooksInLounge table (bookId int, Title varchar(30))
AS
BEGIN
	INSERT @BooksInLounge 
		SELECT BookID, BookName FROM BooksLocations
		WHERE LoungeID = @LoungeID
	RETURN
END;
GO
/****** Object:  UserDefinedFunction [dbo].[allBooksInRack]    Script Date: 29/9/2023 15:15:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[allBooksInRack] (@RackId int) 
RETURNS @BooksInRack table (bookId int, bookName varchar(30))
AS
BEGIN
	INSERT @BooksInRack
		SELECT BookId, BookName FROM BooksLocations
		WHERE RackId = @RackId
	RETURN
END;
GO
/****** Object:  UserDefinedFunction [dbo].[allBooksInSection]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[allBooksInSection] (@SectionId int) 
RETURNS @BooksInSection table (bookId int, BookTitle varchar(40))
AS
BEGIN
	INSERT @BooksInSection
		SELECT BookId, BookName FROM BooksLocations
		WHERE SectionId = @sectionId
	RETURN
END;
GO
/****** Object:  UserDefinedFunction [dbo].[allBooksInShelf]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[allBooksInShelf] (@ShelfId int) 
RETURNS @BooksInShelf table (bookId int, BookTitle varchar(40))
AS
BEGIN
	INSERT @BooksInShelf
		SELECT BookId, BookName FROM BooksLocations
		WHERE ShelfId = @ShelfID
	RETURN
END;
GO
/****** Object:  UserDefinedFunction [dbo].[allBooksInShelvings]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[allBooksInShelvings] (@ShelvingID int) 
RETURNS @BooksInShelvings table (bookId int, Title varchar(40))
AS
BEGIN
	INSERT @BooksInShelvings
		SELECT BookId, BookName FROM BooksLocations
		WHERE ShelvingID = @ShelvingID
	RETURN
END;
GO
/****** Object:  UserDefinedFunction [dbo].[CheckUserRole]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CheckUserRole](@UserID int, @RoleID int) RETURNS bit
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
/****** Object:  UserDefinedFunction [dbo].[getLoanDateDiff]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getLoanDateDiff] (@LoanID int)
RETURNS INT
AS
BEGIN
       DECLARE @LoanDate Datetime = (SELECT LoanDate FROM Loan WHERE LoanID = @LoanID)
	   DECLARE @ReturnDate Datetime = (SELECT ReturnDate FROM Loan WHERE LoanID = @LoanID)

	   RETURN datediff(day, @LoanDate, @ReturnDate);
END
GO
/****** Object:  UserDefinedFunction [dbo].[IsBookAvailable]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsBookAvailable] (@BookID int)
RETURNS BIT
AS 
BEGIN
      RETURN (SELECT IsAvailable from Book WHERE BookID = @BookID);
END 
GO
/****** Object:  UserDefinedFunction [dbo].[SearchBook]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SearchBook] (@BookID int)
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
/****** Object:  UserDefinedFunction [dbo].[searchBooksByName]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[searchBooksByName] (@Title varchar(40))
RETURNS @BooksByName table (bookId int, Title varchar(40), sectionId int)
AS
BEGIN
	INSERT @BooksByName
		SELECT BookID, title, SectionId FROM Book
		WHERE title = @Title
	RETURN
END;
GO
/****** Object:  Table [dbo].[Branches]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branches](
	[BranchID] [int] IDENTITY(1,1) NOT NULL,
	[BranchCode] [varchar](10) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BranchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lounges]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lounges](
	[LoungeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[BranchID] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LoungeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shelvings]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shelvings](
	[ShelvingID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[LoungeID] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ShelvingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shelves]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shelves](
	[ShelfID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[ShelvingID] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ShelfID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sections]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sections](
	[SectionID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[ShelfID] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[SectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Book]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Book](
	[BookID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](40) NOT NULL,
	[Synopsis] [varchar](300) NOT NULL,
	[Rating] [decimal](3, 1) NOT NULL,
	[IsAvailable] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[SectionID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[BooksLocations]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[BooksLocations] 
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
/****** Object:  UserDefinedFunction [dbo].[getBookLocation]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getBookLocation] (@BookID int)
RETURNS TABLE
AS
    RETURN (SELECT BookID, BookName, BranchID, LoungeID, ShelvingID, ShelfID, SectionID FROM BooksLocations WHERE BookID = @BookID);
GO
/****** Object:  Table [dbo].[Loan]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Loan](
	[LoanID] [int] IDENTITY(1,1) NOT NULL,
	[LoanDate] [datetime] NOT NULL,
	[ReturnDate] [datetime] NOT NULL,
	[UserID] [int] NOT NULL,
	[BookID] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LoanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](20) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Identification] [varchar](20) NOT NULL,
	[FirstName] [varchar](20) NOT NULL,
	[Surname] [varchar](20) NOT NULL,
	[Birthdate] [date] NOT NULL,
	[PhoneNumber] [varchar](11) NOT NULL,
	[Email] [varchar](40) NOT NULL,
	[RoleID] [int] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ModifiedAt] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Book]  WITH CHECK ADD  CONSTRAINT [FK_Book_SectionID] FOREIGN KEY([SectionID])
REFERENCES [dbo].[Sections] ([SectionID])
GO
ALTER TABLE [dbo].[Book] CHECK CONSTRAINT [FK_Book_SectionID]
GO
ALTER TABLE [dbo].[Loan]  WITH CHECK ADD  CONSTRAINT [FK_Loan_BookID] FOREIGN KEY([BookID])
REFERENCES [dbo].[Book] ([BookID])
GO
ALTER TABLE [dbo].[Loan] CHECK CONSTRAINT [FK_Loan_BookID]
GO
ALTER TABLE [dbo].[Loan]  WITH CHECK ADD  CONSTRAINT [FK_Loan_UserID] FOREIGN KEY([UserID])
REFERENCES [dbo].[User] ([UserID])
GO
ALTER TABLE [dbo].[Loan] CHECK CONSTRAINT [FK_Loan_UserID]
GO
ALTER TABLE [dbo].[Sections]  WITH CHECK ADD  CONSTRAINT [FK_Sections_ShelfID] FOREIGN KEY([ShelfID])
REFERENCES [dbo].[Shelves] ([ShelfID])
GO
ALTER TABLE [dbo].[Sections] CHECK CONSTRAINT [FK_Sections_ShelfID]
GO
ALTER TABLE [dbo].[Shelves]  WITH CHECK ADD  CONSTRAINT [FK_Shelves_ShelvingID] FOREIGN KEY([ShelvingID])
REFERENCES [dbo].[Shelvings] ([ShelvingID])
GO
ALTER TABLE [dbo].[Shelves] CHECK CONSTRAINT [FK_Shelves_ShelvingID]
GO
ALTER TABLE [dbo].[Shelvings]  WITH CHECK ADD  CONSTRAINT [FK_Shelvings_LoungeID] FOREIGN KEY([LoungeID])
REFERENCES [dbo].[Lounges] ([LoungeID])
GO
ALTER TABLE [dbo].[Shelvings] CHECK CONSTRAINT [FK_Shelvings_LoungeID]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [FK_User_RoleID] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Role] ([RoleID])
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [FK_User_RoleID]
GO
/****** Object:  StoredProcedure [dbo].[delBook]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delBook] @DeleterId int, @BookID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Books SET IsActive = 0, ModifiedAt = getdate()
	WHERE BookID = @BookID
END;
GO
/****** Object:  StoredProcedure [dbo].[delBooks]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delBooks] @DeleterId int, @BookID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Book SET IsActive = 0, ModifiedAt = getdate()
	WHERE BookID = @BookID
END;
GO
/****** Object:  StoredProcedure [dbo].[delBranch]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delBranch] @DeleterId int, @BranchID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Branches set IsActive = 0, ModifiedAt = GETDATE()
	WHERE BranchID = @BranchID
END;
GO
/****** Object:  StoredProcedure [dbo].[delBranches]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delBranches] @DeleterId int, @BranchID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Branches set IsActive = 0, ModifiedAt = GETDATE()
	WHERE BranchID = @BranchID
END;
GO
/****** Object:  StoredProcedure [dbo].[delLounge]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delLounge] @DeleterId int, @LoungeID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator'))=1)
BEGIN
	UPDATE Shelvings SET IsActive = 0, ModifiedAt = getdate()
	WHERE LoungeID = @LoungeID
END;
GO
/****** Object:  StoredProcedure [dbo].[delLounges]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[delLounges] @DeleterId int, @LoungeID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator'))=1)
BEGIN
	UPDATE Shelvings SET IsActive = 0, ModifiedAt = getdate()
	WHERE LoungeID = @LoungeID
END;
GO
/****** Object:  StoredProcedure [dbo].[delSection]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delSection] @DeleterId int, @SectionID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Sections SET IsActive =0, ModifiedAt = getdate()
	WHERE SectionID = @SectionID
END;
GO
/****** Object:  StoredProcedure [dbo].[delSections]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delSections] @DeleterId int, @SectionID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Sections SET IsActive =0, ModifiedAt = getdate()
	WHERE SectionID = @SectionID
END;
GO
/****** Object:  StoredProcedure [dbo].[delShelf]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delShelf] @DeleterId int, @ShelfID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelves SET IsActive = 0, ModifiedAt = getdate()
	WHERE ShelfID = @ShelfID
END;
GO
/****** Object:  StoredProcedure [dbo].[delShelves]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delShelves] @DeleterId int, @ShelfID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelves SET IsActive = 0, ModifiedAt = getdate()
	WHERE ShelfID = @ShelfID
END;
GO
/****** Object:  StoredProcedure [dbo].[delShelving]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delShelving] @DeleterId int, @ShelvingID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelvings SET IsActive =0, ModifiedAt = getdate()
	WHERE ShelvingID = @ShelvingID
END;
GO
/****** Object:  StoredProcedure [dbo].[delShelvings]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[delShelvings] @DeleterId int, @ShelvingID int
AS
if (dbo.checkUserRole(@DeleterId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelvings SET IsActive =0, ModifiedAt = getdate()
	WHERE ShelvingID = @ShelvingID
END;
GO
/****** Object:  StoredProcedure [dbo].[insBook]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Books
CREATE PROCEDURE [dbo].[insBook] @CreatorId int, @SectionId int, @Title varchar(40), @Synopsis varchar (300), @Rating decimal
AS
if (dbo.checkUserRole(@CreatorId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Book (SectionId, Title, Synopsis, Rating)
	VALUES (@SectionId, @Title, @Synopsis, @Rating)
END;
GO
/****** Object:  StoredProcedure [dbo].[insBooks]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insBooks] @CreatorId int, @SectionId int, @Title varchar(40), @Synopsis varchar (300), @Rating decimal
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Book (SectionId, Title, Synopsis, Rating)
	VALUES (@SectionId, @Title, @Synopsis, @Rating)
END;
GO
/****** Object:  StoredProcedure [dbo].[insLounge]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Lounges
CREATE PROCEDURE [dbo].[insLounge] @CreatorId int, @LoungeID varchar(30), @BranchId int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT id FROM Roles WHERE name = 'Administrator'))=1)
BEGIN
	INSERT INTO Lounges(LoungeID, BranchID)
	VALUES (@LoungeID,@BranchID)
END;
GO
/****** Object:  StoredProcedure [dbo].[insLounges]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[insLounges] @CreatorId int, @LoungeID varchar(30), @BranchId int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Administrator'))=1)
BEGIN
	INSERT INTO Lounges(LoungeID, BranchID)
	VALUES (@LoungeID,@BranchID)
END;
GO
/****** Object:  StoredProcedure [dbo].[insSection]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insSection] @CreatorId int, @SectionID varchar(30), @ShelfID int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Sections (SectionID , ShelfID)
	VALUES (@SectionID, @ShelfID)
END;
GO
/****** Object:  StoredProcedure [dbo].[insSections]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Sections
CREATE PROCEDURE [dbo].[insSections] @CreatorId int, @SectionID varchar(30), @ShelfID int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Sections (SectionID , ShelfID)
	VALUES (@SectionID, @ShelfID)
END;
GO
/****** Object:  StoredProcedure [dbo].[insShelf]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insShelf] @CreatorId int,@ShelfID varchar(30), @ShelvingID int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Shelves (ShelfID,ShelvingID)
	VALUES (@ShelfID , @ShelvingID)
END;
GO
/****** Object:  StoredProcedure [dbo].[insShelves]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Shelves
CREATE PROCEDURE [dbo].[insShelves] @CreatorId int,@ShelfID varchar(30), @ShelvingID int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Shelves (ShelfID,ShelvingID)
	VALUES (@ShelfID , @ShelvingID)
END;
GO
/****** Object:  StoredProcedure [dbo].[insShelving]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[insShelving]
@CreatorId int, @ShelvingID varchar(30), @LoungeID int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Shelvings (ShelvingID , LoungeID)
	VALUES (@ShelvingID , @LoungeID)
END;
GO
/****** Object:  StoredProcedure [dbo].[insShelvings]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Shelvings
CREATE PROCEDURE [dbo].[insShelvings]
@CreatorId int, @ShelvingID varchar(30), @LoungeID int
AS
if (dbo.checkUserRole(@CreatorId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	INSERT INTO Shelvings (ShelvingID , LoungeID)
	VALUES (@ShelvingID , @LoungeID)
END;
GO
/****** Object:  StoredProcedure [dbo].[updBook]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updBook] @ModifierId int, @BookID int, 
	@SectionId int = NULL,
	@Title varchar(40) = NULL,
	@Synopsis varchar(300) = NULL,
	@Rating decimal = NULL
AS
if (dbo.checkUserRole(@ModifierId,(SELECT id FROM Roles WHERE name =  'Adminstrator')) = 1)
BEGIN
	if (@SectionId is NULL) SET @SectionId = (SELECT sectionId from Book WHERE BookID = @BookID);
	if (@Title is NULL) SET @Title = (SELECT title from Book WHERE BookID = @BookID);
	if (@Synopsis is NULL) SET @Synopsis = (SELECT synopsis from Book WHERE BookID = @BookID);
	if (@Rating is NULL) SET @Rating = (SELECT rating from Book WHERE BookID = @BookID);
	UPDATE Books SET SectionId = @SectionId, Title = @Title, Synopsis = @Synopsis, Rating = @Rating, ModifiedAt = GETDATE()
	WHERE BookID = @BookID
END;
GO
/****** Object:  StoredProcedure [dbo].[UpdBooks]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdBooks] @ModifierId int, @BookID int, 
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
/****** Object:  StoredProcedure [dbo].[updLounge]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updLounge] @ModifierId int, @LoungeID int, @BranchId int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT id FROM Roles WHERE name = 'Administrator'))=1)
BEGIN
	UPDATE Lounges
	SET BranchID = @BranchId, ModifiedAt= GETDATE()
	WHERE LoungeID = @LoungeID
END;
GO
/****** Object:  StoredProcedure [dbo].[updLounges]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updLounges] @ModifierId int, @LoungeID int, @BranchId int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name = 'Administrator'))=1)
BEGIN
	UPDATE Lounges
	SET BranchID = @BranchId, ModifiedAt= GETDATE()
	WHERE LoungeID = @LoungeID
END;
GO
/****** Object:  StoredProcedure [dbo].[updSection]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updSection] @ModifierId int, @SectionID int, @ShelfID int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Sections SET ShelfID = @ShelfID, ModifiedAt = GETDATE()
	WHERE SectionID = @SectionID
END;
GO
/****** Object:  StoredProcedure [dbo].[updSections]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updSections] @ModifierId int, @SectionID int, @ShelfID int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Sections SET ShelfID = @ShelfID, ModifiedAt = GETDATE()
	WHERE SectionID = @SectionID
END;
GO
/****** Object:  StoredProcedure [dbo].[updShelf]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updShelf] @ModifierId int, @ShelfID int, @ShelvingID int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelves SET ShelvingID = @ShelvingID , ModifiedAt = GETDATE()
	WHERE ShelvingID = @ShelvingID
END;
GO
/****** Object:  StoredProcedure [dbo].[updShelves]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updShelves] @ModifierId int, @ShelfID int, @ShelvingID int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelves SET ShelvingID = @ShelvingID , ModifiedAt = GETDATE()
	WHERE ShelvingID = @ShelvingID
END;
GO
/****** Object:  StoredProcedure [dbo].[updShelving]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updShelving] @ModifierId int, @ShelvingID int, @LoungeID int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT RoleID FROM Role WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelvings SET LoungeID = @LoungeID, ModifiedAt = GETDATE()
	WHERE ShelvingID = @ShelvingID
END;
GO
/****** Object:  StoredProcedure [dbo].[updShelvings]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[updShelvings] @ModifierId int, @ShelvingID int, @LoungeID int 
AS
if (dbo.checkUserRole(@ModifierId,(SELECT id FROM Roles WHERE name = 'Adminstrator')) = 1)
BEGIN
	UPDATE Shelvings SET LoungeID = @LoungeID, ModifiedAt = GETDATE()
	WHERE ShelvingID = @ShelvingID
END;
GO
/****** Object:  StoredProcedure [dbo].[upduser]    Script Date: 29/9/2023 15:15:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[upduser] @ModifierID int, @Id int,
       @FirstName varchar(30)= NULL,
	   @Surname varchar(30)= NULL,
	   @Identification varchar(9) = NULL,
	   @BirthDate datetime = NULL,
	   @Telephone varchar(11) = NULL,
	   @Email varchar(30)= NULL,
	   @RoleID int = NULL 

AS 
IF (dbo.checkUserRole(@ModifierID,(SELECT id FROM Roles WHERE name = 'Adminstrator')) =1)
BEGIN
      UPDATE Users SET FirstName= @FirstName, LastName = @Surname, identification= @Identification, BirthDate= @BirthDate, Telephone= @Telephone, Email= @Email
	  WHERE id=@Id
END;
ELSE
BEGIN 
      IF (dbo.checkUserRole(@ModifierId,(Select id FROM Roles WHERE NAME = 'User')) = 1) AND (@ModifierId = @Id)
      BEGIN 
	        UPDATE Users SET FirstName= @FirstName, Surname= @Surname, identification= @Identification, BirthDate= @BirthDate, Telephone= @Telephone, Email= @Email
			WHERE id=@Id
	  END;
END;
GO
USE [master]
GO
ALTER DATABASE [AtlasBooks] SET  READ_WRITE 
GO
