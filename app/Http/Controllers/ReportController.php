<?php

namespace App\Http\Controllers;

use App\Models\Loan;
use App\Models\Member;
use App\Models\Expense;
use App\Models\LoanPayment;
use App\Models\Transaction;
use Illuminate\Http\Request;
use App\Models\LoanRepayment;
use App\Models\SavingsAccount;
use Illuminate\Support\Facades\DB;
use Illuminate\Database\Eloquent\Builder;
use Carbon\Carbon;

class ReportController extends Controller
{

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        date_default_timezone_set(get_option('timezone', 'Asia/Kolkata'));
    }

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function account_statement(Request $request)
    {
        if ($request->isMethod('get')) {
            return view('backend.reports.account_statement');
        } else if ($request->isMethod('post')) {
            @ini_set('max_execution_time', 0);
            @set_time_limit(0);

            $data = array();
            $date1 = $request->date1;
            $date2 = $request->date2;
            $account_number = isset($request->account_number) ? $request->account_number : '';

            $account = SavingsAccount::where('account_number', $account_number)->with('savings_type.currency')->first();
            if (!$account) {
                return back()->with('error', _lang('Account not found'));
            }

            DB::select("SELECT ((SELECT IFNULL(SUM(amount),0) FROM transactions WHERE dr_cr = 'cr' AND member_id = $account->member_id AND savings_account_id = $account->id AND status=2 AND created_at < '$date1') - (SELECT IFNULL(SUM(amount),0) FROM transactions WHERE dr_cr = 'dr' AND member_id = $account->member_id AND savings_account_id = $account->id AND status = 2 AND created_at < '$date1')) into @openingBalance");

            $data['report_data'] = DB::select("SELECT '$date1' trans_date,'Opening Balance' as description, 0 as 'debit', 0 as 'credit', @openingBalance as 'balance'
            UNION ALL
            SELECT date(trans_date), description, debit, credit, @openingBalance := @openingBalance + (credit - debit) as balance FROM
            (SELECT date(transactions.trans_date) as trans_date, transactions.description, IF(transactions.dr_cr='dr',transactions.amount,0) as debit, IF(transactions.dr_cr='cr',transactions.amount,0) as credit FROM `transactions` JOIN savings_accounts ON savings_account_id=savings_accounts.id WHERE savings_accounts.id = $account->id AND transactions.member_id = $account->member_id AND transactions.status=2 AND date(transactions.trans_date) >= '$date1' AND date(transactions.trans_date) <= '$date2')
            as all_transaction");

            $data['date1'] = $request->date1;
            $data['date2'] = $request->date2;
            $data['account_number'] = $request->account_number;
            $data['account'] = $account;
            return view('backend.reports.account_statement', $data);
        }
    }

    public function loan_report(Request $request)
    {
        if ($request->isMethod('get')) {
            return view('backend.reports.loan_report');
        } else if ($request->isMethod('post')) {
            @ini_set('max_execution_time', 0);
            @set_time_limit(0);

            $data = array();
            $date1 = $request->date1;
            $date2 = $request->date2;
            $member_no = isset($request->member_no) ? $request->member_no : '';
            $status = isset($request->status) ? $request->status : '';
            $loan_type = isset($request->loan_type) ? $request->loan_type : '';

            $data['report_data'] = Loan::select('loans.*')
                ->with(['borrower', 'loan_product'])
                ->when($status, function ($query, $status) {
                    return $query->where('status', $status);
                }, function ($query, $status) {
                    if ($status != '') {
                        return $query->where('status', $status);
                    }
                })
                ->when($loan_type, function ($query, $loan_type) {
                    return $query->where('loan_product_id', $loan_type);
                })
                ->when($member_no, function ($query, $member_no) {
                    return $query->whereHas('borrower', function ($query) use ($member_no) {
                        return $query->where('member_no', $member_no);
                    });
                })
                ->whereRaw("date(loans.created_at) >= '$date1' AND date(loans.created_at) <= '$date2'")
                ->orderBy('id', 'desc')
                ->get();

            $data['date1'] = $request->date1;
            $data['date2'] = $request->date2;
            $data['status'] = $request->status;
            $data['member_no'] = $request->member_no;
            $data['loan_type'] = $request->loan_type;
            return view('backend.reports.loan_report', $data);
        }
    }

    public function loan_due_report(Request $request)
    {
        // Handle GET Request
        if ($request->isMethod('get')) {
            return view('backend.reports.loan_due_report');
        }

        // Handle POST Request
        else if ($request->isMethod('post')) {
            @ini_set('max_execution_time', 0);
            @set_time_limit(0);

            $data = array();

            // Fetch request parameters
            $date1 = $request->date1;
            $date2 = $request->date2;
            $member_no = $request->member_no ?? '';
            $status = $request->status ?? '';
            $loan_type = $request->loan_type ?? '';

            // Fetch loans and filter
            $data['report_data'] = Loan::select('loans.*')
                ->with([
                    'borrower',
                    'loan_product',
                    'repayments' => function ($query) {
                        $query->selectRaw('
                        loan_id,
                        CASE 
                        WHEN status = 0 AND MONTH(repayment_date) > 0 THEN MONTH(repayment_date) 
                        ELSE NULL 
                        END as due_month,
                        COUNT(id) as total_installments,
                        SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as deposited_installments,
                        SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) as due_installments,
                        SUM(amount_to_pay) as total_due,
                        SUM(CASE WHEN status = 1 THEN amount_to_pay ELSE 0 END) as deposited_amount,
                        SUM(CASE WHEN status = 0 THEN amount_to_pay ELSE 0 END) as due_amount
                    ')
                            ->groupBy('loan_id', 'due_month');
                    }
                ])
                ->whereHas('repayments', function ($query) {
                    $query->havingRaw('SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) > 0'); // Filter only loans with due installments
                })
                ->whereBetween('loans.created_at', [$date1, $date2])
                ->orderBy('id', 'desc')
                ->get();

            // Pass filters back to the view
            $data['date1'] = $date1;
            $data['date2'] = $date2;
            $data['status'] = $status;
            $data['member_no'] = $member_no;
            $data['loan_type'] = $loan_type;

            return view('backend.reports.loan_due_report', $data);
        }
    }

    public function upcoming_emi_report(Request $request)
    {
        $data = [];
        
        $startDate = $request->input('date1') ? Carbon::parse($request->input('date1'))->startOfDay() : now()->startOfDay();
        
        $endDate = $request->input('date2') ? Carbon::parse($request->input('date2'))->endOfDay() : now()->addDays(10)->endOfDay();
    
        $data['report_data'] = LoanRepayment::query()
            ->with(['loan'])
            ->whereBetween('repayment_date', [$startDate, $endDate])
            ->where('status', 0)
            ->orderBy('repayment_date', 'asc')
            ->get();
    
        $data['date1'] = $startDate->format('Y-m-d');
        $data['date2'] = $endDate->format('Y-m-d');
    
        return view('backend.reports.upcoming_emi_report', $data);
    }


    public function transactions_report(Request $request)
    {
        if ($request->isMethod('get')) {
            return view('backend.reports.transactions_report');
        } else if ($request->isMethod('post')) {
            @ini_set('max_execution_time', 0);
            @set_time_limit(0);

            $data = array();
            $date1 = $request->date1;
            $date2 = $request->date2;
            $account_number = isset($request->account_number) ? $request->account_number : '';
            $status = isset($request->status) ? $request->status : '';
            $transaction_type = isset($request->transaction_type) ? $request->transaction_type : '';

            $data['report_data'] = Transaction::select('transactions.*')
                ->with(['member', 'account'])
                ->when($status, function ($query, $status) {
                    return $query->where('status', $status);
                }, function ($query, $status) {
                    if ($status != '') {
                        return $query->where('status', $status);
                    }
                })
                ->when($transaction_type, function ($query, $transaction_type) {
                    return $query->where('type', $transaction_type);
                })
                ->when($account_number, function ($query, $account_number) {
                    return $query->whereHas('account', function ($query) use ($account_number) {
                        return $query->where('account_number', $account_number);
                    });
                })
                ->whereRaw("date(transactions.trans_date) >= '$date1' AND date(transactions.trans_date) <= '$date2'")
                ->orderBy('transactions.trans_date', 'desc')
                ->get();

            $data['date1'] = $request->date1;
            $data['date2'] = $request->date2;
            $data['status'] = $request->status;
            $data['account_number'] = $request->account_number;
            $data['transaction_type'] = $request->transaction_type;
            return view('backend.reports.transactions_report', $data);
        }
    }

    public function expense_report(Request $request)
    {
        if ($request->isMethod('get')) {
            return view('backend.reports.expense_report');
        } else if ($request->isMethod('post')) {
            @ini_set('max_execution_time', 0);
            @set_time_limit(0);

            $data = array();
            $date1 = $request->date1;
            $date2 = $request->date2;
            $category = isset($request->category) ? $request->category : '';
            $branch = isset($request->branch) ? $request->branch : '';

            $data['report_data'] = Expense::select('expenses.*')
                ->with(['expense_category'])
                ->when($category, function ($query, $category) {
                    return $query->whereHas('expense_category', function ($query) use ($category) {
                        return $query->where('expense_category_id', $category);
                    });
                })
                ->when($branch, function ($query, $branch) {
                    return $query->where('branch_id', $branch);
                })
                ->whereRaw("date(expenses.expense_date) >= '$date1' AND date(expenses.expense_date) <= '$date2'")
                ->orderBy('expense_date', 'desc')
                ->get();

            $data['date1'] = $request->date1;
            $data['date2'] = $request->date2;
            $data['category'] = $request->category;
            $data['branch'] = $request->branch;
            return view('backend.reports.expense_report', $data);
        }
    }

    public function account_balances(Request $request)
    {
        if ($request->isMethod('get')) {
            return view('backend.reports.account_balances');
        } else if ($request->isMethod('post')) {
            $member_no = $request->member_no;
            $member = Member::where('member_no', $member_no)->first();
            if (!$member) {
                return back()->with('error', _lang('Invalid Member No'));
            }
            $accounts = get_account_details($member->id);
            return view('backend.reports.account_balances', compact('accounts', 'member_no'));
        }
    }

    public function revenue_report(Request $request)
    {
        if ($request->isMethod('get')) {
            return view('backend.reports.revenue_report');
        } else if ($request->isMethod('post')) {
            @ini_set('max_execution_time', 0);
            @set_time_limit(0);

            $data = array();
            $year = $request->year;
            $month = $request->month;
            $currency_id = $request->currency_id;

            $transaction_revenue = Transaction::selectRaw("CONCAT('Revenue from ', type), sum(charge) as amount")
                ->whereRaw("YEAR(trans_date) = '$year' AND MONTH(trans_date) = '$month'")
                ->where('charge', '>', 0)
                ->where('status', 2)
                ->whereHas('account.savings_type', function ($query) use ($currency_id) {
                    return $query->where('currency_id', $currency_id);
                })
                ->groupBy('type');

            $maintainaince_fee = Transaction::selectRaw("CONCAT('Revenue from ', type), sum(amount) as amount")
                ->whereRaw("YEAR(trans_date) = '$year' AND MONTH(trans_date) = '$month'")
                ->where('type', 'Account_Maintenance_Fee')
                ->where('status', 2)
                ->whereHas('account.savings_type', function ($query) use ($currency_id) {
                    return $query->where('currency_id', $currency_id);
                })
                ->groupBy('type');

            $others_fee = Transaction::join('transaction_categories', function ($join) {
                $join->on('transaction_categories.name', '=', 'transactions.type')
                    ->where('transaction_categories.status', '=', 1);
            })
                ->selectRaw("CONCAT('Revenue from ', type), sum(amount) as amount")
                ->whereRaw("YEAR(trans_date) = '$year' AND MONTH(trans_date) = '$month'")
                ->where('dr_cr', 'dr')
                ->where('transactions.status', 2)
                ->whereHas('account.savings_type', function ($query) use ($currency_id) {
                    return $query->where('currency_id', $currency_id);
                })
                ->groupBy('type');

            $data['report_data'] = LoanPayment::selectRaw("'Revenue from Loan' as type, sum(interest + late_penalties) as amount")
                ->whereRaw("YEAR(loan_payments.created_at) = '$year' AND MONTH(loan_payments.created_at) = '$month'")
                ->whereHas('loan', function ($query) use ($currency_id) {
                    return $query->where('currency_id', $currency_id);
                })
                ->union($transaction_revenue)
                ->union($maintainaince_fee)
                ->union($others_fee)
                ->get();

            $data['year'] = $request->year;
            $data['month'] = $request->month;
            $data['currency_id'] = $request->currency_id;
            return view('backend.reports.revenue_report', $data);
        }

    }

}
