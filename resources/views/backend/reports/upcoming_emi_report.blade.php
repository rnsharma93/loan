@extends('layouts.app')

@section('content')
<div class="row">
    <div class="col-12">
        <div class="card">
            <div class="card-header">
                <span class="panel-title">{{ _lang('Upcoming EMI Report') }}</span>
            </div>

            <div class="card-body">
                <div class="report-params">
                    <form class="validate" method="post" action="{{ route('reports.upcoming_emi_report') }}">
                        <div class="row">
                            {{ csrf_field() }}
							<div class="col-xl-2 col-lg-4">
								<div class="form-group">
									<label class="control-label">{{ _lang('Start Date') }}</label>
									<input type="text" class="form-control datepicker" name="date1" id="date1" 
										   value="{{ isset($date1) ? \Carbon\Carbon::parse($date1)->format('d-m-Y') : old('date1') }}" 
										   readOnly="true" required>
								</div>
							</div>
							
							<div class="col-xl-2 col-lg-4">
								<div class="form-group">
									<label class="control-label">{{ _lang('End Date') }}</label>
									<input type="text" class="form-control datepicker" name="date2" id="date2" 
										   value="{{ isset($date2) ? \Carbon\Carbon::parse($date2)->format('d-m-Y') : old('date2') }}" 
										   readOnly="true" required>
								</div>
							</div>

                            <div class="col-xl-2 col-lg-4">
                                <button type="submit" class="btn btn-light btn-xs btn-block mt-26">
                                    <i class="ti-filter"></i>&nbsp;{{ _lang('Filter') }}
                                </button>
                            </div>
                        </div>
                    </form>
                </div><!-- End Report param -->

                <div class="report-header">
                    <h4>{{ _lang('Upcoming EMI Report') }}</h4>
                    <h5>{{ isset($date1) ? date('d-m-Y', strtotime($date1)) . ' ' . _lang('to') . ' ' . date('d-m-Y', strtotime($date2)) : '---------- ' . _lang('to') . ' ----------' }}</h5>

                <table class="table table-bordered report-table">
                    <thead>
                        <th>{{ _lang('Loan ID') }}</th>
                        <th>{{ _lang('Borrower') }}</th>
                        <th>{{ _lang('Mobile No.') }}</th>
						<th>{{ _lang('Address') }}</th>
                        <th>{{ _lang('Product Name') }}</th>
                        <th>{{ _lang('EMI Date') }}</th>
                        <th>{{ _lang('EMI Amount') }}</th>
                        <th class="text-center">{{ _lang('Details') }}</th>
                    </thead>
                    <tbody>
                        @if(isset($report_data))
                            @foreach($report_data as $loan)
                                @foreach($loan->repayments as $repayment)
                                    <tr>
                                        <td>{{ $loan->id }}</td>
                                        <td>{{ strtoupper($loan->borrower->name) }} <br> S/O {{ strtoupper($loan->borrower->father_name) }}</td>
                                        <td>{{ $loan->borrower->mobile }}</td>
										<td>{{ $loan->borrower->address }}</td>
                                        <td>{{ $loan->loan_product->name ?? 'N/A' }}</td>
                                        <td>{{ \Carbon\Carbon::parse($repayment->repayment_date)->format('d-m-Y') ?? 'Invalid date' }}</td>
                                        <td>{{ number_format($repayment->amount_to_pay, 2) }}</td>
                                        <td class="text-center">
                                            <a href="{{ action('LoanController@show', $loan->id) }}" 
                                               target="_blank" 
                                               class="btn btn-outline-primary btn-xs">
                                                {{ _lang('View') }}
                                            </a>
                                        </td>
                                    </tr>
                                @endforeach
                            @endforeach
                        @endif
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<style>
    /* Hide the "Details" column during print */
    @media print {
        .report-table th:nth-child(7),
        .report-table td:nth-child(7)
        {
            display: none;
        }
    }
</style>
@endsection
