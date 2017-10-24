



-- -----------------------------------------------------------
-- Entity Designer DDL Script for MySQL Server 4.1 and higher
-- -----------------------------------------------------------
-- Date Created: 03/27/2014 10:50:35
-- Generated from EDMX file: D:\Personal\FMS-2013-08-22\FMS\FMS\feeEntityDataModel.edmx
-- Target version: 2.0.0.0
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- NOTE: if the constraint does not exist, an ignorable error will be reported.
-- --------------------------------------------------

--    ALTER TABLE `curracayears` DROP CONSTRAINT `FK_currAcaYear1`;
--    ALTER TABLE `setfees` DROP CONSTRAINT `FK_fr_acaYear`;
--    ALTER TABLE `payfees` DROP CONSTRAINT `FK_fr_acaYear0`;
--    ALTER TABLE `reimbursements` DROP CONSTRAINT `FK_fr_acaYear1`;
--    ALTER TABLE `students` DROP CONSTRAINT `FK_fr_batch`;
--    ALTER TABLE `students` DROP CONSTRAINT `FK_fr_caste`;
--    ALTER TABLE `depts` DROP CONSTRAINT `FK_fr_collegeid`;
--    ALTER TABLE `students` DROP CONSTRAINT `FK_fr_dept`;
--    ALTER TABLE `sems` DROP CONSTRAINT `FK_fr_deptid`;
--    ALTER TABLE `setfees` DROP CONSTRAINT `FK_fr_feeType`;
--    ALTER TABLE `payfees` DROP CONSTRAINT `FK_fr_feeType0`;
--    ALTER TABLE `cheques` DROP CONSTRAINT `FK_fr_payfee`;
--    ALTER TABLE `payfees` DROP CONSTRAINT `FK_fr_paymentType`;
--    ALTER TABLE `students` DROP CONSTRAINT `FK_fr_quota`;
--    ALTER TABLE `users` DROP CONSTRAINT `FK_fr_role`;
--    ALTER TABLE `rolemodulepermissions` DROP CONSTRAINT `FK_fr_role1`;
--    ALTER TABLE `rolemoduleactionpermissions` DROP CONSTRAINT `FK_fr_role2`;
--    ALTER TABLE `rolemoduleactions` DROP CONSTRAINT `FK_fr_rolemodule`;
--    ALTER TABLE `rolemodulepermissions` DROP CONSTRAINT `FK_fr_rolemodule1`;
--    ALTER TABLE `rolemoduleactionpermissions` DROP CONSTRAINT `FK_fr_rolemoduleaction`;
--    ALTER TABLE `students` DROP CONSTRAINT `FK_fr_sem`;
--    ALTER TABLE `setfees` DROP CONSTRAINT `FK_fr_student`;
--    ALTER TABLE `payfees` DROP CONSTRAINT `FK_fr_student0`;
--    ALTER TABLE `reimbursements` DROP CONSTRAINT `FK_fr_student1`;
--    ALTER TABLE `concessions` DROP CONSTRAINT `FK_fr_acayear`;
--    ALTER TABLE `concessions` DROP CONSTRAINT `FK_fr_feetype`;
--    ALTER TABLE `concessions` DROP CONSTRAINT `FK_fr_student`;

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------
SET foreign_key_checks = 0;
    DROP TABLE IF EXISTS `acayears`;
    DROP TABLE IF EXISTS `batches`;
    DROP TABLE IF EXISTS `castes`;
    DROP TABLE IF EXISTS `cheques`;
    DROP TABLE IF EXISTS `colleges`;
    DROP TABLE IF EXISTS `concessions`;
    DROP TABLE IF EXISTS `curracayears`;
    DROP TABLE IF EXISTS `depts`;
    DROP TABLE IF EXISTS `feetypes`;
    DROP TABLE IF EXISTS `payfees`;
    DROP TABLE IF EXISTS `paymenttypes`;
    DROP TABLE IF EXISTS `quotas`;
    DROP TABLE IF EXISTS `reimbursements`;
    DROP TABLE IF EXISTS `rolemoduleactionpermissions`;
    DROP TABLE IF EXISTS `rolemoduleactions`;
    DROP TABLE IF EXISTS `rolemodulepermissions`;
    DROP TABLE IF EXISTS `rolemodules`;
    DROP TABLE IF EXISTS `roles`;
    DROP TABLE IF EXISTS `sems`;
    DROP TABLE IF EXISTS `setfees`;
    DROP TABLE IF EXISTS `students`;
    DROP TABLE IF EXISTS `users`;
SET foreign_key_checks = 1;

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

CREATE TABLE `castes`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`name` varchar (1000) NOT NULL);

ALTER TABLE `castes` ADD PRIMARY KEY (id);




CREATE TABLE `cheques`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`payFeeid` int NOT NULL, 
	`bankName` varchar (1000) NOT NULL, 
	`bankAddress` varchar (1000), 
	`chequenumber` int NOT NULL, 
	`dated` datetime NOT NULL, 
	`status` bool NOT NULL);

ALTER TABLE `cheques` ADD PRIMARY KEY (id);




CREATE TABLE `colleges`(
	`collegeid` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`collegeCode` varchar (1000) NOT NULL, 
	`collegeName` varchar (1000) NOT NULL);

ALTER TABLE `colleges` ADD PRIMARY KEY (collegeid);




CREATE TABLE `concessions`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`amount` int NOT NULL, 
	`remarks` varchar (1000) NOT NULL, 
	`time` datetime NOT NULL, 
	`studentid` int NOT NULL, 
	`acaYearid` int NOT NULL, 
	`feeTypeid` int NOT NULL);

ALTER TABLE `concessions` ADD PRIMARY KEY (id);




CREATE TABLE `curracayears`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`currAcaYearid` int NOT NULL);

ALTER TABLE `curracayears` ADD PRIMARY KEY (id);




CREATE TABLE `depts`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`name` varchar (1000) NOT NULL, 
	`desc` varchar (1000), 
	`duration` smallint NOT NULL, 
	`collegeid` int NOT NULL);

ALTER TABLE `depts` ADD PRIMARY KEY (id);




CREATE TABLE `feetypes`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`type` varchar (1000) NOT NULL, 
	`allowedInstallments` smallint NOT NULL);

ALTER TABLE `feetypes` ADD PRIMARY KEY (id);




CREATE TABLE `payfees`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`studentid` int NOT NULL, 
	`feeTypeid` int NOT NULL, 
	`acaYearid` int NOT NULL, 
	`amount` int NOT NULL, 
	`recieptNo` varchar (1000) NOT NULL, 
	`time` datetime NOT NULL, 
	`paymentTypeid` int NOT NULL);

ALTER TABLE `payfees` ADD PRIMARY KEY (id);




CREATE TABLE `paymenttypes`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`type` varchar (1000) NOT NULL);

ALTER TABLE `paymenttypes` ADD PRIMARY KEY (id);




CREATE TABLE `quotas`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`name` varchar (1000) NOT NULL, 
	`desc` varchar (1000));

ALTER TABLE `quotas` ADD PRIMARY KEY (id);




CREATE TABLE `rolemoduleactionpermissions`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`roleid` int NOT NULL, 
	`rolemoduleactionid` int NOT NULL, 
	`permission` bool NOT NULL);

ALTER TABLE `rolemoduleactionpermissions` ADD PRIMARY KEY (id);




CREATE TABLE `rolemoduleactions`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`rolemoduleid` int NOT NULL, 
	`name` varchar (1000) NOT NULL, 
	`displayname` varchar (1000) NOT NULL);

ALTER TABLE `rolemoduleactions` ADD PRIMARY KEY (id);




CREATE TABLE `rolemodulepermissions`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`roleid` int NOT NULL, 
	`rolemoduleid` int NOT NULL, 
	`permission` bool NOT NULL);

ALTER TABLE `rolemodulepermissions` ADD PRIMARY KEY (id);




CREATE TABLE `rolemodules`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`name` varchar (1000) NOT NULL, 
	`displayname` varchar (1000) NOT NULL);

ALTER TABLE `rolemodules` ADD PRIMARY KEY (id);




CREATE TABLE `roles`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`roleName` varchar (1000) NOT NULL);

ALTER TABLE `roles` ADD PRIMARY KEY (id);




CREATE TABLE `sems`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`name` varchar (1000) NOT NULL, 
	`deptid` int NOT NULL, 
	`desc` varchar (1000));

ALTER TABLE `sems` ADD PRIMARY KEY (id);




CREATE TABLE `setfees`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`studentid` int NOT NULL, 
	`feeTypeid` int NOT NULL, 
	`acaYearid` int NOT NULL, 
	`amount` int NOT NULL);

ALTER TABLE `setfees` ADD PRIMARY KEY (id);




CREATE TABLE `students`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`htno` varchar (1000) NOT NULL, 
	`name` varchar (1000) NOT NULL, 
	`fname` varchar (1000), 
	`casteid` int NOT NULL, 
	`quotaid` int NOT NULL, 
	`batchid` int NOT NULL, 
	`deptid` int NOT NULL, 
	`semid` int NOT NULL, 
	`feeExemption` bool NOT NULL);

ALTER TABLE `students` ADD PRIMARY KEY (id);




CREATE TABLE `users`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`name` varchar (1000) NOT NULL, 
	`password` varchar (1000) NOT NULL, 
	`roleid` int NOT NULL, 
	`username` varchar (1000) NOT NULL);

ALTER TABLE `users` ADD PRIMARY KEY (id);




CREATE TABLE `acayears`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`year` smallint NOT NULL);

ALTER TABLE `acayears` ADD PRIMARY KEY (id);




CREATE TABLE `batches`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`name` smallint NOT NULL);

ALTER TABLE `batches` ADD PRIMARY KEY (id);




CREATE TABLE `reimbursements`(
	`id` int NOT NULL AUTO_INCREMENT UNIQUE, 
	`studentid` int NOT NULL, 
	`acaYearid` int NOT NULL, 
	`epassid` varchar (1000) NOT NULL, 
	`date` datetime NOT NULL, 
	`remarks` varchar (1000), 
	`approved` bool NOT NULL);

ALTER TABLE `reimbursements` ADD PRIMARY KEY (id);






-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on `casteid` in table 'students'

ALTER TABLE `students`
ADD CONSTRAINT `FK_fr_caste`
    FOREIGN KEY (`casteid`)
    REFERENCES `castes`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_caste'

CREATE INDEX `IX_FK_fr_caste` 
    ON `students`
    (`casteid`);

-- Creating foreign key on `payFeeid` in table 'cheques'

ALTER TABLE `cheques`
ADD CONSTRAINT `FK_fr_payfee`
    FOREIGN KEY (`payFeeid`)
    REFERENCES `payfees`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_payfee'

CREATE INDEX `IX_FK_fr_payfee` 
    ON `cheques`
    (`payFeeid`);

-- Creating foreign key on `collegeid` in table 'depts'

ALTER TABLE `depts`
ADD CONSTRAINT `FK_fr_collegeid`
    FOREIGN KEY (`collegeid`)
    REFERENCES `colleges`
        (`collegeid`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_collegeid'

CREATE INDEX `IX_FK_fr_collegeid` 
    ON `depts`
    (`collegeid`);

-- Creating foreign key on `feeTypeid` in table 'concessions'

ALTER TABLE `concessions`
ADD CONSTRAINT `FK_fr_feetype`
    FOREIGN KEY (`feeTypeid`)
    REFERENCES `feetypes`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_feetype'

CREATE INDEX `IX_FK_fr_feetype` 
    ON `concessions`
    (`feeTypeid`);

-- Creating foreign key on `studentid` in table 'concessions'

ALTER TABLE `concessions`
ADD CONSTRAINT `FK_fr_student`
    FOREIGN KEY (`studentid`)
    REFERENCES `students`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_student'

CREATE INDEX `IX_FK_fr_student` 
    ON `concessions`
    (`studentid`);

-- Creating foreign key on `deptid` in table 'students'

ALTER TABLE `students`
ADD CONSTRAINT `FK_fr_dept`
    FOREIGN KEY (`deptid`)
    REFERENCES `depts`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_dept'

CREATE INDEX `IX_FK_fr_dept` 
    ON `students`
    (`deptid`);

-- Creating foreign key on `deptid` in table 'sems'

ALTER TABLE `sems`
ADD CONSTRAINT `FK_fr_deptid`
    FOREIGN KEY (`deptid`)
    REFERENCES `depts`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_deptid'

CREATE INDEX `IX_FK_fr_deptid` 
    ON `sems`
    (`deptid`);

-- Creating foreign key on `feeTypeid` in table 'setfees'

ALTER TABLE `setfees`
ADD CONSTRAINT `FK_fr_feeType`
    FOREIGN KEY (`feeTypeid`)
    REFERENCES `feetypes`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_feeType'

CREATE INDEX `IX_FK_fr_feeType` 
    ON `setfees`
    (`feeTypeid`);

-- Creating foreign key on `feeTypeid` in table 'payfees'

ALTER TABLE `payfees`
ADD CONSTRAINT `FK_fr_feeType0`
    FOREIGN KEY (`feeTypeid`)
    REFERENCES `feetypes`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_feeType0'

CREATE INDEX `IX_FK_fr_feeType0` 
    ON `payfees`
    (`feeTypeid`);

-- Creating foreign key on `paymentTypeid` in table 'payfees'

ALTER TABLE `payfees`
ADD CONSTRAINT `FK_fr_paymentType`
    FOREIGN KEY (`paymentTypeid`)
    REFERENCES `paymenttypes`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_paymentType'

CREATE INDEX `IX_FK_fr_paymentType` 
    ON `payfees`
    (`paymentTypeid`);

-- Creating foreign key on `studentid` in table 'payfees'

ALTER TABLE `payfees`
ADD CONSTRAINT `FK_fr_student0`
    FOREIGN KEY (`studentid`)
    REFERENCES `students`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_student0'

CREATE INDEX `IX_FK_fr_student0` 
    ON `payfees`
    (`studentid`);

-- Creating foreign key on `quotaid` in table 'students'

ALTER TABLE `students`
ADD CONSTRAINT `FK_fr_quota`
    FOREIGN KEY (`quotaid`)
    REFERENCES `quotas`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_quota'

CREATE INDEX `IX_FK_fr_quota` 
    ON `students`
    (`quotaid`);

-- Creating foreign key on `roleid` in table 'rolemoduleactionpermissions'

ALTER TABLE `rolemoduleactionpermissions`
ADD CONSTRAINT `FK_fr_role2`
    FOREIGN KEY (`roleid`)
    REFERENCES `roles`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_role2'

CREATE INDEX `IX_FK_fr_role2` 
    ON `rolemoduleactionpermissions`
    (`roleid`);

-- Creating foreign key on `rolemoduleactionid` in table 'rolemoduleactionpermissions'

ALTER TABLE `rolemoduleactionpermissions`
ADD CONSTRAINT `FK_fr_rolemoduleaction`
    FOREIGN KEY (`rolemoduleactionid`)
    REFERENCES `rolemoduleactions`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_rolemoduleaction'

CREATE INDEX `IX_FK_fr_rolemoduleaction` 
    ON `rolemoduleactionpermissions`
    (`rolemoduleactionid`);

-- Creating foreign key on `rolemoduleid` in table 'rolemoduleactions'

ALTER TABLE `rolemoduleactions`
ADD CONSTRAINT `FK_fr_rolemodule`
    FOREIGN KEY (`rolemoduleid`)
    REFERENCES `rolemodules`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_rolemodule'

CREATE INDEX `IX_FK_fr_rolemodule` 
    ON `rolemoduleactions`
    (`rolemoduleid`);

-- Creating foreign key on `roleid` in table 'rolemodulepermissions'

ALTER TABLE `rolemodulepermissions`
ADD CONSTRAINT `FK_fr_role1`
    FOREIGN KEY (`roleid`)
    REFERENCES `roles`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_role1'

CREATE INDEX `IX_FK_fr_role1` 
    ON `rolemodulepermissions`
    (`roleid`);

-- Creating foreign key on `rolemoduleid` in table 'rolemodulepermissions'

ALTER TABLE `rolemodulepermissions`
ADD CONSTRAINT `FK_fr_rolemodule1`
    FOREIGN KEY (`rolemoduleid`)
    REFERENCES `rolemodules`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_rolemodule1'

CREATE INDEX `IX_FK_fr_rolemodule1` 
    ON `rolemodulepermissions`
    (`rolemoduleid`);

-- Creating foreign key on `roleid` in table 'users'

ALTER TABLE `users`
ADD CONSTRAINT `FK_fr_role`
    FOREIGN KEY (`roleid`)
    REFERENCES `roles`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_role'

CREATE INDEX `IX_FK_fr_role` 
    ON `users`
    (`roleid`);

-- Creating foreign key on `semid` in table 'students'

ALTER TABLE `students`
ADD CONSTRAINT `FK_fr_sem`
    FOREIGN KEY (`semid`)
    REFERENCES `sems`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_sem'

CREATE INDEX `IX_FK_fr_sem` 
    ON `students`
    (`semid`);

-- Creating foreign key on `studentid` in table 'setfees'

ALTER TABLE `setfees`
ADD CONSTRAINT `FK_fr_student`
    FOREIGN KEY (`studentid`)
    REFERENCES `students`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_student'

CREATE INDEX `IX_FK_fr_student` 
    ON `setfees`
    (`studentid`);

-- Creating foreign key on `currAcaYearid` in table 'curracayears'

ALTER TABLE `curracayears`
ADD CONSTRAINT `FK_currAcaYear1`
    FOREIGN KEY (`currAcaYearid`)
    REFERENCES `acayears`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_currAcaYear1'

CREATE INDEX `IX_FK_currAcaYear1` 
    ON `curracayears`
    (`currAcaYearid`);

-- Creating foreign key on `acaYearid` in table 'setfees'

ALTER TABLE `setfees`
ADD CONSTRAINT `FK_fr_acaYear`
    FOREIGN KEY (`acaYearid`)
    REFERENCES `acayears`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_acaYear'

CREATE INDEX `IX_FK_fr_acaYear` 
    ON `setfees`
    (`acaYearid`);

-- Creating foreign key on `acaYearid` in table 'payfees'

ALTER TABLE `payfees`
ADD CONSTRAINT `FK_fr_acaYear0`
    FOREIGN KEY (`acaYearid`)
    REFERENCES `acayears`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_acaYear0'

CREATE INDEX `IX_FK_fr_acaYear0` 
    ON `payfees`
    (`acaYearid`);

-- Creating foreign key on `acaYearid` in table 'concessions'

ALTER TABLE `concessions`
ADD CONSTRAINT `FK_fr_acayear`
    FOREIGN KEY (`acaYearid`)
    REFERENCES `acayears`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_acayear'

CREATE INDEX `IX_FK_fr_acayear` 
    ON `concessions`
    (`acaYearid`);

-- Creating foreign key on `batchid` in table 'students'

ALTER TABLE `students`
ADD CONSTRAINT `FK_fr_batch`
    FOREIGN KEY (`batchid`)
    REFERENCES `batches`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_batch'

CREATE INDEX `IX_FK_fr_batch` 
    ON `students`
    (`batchid`);

-- Creating foreign key on `acaYearid` in table 'reimbursements'

ALTER TABLE `reimbursements`
ADD CONSTRAINT `FK_fr_acaYear1`
    FOREIGN KEY (`acaYearid`)
    REFERENCES `acayears`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_acaYear1'

CREATE INDEX `IX_FK_fr_acaYear1` 
    ON `reimbursements`
    (`acaYearid`);

-- Creating foreign key on `studentid` in table 'reimbursements'

ALTER TABLE `reimbursements`
ADD CONSTRAINT `FK_fr_student1`
    FOREIGN KEY (`studentid`)
    REFERENCES `students`
        (`id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Creating non-clustered index for FOREIGN KEY 'FK_fr_student1'

CREATE INDEX `IX_FK_fr_student1` 
    ON `reimbursements`
    (`studentid`);

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------
