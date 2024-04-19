DROP TABLE IF EXISTS branches;

CREATE TABLE `branches` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contact_phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `descriptions` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS charge_limits;

CREATE TABLE `charge_limits` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `minimum_amount` decimal(18,2) NOT NULL,
  `maximum_amount` decimal(18,2) NOT NULL,
  `fixed_charge` decimal(10,2) NOT NULL,
  `charge_in_percentage` decimal(10,2) NOT NULL,
  `gateway_id` bigint(20) NOT NULL,
  `gateway_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS currency;

CREATE TABLE `currency` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `exchange_rate` decimal(10,6) NOT NULL,
  `base_currency` tinyint(4) NOT NULL DEFAULT '0',
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO currency VALUES('1','INR','1.000000','1','1','','2023-05-30 17:54:23');



DROP TABLE IF EXISTS database_backups;

CREATE TABLE `database_backups` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `file` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO database_backups VALUES('1','DB-BACKUP-1687073714.sql','1','2023-06-18 13:05:14','2023-06-18 13:05:14');



DROP TABLE IF EXISTS deposit_methods;

CREATE TABLE `deposit_methods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency_id` bigint(20) NOT NULL,
  `minimum_amount` decimal(10,2) NOT NULL,
  `maximum_amount` decimal(10,2) NOT NULL,
  `fixed_charge` decimal(10,2) NOT NULL,
  `charge_in_percentage` decimal(10,2) NOT NULL,
  `descriptions` text COLLATE utf8mb4_unicode_ci,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `requirements` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS deposit_requests;

CREATE TABLE `deposit_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) unsigned NOT NULL,
  `method_id` bigint(20) unsigned NOT NULL,
  `credit_account_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `converted_amount` decimal(10,2) NOT NULL,
  `charge` decimal(10,2) DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `requirements` text COLLATE utf8mb4_unicode_ci,
  `attachment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `transaction_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `deposit_requests_member_id_foreign` (`member_id`),
  KEY `deposit_requests_method_id_foreign` (`method_id`),
  KEY `deposit_requests_credit_account_id_foreign` (`credit_account_id`),
  CONSTRAINT `deposit_requests_credit_account_id_foreign` FOREIGN KEY (`credit_account_id`) REFERENCES `savings_accounts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `deposit_requests_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `deposit_requests_method_id_foreign` FOREIGN KEY (`method_id`) REFERENCES `deposit_methods` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS email_sms_templates;

CREATE TABLE `email_sms_templates` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_body` text COLLATE utf8mb4_unicode_ci,
  `sms_body` text COLLATE utf8mb4_unicode_ci,
  `notification_body` text COLLATE utf8mb4_unicode_ci,
  `shortcode` text COLLATE utf8mb4_unicode_ci,
  `email_status` tinyint(4) NOT NULL DEFAULT '0',
  `sms_status` tinyint(4) NOT NULL DEFAULT '0',
  `notification_status` tinyint(4) NOT NULL DEFAULT '0',
  `template_mode` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 = all, 1 = email, 2 = sms, 3 = notification',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO email_sms_templates VALUES('1','Transfer Money','TRANSFER_MONEY','Transfer Money','<div>
<div>Dear {{name}},</div>
<div>You have received {{amount}} to {{account_number}} from {{sender_account_number}} on {{dateTime}}</div>
</div>','Dear {{name}}, You have received {{amount}} to {{account_number}} from {{sender_account_number}} on {{dateTime}}','Dear {{name}}, You have received {{amount}} to {{account_number}} from {{sender_account_number}} on {{dateTime}}','{{name}} {{account_number}} {{amount}} {{sender}} {{sender_account_number}} {{balance}} {{dateTime}}','0','0','0','0','','');
INSERT INTO email_sms_templates VALUES('2','Deposit Money','DEPOSIT_MONEY','Deposit Money','<div>
<div>Dear {{name}},</div>
<div>Your account has been credited with {{amount}} on {{dateTime}}</div>
</div>','Dear {{name}}, Your account has been credited with {{amount}} on {{dateTime}}','Dear {{name}}, Your account has been credited with {{amount}} on {{dateTime}}','{{name}} {{account_number}} {{amount}} {{dateTime}} {{balance}} {{depositMethod}}','0','0','0','0','','');
INSERT INTO email_sms_templates VALUES('3','Deposit Request Approved','DEPOSIT_REQUEST_APPROVED','Deposit Request Approved','<div>
<div>Dear {{name}},</div>
<div>Your deposit request has been approved. Your account {{account_number}} has been credited with {{amount}} on {{dateTime}}</div>
</div>','Dear {{name}}, Your deposit request has been approved. Your account {{account_number}} has been credited with {{amount}} on {{dateTime}}','Dear {{name}}, Your deposit request has been approved. Your account {{account_number}} has been credited with {{amount}} on {{dateTime}}','{{name}} {{account_number}} {{amount}} {{dateTime}} {{balance}} {{depositMethod}}','0','0','0','0','','');
INSERT INTO email_sms_templates VALUES('4','Loan Request Approved','LOAN_REQUEST_APPROVED','Loan Request Approved','<div>
<div>Dear {{name}},</div>
<div>Your loan request of {{amount}} has been approved on {{dateTime}}</div>
</div>','Dear {{name}}, Your loan request of {{amount}} has been approved on {{dateTime}}','Dear {{name}}, Your loan request of {{amount}} has been approved on {{dateTime}}','{{name}} {{amount}} {{dateTime}}','0','0','0','0','','');
INSERT INTO email_sms_templates VALUES('5','Withdraw Request Approved','WITHDRAW_REQUEST_APPROVED','Withdraw Request Approved','<div>
<div>Dear {{name}},</div>
<div>Your withdraw request has been approved. Your account has been debited with {{amount}} on {{dateTime}}</div>
</div>','Dear {{name}}, Your withdraw request has been approved. Your account has been debited with {{amount}} on {{dateTime}}','Dear {{name}}, Your withdraw request has been approved. Your account has been debited with {{amount}} on {{dateTime}}','{{name}} {{account_number}} {{amount}} {{withdrawMethod}} {{balance}} {{dateTime}}','0','0','0','0','','');
INSERT INTO email_sms_templates VALUES('6','Deposit Request Rejected','DEPOSIT_REQUEST_REJECTED','Deposit Request Rejected','<div>
<div>Dear {{name}},</div>
<div>Your deposit request of {{amount}} has been rejected.</div>
<div>&nbsp;</div>
<div>Amount:&nbsp;{{amount}}</div>
<div>Deposit Method: {{depositMethod}}</div>
</div>','Dear {{name}}, Your deposit request of {{amount}} has been rejected.','Dear {{name}}, Your deposit request of {{amount}} has been rejected.','{{name}}  {{account_number}} {{amount}} {{depositMethod}} {{balance}}','0','0','0','0','','');
INSERT INTO email_sms_templates VALUES('7','Loan Request Rejected','LOAN_REQUEST_REJECTED','Loan Request Rejected','<div>
<div>Dear {{name}},</div>
<div>Your loan request of {{amount}} has been rejected on {{dateTime}}</div>
</div>','Dear {{name}}, Your loan request of {{amount}} has been rejected on {{dateTime}}','Dear {{name}}, Your loan request of {{amount}} has been rejected on {{dateTime}}','{{name}} {{amount}} {{dateTime}}','0','0','0','0','','');
INSERT INTO email_sms_templates VALUES('8','Withdraw Request Rejected','WITHDRAW_REQUEST_REJECTED','Withdraw Request Rejected','<div>
<div>Dear {{name}}, Your withdraw request has been rejected. Your transferred amount {{amount}} has returned back to your account.</div>
</div>','Dear {{name}}, Your withdraw request has been rejected. Your transferred amount {{amount}} has returned back to your account.','Dear {{name}}, Your withdraw request has been rejected. Your transferred amount {{amount}} has returned back to your account.','{{name}} {{account_number}} {{amount}} {{withdrawMethod}} {{dateTime}} {{balance}}','0','0','0','0','','');
INSERT INTO email_sms_templates VALUES('9','Withdraw Money','WITHDRAW_MONEY','Withdraw Money','<div>
<div>Dear {{name}},</div>
<div>Your account has been debited with {{amount}} on {{dateTime}}</div>
</div>','Dear {{name}}, Your account has been debited with {{amount}} on {{dateTime}}','Dear {{name}}, Your account has been debited with {{amount}} on {{dateTime}}','{{name}} {{account_number}} {{amount}} {{dateTime}} {{withdrawMethod}} {{balance}}','0','0','0','0','','');
INSERT INTO email_sms_templates VALUES('10','Member Request Accepted','MEMBER_REQUEST_ACCEPTED','Member Request Accepted','<div>
<div>Dear {{name}},</div>
<div>Your member request has been accepted by authority on {{dateTime}}. You can now login to your account by using your email and password.</div>
</div>','','','{{name}} {{member_no}} {{dateTime}}','0','0','0','1','','');



DROP TABLE IF EXISTS expense_categories;

CREATE TABLE `expense_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS expenses;

CREATE TABLE `expenses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `expense_date` datetime NOT NULL,
  `expense_category_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reference` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `attachment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_user_id` bigint(20) DEFAULT NULL,
  `updated_user_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `expenses_expense_category_id_foreign` (`expense_category_id`),
  KEY `expenses_branch_id_foreign` (`branch_id`),
  CONSTRAINT `expenses_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `expenses_expense_category_id_foreign` FOREIGN KEY (`expense_category_id`) REFERENCES `expense_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS failed_jobs;

CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS guarantor_documents;

CREATE TABLE `guarantor_documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `guarantor_id` bigint(20) unsigned NOT NULL,
  `loan_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `guarantor_documents_guarantor_id_foreign` (`guarantor_id`),
  KEY `guarantor_documents_loan_id_foreign` (`loan_id`),
  CONSTRAINT `guarantor_documents_guarantor_id_foreign` FOREIGN KEY (`guarantor_id`) REFERENCES `guarantors` (`id`) ON DELETE CASCADE,
  CONSTRAINT `guarantor_documents_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS guarantors;

CREATE TABLE `guarantors` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `father_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `guarantors_loan_id_foreign` (`loan_id`),
  CONSTRAINT `guarantors_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO guarantors VALUES('2','6','Test','test','9413555613','5000.00','2023-08-19 17:59:12','2023-08-19 18:08:43');
INSERT INTO guarantors VALUES('3','7','Test','Test2','343433','10000.00','2023-08-20 12:20:24','2023-08-20 12:20:24');



DROP TABLE IF EXISTS interest_posting;

CREATE TABLE `interest_posting` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `account_type_id` bigint(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS loan_collaterals;

CREATE TABLE `loan_collaterals` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `collateral_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serial_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estimated_price` decimal(10,2) NOT NULL,
  `attachments` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `loan_collaterals_loan_id_foreign` (`loan_id`),
  CONSTRAINT `loan_collaterals_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS loan_documents;

CREATE TABLE `loan_documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS loan_payments;

CREATE TABLE `loan_payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) unsigned NOT NULL,
  `paid_at` date NOT NULL,
  `late_penalties` decimal(10,2) NOT NULL,
  `interest` decimal(10,2) NOT NULL,
  `repayment_amount` decimal(10,2) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `remarks` text COLLATE utf8mb4_unicode_ci,
  `member_id` bigint(20) unsigned NOT NULL,
  `transaction_id` bigint(20) DEFAULT NULL,
  `repayment_id` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `loan_payments_loan_id_foreign` (`loan_id`),
  KEY `loan_payments_member_id_foreign` (`member_id`),
  CONSTRAINT `loan_payments_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `loan_payments_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO loan_payments VALUES('3','6','2023-08-19','0.00','2000.00','6166.67','6166.67','','1','','109','2023-08-19 18:37:58','2023-08-19 18:37:58');
INSERT INTO loan_payments VALUES('4','6','2023-09-28','0.00','2000.00','6166.67','6166.67','','1','','110','2023-09-28 16:10:19','2023-09-28 16:10:19');
INSERT INTO loan_payments VALUES('5','7','2023-09-30','0.00','2000.00','6166.67','6166.67','','2','','133','2023-09-28 16:10:31','2023-09-28 16:10:31');



DROP TABLE IF EXISTS loan_products;

CREATE TABLE `loan_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `minimum_amount` decimal(10,2) NOT NULL,
  `maximum_amount` decimal(10,2) NOT NULL,
  `late_payment_penalties` decimal(10,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `interest_rate` decimal(10,2) NOT NULL,
  `interest_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `term` int(11) NOT NULL,
  `term_period` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO loan_products VALUES('1','Personal Loan 2%','10000.00','99999999.99','0.00','Personal loan at 2% per month','2.00','fixed_rate','24','+1 month','1','2023-05-30 17:55:34','2023-05-30 17:55:34');



DROP TABLE IF EXISTS loan_repayments;

CREATE TABLE `loan_repayments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `repayment_date` date NOT NULL,
  `amount_to_pay` decimal(10,2) NOT NULL,
  `penalty` decimal(10,2) NOT NULL,
  `principal_amount` decimal(10,2) NOT NULL,
  `interest` decimal(10,2) NOT NULL,
  `balance` decimal(10,2) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=157 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO loan_repayments VALUES('109','6','2023-08-09','6166.67','0.00','4166.67','2000.00','141833.33','1','2023-08-09 11:54:59','2023-08-19 18:37:58');
INSERT INTO loan_repayments VALUES('110','6','2023-09-09','6166.67','0.00','4166.67','2000.00','135666.67','1','2023-08-09 11:54:59','2023-09-28 16:10:19');
INSERT INTO loan_repayments VALUES('111','6','2023-10-09','6166.67','0.00','4166.67','2000.00','129500.00','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('112','6','2023-11-09','6166.67','0.00','4166.67','2000.00','123333.33','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('113','6','2023-12-09','6166.67','0.00','4166.67','2000.00','117166.67','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('114','6','2024-01-09','6166.67','0.00','4166.67','2000.00','111000.00','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('115','6','2024-02-09','6166.67','0.00','4166.67','2000.00','104833.33','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('116','6','2024-03-09','6166.67','0.00','4166.67','2000.00','98666.67','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('117','6','2024-04-09','6166.67','0.00','4166.67','2000.00','92500.00','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('118','6','2024-05-09','6166.67','0.00','4166.67','2000.00','86333.33','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('119','6','2024-06-09','6166.67','0.00','4166.67','2000.00','80166.67','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('120','6','2024-07-09','6166.67','0.00','4166.67','2000.00','74000.00','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('121','6','2024-08-09','6166.67','0.00','4166.67','2000.00','67833.33','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('122','6','2024-09-09','6166.67','0.00','4166.67','2000.00','61666.67','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('123','6','2024-10-09','6166.67','0.00','4166.67','2000.00','55500.00','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('124','6','2024-11-09','6166.67','0.00','4166.67','2000.00','49333.33','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('125','6','2024-12-09','6166.67','0.00','4166.67','2000.00','43166.67','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('126','6','2025-01-09','6166.67','0.00','4166.67','2000.00','37000.00','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('127','6','2025-02-09','6166.67','0.00','4166.67','2000.00','30833.33','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('128','6','2025-03-09','6166.67','0.00','4166.67','2000.00','24666.67','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('129','6','2025-04-09','6166.67','0.00','4166.67','2000.00','18500.00','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('130','6','2025-05-09','6166.67','0.00','4166.67','2000.00','12333.33','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('131','6','2025-06-09','6166.67','0.00','4166.67','2000.00','6166.67','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('132','6','2025-07-09','6166.67','0.00','4166.67','2000.00','0.00','0','2023-08-09 11:54:59','2023-08-09 11:54:59');
INSERT INTO loan_repayments VALUES('133','7','2023-08-19','6166.67','0.00','4166.67','2000.00','141833.33','1','2023-08-19 18:36:55','2023-09-28 16:10:31');
INSERT INTO loan_repayments VALUES('134','7','2023-09-19','6166.67','0.00','4166.67','2000.00','135666.67','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('135','7','2023-10-19','6166.67','0.00','4166.67','2000.00','129500.00','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('136','7','2023-11-19','6166.67','0.00','4166.67','2000.00','123333.33','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('137','7','2023-12-19','6166.67','0.00','4166.67','2000.00','117166.67','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('138','7','2024-01-19','6166.67','0.00','4166.67','2000.00','111000.00','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('139','7','2024-02-19','6166.67','0.00','4166.67','2000.00','104833.33','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('140','7','2024-03-19','6166.67','0.00','4166.67','2000.00','98666.67','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('141','7','2024-04-19','6166.67','0.00','4166.67','2000.00','92500.00','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('142','7','2024-05-19','6166.67','0.00','4166.67','2000.00','86333.33','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('143','7','2024-06-19','6166.67','0.00','4166.67','2000.00','80166.67','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('144','7','2024-07-19','6166.67','0.00','4166.67','2000.00','74000.00','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('145','7','2024-08-19','6166.67','0.00','4166.67','2000.00','67833.33','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('146','7','2024-09-19','6166.67','0.00','4166.67','2000.00','61666.67','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('147','7','2024-10-19','6166.67','0.00','4166.67','2000.00','55500.00','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('148','7','2024-11-19','6166.67','0.00','4166.67','2000.00','49333.33','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('149','7','2024-12-19','6166.67','0.00','4166.67','2000.00','43166.67','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('150','7','2025-01-19','6166.67','0.00','4166.67','2000.00','37000.00','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('151','7','2025-02-19','6166.67','0.00','4166.67','2000.00','30833.33','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('152','7','2025-03-19','6166.67','0.00','4166.67','2000.00','24666.67','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('153','7','2025-04-19','6166.67','0.00','4166.67','2000.00','18500.00','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('154','7','2025-05-19','6166.67','0.00','4166.67','2000.00','12333.33','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('155','7','2025-06-19','6166.67','0.00','4166.67','2000.00','6166.67','0','2023-08-19 18:36:55','2023-08-19 18:36:55');
INSERT INTO loan_repayments VALUES('156','7','2025-07-19','6166.67','0.00','4166.67','2000.00','0.00','0','2023-08-19 18:36:55','2023-08-19 18:36:55');



DROP TABLE IF EXISTS loans;

CREATE TABLE `loans` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `loan_product_id` bigint(20) unsigned NOT NULL,
  `borrower_id` bigint(20) unsigned NOT NULL,
  `first_payment_date` date NOT NULL,
  `release_date` date DEFAULT NULL,
  `currency_id` bigint(20) NOT NULL,
  `applied_amount` decimal(10,2) NOT NULL,
  `term` int(10) DEFAULT NULL,
  `total_payable` decimal(10,2) DEFAULT NULL,
  `total_paid` decimal(10,2) DEFAULT NULL,
  `late_payment_penalties` decimal(10,2) NOT NULL,
  `attachment` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `remarks` text COLLATE utf8mb4_unicode_ci,
  `status` int(11) NOT NULL DEFAULT '0',
  `approved_date` date DEFAULT NULL,
  `approved_user_id` bigint(20) DEFAULT NULL,
  `created_user_id` bigint(20) DEFAULT NULL,
  `updated_user_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO loans VALUES('6','Test','1','1','2023-08-09','2023-08-09','1','100000.00','24','148000.00','12333.34','0.00','','','','1','2023-08-09','1','1','','','2023-08-09 11:54:57','2023-09-28 16:10:19');
INSERT INTO loans VALUES('7','123','1','2','2023-08-19','2023-08-19','1','100000.00','24','148000.00','6166.67','0.00','','','','1','2023-08-19','1','1','','','2023-08-19 18:36:52','2023-09-28 16:10:31');



DROP TABLE IF EXISTS member_documents;

CREATE TABLE `member_documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `document` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `member_documents_member_id_foreign` (`member_id`),
  CONSTRAINT `member_documents_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO member_documents VALUES('1','1','Test','1687073833648eb4296906a-GMCA Logo.png','2023-06-18 13:07:13','2023-06-18 13:07:13');



DROP TABLE IF EXISTS members;

CREATE TABLE `members` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `business_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `member_no` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `gender` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `credit_source` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `photo` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `custom_fields` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `aadhaar_no` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pan_card_no` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO members VALUES('1','Ram','Test','','','1','','91','9413555613','Test','RNS-1','male','','','','','','default.png','','2023-05-30 17:56:12','2023-08-19 15:32:06','1212121221212121','EFRPS1234T');
INSERT INTO members VALUES('2','Ram','Test2','','','1','','91','','','RNS-02','','','','','','','default.png','','2023-08-19 15:38:45','2023-08-19 15:38:45','A234232','EFSf3434');



DROP TABLE IF EXISTS migrations;

CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO migrations VALUES('1','2014_10_12_000000_create_users_table','1');
INSERT INTO migrations VALUES('2','2014_10_12_100000_create_password_resets_table','1');
INSERT INTO migrations VALUES('3','2019_08_19_000000_create_failed_jobs_table','1');
INSERT INTO migrations VALUES('4','2019_09_01_080940_create_settings_table','1');
INSERT INTO migrations VALUES('5','2020_07_02_145857_create_database_backups_table','1');
INSERT INTO migrations VALUES('6','2020_07_06_142817_create_roles_table','1');
INSERT INTO migrations VALUES('7','2020_07_06_143240_create_permissions_table','1');
INSERT INTO migrations VALUES('8','2021_03_22_071324_create_setting_translations','1');
INSERT INTO migrations VALUES('9','2021_07_02_145504_create_pages_table','1');
INSERT INTO migrations VALUES('10','2021_07_02_145952_create_page_translations_table','1');
INSERT INTO migrations VALUES('11','2021_08_06_104648_create_branches_table','1');
INSERT INTO migrations VALUES('12','2021_08_07_111236_create_currency_table','1');
INSERT INTO migrations VALUES('13','2021_08_08_132702_create_payment_gateways_table','1');
INSERT INTO migrations VALUES('14','2021_08_08_152535_create_deposit_methods_table','1');
INSERT INTO migrations VALUES('15','2021_08_08_164152_create_withdraw_methods_table','1');
INSERT INTO migrations VALUES('16','2021_08_31_201125_create_navigations_table','1');
INSERT INTO migrations VALUES('17','2021_08_31_201126_create_navigation_items_table','1');
INSERT INTO migrations VALUES('18','2021_08_31_201127_create_navigation_item_translations_table','1');
INSERT INTO migrations VALUES('19','2021_10_22_070458_create_email_sms_templates_table','1');
INSERT INTO migrations VALUES('20','2022_03_21_075342_create_members_table','1');
INSERT INTO migrations VALUES('21','2022_03_24_090932_create_member_documents_table','1');
INSERT INTO migrations VALUES('22','2022_03_28_114203_create_savings_products_table','1');
INSERT INTO migrations VALUES('23','2022_04_13_073108_create_savings_accounts_table','1');
INSERT INTO migrations VALUES('24','2022_04_13_073109_create_transactions_table','1');
INSERT INTO migrations VALUES('25','2022_05_31_074804_create_expense_categories_table','1');
INSERT INTO migrations VALUES('26','2022_05_31_074918_create_expenses_table','1');
INSERT INTO migrations VALUES('27','2022_06_01_082019_create_loan_products_table','1');
INSERT INTO migrations VALUES('28','2022_06_01_083021_create_loans_table','1');
INSERT INTO migrations VALUES('29','2022_06_01_083022_create_loan_collaterals_table','1');
INSERT INTO migrations VALUES('30','2022_06_01_083025_create_loan_payments_table','1');
INSERT INTO migrations VALUES('31','2022_06_01_083069_create_loan_repayments_table','1');
INSERT INTO migrations VALUES('33','2022_07_26_155338_create_deposit_requests_table','1');
INSERT INTO migrations VALUES('34','2022_07_26_163427_create_withdraw_requests_table','1');
INSERT INTO migrations VALUES('35','2022_08_09_160105_create_notifications_table','1');
INSERT INTO migrations VALUES('36','2022_08_15_055625_create_interest_posting_table','1');
INSERT INTO migrations VALUES('37','2022_08_27_151317_create_transaction_categories_table','1');
INSERT INTO migrations VALUES('38','2022_08_29_102757_create_schedule_tasks_histories_table','1');
INSERT INTO migrations VALUES('39','2022_09_13_162539_add_branch_id_to_users_table','1');
INSERT INTO migrations VALUES('40','2022_09_18_074806_add_branch_id_to_expenses_table','1');
INSERT INTO migrations VALUES('41','2022_10_16_081858_add_charge_to_deposit_requests_table','1');
INSERT INTO migrations VALUES('42','2022_10_29_095023_add_status_to_members_table','1');
INSERT INTO migrations VALUES('43','2023_01_29_093731_create_charge_limits_table','1');
INSERT INTO migrations VALUES('44','2019_12_14_000001_create_personal_access_tokens_table','2');
INSERT INTO migrations VALUES('45','2023_08_19_094327_add_column_to_members_table','2');
INSERT INTO migrations VALUES('46','2022_06_06_072245_create_guarantors_table','3');
INSERT INTO migrations VALUES('47','2023_08_19_103847_create_guarantor_documents_table','3');
INSERT INTO migrations VALUES('48','2023_08_20_065226_create_loan_documents_table','4');



DROP TABLE IF EXISTS navigation_item_translations;

CREATE TABLE `navigation_item_translations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `navigation_item_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `navigation_item_translations_navigation_item_id_locale_unique` (`navigation_item_id`,`locale`),
  CONSTRAINT `navigation_item_translations_navigation_item_id_foreign` FOREIGN KEY (`navigation_item_id`) REFERENCES `navigation_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS navigation_items;

CREATE TABLE `navigation_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `navigation_id` bigint(20) unsigned NOT NULL,
  `type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `page_id` bigint(20) unsigned DEFAULT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `target` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `position` int(10) unsigned DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `css_class` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `css_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `navigation_items_parent_id_foreign` (`parent_id`),
  KEY `navigation_items_page_id_foreign` (`page_id`),
  KEY `navigation_items_navigation_id_index` (`navigation_id`),
  CONSTRAINT `navigation_items_navigation_id_foreign` FOREIGN KEY (`navigation_id`) REFERENCES `navigations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `navigation_items_page_id_foreign` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `navigation_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `navigation_items` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS navigations;

CREATE TABLE `navigations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS notifications;

CREATE TABLE `notifications` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` bigint(20) unsigned NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS page_translations;

CREATE TABLE `page_translations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `page_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `page_translations_page_id_locale_unique` (`page_id`,`locale`),
  CONSTRAINT `page_translations_page_id_foreign` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS pages;

CREATE TABLE `pages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pages_slug_unique` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS password_resets;

CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS payment_gateways;

CREATE TABLE `payment_gateways` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `is_crypto` tinyint(4) NOT NULL DEFAULT '0',
  `parameters` text COLLATE utf8mb4_unicode_ci,
  `currency` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `supported_currencies` text COLLATE utf8mb4_unicode_ci,
  `extra` text COLLATE utf8mb4_unicode_ci,
  `exchange_rate` decimal(10,6) DEFAULT NULL,
  `fixed_charge` decimal(10,2) NOT NULL DEFAULT '0.00',
  `charge_in_percentage` decimal(10,2) NOT NULL DEFAULT '0.00',
  `minimum_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `maximum_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO payment_gateways VALUES('1','PayPal','PayPal','paypal.png','0','0','{\"client_id\":\"\",\"client_secret\":\"\",\"environment\":\"sandbox\"}','','{\"AUD\":\"AUD\",\"BRL\":\"BRL\",\"CAD\":\"CAD\",\"CZK\":\"CZK\",\"DKK\":\"DKK\",\"EUR\":\"EUR\",\"HKD\":\"HKD\",\"HUF\":\"HUF\",\"INR\":\"INR\",\"ILS\":\"ILS\",\"JPY\":\"JPY\",\"MYR\":\"MYR\",\"MXN\":\"MXN\",\"TWD\":\"TWD\",\"NZD\":\"NZD\",\"NOK\":\"NOK\",\"PHP\":\"PHP\",\"PLN\":\"PLN\",\"GBP\":\"GBP\",\"RUB\":\"RUB\",\"SGD\":\"SGD\",\"SEK\":\"SEK\",\"CHF\":\"CHF\",\"THB\":\"THB\",\"USD\":\"USD\"}','','','0.00','0.00','0.00','0.00','','');
INSERT INTO payment_gateways VALUES('2','Stripe','Stripe','stripe.png','0','0','{\"secret_key\":\"\",\"publishable_key\":\"\"}','','{\"USD\":\"USD\",\"AUD\":\"AUD\",\"BRL\":\"BRL\",\"CAD\":\"CAD\",\"CHF\":\"CHF\",\"DKK\":\"DKK\",\"EUR\":\"EUR\",\"GBP\":\"GBP\",\"HKD\":\"HKD\",\"INR\":\"INR\",\"JPY\":\"JPY\",\"MXN\":\"MXN\",\"MYR\":\"MYR\",\"NOK\":\"NOK\",\"NZD\":\"NZD\",\"PLN\":\"PLN\",\"SEK\":\"SEK\",\"SGD\":\"SGD\"}','','','0.00','0.00','0.00','0.00','','');
INSERT INTO payment_gateways VALUES('3','Razorpay','Razorpay','razorpay.png','0','0','{\"razorpay_key_id\":\"\",\"razorpay_key_secret\":\"\"}','','{\"INR\":\"INR\"}','','','0.00','0.00','0.00','0.00','','');
INSERT INTO payment_gateways VALUES('4','Paystack','Paystack','paystack.png','0','0','{\"paystack_public_key\":\"\",\"paystack_secret_key\":\"\"}','','{\"GHS\":\"GHS\",\"NGN\":\"NGN\",\"ZAR\":\"ZAR\"}','','','0.00','0.00','0.00','0.00','','');
INSERT INTO payment_gateways VALUES('5','BlockChain','BlockChain','blockchain.png','0','1','{\"blockchain_api_key\":\"\",\"blockchain_xpub\":\"\"}','','{\"BTC\":\"BTC\"}','','','0.00','0.00','0.00','0.00','','');
INSERT INTO payment_gateways VALUES('6','Flutterwave','Flutterwave','flutterwave.png','0','0','{\"public_key\":\"\",\"secret_key\":\"\",\"encryption_key\":\"\",\"environment\":\"sandbox\"}','','{\"BIF\":\"BIF\",\"CAD\":\"CAD\",\"CDF\":\"CDF\",\"CVE\":\"CVE\",\"EUR\":\"EUR\",\"GBP\":\"GBP\",\"GHS\":\"GHS\",\"GMD\":\"GMD\",\"GNF\":\"GNF\",\"KES\":\"KES\",\"LRD\":\"LRD\",\"MWK\":\"MWK\",\"MZN\":\"MZN\",\"NGN\":\"NGN\",\"RWF\":\"RWF\",\"SLL\":\"SLL\",\"STD\":\"STD\",\"TZS\":\"TZS\",\"UGX\":\"UGX\",\"USD\":\"USD\",\"XAF\":\"XAF\",\"XOF\":\"XOF\",\"ZMK\":\"ZMK\",\"ZMW\":\"ZMW\",\"ZWD\":\"ZWD\"}','','','0.00','0.00','0.00','0.00','','');
INSERT INTO payment_gateways VALUES('7','VoguePay','VoguePay','VoguePay.png','1','0','{\"merchant_id\":\"\"}','','{\"USD\":\"USD\",\"GBP\":\"GBP\",\"EUR\":\"EUR\",\"GHS\":\"GHS\",\"NGN\":\"NGN\",\"ZAR\":\"ZAR\"}','','','0.00','0.00','0.00','0.00','','');
INSERT INTO payment_gateways VALUES('8','Mollie','Mollie','Mollie.png','1','0','{\"api_key\":\"\"}','','{\"AED\":\"AED\",\"AUD\":\"AUD\",\"BGN\":\"BGN\",\"BRL\":\"BRL\",\"CAD\":\"CAD\",\"CHF\":\"CHF\",\"CZK\":\"CZK\",\"DKK\":\"DKK\",\"EUR\":\"EUR\",\"GBP\":\"GBP\",\"HKD\":\"HKD\",\"HRK\":\"HRK\",\"HUF\":\"HUF\",\"ILS\":\"ILS\",\"ISK\":\"ISK\",\"JPY\":\"JPY\",\"MXN\":\"MXN\",\"MYR\":\"MYR\",\"NOK\":\"NOK\",\"NZD\":\"NZD\",\"PHP\":\"PHP\",\"PLN\":\"PLN\",\"RON\":\"RON\",\"RUB\":\"RUB\",\"SEK\":\"SEK\",\"SGD\":\"SGD\",\"THB\":\"THB\",\"TWD\":\"TWD\",\"USD\":\"USD\",\"ZAR\":\"ZAR\"}','','','0.00','0.00','0.00','0.00','','');
INSERT INTO payment_gateways VALUES('9','CoinPayments','CoinPayments','CoinPayments.png','1','1','{\"public_key\":\"\",\"private_key\":\"\",\"merchant_id\":\"\",\"ipn_secret\":\"\"}','','{\"BTC\":\"Bitcoin\",\"BTC.LN\":\"Bitcoin (Lightning Network)\",\"LTC\":\"Litecoin\",\"CPS\":\"CPS Coin\",\"VLX\":\"Velas\",\"APL\":\"Apollo\",\"AYA\":\"Aryacoin\",\"BAD\":\"Badcoin\",\"BCD\":\"Bitcoin Diamond\",\"BCH\":\"Bitcoin Cash\",\"BCN\":\"Bytecoin\",\"BEAM\":\"BEAM\",\"BITB\":\"Bean Cash\",\"BLK\":\"BlackCoin\",\"BSV\":\"Bitcoin SV\",\"BTAD\":\"Bitcoin Adult\",\"BTG\":\"Bitcoin Gold\",\"BTT\":\"BitTorrent\",\"CLOAK\":\"CloakCoin\",\"CLUB\":\"ClubCoin\",\"CRW\":\"Crown\",\"CRYP\":\"CrypticCoin\",\"CRYT\":\"CryTrExCoin\",\"CURE\":\"CureCoin\",\"DASH\":\"DASH\",\"DCR\":\"Decred\",\"DEV\":\"DeviantCoin\",\"DGB\":\"DigiByte\",\"DOGE\":\"Dogecoin\",\"EBST\":\"eBoost\",\"EOS\":\"EOS\",\"ETC\":\"Ether Classic\",\"ETH\":\"Ethereum\",\"ETN\":\"Electroneum\",\"EUNO\":\"EUNO\",\"EXP\":\"EXP\",\"Expanse\":\"Expanse\",\"FLASH\":\"FLASH\",\"GAME\":\"GameCredits\",\"GLC\":\"Goldcoin\",\"GRS\":\"Groestlcoin\",\"KMD\":\"Komodo\",\"LOKI\":\"LOKI\",\"LSK\":\"LSK\",\"MAID\":\"MaidSafeCoin\",\"MUE\":\"MonetaryUnit\",\"NAV\":\"NAV Coin\",\"NEO\":\"NEO\",\"NMC\":\"Namecoin\",\"NVST\":\"NVO Token\",\"NXT\":\"NXT\",\"OMNI\":\"OMNI\",\"PINK\":\"PinkCoin\",\"PIVX\":\"PIVX\",\"POT\":\"PotCoin\",\"PPC\":\"Peercoin\",\"PROC\":\"ProCurrency\",\"PURA\":\"PURA\",\"QTUM\":\"QTUM\",\"RES\":\"Resistance\",\"RVN\":\"Ravencoin\",\"RVR\":\"RevolutionVR\",\"SBD\":\"Steem Dollars\",\"SMART\":\"SmartCash\",\"SOXAX\":\"SOXAX\",\"STEEM\":\"STEEM\",\"STRAT\":\"STRAT\",\"SYS\":\"Syscoin\",\"TPAY\":\"TokenPay\",\"TRIGGERS\":\"Triggers\",\"TRX\":\" TRON\",\"UBQ\":\"Ubiq\",\"UNIT\":\"UniversalCurrency\",\"USDT\":\"Tether USD (Omni Layer)\",\"VTC\":\"Vertcoin\",\"WAVES\":\"Waves\",\"XEM\":\"NEM\",\"XMR\":\"Monero\",\"XSN\":\"Stakenet\",\"XSR\":\"SucreCoin\",\"XVG\":\"VERGE\",\"XZC\":\"ZCoin\",\"ZEC\":\"ZCash\",\"ZEN\":\"Horizen\"}','','','0.00','0.00','0.00','0.00','','');
INSERT INTO payment_gateways VALUES('10','Instamojo','Instamojo','instamojo.png','1','0','{\"api_key\":\"\",\"auth_token\":\"\",\"salt\":\"\",\"environment\":\"sandbox\"}','','{\"INR\":\"INR\"}','','','0.00','0.00','0.00','0.00','','');



DROP TABLE IF EXISTS permissions;

CREATE TABLE `permissions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` bigint(20) NOT NULL,
  `permission` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS personal_access_tokens;

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS roles;

CREATE TABLE `roles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS savings_accounts;

CREATE TABLE `savings_accounts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `account_number` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `member_id` bigint(20) unsigned NOT NULL,
  `savings_product_id` bigint(20) unsigned NOT NULL,
  `status` int(11) NOT NULL COMMENT '1 = action | 2 = Deactivate',
  `opening_balance` decimal(10,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_user_id` bigint(20) DEFAULT NULL,
  `updated_user_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `savings_accounts_member_id_foreign` (`member_id`),
  KEY `savings_accounts_savings_product_id_foreign` (`savings_product_id`),
  CONSTRAINT `savings_accounts_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `savings_accounts_savings_product_id_foreign` FOREIGN KEY (`savings_product_id`) REFERENCES `savings_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO savings_accounts VALUES('1','9413555613','1','1','1','0.00','','1','','2023-05-31 15:07:46','2023-05-31 15:07:46');
INSERT INTO savings_accounts VALUES('2','9413555613-001','1','1','1','200000.00','','1','','2023-06-18 09:40:25','2023-06-18 09:40:25');
INSERT INTO savings_accounts VALUES('3','9413555613-002','1','1','1','100000.00','','1','','2023-08-19 14:23:07','2023-08-19 14:23:07');



DROP TABLE IF EXISTS savings_products;

CREATE TABLE `savings_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `currency_id` bigint(20) unsigned NOT NULL,
  `interest_rate` decimal(8,2) DEFAULT NULL,
  `interest_method` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `interest_period` int(11) DEFAULT NULL,
  `interest_posting_period` int(11) DEFAULT NULL,
  `min_bal_interest_rate` decimal(10,2) DEFAULT NULL,
  `allow_withdraw` tinyint(4) NOT NULL DEFAULT '1',
  `minimum_account_balance` decimal(10,2) NOT NULL DEFAULT '0.00',
  `minimum_deposit_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `maintenance_fee` decimal(10,2) NOT NULL DEFAULT '0.00',
  `maintenance_fee_posting_period` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL COMMENT '1 = active | 2 = Deactivate',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `savings_products_currency_id_foreign` (`currency_id`),
  CONSTRAINT `savings_products_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO savings_products VALUES('1','Investment - 1%','1','12.00','daily_outstanding_balance','1','','0.00','1','0.00','0.00','0.00','','1','2023-05-31 15:07:16','2023-08-19 14:30:06');



DROP TABLE IF EXISTS schedule_tasks_histories;

CREATE TABLE `schedule_tasks_histories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` bigint(20) DEFAULT NULL,
  `others` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS setting_translations;

CREATE TABLE `setting_translations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `setting_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_translations_setting_id_locale_unique` (`setting_id`,`locale`),
  CONSTRAINT `setting_translations_setting_id_foreign` FOREIGN KEY (`setting_id`) REFERENCES `settings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS settings;

CREATE TABLE `settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO settings VALUES('1','mail_type','smtp','','');
INSERT INTO settings VALUES('2','backend_direction','ltr','','');
INSERT INTO settings VALUES('3','language','English','','');
INSERT INTO settings VALUES('4','email_verification','disabled','','');
INSERT INTO settings VALUES('5','allow_singup','yes','','');
INSERT INTO settings VALUES('6','company_name','Test Company','2023-05-30 07:09:04','2023-05-30 07:09:04');
INSERT INTO settings VALUES('7','site_title','Test','2023-05-30 07:09:04','2023-05-30 07:09:04');
INSERT INTO settings VALUES('8','phone','1234567890','2023-05-30 07:09:04','2023-05-30 07:09:04');
INSERT INTO settings VALUES('9','email','rns6393@gmail.com','2023-05-30 07:09:04','2023-05-30 07:09:04');
INSERT INTO settings VALUES('10','timezone','Asia/Kolkata','2023-05-30 07:09:04','2023-05-30 07:09:04');



DROP TABLE IF EXISTS transaction_categories;

CREATE TABLE `transaction_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `related_to` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS transactions;

CREATE TABLE `transactions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) unsigned NOT NULL,
  `trans_date` datetime NOT NULL,
  `savings_account_id` bigint(20) unsigned DEFAULT NULL,
  `charge` decimal(10,2) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `gateway_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `dr_cr` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL,
  `note` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `loan_id` bigint(20) DEFAULT NULL,
  `ref_id` bigint(20) DEFAULT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Parent transaction id',
  `gateway_id` bigint(20) DEFAULT NULL COMMENT 'PayPal | Stripe | Other Gateway',
  `created_user_id` bigint(20) DEFAULT NULL,
  `updated_user_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  `transaction_details` text COLLATE utf8mb4_unicode_ci,
  `tracking_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transactions_member_id_foreign` (`member_id`),
  KEY `transactions_savings_account_id_foreign` (`savings_account_id`),
  KEY `transactions_parent_id_foreign` (`parent_id`),
  CONSTRAINT `transactions_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transactions_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transactions_savings_account_id_foreign` FOREIGN KEY (`savings_account_id`) REFERENCES `savings_accounts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO transactions VALUES('1','1','2023-05-31 15:07:46','1','','0.00','0.00','cr','Deposit','Manual','2','','Initial Deposit','','','','','1','','','','','2023-05-31 15:07:46','2023-05-31 15:07:46');
INSERT INTO transactions VALUES('2','1','2023-04-01 15:08:00','1','','500000.00','0.00','cr','Deposit','Manual','2','','Deposit 5 lac','','','','','1','','','','','2023-05-31 15:09:27','2023-05-31 15:09:27');
INSERT INTO transactions VALUES('3','1','2023-06-18 09:40:25','2','','200000.00','0.00','cr','Deposit','Manual','2','','Initial Deposit','','','','','1','','','','','2023-06-18 09:40:25','2023-06-18 09:40:25');
INSERT INTO transactions VALUES('4','1','2023-08-19 14:23:07','3','','100000.00','0.00','cr','Deposit','Manual','2','','Initial Deposit','','','','','1','','','','','2023-08-19 14:23:07','2023-08-19 14:23:07');
INSERT INTO transactions VALUES('5','1','2023-08-19 14:23:00','3','','100000.00','0.00','cr','Deposit','Manual','2','','deposit 1 lakh','','','','','1','','','','','2023-08-19 14:24:31','2023-08-19 14:24:31');
INSERT INTO transactions VALUES('6','1','2023-08-19 14:29:00','3','','10000.00','0.00','dr','Withdraw','Manual','2','','withdraw 10 thousands','','','','','1','','','','','2023-08-19 14:30:10','2023-08-19 14:30:10');
INSERT INTO transactions VALUES('8','1','2023-08-19 18:39:00','1','','100000.00','0.00','cr','Deposit','Manual','2','','s','','','','','1','','','','','2023-08-19 18:39:23','2023-08-19 18:39:23');



DROP TABLE IF EXISTS users;

CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_type` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) unsigned DEFAULT NULL,
  `status` int(11) NOT NULL,
  `profile_picture` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_branch_id_foreign` (`branch_id`),
  CONSTRAINT `users_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users VALUES('1','Admin','admin@gmail.com','admin','','','1','default.png','2023-05-30 07:08:28','$2y$10$Tl.0JW62tzjsYXWSUtRT9u8xMh1yLVGOpkzP1pfoeZqCESA2H1yRm','','','R4sAaLvfvCsj6O0Jj8821fHIE8VoqtuypWGeZJukcB9WGTQopGFuM3bqDslY','2023-05-30 07:08:28','2023-05-30 07:08:28');



DROP TABLE IF EXISTS withdraw_methods;

CREATE TABLE `withdraw_methods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency_id` bigint(20) NOT NULL,
  `minimum_amount` decimal(10,2) NOT NULL,
  `maximum_amount` decimal(10,2) NOT NULL,
  `fixed_charge` decimal(10,2) NOT NULL,
  `charge_in_percentage` decimal(10,2) NOT NULL,
  `descriptions` text COLLATE utf8mb4_unicode_ci,
  `status` tinyint(4) NOT NULL DEFAULT '1',
  `requirements` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




DROP TABLE IF EXISTS withdraw_requests;

CREATE TABLE `withdraw_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` bigint(20) unsigned NOT NULL,
  `method_id` bigint(20) unsigned NOT NULL,
  `debit_account_id` bigint(20) unsigned NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `converted_amount` decimal(10,2) NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `requirements` text COLLATE utf8mb4_unicode_ci,
  `attachment` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `transaction_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `withdraw_requests_member_id_foreign` (`member_id`),
  KEY `withdraw_requests_method_id_foreign` (`method_id`),
  KEY `withdraw_requests_debit_account_id_foreign` (`debit_account_id`),
  CONSTRAINT `withdraw_requests_debit_account_id_foreign` FOREIGN KEY (`debit_account_id`) REFERENCES `savings_accounts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `withdraw_requests_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  CONSTRAINT `withdraw_requests_method_id_foreign` FOREIGN KEY (`method_id`) REFERENCES `withdraw_methods` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




