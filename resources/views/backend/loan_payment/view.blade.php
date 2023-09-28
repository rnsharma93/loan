@extends('layouts.app')
<style type="text/css">
	@media print {
    /* Specify table borders */
    table {
        border-collapse: collapse;
        width: 100%;
        border: 1px solid #000; /* Add a 1px solid black border to the table */
    }

    th, td {
        border: 1px solid #000; /* Add a 1px solid black border to table cells */
        padding: 8px;
        text-align: left;
    }
}
</style>
@section('content')
<div class="row">
	<div class="col-lg-12">
		<div class="card">
			<div class="card-header">
				<span class="panel-title">{{ _lang('Loan Repayment Details') }}</span>
			</div>
			
			<div class="card-body">
				<table id="table_receipt" class="table table-bordered printable">
					<tr>
						<td>{{ _lang('Loan ID') }}</td>
						<td><a href="{{ action('LoanController@show', $loanpayment->loan->id) }}" target="_blank">{{ $loanpayment->loan->loan_id }}</a></td>
					</tr>
					<tr>
						<td> {{ _lang('Receipt No') }}  </td>
						<td>{{ $s_no }}</td>
					</tr>
					@if($loanpayment->transaction_id != NULL)
						<tr><td>{{ _lang('Transaction') }}</td><td><a target="_blank" href="{{ action('TransactionController@show', $loanpayment->transaction_id) }}">{{ _lang('View Transaction Details') }}</a></td></tr>
					@endif
					<tr><td>{{ _lang('Payment Date') }}</td><td>{{ $loanpayment->paid_at }}</td></tr>
					<tr><td>{{ _lang('Principal Amount') }}</td><td>{{ decimalPlace($loanpayment->repayment_amount - $loanpayment->interest, currency($loanpayment->loan->currency->name)) }}</td></tr>
					<tr><td>{{ _lang('Interest') }}</td><td>{{ $loanpayment->interest }}</td></tr>
					<tr><td>{{ _lang('Late Penalties') }}</td><td>{{ $loanpayment->late_penalties }}</td></tr>
					<tr><td>{{ _lang('Total Amount') }}</td><td>{{ decimalPlace($loanpayment->total_amount, currency($loanpayment->loan->currency->name)) }}</td></tr>
					<tr><td>{{ _lang('Remarks') }}</td><td>{{ $loanpayment->remarks }}</td></tr>
				</table>
			</div>
		</div>
	</div>
</div>

<script>
	// Function to print the table
	function printTable() {
		var table = document.getElementById("table_receipt");
		var newWin = window.open("", "Print-Window");
		newWin.document.open();
		newWin.document.write('<html><head><link rel="stylesheet" type="text/css" href="print.css"></head><body>');
		newWin.document.write(table.outerHTML);
		newWin.document.write('</body></html>');
		newWin.document.close();
		newWin.print();
		newWin.close();
	}

	// Listen for the "Ctrl + P" or "Command + P" key combination
	document.addEventListener("keydown", function(event) {
		if ((event.ctrlKey || event.metaKey) && event.key === "p") {
			event.preventDefault(); // Prevent the browser's default print dialog
			printTable();
		}
	});
</script>


@endsection


