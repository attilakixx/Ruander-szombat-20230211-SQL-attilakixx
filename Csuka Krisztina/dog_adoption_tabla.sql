CREATE SCHEMA `dog_adoption` DEFAULT CHARACTER SET utf8 COLLATE utf8_hungarian_ci ;

CREATE TABLE `dog_adoption`.`dog` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `transponder` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `breed` VARCHAR(45) NOT NULL DEFAULT 'mix',
  `sex` TINYINT(2) NOT NULL COMMENT '1:female 2:male',
  `birthdate` DATE NULL,
  `color` VARCHAR(45) NOT NULL,
  `size` VARCHAR(45) NOT NULL,
  `status` TINYINT(1) NULL COMMENT '1:adopted, 2:not adopted,3:reserved',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `transponder_UNIQUE` (`transponder` ASC) );
  
  ALTER TABLE `dog_adoption`.`dog` 
ADD COLUMN `owner_id` VARCHAR(4) NOT NULL AFTER `id`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`, `owner_id`);
;
  
  
CREATE TABLE `dog_adoption`.`owner` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `address` VARCHAR(200) NULL,
  `email` VARCHAR(100) NULL,
  `phone` VARCHAR(45) NULL,
  `status` TINYINT(1) NULL COMMENT '1: adopted, 3:reserved',
  PRIMARY KEY (`id`));
  
  ALTER TABLE `dog_adoption`.`owner` 
ADD COLUMN `owner_id` VARCHAR(4) NOT NULL AFTER `id`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`id`, `owner_id`);
;

CREATE TABLE `dog_adoption`.`basic_vaccination` (
  `transponder` INT NOT NULL,
  `distemper` TINYINT(1) NOT NULL COMMENT '1:yes, 2:no',
  `hepatitis(CVH)` TINYINT(1) NOT NULL COMMENT '1:yes, 2:no',
  `leptospirosis` TINYINT(1) NOT NULL COMMENT '1:yes, 2:no',
  `parvovirosis` TINYINT(1) NOT NULL COMMENT '1:yes, 2:no',
  `rabies` TINYINT(1) NOT NULL COMMENT '1:yes, 2:no',
  PRIMARY KEY (`transponder`));
  
