-- MySQL Script generated by MySQL Workbench
-- Sat Aug  3 23:19:02 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ParkingLot_DB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ParkingLot_DB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ParkingLot_DB` DEFAULT CHARACTER SET utf8 ;
USE `ParkingLot_DB` ;

-- -----------------------------------------------------
-- Table `ParkingLot_DB`.`Users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ParkingLot_DB`.`Users` (
  `idUsers` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `persId` INT UNSIGNED NOT NULL,
  `FirstName` VARCHAR(40) NOT NULL,
  `LastName` VARCHAR(45) NOT NULL,
  `Phone` INT NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `SubscriptStart` DATE NOT NULL,
  `SubscriptEnd` DATE NOT NULL,
  `Active` TINYINT NULL,
  PRIMARY KEY (`idUsers`, `persId`),
  UNIQUE INDEX `idUsers_UNIQUE` (`idUsers` ASC) VISIBLE,
  UNIQUE INDEX `persId_UNIQUE` (`persId` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ParkingLot_DB`.`HW_Alive`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ParkingLot_DB`.`HW_Alive` (
  `Fault` TINYINT(1) NOT NULL DEFAULT 0)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ParkingLot_DB`.`Cars`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ParkingLot_DB`.`Cars` (
  `idCars` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `RegistrationID` VARCHAR(11) NOT NULL,
  `Model` VARCHAR(45) NOT NULL,
  `OwnerID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`idCars`),
  UNIQUE INDEX `idCars_UNIQUE` (`idCars` ASC) VISIBLE,
  UNIQUE INDEX `RegistrationID_UNIQUE` (`RegistrationID` ASC) VISIBLE,
  INDEX `OwnerID` (`idCars` ASC, `OwnerID` ASC) INVISIBLE,
  INDEX `OwnerID_idx` (`OwnerID` ASC) VISIBLE,
  CONSTRAINT `OwnerID`
    FOREIGN KEY (`OwnerID`)
    REFERENCES `ParkingLot_DB`.`Users` (`idUsers`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ParkingLot_DB`.`Areas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ParkingLot_DB`.`Areas` (
  `idAreas` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `AreaName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idAreas`),
  UNIQUE INDEX `idAreas_UNIQUE` (`idAreas` ASC) VISIBLE,
  UNIQUE INDEX `AreaName_UNIQUE` (`AreaName` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ParkingLot_DB`.`Gates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ParkingLot_DB`.`Gates` (
  `idGates` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Entrance` TINYINT(1) UNSIGNED NOT NULL,
  `AreaID` INT UNSIGNED NOT NULL,
  `Fault` TINYINT(1) UNSIGNED NOT NULL,
  PRIMARY KEY (`idGates`),
  UNIQUE INDEX `idGates_UNIQUE` (`idGates` ASC) VISIBLE,
  INDEX `AreaID` (`idGates` ASC, `AreaID` ASC) VISIBLE,
  INDEX `AreaID_idx` (`AreaID` ASC) VISIBLE,
  CONSTRAINT `AreaID`
    FOREIGN KEY (`AreaID`)
    REFERENCES `ParkingLot_DB`.`Areas` (`idAreas`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ParkingLot_DB`.`SlotSizes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ParkingLot_DB`.`SlotSizes` (
  `idSlotSizes` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Size` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idSlotSizes`),
  UNIQUE INDEX `idSlotSizes_UNIQUE` (`idSlotSizes` ASC) VISIBLE,
  UNIQUE INDEX `Size_UNIQUE` (`Size` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ParkingLot_DB`.`Borders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ParkingLot_DB`.`Borders` (
  `idBorders` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Violated` TINYINT(1) UNSIGNED NOT NULL,
  PRIMARY KEY (`idBorders`),
  UNIQUE INDEX `idBorders_UNIQUE` (`idBorders` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ParkingLot_DB`.`Slots`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ParkingLot_DB`.`Slots` (
  `idSlots` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Busy` TINYINT(1) UNSIGNED NOT NULL,
  `Area` INT UNSIGNED NOT NULL,
  `SavedFor` INT UNSIGNED NOT NULL,
  `TakenBy` INT UNSIGNED NOT NULL,
  `BorderLeft` INT UNSIGNED NOT NULL,
  `BorderRigth` INT UNSIGNED NOT NULL,
  `Size` INT UNSIGNED NOT NULL,
  `Active` TINYINT(1) UNSIGNED NOT NULL,
  `Fault` TINYINT(1) UNSIGNED NOT NULL,
  PRIMARY KEY (`idSlots`),
  UNIQUE INDEX `idSlots_UNIQUE` (`idSlots` ASC) VISIBLE,
  UNIQUE INDEX `BorderLeft_UNIQUE` (`BorderLeft` ASC) VISIBLE,
  UNIQUE INDEX `BorderRigth_UNIQUE` (`BorderRigth` ASC) INVISIBLE,
  INDEX `Area` (`Area` ASC) VISIBLE,
  INDEX `SavedFor` (`SavedFor` ASC) VISIBLE,
  INDEX `TakenBy` (`TakenBy` ASC) INVISIBLE,
  INDEX `BorderLeft` (`BorderLeft` ASC) INVISIBLE,
  INDEX `BorderRight` (`BorderRigth` ASC) INVISIBLE,
  INDEX `Size` (`Size` ASC) INVISIBLE,
  CONSTRAINT `SavedFor`
    FOREIGN KEY (`SavedFor`)
    REFERENCES `ParkingLot_DB`.`Cars` (`idCars`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `TakenBy`
    FOREIGN KEY (`TakenBy`)
    REFERENCES `ParkingLot_DB`.`Cars` (`idCars`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `BorderL`
    FOREIGN KEY (`BorderLeft`)
    REFERENCES `ParkingLot_DB`.`Borders` (`idBorders`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `BorderR`
    FOREIGN KEY (`BorderRigth`)
    REFERENCES `ParkingLot_DB`.`Borders` (`idBorders`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Size`
    FOREIGN KEY (`Size`)
    REFERENCES `ParkingLot_DB`.`SlotSizes` (`idSlotSizes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Area`
    FOREIGN KEY (`Area`)
    REFERENCES `ParkingLot_DB`.`Areas` (`idAreas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ParkingLot_DB`.`ParkingLog`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ParkingLot_DB`.`ParkingLog` (
  `idParkingLog` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CarID` INT UNSIGNED NOT NULL,
  `SlotID` INT UNSIGNED NOT NULL,
  `Entrance` DATETIME NOT NULL,
  `Exit` DATETIME NOT NULL,
  `ParkingStart` DATETIME NOT NULL,
  `ParkingEnd` DATETIME NOT NULL,
  `SavingStart` DATETIME NOT NULL,
  `SavingEnd` DATETIME NOT NULL,
  `Violation` TINYINT(1) NOT NULL,
  PRIMARY KEY (`idParkingLog`),
  UNIQUE INDEX `idParkingLog_UNIQUE` (`idParkingLog` ASC) VISIBLE,
  INDEX `SlotID` (`SlotID` ASC) INVISIBLE,
  INDEX `CarID` (`CarID` ASC) VISIBLE,
  CONSTRAINT `CarID`
    FOREIGN KEY (`CarID`)
    REFERENCES `ParkingLot_DB`.`Cars` (`idCars`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `SlotID`
    FOREIGN KEY (`SlotID`)
    REFERENCES `ParkingLot_DB`.`Slots` (`idSlots`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
