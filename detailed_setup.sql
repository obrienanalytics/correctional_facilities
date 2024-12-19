﻿USE [master]
GO
/****** Object:  Database [testDB]    Script Date: 12/12/2024 9:24:30 AM ******/
CREATE DATABASE [testDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'testDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\testDB.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'testDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\testDB_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [testDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [testDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [testDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [testDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [testDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [testDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [testDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [testDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [testDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [testDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [testDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [testDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [testDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [testDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [testDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [testDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [testDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [testDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [testDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [testDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [testDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [testDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [testDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [testDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [testDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [testDB] SET  MULTI_USER 
GO
ALTER DATABASE [testDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [testDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [testDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [testDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [testDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [testDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [testDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [testDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [testDB]
GO
/****** Object:  Table [dbo].[cor_facilities]    Script Date: 12/12/2024 9:24:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cor_facilities](
	[FID] [smallint] NOT NULL,
	[FACILITYID] [int] NULL,
	[NAME] [nvarchar](100) NULL,
	[ADDRESS] [nvarchar](100) NULL,
	[CITY] [nvarchar](50) NULL,
	[State_Abbreviation] [nvarchar](50) NULL,
	[ZIP] [int] NULL,
	[ZIP4] [smallint] NULL,
	[TELEPHONE] [nvarchar](50) NULL,
	[TYPE] [nvarchar](50) NULL,
	[STATUS] [nvarchar](50) NULL,
	[POPULATION] [smallint] NULL,
	[COUNTY] [nvarchar](50) NULL,
	[COUNTYFIPS] [int] NULL,
	[COUNTRY] [nvarchar](50) NULL,
	[NAICS_CODE] [int] NULL,
	[NAICS_DESC] [nvarchar](50) NULL,
	[SOURCE] [nvarchar](max) NULL,
	[SOURCEDATE] [datetime2](7) NULL,
	[VAL_METHOD] [nvarchar](50) NULL,
	[VAL_DATE] [datetime2](7) NULL,
	[WEBSITE] [nvarchar](250) NULL,
	[SECURELVL] [nvarchar](50) NULL,
	[CAPACITY] [smallint] NULL,
	[SHAPE_Leng] [float] NULL,
	[GlobalID] [nvarchar](50) NULL,
	[CreationDate] [datetime2](7) NULL,
	[Creator] [nvarchar](50) NULL,
	[EditDate] [datetime2](7) NULL,
	[Editor] [nvarchar](50) NULL,
	[SHAPE_Length] [float] NULL,
	[SHAPE_Area] [float] NULL,
 CONSTRAINT [PK_Prison_Boundaries] PRIMARY KEY CLUSTERED 
(
	[FID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[INDEX]    Script Date: 12/12/2024 9:24:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[INDEX](
	[StateID] [int] IDENTITY(1,1) NOT NULL,
	[StateName] [varchar](50) NOT NULL,
	[State_Abbreviation] [char](2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[State_Abbreviation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[state_population]    Script Date: 12/12/2024 9:24:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[state_population](
	[state_abbreviation] [nvarchar](50) NOT NULL,
	[State] [nvarchar](50) NOT NULL,
	[Population] [int] NOT NULL,
 CONSTRAINT [PK_state_population] PRIMARY KEY CLUSTERED 
(
	[state_abbreviation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[suicide]    Script Date: 12/12/2024 9:24:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[suicide](
	[Year] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Deaths] [int] NULL,
	[Age Adjusted Rate] [varchar](50) NULL,
	[URL] [varchar](50) NULL,
	[State_Abbreviation] [char](2) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TestTable]    Script Date: 12/12/2024 9:24:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TestTable](
	[column1] [varchar](100) NULL,
	[column2] [varchar](100) NULL,
	[column3] [varchar](100) NULL,
	[Truth?] [varchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[testprocedure]    Script Date: 12/12/2024 9:24:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[testprocedure]
AS Select * from testtable
GO;
GO
USE [master]
GO
ALTER DATABASE [testDB] SET  READ_WRITE 
GO
