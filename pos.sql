SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
---------------------------------------------
-- Schema pos_system
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pos_system` DEFAULT CHARACTER SET latin1 ;
USE `pos_system` ;

-------------------------------------------------------
-- Table `pos_system`.`customer`
DROP TABLE IF EXISTS `pos_system`.`customer` ;
CREATE TABLE IF NOT EXISTS `pos_system`.`customer` (
  `CustomerID` INT(11) NOT NULL,
  `Name` VARCHAR(50) NOT NULL,
  `Address` VARCHAR(120) NULL DEFAULT NULL,
  `PhoneNumber` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-------------------------------------------------------
-- Table `pos_system`.`store`
DROP TABLE IF EXISTS `pos_system`.`store` ;
CREATE TABLE IF NOT EXISTS `pos_system`.`store` (
  `StoreID` INT(11) NOT NULL,
  `Address` VARCHAR(120) NULL DEFAULT NULL,
  `PhoneNumber` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`StoreID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-------------------------------------------------------
-- Table `pos_system`.`manager`
DROP TABLE IF EXISTS `pos_system`.`manager` ;
CREATE TABLE IF NOT EXISTS `pos_system`.`manager` (
  `ManagerID` INT(11) NOT NULL,
  `EmployeeName` VARCHAR(45) NULL DEFAULT NULL,
  `Address` VARCHAR(120) NULL DEFAULT NULL,
  `PhoneNumber` INT(11) NULL DEFAULT NULL,
  `StoreID` INT(11) NOT NULL,
  PRIMARY KEY (`ManagerID`),
  INDEX `StoreID_idx` (`StoreID` ASC) VISIBLE,
  INDEX `ManagerID_idx` (`ManagerID` ASC) VISIBLE,
  CONSTRAINT `StoreIDM`
    FOREIGN KEY (`StoreID`)
    REFERENCES `pos_system`.`store` (`StoreID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `pos_system`.`employee`
DROP TABLE IF EXISTS `pos_system`.`employee` ;
CREATE TABLE IF NOT EXISTS `pos_system`.`employee` (
  `EmployeeID` INT(11) NOT NULL,
  `EmployeeName` VARCHAR(45) NULL DEFAULT NULL,
  `Address` VARCHAR(120) NULL DEFAULT NULL,
  `PhoneNumber` INT(11) NULL DEFAULT NULL,
  `ManagerID` INT(11) NOT NULL,
  `StoreID` INT(11) NOT NULL,
  PRIMARY KEY (`EmployeeID`),
  INDEX `StoreID_idx` (`StoreID` ASC) VISIBLE,
  INDEX `ManagerID_idx` (`ManagerID` ASC) VISIBLE,
  CONSTRAINT `ManagerIDE`
    FOREIGN KEY (`ManagerID`)
    REFERENCES `pos_system`.`manager` (`ManagerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `StoreIDE`
    FOREIGN KEY (`StoreID`)
    REFERENCES `pos_system`.`store` (`StoreID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `pos_system`.`transactions`
DROP TABLE IF EXISTS `pos_system`.`transactions` ;
CREATE TABLE IF NOT EXISTS `pos_system`.`transactions` (
  `TransactionID` INT(11) NOT NULL,
  `FinalCost` INT(11) NOT NULL,
  `OrderDate` DATE NOT NULL,
  `TaxAmount` INT(11) NOT NULL,
  `TotalWithoutTax` INT(11) NOT NULL,
  `TotalItems` INT(11) NOT NULL,
  `EmployeeID` INT(11) NOT NULL,
  `ItemNumber` INT(11) NOT NULL,
  `CustomerID` INT(11) NULL DEFAULT NULL,
  `Cost` INT(11) NOT NULL,
  PRIMARY KEY (`TransactionID`, `EmployeeID`),
  INDEX `EmployeeID_idx` (`EmployeeID` ASC) VISIBLE,
  INDEX `CustomerID_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `CustomerIDT`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `pos_system`.`customer` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `EmployeeIDT`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `pos_system`.`employee` (`EmployeeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `pos_system`.`billing`
DROP TABLE IF EXISTS `pos_system`.`billing` ;
CREATE TABLE IF NOT EXISTS `pos_system`.`billing` (
  `ReceiptNumber` INT(11) NOT NULL,
  `TransactionID` INT(11) NOT NULL,
  `CardType` VARCHAR(10) NULL DEFAULT NULL,
  `CashValue` INT(11) NOT NULL,
  `CardPin` INT(11) NULL DEFAULT NULL,
  `CardNumber` INT(11) NOT NULL,
  `CardHolderName` VARCHAR(50) NULL DEFAULT NULL,
  `PaymentType` VARCHAR(10) NOT NULL,
  `BillingAddress` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ReceiptNumber`),
  INDEX `TransactionID_idx` (`TransactionID` ASC) VISIBLE,
  CONSTRAINT `TransactionIDD`
    FOREIGN KEY (`TransactionID`)
    REFERENCES `pos_system`.`transactions` (`TransactionID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `pos_system`.`warehouse`
DROP TABLE IF EXISTS `pos_system`.`warehouse` ;
CREATE TABLE IF NOT EXISTS `pos_system`.`warehouse` (
  `WarehouseID` INT(11) NOT NULL,
  `Address` VARCHAR(120) NULL DEFAULT NULL,
  `PhoneNumber` INT(11) NULL DEFAULT NULL,
  `CustomerID` INT(11) NOT NULL,
  `StoreID` INT(11) NOT NULL,
  PRIMARY KEY (`WarehouseID`),
  INDEX `CustomerID_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `StoreID_idx` (`StoreID` ASC) VISIBLE,
  CONSTRAINT `CustomerIDW`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `pos_system`.`customer` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `StoreIDW`
    FOREIGN KEY (`StoreID`)
    REFERENCES `pos_system`.`store` (`StoreID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `pos_system`.`product`
DROP TABLE IF EXISTS `pos_system`.`product` ;
CREATE TABLE IF NOT EXISTS `pos_system`.`product` (
  `ItemNumber` INT(11) NOT NULL,
  `Description` VARCHAR(45) NULL DEFAULT NULL,
  `Quanitity` INT(11) NOT NULL,
  `Cost` INT(11) NOT NULL,
  `ProductName` VARCHAR(45) NULL DEFAULT NULL,
  `TransactionID` INT(11) NOT NULL,
  `WarehouseID` INT(11) NOT NULL,
  `StoreID` INT(11) NOT NULL,
  PRIMARY KEY (`ItemNumber`, `StoreID`, `WarehouseID`, `TransactionID`),
  INDEX `StoreID_idx` (`StoreID` ASC) VISIBLE,
  INDEX `WarehouseID_idx` (`WarehouseID` ASC) VISIBLE,
  INDEX `TransactionID_idx` (`TransactionID` ASC) VISIBLE,
  CONSTRAINT `StoreIDP`
    FOREIGN KEY (`StoreID`)
    REFERENCES `pos_system`.`store` (`StoreID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `TransactionIDP`
    FOREIGN KEY (`TransactionID`)
    REFERENCES `pos_system`.`transactions` (`TransactionID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `WarehouseIDP`
    FOREIGN KEY (`WarehouseID`)
    REFERENCES `pos_system`.`warehouse` (`WarehouseID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
