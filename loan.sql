-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 19, 2024 at 11:39 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `loan`
--

-- --------------------------------------------------------

--
-- Table structure for table `branches`
--

CREATE TABLE `branches` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `contact_email` varchar(191) DEFAULT NULL,
  `contact_phone` varchar(191) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `descriptions` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `charge_limits`
--

CREATE TABLE `charge_limits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `minimum_amount` decimal(18,2) NOT NULL,
  `maximum_amount` decimal(18,2) NOT NULL,
  `fixed_charge` decimal(10,2) NOT NULL,
  `charge_in_percentage` decimal(10,2) NOT NULL,
  `gateway_id` bigint(20) NOT NULL,
  `gateway_type` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `currency`
--

CREATE TABLE `currency` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(3) NOT NULL,
  `exchange_rate` decimal(10,6) NOT NULL,
  `base_currency` tinyint(4) NOT NULL DEFAULT 0,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `currency`
--

INSERT INTO `currency` (`id`, `name`, `exchange_rate`, `base_currency`, `status`, `created_at`, `updated_at`) VALUES
(1, 'USD', 1.000000, 1, 1, NULL, NULL),
(2, 'EUR', 0.850000, 0, 1, NULL, NULL),
(3, 'INR', 74.500000, 0, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `database_backups`
--

CREATE TABLE `database_backups` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `file` varchar(191) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deposit_methods`
--

CREATE TABLE `deposit_methods` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `currency_id` bigint(20) NOT NULL,
  `minimum_amount` decimal(10,2) NOT NULL,
  `maximum_amount` decimal(10,2) NOT NULL,
  `fixed_charge` decimal(10,2) NOT NULL,
  `charge_in_percentage` decimal(10,2) NOT NULL,
  `descriptions` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `requirements` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `deposit_requests`
--

CREATE TABLE `deposit_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `method_id` bigint(20) UNSIGNED NOT NULL,
  `credit_account_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `converted_amount` decimal(10,2) NOT NULL,
  `charge` decimal(10,2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `requirements` text DEFAULT NULL,
  `attachment` varchar(191) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `transaction_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `email_sms_templates`
--

CREATE TABLE `email_sms_templates` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `subject` varchar(191) NOT NULL,
  `email_body` text DEFAULT NULL,
  `sms_body` text DEFAULT NULL,
  `notification_body` text DEFAULT NULL,
  `shortcode` text DEFAULT NULL,
  `email_status` tinyint(4) NOT NULL DEFAULT 0,
  `sms_status` tinyint(4) NOT NULL DEFAULT 0,
  `notification_status` tinyint(4) NOT NULL DEFAULT 0,
  `template_mode` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 = all, 1 = email, 2 = sms, 3 = notification',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `email_sms_templates`
--

INSERT INTO `email_sms_templates` (`id`, `name`, `slug`, `subject`, `email_body`, `sms_body`, `notification_body`, `shortcode`, `email_status`, `sms_status`, `notification_status`, `template_mode`, `created_at`, `updated_at`) VALUES
(1, 'Transfer Money', 'TRANSFER_MONEY', 'Transfer Money', '<div>\r\n<div>Dear {{name}},</div>\r\n<div>You have received {{amount}} to {{account_number}} from {{sender_account_number}} on {{dateTime}}</div>\r\n</div>', 'Dear {{name}}, You have received {{amount}} to {{account_number}} from {{sender_account_number}} on {{dateTime}}', 'Dear {{name}}, You have received {{amount}} to {{account_number}} from {{sender_account_number}} on {{dateTime}}', '{{name}} {{account_number}} {{amount}} {{sender}} {{sender_account_number}} {{balance}} {{dateTime}}', 0, 0, 0, 0, NULL, NULL),
(2, 'Deposit Money', 'DEPOSIT_MONEY', 'Deposit Money', '<div>\r\n<div>Dear {{name}},</div>\r\n<div>Your account has been credited with {{amount}} on {{dateTime}}</div>\r\n</div>', 'Dear {{name}}, Your account has been credited with {{amount}} on {{dateTime}}', 'Dear {{name}}, Your account has been credited with {{amount}} on {{dateTime}}', '{{name}} {{account_number}} {{amount}} {{dateTime}} {{balance}} {{depositMethod}}', 0, 0, 0, 0, NULL, NULL),
(3, 'Deposit Request Approved', 'DEPOSIT_REQUEST_APPROVED', 'Deposit Request Approved', '<div>\r\n<div>Dear {{name}},</div>\r\n<div>Your deposit request has been approved. Your account {{account_number}} has been credited with {{amount}} on {{dateTime}}</div>\r\n</div>', 'Dear {{name}}, Your deposit request has been approved. Your account {{account_number}} has been credited with {{amount}} on {{dateTime}}', 'Dear {{name}}, Your deposit request has been approved. Your account {{account_number}} has been credited with {{amount}} on {{dateTime}}', '{{name}} {{account_number}} {{amount}} {{dateTime}} {{balance}} {{depositMethod}}', 0, 0, 0, 0, NULL, NULL),
(4, 'Loan Request Approved', 'LOAN_REQUEST_APPROVED', 'Loan Request Approved', '<div>\r\n<div>Dear {{name}},</div>\r\n<div>Your loan request of {{amount}} has been approved on {{dateTime}}</div>\r\n</div>', 'Dear {{name}}, Your loan request of {{amount}} has been approved on {{dateTime}}', 'Dear {{name}}, Your loan request of {{amount}} has been approved on {{dateTime}}', '{{name}} {{amount}} {{dateTime}}', 0, 0, 0, 0, NULL, NULL),
(5, 'Withdraw Request Approved', 'WITHDRAW_REQUEST_APPROVED', 'Withdraw Request Approved', '<div>\r\n<div>Dear {{name}},</div>\r\n<div>Your withdraw request has been approved. Your account has been debited with {{amount}} on {{dateTime}}</div>\r\n</div>', 'Dear {{name}}, Your withdraw request has been approved. Your account has been debited with {{amount}} on {{dateTime}}', 'Dear {{name}}, Your withdraw request has been approved. Your account has been debited with {{amount}} on {{dateTime}}', '{{name}} {{account_number}} {{amount}} {{withdrawMethod}} {{balance}} {{dateTime}}', 0, 0, 0, 0, NULL, NULL),
(6, 'Deposit Request Rejected', 'DEPOSIT_REQUEST_REJECTED', 'Deposit Request Rejected', '<div>\r\n<div>Dear {{name}},</div>\r\n<div>Your deposit request of {{amount}} has been rejected.</div>\r\n<div>&nbsp;</div>\r\n<div>Amount:&nbsp;{{amount}}</div>\r\n<div>Deposit Method: {{depositMethod}}</div>\r\n</div>', 'Dear {{name}}, Your deposit request of {{amount}} has been rejected.', 'Dear {{name}}, Your deposit request of {{amount}} has been rejected.', '{{name}}  {{account_number}} {{amount}} {{depositMethod}} {{balance}}', 0, 0, 0, 0, NULL, NULL),
(7, 'Loan Request Rejected', 'LOAN_REQUEST_REJECTED', 'Loan Request Rejected', '<div>\r\n<div>Dear {{name}},</div>\r\n<div>Your loan request of {{amount}} has been rejected on {{dateTime}}</div>\r\n</div>', 'Dear {{name}}, Your loan request of {{amount}} has been rejected on {{dateTime}}', 'Dear {{name}}, Your loan request of {{amount}} has been rejected on {{dateTime}}', '{{name}} {{amount}} {{dateTime}}', 0, 0, 0, 0, NULL, NULL),
(8, 'Withdraw Request Rejected', 'WITHDRAW_REQUEST_REJECTED', 'Withdraw Request Rejected', '<div>\r\n<div>Dear {{name}}, Your withdraw request has been rejected. Your transferred amount {{amount}} has returned back to your account.</div>\r\n</div>', 'Dear {{name}}, Your withdraw request has been rejected. Your transferred amount {{amount}} has returned back to your account.', 'Dear {{name}}, Your withdraw request has been rejected. Your transferred amount {{amount}} has returned back to your account.', '{{name}} {{account_number}} {{amount}} {{withdrawMethod}} {{dateTime}} {{balance}}', 0, 0, 0, 0, NULL, NULL),
(9, 'Withdraw Money', 'WITHDRAW_MONEY', 'Withdraw Money', '<div>\r\n<div>Dear {{name}},</div>\r\n<div>Your account has been debited with {{amount}} on {{dateTime}}</div>\r\n</div>', 'Dear {{name}}, Your account has been debited with {{amount}} on {{dateTime}}', 'Dear {{name}}, Your account has been debited with {{amount}} on {{dateTime}}', '{{name}} {{account_number}} {{amount}} {{dateTime}} {{withdrawMethod}} {{balance}}', 0, 0, 0, 0, NULL, NULL),
(10, 'Member Request Accepted', 'MEMBER_REQUEST_ACCEPTED', 'Member Request Accepted', '<div>\r\n<div>Dear {{name}},</div>\r\n<div>Your member request has been accepted by authority on {{dateTime}}. You can now login to your account by using your email and password.</div>\r\n</div>', '', '', '{{name}} {{member_no}} {{dateTime}}', 0, 0, 0, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `expense_date` datetime NOT NULL,
  `expense_category_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reference` varchar(191) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `attachment` varchar(191) DEFAULT NULL,
  `created_user_id` bigint(20) DEFAULT NULL,
  `updated_user_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `expense_categories`
--

CREATE TABLE `expense_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `color` varchar(20) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guarantors`
--

CREATE TABLE `guarantors` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `loan_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `father_name` varchar(191) DEFAULT NULL,
  `mobile` varchar(191) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `guarantor_documents`
--

CREATE TABLE `guarantor_documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `guarantor_id` bigint(20) UNSIGNED NOT NULL,
  `loan_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `document` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `interest_posting`
--

CREATE TABLE `interest_posting` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `account_type_id` bigint(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

CREATE TABLE `loans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `loan_id` varchar(30) DEFAULT NULL,
  `loan_product_id` bigint(20) UNSIGNED NOT NULL,
  `borrower_id` bigint(20) UNSIGNED NOT NULL,
  `term` varchar(30) DEFAULT NULL,
  `first_payment_date` date NOT NULL,
  `release_date` date DEFAULT NULL,
  `currency_id` bigint(20) NOT NULL,
  `applied_amount` decimal(10,2) NOT NULL,
  `total_payable` decimal(10,2) DEFAULT NULL,
  `total_paid` decimal(10,2) DEFAULT NULL,
  `foreclose_amount` decimal(10,2) DEFAULT NULL,
  `foreclose_difference` decimal(10,2) DEFAULT NULL,
  `late_payment_penalties` decimal(10,2) NOT NULL,
  `attachment` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `approved_date` date DEFAULT NULL,
  `approved_user_id` bigint(20) DEFAULT NULL,
  `created_user_id` bigint(20) DEFAULT NULL,
  `updated_user_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loans`
--

INSERT INTO `loans` (`id`, `loan_id`, `loan_product_id`, `borrower_id`, `term`, `first_payment_date`, `release_date`, `currency_id`, `applied_amount`, `total_payable`, `total_paid`, `foreclose_amount`, `foreclose_difference`, `late_payment_penalties`, `attachment`, `description`, `remarks`, `status`, `approved_date`, `approved_user_id`, `created_user_id`, `updated_user_id`, `branch_id`, `created_at`, `updated_at`) VALUES
(20, '1234', 3, 2, '12', '2019-04-10', '2019-04-10', 1, 18600.00, 18600.00, 8340.00, NULL, NULL, 0.00, '', NULL, NULL, 1, '2024-11-19', 1, 1, NULL, NULL, '2024-11-19 09:23:50', '2024-11-19 09:33:03'),
(21, '2', 4, 3, '12', '2019-04-10', '2019-04-10', 1, 31020.00, 31020.00, 14170.00, NULL, NULL, 0.00, '', NULL, NULL, 1, '2024-11-19', 1, 1, NULL, NULL, '2024-11-19 09:37:59', '2024-11-19 09:45:53'),
(23, 'sanju', 5, 4, '15', '2019-04-10', '2019-04-10', 1, 32475.00, 32475.00, 16460.00, NULL, NULL, 0.00, '', NULL, NULL, 1, '2024-11-19', 1, 1, NULL, NULL, '2024-11-19 09:53:34', '2024-11-19 10:14:47');

-- --------------------------------------------------------

--
-- Table structure for table `loan_collaterals`
--

CREATE TABLE `loan_collaterals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `loan_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `collateral_type` varchar(191) NOT NULL,
  `serial_number` varchar(191) DEFAULT NULL,
  `estimated_price` decimal(10,2) NOT NULL,
  `attachments` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loan_documents`
--

CREATE TABLE `loan_documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `loan_id` bigint(20) NOT NULL,
  `name` varchar(191) NOT NULL,
  `document` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `loan_payments`
--

CREATE TABLE `loan_payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `receipt_number` varchar(200) NOT NULL,
  `loan_id` bigint(20) UNSIGNED NOT NULL,
  `paid_at` date NOT NULL,
  `late_penalties` decimal(10,2) NOT NULL,
  `interest` decimal(10,2) NOT NULL,
  `paid_amount` decimal(10,2) NOT NULL,
  `repayment_amount` decimal(10,2) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `remaining_amount` decimal(10,2) NOT NULL,
  `remarks` text DEFAULT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `transaction_id` bigint(20) DEFAULT NULL,
  `repayment_id` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loan_payments`
--

INSERT INTO `loan_payments` (`id`, `receipt_number`, `loan_id`, `paid_at`, `late_penalties`, `interest`, `paid_amount`, `repayment_amount`, `total_amount`, `remaining_amount`, `remarks`, `member_id`, `transaction_id`, `repayment_id`, `created_at`, `updated_at`) VALUES
(37, '8100', 20, '2019-05-02', 0.00, 0.00, 1550.00, 1550.00, 1550.00, 0.00, NULL, 2, NULL, 129, '2024-11-19 09:26:19', '2024-11-19 09:26:19'),
(38, '8500', 20, '2019-08-14', 0.00, 0.00, 1550.00, 1550.00, 1550.00, 0.00, NULL, 2, NULL, 130, '2024-11-19 09:27:01', '2024-11-19 09:27:01'),
(39, '8500', 20, '2019-08-14', 64.00, 0.00, 1614.00, 1550.00, 1614.00, 0.00, NULL, 2, NULL, 131, '2024-11-19 09:28:47', '2024-11-19 09:28:47'),
(40, '8500', 20, '2019-08-14', 34.00, 0.00, 1584.00, 1550.00, 1584.00, 0.00, NULL, 2, NULL, 132, '2024-11-19 09:29:19', '2024-11-19 09:29:19'),
(41, '8500', 20, '2019-08-14', 4.00, 0.00, 1150.00, 1550.00, 1554.00, 404.00, NULL, 2, NULL, 133, '2024-11-19 09:29:59', '2024-11-19 09:29:59'),
(42, '8888', 20, '2019-11-06', 56.00, 0.00, 1050.00, 1550.00, 1606.00, 556.00, NULL, 2, NULL, 134, '2024-11-19 09:33:03', '2024-11-19 09:33:03'),
(43, '8053', 21, '2019-04-10', 0.00, 0.00, 2585.00, 2585.00, 2585.00, 0.00, NULL, 3, NULL, 141, '2024-11-19 09:39:19', '2024-11-19 09:39:19'),
(44, '8229', 21, '2019-06-11', 0.00, 0.00, 2585.00, 2585.00, 2585.00, 0.00, NULL, 3, NULL, 142, '2024-11-19 09:40:05', '2024-11-19 09:40:05'),
(45, '8229', 21, '2019-06-11', 0.00, 0.00, 1915.00, 2585.00, 2585.00, 670.00, NULL, 3, NULL, 143, '2024-11-19 09:41:51', '2024-11-19 09:41:51'),
(46, '8229', 21, '2024-11-19', 15.00, 0.00, 2600.00, 2585.00, 2600.00, 0.00, NULL, 3, NULL, 144, '2024-11-19 09:44:27', '2024-11-19 09:44:27'),
(47, '8485', 21, '2019-08-11', 0.00, 0.00, 2500.00, 2585.00, 2585.00, 85.00, NULL, 3, NULL, 145, '2024-11-19 09:45:18', '2024-11-19 09:45:18'),
(48, '8853', 21, '2019-10-31', 0.00, 0.00, 2000.00, 2585.00, 2585.00, 585.00, NULL, 3, NULL, 146, '2024-11-19 09:45:53', '2024-11-19 09:45:53'),
(49, '8230', 23, '2019-06-11', 335.00, 0.00, 2500.00, 2165.00, 2500.00, 0.00, NULL, 4, NULL, 165, '2024-11-19 09:55:04', '2024-11-19 09:55:04'),
(50, '8230', 23, '2019-04-10', 335.00, 0.00, 2500.00, 2165.00, 2500.00, 0.00, NULL, 4, NULL, 166, '2024-11-19 10:06:47', '2024-11-19 10:06:47'),
(51, '8488', 23, '2019-08-11', 85.00, 0.00, 2250.00, 2165.00, 2250.00, 0.00, NULL, 4, NULL, 167, '2024-11-19 10:07:59', '2024-11-19 10:07:59'),
(52, '8488', 23, '2019-07-10', 85.00, 0.00, 2250.00, 2165.00, 2250.00, 0.00, NULL, 4, NULL, 168, '2024-11-19 10:08:44', '2024-11-19 10:08:44'),
(53, '10456', 23, '2020-01-14', 0.00, 0.00, 2165.00, 2165.00, 2165.00, 0.00, NULL, 4, NULL, 169, '2024-11-19 10:11:44', '2024-11-19 10:11:44'),
(54, '10456', 23, '2020-01-14', 0.00, 0.00, 2165.00, 2165.00, 2165.00, 0.00, NULL, 4, NULL, 170, '2024-11-19 10:12:20', '2024-11-19 10:12:20'),
(55, '10456', 23, '2020-01-14', 0.00, 0.00, 2165.00, 2165.00, 2165.00, 0.00, NULL, 4, NULL, 171, '2024-11-19 10:12:55', '2024-11-19 10:12:55'),
(56, '10456', 23, '2024-01-14', 0.00, 0.00, 1305.00, 2165.00, 2165.00, 860.00, NULL, 4, NULL, 172, '2024-11-19 10:14:47', '2024-11-19 10:14:47');

-- --------------------------------------------------------

--
-- Table structure for table `loan_payment_history`
--

CREATE TABLE `loan_payment_history` (
  `id` int(11) NOT NULL,
  `loan_id` int(11) NOT NULL,
  `payment_id` int(11) NOT NULL,
  `repayment_id` int(11) NOT NULL,
  `amount_paid` decimal(10,2) NOT NULL,
  `late_penalties` decimal(10,2) NOT NULL DEFAULT 0.00,
  `remaining_balance` decimal(10,2) NOT NULL,
  `payment_date` datetime NOT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loan_payment_history`
--

INSERT INTO `loan_payment_history` (`id`, `loan_id`, `payment_id`, `repayment_id`, `amount_paid`, `late_penalties`, `remaining_balance`, `payment_date`, `status`, `created_at`, `updated_at`) VALUES
(26, 16, 26, 115, 5.00, 0.00, 5.00, '2024-11-20 00:00:00', 0, '2024-11-19 12:06:03', '2024-11-19 12:06:03'),
(25, 15, 25, 111, 13.00, 3.00, 0.00, '2024-11-19 00:00:00', 1, '2024-11-19 12:04:18', '2024-11-19 12:04:18'),
(24, 15, 24, 110, 12.00, 2.00, 0.00, '2024-11-19 00:00:00', 1, '2024-11-19 12:02:38', '2024-11-19 12:02:38'),
(23, 15, 23, 109, 15.00, 5.00, 0.00, '2024-12-27 00:00:00', 1, '2024-11-19 11:59:48', '2024-11-19 11:59:48'),
(27, 16, 27, 115, 1.00, 0.00, 4.00, '2024-11-19 00:00:00', 0, '2024-11-19 12:23:17', '2024-11-19 12:23:17'),
(28, 16, 28, 116, 4.00, 0.00, 6.00, '2024-11-19 00:00:00', 0, '2024-11-19 12:23:37', '2024-11-19 12:23:37'),
(29, 16, 29, 115, 1.00, 0.00, 3.00, '2024-11-19 00:00:00', 0, '2024-11-19 12:34:08', '2024-11-19 12:34:08'),
(30, 18, 30, 121, 1.00, 0.00, 9.00, '2024-11-19 00:00:00', 0, '2024-11-19 14:08:20', '2024-11-19 14:08:20'),
(31, 18, 31, 121, 2.00, 0.00, 7.00, '2024-11-19 00:00:00', 0, '2024-11-19 14:10:34', '2024-11-19 14:10:34'),
(32, 19, 32, 123, 6.00, 0.00, 4.00, '2024-11-19 00:00:00', 0, '2024-11-19 14:24:57', '2024-11-19 14:24:57'),
(33, 19, 33, 123, 4.00, 0.00, 0.00, '2024-11-19 00:00:00', 1, '2024-11-19 14:25:36', '2024-11-19 14:25:36'),
(34, 19, 34, 124, 5.00, 0.00, 5.00, '2024-11-19 00:00:00', 0, '2024-11-19 14:28:09', '2024-11-19 14:28:09'),
(35, 19, 35, 124, 5.00, 0.00, 0.00, '2024-11-19 00:00:00', 1, '2024-11-19 14:28:34', '2024-11-19 14:28:34'),
(36, 19, 36, 125, 30.00, 20.00, 0.00, '2024-11-19 00:00:00', 1, '2024-11-19 14:29:35', '2024-11-19 14:29:35'),
(37, 20, 37, 129, 1550.00, 0.00, 0.00, '2019-05-02 00:00:00', 1, '2024-11-19 14:56:19', '2024-11-19 14:56:19'),
(38, 20, 38, 130, 1550.00, 0.00, 0.00, '2019-08-14 00:00:00', 1, '2024-11-19 14:57:01', '2024-11-19 14:57:01'),
(39, 20, 39, 131, 1614.00, 64.00, 0.00, '2019-08-14 00:00:00', 1, '2024-11-19 14:58:47', '2024-11-19 14:58:47'),
(40, 20, 40, 132, 1584.00, 34.00, 0.00, '2019-08-14 00:00:00', 1, '2024-11-19 14:59:19', '2024-11-19 14:59:19'),
(41, 20, 41, 133, 1150.00, 4.00, 404.00, '2019-08-14 00:00:00', 0, '2024-11-19 14:59:59', '2024-11-19 14:59:59'),
(42, 20, 42, 134, 1050.00, 56.00, 556.00, '2019-11-06 00:00:00', 0, '2024-11-19 15:03:03', '2024-11-19 15:03:03'),
(43, 21, 43, 141, 2585.00, 0.00, 0.00, '2019-04-10 00:00:00', 1, '2024-11-19 15:09:19', '2024-11-19 15:09:19'),
(44, 21, 44, 142, 2585.00, 0.00, 0.00, '2019-06-11 00:00:00', 1, '2024-11-19 15:10:05', '2024-11-19 15:10:05'),
(45, 21, 45, 143, 1915.00, 0.00, 670.00, '2019-06-11 00:00:00', 0, '2024-11-19 15:11:51', '2024-11-19 15:11:51'),
(46, 21, 46, 144, 2600.00, 15.00, 0.00, '2024-11-19 00:00:00', 1, '2024-11-19 15:14:27', '2024-11-19 15:14:27'),
(47, 21, 47, 145, 2500.00, 0.00, 85.00, '2019-08-11 00:00:00', 0, '2024-11-19 15:15:18', '2024-11-19 15:15:18'),
(48, 21, 48, 146, 2000.00, 0.00, 585.00, '2019-10-31 00:00:00', 0, '2024-11-19 15:15:53', '2024-11-19 15:15:53'),
(49, 23, 49, 165, 2500.00, 335.00, 0.00, '2019-06-11 00:00:00', 1, '2024-11-19 15:25:04', '2024-11-19 15:25:04'),
(50, 23, 50, 166, 2500.00, 335.00, 0.00, '2019-04-10 00:00:00', 1, '2024-11-19 15:36:47', '2024-11-19 15:36:47'),
(51, 23, 51, 167, 2250.00, 85.00, 0.00, '2019-08-11 00:00:00', 1, '2024-11-19 15:37:59', '2024-11-19 15:37:59'),
(52, 23, 52, 168, 2250.00, 85.00, 0.00, '2019-07-10 00:00:00', 1, '2024-11-19 15:38:44', '2024-11-19 15:38:44'),
(53, 23, 53, 169, 2165.00, 0.00, 0.00, '2020-01-14 00:00:00', 1, '2024-11-19 15:41:44', '2024-11-19 15:41:44'),
(54, 23, 54, 170, 2165.00, 0.00, 0.00, '2019-09-10 00:00:00', 1, '2024-11-19 15:42:20', '2024-11-19 15:42:20'),
(55, 23, 55, 171, 2165.00, 0.00, 0.00, '2020-01-14 00:00:00', 1, '2024-11-19 15:42:55', '2024-11-19 15:42:55'),
(56, 23, 56, 172, 1305.00, 0.00, 860.00, '2024-01-14 00:00:00', 0, '2024-11-19 15:44:47', '2024-11-19 15:44:47');

-- --------------------------------------------------------

--
-- Table structure for table `loan_products`
--

CREATE TABLE `loan_products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `minimum_amount` decimal(10,2) NOT NULL,
  `maximum_amount` decimal(10,2) NOT NULL,
  `late_payment_penalties` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `interest_rate` decimal(10,2) NOT NULL,
  `interest_type` varchar(191) NOT NULL,
  `term` int(11) NOT NULL,
  `term_period` varchar(15) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loan_products`
--

INSERT INTO `loan_products` (`id`, `name`, `minimum_amount`, `maximum_amount`, `late_payment_penalties`, `description`, `interest_rate`, `interest_type`, `term`, `term_period`, `status`, `created_at`, `updated_at`) VALUES
(3, 'abc', 1.00, 50000.00, 0.00, NULL, 0.00, 'fixed_rate', 12, '+1 month', 1, '2024-11-19 09:22:34', '2024-11-19 09:22:34'),
(4, 'abcd', 1.00, 50000.00, 0.00, NULL, 0.00, 'fixed_rate', 12, '+1 month', 1, '2024-11-19 09:36:48', '2024-11-19 09:36:48'),
(5, 'aa', 1.00, 50000.00, 0.00, NULL, 0.00, 'fixed_rate', 12, '+1 month', 1, '2024-11-19 09:47:20', '2024-11-19 09:47:20');

-- --------------------------------------------------------

--
-- Table structure for table `loan_repayments`
--

CREATE TABLE `loan_repayments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `loan_id` bigint(20) NOT NULL,
  `repayment_date` date NOT NULL,
  `amount_to_pay` decimal(10,2) NOT NULL,
  `penalty` decimal(10,2) NOT NULL,
  `principal_amount` decimal(10,2) NOT NULL,
  `interest` decimal(10,2) NOT NULL,
  `balance` decimal(10,2) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loan_repayments`
--

INSERT INTO `loan_repayments` (`id`, `loan_id`, `repayment_date`, `amount_to_pay`, `penalty`, `principal_amount`, `interest`, `balance`, `status`, `created_at`, `updated_at`) VALUES
(129, 20, '2019-04-10', 1550.00, 0.00, 1550.00, 0.00, 17050.00, 1, '2024-11-19 09:23:55', '2024-11-19 09:26:19'),
(130, 20, '2019-05-10', 1550.00, 0.00, 1550.00, 0.00, 15500.00, 1, '2024-11-19 09:23:55', '2024-11-19 09:27:01'),
(131, 20, '2019-06-10', 1550.00, 0.00, 1550.00, 0.00, 13950.00, 1, '2024-11-19 09:23:55', '2024-11-19 09:28:47'),
(132, 20, '2019-07-10', 1550.00, 0.00, 1550.00, 0.00, 12400.00, 1, '2024-11-19 09:23:55', '2024-11-19 09:29:19'),
(133, 20, '2019-08-10', 1550.00, 0.00, 1550.00, 0.00, 10850.00, 0, '2024-11-19 09:23:55', '2024-11-19 09:23:55'),
(134, 20, '2019-09-10', 1550.00, 0.00, 1550.00, 0.00, 9300.00, 0, '2024-11-19 09:23:55', '2024-11-19 09:23:55'),
(135, 20, '2019-10-10', 1550.00, 0.00, 1550.00, 0.00, 7750.00, 0, '2024-11-19 09:23:55', '2024-11-19 09:23:55'),
(136, 20, '2019-11-10', 1550.00, 0.00, 1550.00, 0.00, 6200.00, 0, '2024-11-19 09:23:55', '2024-11-19 09:23:55'),
(137, 20, '2019-12-10', 1550.00, 0.00, 1550.00, 0.00, 4650.00, 0, '2024-11-19 09:23:55', '2024-11-19 09:23:55'),
(138, 20, '2020-01-10', 1550.00, 0.00, 1550.00, 0.00, 3100.00, 0, '2024-11-19 09:23:55', '2024-11-19 09:23:55'),
(139, 20, '2020-02-10', 1550.00, 0.00, 1550.00, 0.00, 1550.00, 0, '2024-11-19 09:23:55', '2024-11-19 09:23:55'),
(140, 20, '2020-03-10', 1550.00, 0.00, 1550.00, 0.00, 0.00, 0, '2024-11-19 09:23:55', '2024-11-19 09:23:55'),
(141, 21, '2019-04-10', 2585.00, 0.00, 2585.00, 0.00, 28435.00, 1, '2024-11-19 09:38:01', '2024-11-19 09:39:19'),
(142, 21, '2019-05-10', 2585.00, 0.00, 2585.00, 0.00, 25850.00, 1, '2024-11-19 09:38:01', '2024-11-19 09:40:05'),
(143, 21, '2019-06-10', 2585.00, 0.00, 2585.00, 0.00, 23265.00, 0, '2024-11-19 09:38:01', '2024-11-19 09:38:01'),
(144, 21, '2019-07-10', 2585.00, 0.00, 2585.00, 0.00, 20680.00, 1, '2024-11-19 09:38:01', '2024-11-19 09:44:27'),
(145, 21, '2019-08-10', 2585.00, 0.00, 2585.00, 0.00, 18095.00, 0, '2024-11-19 09:38:01', '2024-11-19 09:38:01'),
(146, 21, '2019-09-10', 2585.00, 0.00, 2585.00, 0.00, 15510.00, 0, '2024-11-19 09:38:01', '2024-11-19 09:38:01'),
(147, 21, '2019-10-10', 2585.00, 0.00, 2585.00, 0.00, 12925.00, 0, '2024-11-19 09:38:01', '2024-11-19 09:38:01'),
(148, 21, '2019-11-10', 2585.00, 0.00, 2585.00, 0.00, 10340.00, 0, '2024-11-19 09:38:01', '2024-11-19 09:38:01'),
(149, 21, '2019-12-10', 2585.00, 0.00, 2585.00, 0.00, 7755.00, 0, '2024-11-19 09:38:01', '2024-11-19 09:38:01'),
(150, 21, '2020-01-10', 2585.00, 0.00, 2585.00, 0.00, 5170.00, 0, '2024-11-19 09:38:01', '2024-11-19 09:38:01'),
(151, 21, '2020-02-10', 2585.00, 0.00, 2585.00, 0.00, 2585.00, 0, '2024-11-19 09:38:01', '2024-11-19 09:38:01'),
(152, 21, '2020-03-10', 2585.00, 0.00, 2585.00, 0.00, 0.00, 0, '2024-11-19 09:38:01', '2024-11-19 09:38:01'),
(165, 23, '2019-04-10', 2165.00, 0.00, 2165.00, 0.00, 30310.00, 1, '2024-11-19 09:53:36', '2024-11-19 09:55:04'),
(166, 23, '2019-05-10', 2165.00, 0.00, 2165.00, 0.00, 28145.00, 1, '2024-11-19 09:53:36', '2024-11-19 10:06:47'),
(167, 23, '2019-06-10', 2165.00, 0.00, 2165.00, 0.00, 25980.00, 1, '2024-11-19 09:53:36', '2024-11-19 10:07:59'),
(168, 23, '2019-07-10', 2165.00, 0.00, 2165.00, 0.00, 23815.00, 1, '2024-11-19 09:53:36', '2024-11-19 10:08:44'),
(169, 23, '2019-08-10', 2165.00, 0.00, 2165.00, 0.00, 21650.00, 1, '2024-11-19 09:53:36', '2024-11-19 10:11:44'),
(170, 23, '2019-09-10', 2165.00, 0.00, 2165.00, 0.00, 19485.00, 1, '2024-11-19 09:53:36', '2024-11-19 10:12:20'),
(171, 23, '2019-10-10', 2165.00, 0.00, 2165.00, 0.00, 17320.00, 1, '2024-11-19 09:53:36', '2024-11-19 10:12:55'),
(172, 23, '2019-11-10', 2165.00, 0.00, 2165.00, 0.00, 15155.00, 0, '2024-11-19 09:53:36', '2024-11-19 09:53:36'),
(173, 23, '2019-12-10', 2165.00, 0.00, 2165.00, 0.00, 12990.00, 0, '2024-11-19 09:53:36', '2024-11-19 09:53:36'),
(174, 23, '2020-01-10', 2165.00, 0.00, 2165.00, 0.00, 10825.00, 0, '2024-11-19 09:53:36', '2024-11-19 09:53:36'),
(175, 23, '2020-02-10', 2165.00, 0.00, 2165.00, 0.00, 8660.00, 0, '2024-11-19 09:53:36', '2024-11-19 09:53:36'),
(176, 23, '2020-03-10', 2165.00, 0.00, 2165.00, 0.00, 6495.00, 0, '2024-11-19 09:53:36', '2024-11-19 09:53:36'),
(177, 23, '2020-04-10', 2165.00, 0.00, 2165.00, 0.00, 4330.00, 0, '2024-11-19 09:53:36', '2024-11-19 09:53:36'),
(178, 23, '2020-05-10', 2165.00, 0.00, 2165.00, 0.00, 2165.00, 0, '2024-11-19 09:53:36', '2024-11-19 09:53:36'),
(179, 23, '2020-06-10', 2165.00, 0.00, 2165.00, 0.00, 0.00, 0, '2024-11-19 09:53:36', '2024-11-19 09:53:36');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `email` varchar(100) DEFAULT NULL,
  `country_code` varchar(10) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `business_name` varchar(100) DEFAULT NULL,
  `member_no` varchar(50) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `city` varchar(191) DEFAULT NULL,
  `state` varchar(191) DEFAULT NULL,
  `zip` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `credit_source` varchar(191) DEFAULT NULL,
  `photo` varchar(191) DEFAULT NULL,
  `custom_fields` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `aadhaar_no` varchar(191) DEFAULT NULL,
  `pan_card_no` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `first_name`, `last_name`, `branch_id`, `user_id`, `status`, `email`, `country_code`, `mobile`, `business_name`, `member_no`, `gender`, `city`, `state`, `zip`, `address`, `credit_source`, `photo`, `custom_fields`, `created_at`, `updated_at`, `aadhaar_no`, `pan_card_no`) VALUES
(2, 'Rajulal', 'Regar', NULL, NULL, 1, NULL, '98', '6209124210', NULL, '1', 'male', 'chittorgarh', 'Rajasthan', '312001', 'Begu', NULL, 'default.png', NULL, '2024-11-19 09:21:32', '2024-11-19 09:21:32', NULL, NULL),
(3, 'shankarlal', 'ajuri', NULL, NULL, 1, NULL, '91', '8875793587', NULL, '2', 'male', 'chittorgarh', 'Rajasthan', '312001', NULL, NULL, 'default.png', NULL, '2024-11-19 09:35:45', '2024-11-19 09:35:45', NULL, NULL),
(4, 'sanju', 'ansari', NULL, NULL, 1, NULL, '91', '7733024676', NULL, '3', 'male', 'chittorgarh', 'Rajasthan', '312001', NULL, NULL, 'default.png', NULL, '2024-11-19 09:49:01', '2024-11-19 09:49:01', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `member_documents`
--

CREATE TABLE `member_documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `document` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_09_01_080940_create_settings_table', 1),
(5, '2020_07_02_145857_create_database_backups_table', 1),
(6, '2020_07_06_142817_create_roles_table', 1),
(7, '2020_07_06_143240_create_permissions_table', 1),
(8, '2021_03_22_071324_create_setting_translations', 1),
(9, '2021_07_02_145504_create_pages_table', 1),
(10, '2021_07_02_145952_create_page_translations_table', 1),
(11, '2021_08_06_104648_create_branches_table', 1),
(12, '2021_08_07_111236_create_currency_table', 1),
(13, '2021_08_08_132702_create_payment_gateways_table', 1),
(14, '2021_08_08_152535_create_deposit_methods_table', 1),
(15, '2021_08_08_164152_create_withdraw_methods_table', 1),
(16, '2021_08_31_201125_create_navigations_table', 1),
(17, '2021_08_31_201126_create_navigation_items_table', 1),
(18, '2021_08_31_201127_create_navigation_item_translations_table', 1),
(19, '2021_10_22_070458_create_email_sms_templates_table', 1),
(20, '2022_03_21_075342_create_members_table', 1),
(21, '2022_03_24_090932_create_member_documents_table', 1),
(22, '2022_03_28_114203_create_savings_products_table', 1),
(23, '2022_04_13_073108_create_savings_accounts_table', 1),
(24, '2022_04_13_073109_create_transactions_table', 1),
(25, '2022_05_31_074804_create_expense_categories_table', 1),
(26, '2022_05_31_074918_create_expenses_table', 1),
(27, '2022_06_01_082019_create_loan_products_table', 1),
(28, '2022_06_01_083021_create_loans_table', 1),
(29, '2022_06_01_083022_create_loan_collaterals_table', 1),
(30, '2022_06_01_083025_create_loan_payments_table', 1),
(31, '2022_06_01_083069_create_loan_repayments_table', 1),
(32, '2022_06_06_072245_create_guarantors_table', 1),
(33, '2022_07_26_155338_create_deposit_requests_table', 1),
(34, '2022_07_26_163427_create_withdraw_requests_table', 1),
(35, '2022_08_09_160105_create_notifications_table', 1),
(36, '2022_08_15_055625_create_interest_posting_table', 1),
(37, '2022_08_27_151317_create_transaction_categories_table', 1),
(38, '2022_08_29_102757_create_schedule_tasks_histories_table', 1),
(39, '2022_09_13_162539_add_branch_id_to_users_table', 1),
(40, '2022_09_18_074806_add_branch_id_to_expenses_table', 1),
(41, '2022_10_16_081858_add_charge_to_deposit_requests_table', 1),
(42, '2022_10_29_095023_add_status_to_members_table', 1),
(43, '2023_01_29_093731_create_charge_limits_table', 1),
(44, '2023_08_19_094327_add_column_to_members_table', 1),
(45, '2023_08_19_103847_create_guarantor_documents_table', 1),
(46, '2023_08_20_065226_create_loan_documents_table', 1),
(47, '2024_04_28_090748_update_columns_to_guarantors_table', 1),
(48, '2024_04_28_094242_add_column_to_loans_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `navigations`
--

CREATE TABLE `navigations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `navigation_items`
--

CREATE TABLE `navigation_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `navigation_id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(20) NOT NULL,
  `page_id` bigint(20) UNSIGNED DEFAULT NULL,
  `url` varchar(191) DEFAULT NULL,
  `icon` varchar(191) DEFAULT NULL,
  `target` varchar(191) NOT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `position` int(10) UNSIGNED DEFAULT NULL,
  `status` tinyint(1) NOT NULL,
  `css_class` varchar(191) DEFAULT NULL,
  `css_id` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `navigation_item_translations`
--

CREATE TABLE `navigation_item_translations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `navigation_item_id` bigint(20) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(191) NOT NULL,
  `notifiable_type` varchar(191) NOT NULL,
  `notifiable_id` bigint(20) UNSIGNED NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `slug` varchar(191) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `page_translations`
--

CREATE TABLE `page_translations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `page_id` bigint(20) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `title` text NOT NULL,
  `body` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_gateways`
--

CREATE TABLE `payment_gateways` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(30) NOT NULL,
  `slug` varchar(30) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `is_crypto` tinyint(4) NOT NULL DEFAULT 0,
  `parameters` text DEFAULT NULL,
  `currency` varchar(3) DEFAULT NULL,
  `supported_currencies` text DEFAULT NULL,
  `extra` text DEFAULT NULL,
  `exchange_rate` decimal(10,6) DEFAULT NULL,
  `fixed_charge` decimal(10,2) NOT NULL DEFAULT 0.00,
  `charge_in_percentage` decimal(10,2) NOT NULL DEFAULT 0.00,
  `minimum_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `maximum_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_gateways`
--

INSERT INTO `payment_gateways` (`id`, `name`, `slug`, `image`, `status`, `is_crypto`, `parameters`, `currency`, `supported_currencies`, `extra`, `exchange_rate`, `fixed_charge`, `charge_in_percentage`, `minimum_amount`, `maximum_amount`, `created_at`, `updated_at`) VALUES
(1, 'PayPal', 'PayPal', 'paypal.png', 0, 0, '{\"client_id\":\"\",\"client_secret\":\"\",\"environment\":\"sandbox\"}', NULL, '{\"AUD\":\"AUD\",\"BRL\":\"BRL\",\"CAD\":\"CAD\",\"CZK\":\"CZK\",\"DKK\":\"DKK\",\"EUR\":\"EUR\",\"HKD\":\"HKD\",\"HUF\":\"HUF\",\"INR\":\"INR\",\"ILS\":\"ILS\",\"JPY\":\"JPY\",\"MYR\":\"MYR\",\"MXN\":\"MXN\",\"TWD\":\"TWD\",\"NZD\":\"NZD\",\"NOK\":\"NOK\",\"PHP\":\"PHP\",\"PLN\":\"PLN\",\"GBP\":\"GBP\",\"RUB\":\"RUB\",\"SGD\":\"SGD\",\"SEK\":\"SEK\",\"CHF\":\"CHF\",\"THB\":\"THB\",\"USD\":\"USD\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL),
(2, 'Stripe', 'Stripe', 'stripe.png', 0, 0, '{\"secret_key\":\"\",\"publishable_key\":\"\"}', NULL, '{\"USD\":\"USD\",\"AUD\":\"AUD\",\"BRL\":\"BRL\",\"CAD\":\"CAD\",\"CHF\":\"CHF\",\"DKK\":\"DKK\",\"EUR\":\"EUR\",\"GBP\":\"GBP\",\"HKD\":\"HKD\",\"INR\":\"INR\",\"JPY\":\"JPY\",\"MXN\":\"MXN\",\"MYR\":\"MYR\",\"NOK\":\"NOK\",\"NZD\":\"NZD\",\"PLN\":\"PLN\",\"SEK\":\"SEK\",\"SGD\":\"SGD\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL),
(3, 'Razorpay', 'Razorpay', 'razorpay.png', 0, 0, '{\"razorpay_key_id\":\"\",\"razorpay_key_secret\":\"\"}', NULL, '{\"INR\":\"INR\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL),
(4, 'Paystack', 'Paystack', 'paystack.png', 0, 0, '{\"paystack_public_key\":\"\",\"paystack_secret_key\":\"\"}', NULL, '{\"GHS\":\"GHS\",\"NGN\":\"NGN\",\"ZAR\":\"ZAR\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL),
(5, 'BlockChain', 'BlockChain', 'blockchain.png', 0, 1, '{\"blockchain_api_key\":\"\",\"blockchain_xpub\":\"\"}', NULL, '{\"BTC\":\"BTC\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL),
(6, 'Flutterwave', 'Flutterwave', 'flutterwave.png', 0, 0, '{\"public_key\":\"\",\"secret_key\":\"\",\"encryption_key\":\"\",\"environment\":\"sandbox\"}', NULL, '{\"BIF\":\"BIF\",\"CAD\":\"CAD\",\"CDF\":\"CDF\",\"CVE\":\"CVE\",\"EUR\":\"EUR\",\"GBP\":\"GBP\",\"GHS\":\"GHS\",\"GMD\":\"GMD\",\"GNF\":\"GNF\",\"KES\":\"KES\",\"LRD\":\"LRD\",\"MWK\":\"MWK\",\"MZN\":\"MZN\",\"NGN\":\"NGN\",\"RWF\":\"RWF\",\"SLL\":\"SLL\",\"STD\":\"STD\",\"TZS\":\"TZS\",\"UGX\":\"UGX\",\"USD\":\"USD\",\"XAF\":\"XAF\",\"XOF\":\"XOF\",\"ZMK\":\"ZMK\",\"ZMW\":\"ZMW\",\"ZWD\":\"ZWD\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL),
(7, 'VoguePay', 'VoguePay', 'VoguePay.png', 1, 0, '{\"merchant_id\":\"\"}', NULL, '{\"USD\":\"USD\",\"GBP\":\"GBP\",\"EUR\":\"EUR\",\"GHS\":\"GHS\",\"NGN\":\"NGN\",\"ZAR\":\"ZAR\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL),
(8, 'Mollie', 'Mollie', 'Mollie.png', 1, 0, '{\"api_key\":\"\"}', NULL, '{\"AED\":\"AED\",\"AUD\":\"AUD\",\"BGN\":\"BGN\",\"BRL\":\"BRL\",\"CAD\":\"CAD\",\"CHF\":\"CHF\",\"CZK\":\"CZK\",\"DKK\":\"DKK\",\"EUR\":\"EUR\",\"GBP\":\"GBP\",\"HKD\":\"HKD\",\"HRK\":\"HRK\",\"HUF\":\"HUF\",\"ILS\":\"ILS\",\"ISK\":\"ISK\",\"JPY\":\"JPY\",\"MXN\":\"MXN\",\"MYR\":\"MYR\",\"NOK\":\"NOK\",\"NZD\":\"NZD\",\"PHP\":\"PHP\",\"PLN\":\"PLN\",\"RON\":\"RON\",\"RUB\":\"RUB\",\"SEK\":\"SEK\",\"SGD\":\"SGD\",\"THB\":\"THB\",\"TWD\":\"TWD\",\"USD\":\"USD\",\"ZAR\":\"ZAR\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL),
(9, 'CoinPayments', 'CoinPayments', 'CoinPayments.png', 1, 1, '{\"public_key\":\"\",\"private_key\":\"\",\"merchant_id\":\"\",\"ipn_secret\":\"\"}', NULL, '{\"BTC\":\"Bitcoin\",\"BTC.LN\":\"Bitcoin (Lightning Network)\",\"LTC\":\"Litecoin\",\"CPS\":\"CPS Coin\",\"VLX\":\"Velas\",\"APL\":\"Apollo\",\"AYA\":\"Aryacoin\",\"BAD\":\"Badcoin\",\"BCD\":\"Bitcoin Diamond\",\"BCH\":\"Bitcoin Cash\",\"BCN\":\"Bytecoin\",\"BEAM\":\"BEAM\",\"BITB\":\"Bean Cash\",\"BLK\":\"BlackCoin\",\"BSV\":\"Bitcoin SV\",\"BTAD\":\"Bitcoin Adult\",\"BTG\":\"Bitcoin Gold\",\"BTT\":\"BitTorrent\",\"CLOAK\":\"CloakCoin\",\"CLUB\":\"ClubCoin\",\"CRW\":\"Crown\",\"CRYP\":\"CrypticCoin\",\"CRYT\":\"CryTrExCoin\",\"CURE\":\"CureCoin\",\"DASH\":\"DASH\",\"DCR\":\"Decred\",\"DEV\":\"DeviantCoin\",\"DGB\":\"DigiByte\",\"DOGE\":\"Dogecoin\",\"EBST\":\"eBoost\",\"EOS\":\"EOS\",\"ETC\":\"Ether Classic\",\"ETH\":\"Ethereum\",\"ETN\":\"Electroneum\",\"EUNO\":\"EUNO\",\"EXP\":\"EXP\",\"Expanse\":\"Expanse\",\"FLASH\":\"FLASH\",\"GAME\":\"GameCredits\",\"GLC\":\"Goldcoin\",\"GRS\":\"Groestlcoin\",\"KMD\":\"Komodo\",\"LOKI\":\"LOKI\",\"LSK\":\"LSK\",\"MAID\":\"MaidSafeCoin\",\"MUE\":\"MonetaryUnit\",\"NAV\":\"NAV Coin\",\"NEO\":\"NEO\",\"NMC\":\"Namecoin\",\"NVST\":\"NVO Token\",\"NXT\":\"NXT\",\"OMNI\":\"OMNI\",\"PINK\":\"PinkCoin\",\"PIVX\":\"PIVX\",\"POT\":\"PotCoin\",\"PPC\":\"Peercoin\",\"PROC\":\"ProCurrency\",\"PURA\":\"PURA\",\"QTUM\":\"QTUM\",\"RES\":\"Resistance\",\"RVN\":\"Ravencoin\",\"RVR\":\"RevolutionVR\",\"SBD\":\"Steem Dollars\",\"SMART\":\"SmartCash\",\"SOXAX\":\"SOXAX\",\"STEEM\":\"STEEM\",\"STRAT\":\"STRAT\",\"SYS\":\"Syscoin\",\"TPAY\":\"TokenPay\",\"TRIGGERS\":\"Triggers\",\"TRX\":\" TRON\",\"UBQ\":\"Ubiq\",\"UNIT\":\"UniversalCurrency\",\"USDT\":\"Tether USD (Omni Layer)\",\"VTC\":\"Vertcoin\",\"WAVES\":\"Waves\",\"XEM\":\"NEM\",\"XMR\":\"Monero\",\"XSN\":\"Stakenet\",\"XSR\":\"SucreCoin\",\"XVG\":\"VERGE\",\"XZC\":\"ZCoin\",\"ZEC\":\"ZCash\",\"ZEN\":\"Horizen\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL),
(10, 'Instamojo', 'Instamojo', 'instamojo.png', 1, 0, '{\"api_key\":\"\",\"auth_token\":\"\",\"salt\":\"\",\"environment\":\"sandbox\"}', NULL, '{\"INR\":\"INR\"}', NULL, NULL, 0.00, 0.00, 0.00, 0.00, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) NOT NULL,
  `permission` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `savings_accounts`
--

CREATE TABLE `savings_accounts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `account_number` varchar(30) NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `savings_product_id` bigint(20) UNSIGNED NOT NULL,
  `status` int(11) NOT NULL COMMENT '1 = action | 2 = Deactivate',
  `opening_balance` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `created_user_id` bigint(20) DEFAULT NULL,
  `updated_user_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `savings_products`
--

CREATE TABLE `savings_products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `currency_id` bigint(20) UNSIGNED NOT NULL,
  `interest_rate` decimal(8,2) DEFAULT NULL,
  `interest_method` varchar(30) DEFAULT NULL,
  `interest_period` int(11) DEFAULT NULL,
  `interest_posting_period` int(11) DEFAULT NULL,
  `min_bal_interest_rate` decimal(10,2) DEFAULT NULL,
  `allow_withdraw` tinyint(4) NOT NULL DEFAULT 1,
  `minimum_account_balance` decimal(10,2) NOT NULL DEFAULT 0.00,
  `minimum_deposit_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `maintenance_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `maintenance_fee_posting_period` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL COMMENT '1 = active | 2 = Deactivate',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `schedule_tasks_histories`
--

CREATE TABLE `schedule_tasks_histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(30) NOT NULL,
  `reference_id` bigint(20) DEFAULT NULL,
  `others` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `value` longtext NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `name`, `value`, `created_at`, `updated_at`) VALUES
(1, 'mail_type', 'smtp', NULL, NULL),
(2, 'backend_direction', 'ltr', NULL, NULL),
(3, 'language', 'English', NULL, NULL),
(4, 'email_verification', 'disabled', NULL, NULL),
(5, 'allow_singup', 'yes', NULL, NULL),
(6, 'company_name', 'Techno', '2024-11-14 03:14:38', '2024-11-14 03:14:38'),
(7, 'site_title', 'Loan Management', '2024-11-14 03:14:38', '2024-11-14 03:14:38'),
(8, 'phone', '1234567890', '2024-11-14 03:14:38', '2024-11-14 03:14:38'),
(9, 'email', 'admin@gmail.com', '2024-11-14 03:14:38', '2024-11-14 03:14:38'),
(10, 'timezone', 'Asia/Kolkata', '2024-11-14 03:14:38', '2024-11-14 03:14:38');

-- --------------------------------------------------------

--
-- Table structure for table `setting_translations`
--

CREATE TABLE `setting_translations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `setting_id` bigint(20) UNSIGNED NOT NULL,
  `locale` varchar(191) NOT NULL,
  `value` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `trans_date` datetime NOT NULL,
  `savings_account_id` bigint(20) UNSIGNED DEFAULT NULL,
  `charge` decimal(10,2) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `gateway_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `dr_cr` varchar(2) NOT NULL,
  `type` varchar(30) NOT NULL,
  `method` varchar(20) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `note` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `loan_id` bigint(20) DEFAULT NULL,
  `ref_id` bigint(20) DEFAULT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT 'Parent transaction id',
  `gateway_id` bigint(20) DEFAULT NULL COMMENT 'PayPal | Stripe | Other Gateway',
  `created_user_id` bigint(20) DEFAULT NULL,
  `updated_user_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) DEFAULT NULL,
  `transaction_details` text DEFAULT NULL,
  `tracking_id` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_categories`
--

CREATE TABLE `transaction_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(30) NOT NULL,
  `related_to` varchar(2) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `note` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `user_type` varchar(20) NOT NULL,
  `role_id` bigint(20) DEFAULT NULL,
  `branch_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` int(11) NOT NULL,
  `profile_picture` varchar(191) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) DEFAULT NULL,
  `provider` varchar(191) DEFAULT NULL,
  `provider_id` varchar(191) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `user_type`, `role_id`, `branch_id`, `status`, `profile_picture`, `email_verified_at`, `password`, `provider`, `provider_id`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@gmail.com', 'admin', NULL, NULL, 1, 'profile_1731574224.jpg', '2024-11-14 03:14:02', '$2y$10$hXW5gpGu5PDHfbM2PE./Yuq8GMnypfCqoIIAzW.FntZqg/UmZv6o6', NULL, NULL, NULL, '2024-11-14 03:14:02', '2024-11-14 08:50:24');

-- --------------------------------------------------------

--
-- Table structure for table `withdraw_methods`
--

CREATE TABLE `withdraw_methods` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `currency_id` bigint(20) NOT NULL,
  `minimum_amount` decimal(10,2) NOT NULL,
  `maximum_amount` decimal(10,2) NOT NULL,
  `fixed_charge` decimal(10,2) NOT NULL,
  `charge_in_percentage` decimal(10,2) NOT NULL,
  `descriptions` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `requirements` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `withdraw_requests`
--

CREATE TABLE `withdraw_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `method_id` bigint(20) UNSIGNED NOT NULL,
  `debit_account_id` bigint(20) UNSIGNED NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `converted_amount` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `requirements` text DEFAULT NULL,
  `attachment` varchar(191) DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0,
  `transaction_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `branches`
--
ALTER TABLE `branches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `charge_limits`
--
ALTER TABLE `charge_limits`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `currency`
--
ALTER TABLE `currency`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `database_backups`
--
ALTER TABLE `database_backups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deposit_methods`
--
ALTER TABLE `deposit_methods`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deposit_requests`
--
ALTER TABLE `deposit_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `deposit_requests_member_id_foreign` (`member_id`),
  ADD KEY `deposit_requests_method_id_foreign` (`method_id`),
  ADD KEY `deposit_requests_credit_account_id_foreign` (`credit_account_id`);

--
-- Indexes for table `email_sms_templates`
--
ALTER TABLE `email_sms_templates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `expenses_expense_category_id_foreign` (`expense_category_id`),
  ADD KEY `expenses_branch_id_foreign` (`branch_id`);

--
-- Indexes for table `expense_categories`
--
ALTER TABLE `expense_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `guarantors`
--
ALTER TABLE `guarantors`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guarantors_loan_id_foreign` (`loan_id`);

--
-- Indexes for table `guarantor_documents`
--
ALTER TABLE `guarantor_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guarantor_documents_guarantor_id_foreign` (`guarantor_id`),
  ADD KEY `guarantor_documents_loan_id_foreign` (`loan_id`);

--
-- Indexes for table `interest_posting`
--
ALTER TABLE `interest_posting`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_collaterals`
--
ALTER TABLE `loan_collaterals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_collaterals_loan_id_foreign` (`loan_id`);

--
-- Indexes for table `loan_documents`
--
ALTER TABLE `loan_documents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_payments`
--
ALTER TABLE `loan_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_payments_loan_id_foreign` (`loan_id`),
  ADD KEY `loan_payments_member_id_foreign` (`member_id`);

--
-- Indexes for table `loan_payment_history`
--
ALTER TABLE `loan_payment_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `loan_id` (`loan_id`),
  ADD KEY `payment_id` (`payment_id`),
  ADD KEY `repayment_id` (`repayment_id`);

--
-- Indexes for table `loan_products`
--
ALTER TABLE `loan_products`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_repayments`
--
ALTER TABLE `loan_repayments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `member_documents`
--
ALTER TABLE `member_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_documents_member_id_foreign` (`member_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `navigations`
--
ALTER TABLE `navigations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `navigation_items`
--
ALTER TABLE `navigation_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `navigation_items_parent_id_foreign` (`parent_id`),
  ADD KEY `navigation_items_page_id_foreign` (`page_id`),
  ADD KEY `navigation_items_navigation_id_index` (`navigation_id`);

--
-- Indexes for table `navigation_item_translations`
--
ALTER TABLE `navigation_item_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `navigation_item_translations_navigation_item_id_locale_unique` (`navigation_item_id`,`locale`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pages_slug_unique` (`slug`);

--
-- Indexes for table `page_translations`
--
ALTER TABLE `page_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `page_translations_page_id_locale_unique` (`page_id`,`locale`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `savings_accounts`
--
ALTER TABLE `savings_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `savings_accounts_member_id_foreign` (`member_id`),
  ADD KEY `savings_accounts_savings_product_id_foreign` (`savings_product_id`);

--
-- Indexes for table `savings_products`
--
ALTER TABLE `savings_products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `savings_products_currency_id_foreign` (`currency_id`);

--
-- Indexes for table `schedule_tasks_histories`
--
ALTER TABLE `schedule_tasks_histories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `setting_translations`
--
ALTER TABLE `setting_translations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `setting_translations_setting_id_locale_unique` (`setting_id`,`locale`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transactions_member_id_foreign` (`member_id`),
  ADD KEY `transactions_savings_account_id_foreign` (`savings_account_id`),
  ADD KEY `transactions_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `transaction_categories`
--
ALTER TABLE `transaction_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_branch_id_foreign` (`branch_id`);

--
-- Indexes for table `withdraw_methods`
--
ALTER TABLE `withdraw_methods`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `withdraw_requests`
--
ALTER TABLE `withdraw_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `withdraw_requests_member_id_foreign` (`member_id`),
  ADD KEY `withdraw_requests_method_id_foreign` (`method_id`),
  ADD KEY `withdraw_requests_debit_account_id_foreign` (`debit_account_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `branches`
--
ALTER TABLE `branches`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `charge_limits`
--
ALTER TABLE `charge_limits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `currency`
--
ALTER TABLE `currency`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `database_backups`
--
ALTER TABLE `database_backups`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deposit_methods`
--
ALTER TABLE `deposit_methods`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `deposit_requests`
--
ALTER TABLE `deposit_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `email_sms_templates`
--
ALTER TABLE `email_sms_templates`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `expense_categories`
--
ALTER TABLE `expense_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guarantors`
--
ALTER TABLE `guarantors`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `guarantor_documents`
--
ALTER TABLE `guarantor_documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `interest_posting`
--
ALTER TABLE `interest_posting`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loans`
--
ALTER TABLE `loans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `loan_collaterals`
--
ALTER TABLE `loan_collaterals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loan_documents`
--
ALTER TABLE `loan_documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `loan_payments`
--
ALTER TABLE `loan_payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `loan_payment_history`
--
ALTER TABLE `loan_payment_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `loan_products`
--
ALTER TABLE `loan_products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loan_repayments`
--
ALTER TABLE `loan_repayments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=180;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `member_documents`
--
ALTER TABLE `member_documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `navigations`
--
ALTER TABLE `navigations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `navigation_items`
--
ALTER TABLE `navigation_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `navigation_item_translations`
--
ALTER TABLE `navigation_item_translations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `page_translations`
--
ALTER TABLE `page_translations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `savings_accounts`
--
ALTER TABLE `savings_accounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `savings_products`
--
ALTER TABLE `savings_products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `schedule_tasks_histories`
--
ALTER TABLE `schedule_tasks_histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `setting_translations`
--
ALTER TABLE `setting_translations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction_categories`
--
ALTER TABLE `transaction_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `withdraw_methods`
--
ALTER TABLE `withdraw_methods`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `withdraw_requests`
--
ALTER TABLE `withdraw_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `deposit_requests`
--
ALTER TABLE `deposit_requests`
  ADD CONSTRAINT `deposit_requests_credit_account_id_foreign` FOREIGN KEY (`credit_account_id`) REFERENCES `savings_accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `deposit_requests_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `deposit_requests_method_id_foreign` FOREIGN KEY (`method_id`) REFERENCES `deposit_methods` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `expenses`
--
ALTER TABLE `expenses`
  ADD CONSTRAINT `expenses_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `expenses_expense_category_id_foreign` FOREIGN KEY (`expense_category_id`) REFERENCES `expense_categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guarantors`
--
ALTER TABLE `guarantors`
  ADD CONSTRAINT `guarantors_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `guarantor_documents`
--
ALTER TABLE `guarantor_documents`
  ADD CONSTRAINT `guarantor_documents_guarantor_id_foreign` FOREIGN KEY (`guarantor_id`) REFERENCES `guarantors` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guarantor_documents_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `loan_collaterals`
--
ALTER TABLE `loan_collaterals`
  ADD CONSTRAINT `loan_collaterals_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `loan_payments`
--
ALTER TABLE `loan_payments`
  ADD CONSTRAINT `loan_payments_loan_id_foreign` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `loan_payments_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `member_documents`
--
ALTER TABLE `member_documents`
  ADD CONSTRAINT `member_documents_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `navigation_items`
--
ALTER TABLE `navigation_items`
  ADD CONSTRAINT `navigation_items_navigation_id_foreign` FOREIGN KEY (`navigation_id`) REFERENCES `navigations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `navigation_items_page_id_foreign` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `navigation_items_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `navigation_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `navigation_item_translations`
--
ALTER TABLE `navigation_item_translations`
  ADD CONSTRAINT `navigation_item_translations_navigation_item_id_foreign` FOREIGN KEY (`navigation_item_id`) REFERENCES `navigation_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `page_translations`
--
ALTER TABLE `page_translations`
  ADD CONSTRAINT `page_translations_page_id_foreign` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `savings_accounts`
--
ALTER TABLE `savings_accounts`
  ADD CONSTRAINT `savings_accounts_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `savings_accounts_savings_product_id_foreign` FOREIGN KEY (`savings_product_id`) REFERENCES `savings_products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `savings_products`
--
ALTER TABLE `savings_products`
  ADD CONSTRAINT `savings_products_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `setting_translations`
--
ALTER TABLE `setting_translations`
  ADD CONSTRAINT `setting_translations_setting_id_foreign` FOREIGN KEY (`setting_id`) REFERENCES `settings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_savings_account_id_foreign` FOREIGN KEY (`savings_account_id`) REFERENCES `savings_accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `withdraw_requests`
--
ALTER TABLE `withdraw_requests`
  ADD CONSTRAINT `withdraw_requests_debit_account_id_foreign` FOREIGN KEY (`debit_account_id`) REFERENCES `savings_accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `withdraw_requests_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `withdraw_requests_method_id_foreign` FOREIGN KEY (`method_id`) REFERENCES `withdraw_methods` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
