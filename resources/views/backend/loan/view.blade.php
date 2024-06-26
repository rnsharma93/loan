@extends('layouts.app')

@section('content')
<div class="row">
   <div class="col-lg-12">
      <div class="card">
         <div class="card-header">
            <span class="panel-title">{{ _lang("View Loan Details") }}</span>
         </div>
         <div class="card-body">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs">
               <li class="nav-item">
                  <a class="nav-link active" data-toggle="tab" href="#loan_details">{{
                  _lang("Loan Details")
                  }}</a>
               </li>
               <li class="nav-item">
                  <a class="nav-link" data-toggle="tab" href="#guarantor">{{
                  _lang("Guarantor")
                  }}</a>
               </li>
               <li class="nav-item">
                  <a class="nav-link" data-toggle="tab" href="#documents">{{
                  _lang("Documents")
                  }}</a>
               </li>
               <!--
               <li class="nav-item">
                  <a class="nav-link" data-toggle="tab" href="#collateral">{{
                  _lang("Collateral")
                  }}</a>
               </li>
               -->
               <li class="nav-item">
                  <a class="nav-link" data-toggle="tab" href="#schedule">{{
                  _lang("Repayments Schedule")
                  }}</a>
               </li>
               <li class="nav-item">
                  <a class="nav-link" data-toggle="tab" href="#repayments">{{
                  _lang("Repayments")
                  }}</a>
               </li>
               <li class="nav-item">
                  <a class="nav-link"
                     href="{{ action('LoanController@edit', $loan['id']) }}"
                     >{{ _lang("Edit") }}</a>
               </li>
               
            </ul>
            <!-- Tab panes -->
            <div class="tab-content">
               <div class="tab-pane active" id="loan_details">
                  @if($loan->status == 0)
                  <div class="alert alert-warning mt-4">
                     <span>
                        {{ _lang("Add Loan ID, Release Date and First Payment Date before approving loan request") }}
                     </span>
                  </div>
                  @endif
                  <table id="table_loan_details" class="table table-bordered mt-4">
                     <tr>
                        <td>{{ _lang("Loan ID") }}</td>
                        <td>{{ $loan->loan_id }}</td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Loan Type") }}</td>
                        <td>{{ $loan->loan_product->name }}</td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Borrower") }}</td>
                        <td>{{ $loan->borrower->first_name.' '.$loan->borrower->last_name }}</td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Member No") }}</td>
                        <td>{{ $loan->borrower->member_no }}</td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Status") }}</td>
                        <td>
                            @if($loan->status == 0)
                                {!! xss_clean(show_status(_lang('Pending'), 'warning')) !!}
                            @elseif($loan->status == 1)
                                {!! xss_clean(show_status(_lang('Approved'), 'success')) !!}
                            @elseif($loan->status == 2)
                                {!! xss_clean(show_status(_lang('Completed'), 'info')) !!}
                            @elseif($loan->status == 3)
                                {!! xss_clean(show_status(_lang('Cancelled'), 'danger')) !!}
                            @endif

                           @if($loan->status == 0)
                              <a class="btn btn-outline-primary btn-xs" href="{{ action('LoanController@approve', $loan['id']) }}"><i class="ti-check-box"></i>&nbsp;{{ _lang("Click to Approve") }}</a>
                              <a class="btn btn-outline-danger btn-xs float-right" href="{{ action('LoanController@reject', $loan['id']) }}"><i class="ti-close"></i>&nbsp;{{ _lang("Click to Reject") }}</a>
                           @endif

                           @if ($loan->status == 1) 
                              <a class="btn btn-outline-primary btn-xs" data-toggle="modal" data-target="#foreCloseModal" href="javascript:"><i class="ti-check-box"></i>&nbsp;{{ _lang("For Close") }}</a>
                           @endif
                        </td>
                     </tr>
                     <tr>
                        <td>{{ _lang("First Payment Date") }}</td>
                        <td>{{ $loan->first_payment_date }}</td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Release Date") }}</td>
                        <td>
                           {{ $loan->release_date != '' ? $loan->release_date : '' }}
                        </td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Applied Amount") }}</td>
                        <td>
                           {{ decimalPlace($loan->applied_amount, currency($loan->currency->name)) }}
                        </td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Total Payable") }}</td>
                        <td>
                           {{ decimalPlace($loan->total_payable, currency($loan->currency->name)) }}
                        </td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Total Paid") }}</td>
                        <td class="text-success">
                           {{ decimalPlace($loan->total_paid, currency($loan->currency->name)) }}
                        </td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Due Amount") }}</td>
                        <td class="text-danger">
                           {{ decimalPlace($loan->total_payable - $loan->total_paid, currency($loan->currency->name)) }}
                        </td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Late Payment Penalties") }}</td>
                        <td>{{ $loan->late_payment_penalties }} %</td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Attachment") }}</td>
                        <td>
                           {!! $loan->attachment == "" ? '' : '<a
                              href="'. asset('public/uploads/media/'.$loan->attachment) .'"
                              target="_blank"
                              >'._lang('Download').'</a
                              >' !!}
                        </td>
                     </tr>
                     @if($loan->status == 1)
                     <tr>
                        <td>{{ _lang("Approved Date") }}</td>
                        <td>{{ $loan->approved_date }}</td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Approved By") }}</td>
                        <td>{{ $loan->approved_by->name }}</td>
                     </tr>
                     @endif
                     <tr>
                        <td>{{ _lang("Description") }}</td>
                        <td>{{ $loan->description }}</td>
                     </tr>
                     <tr>
                        <td>{{ _lang("Remarks") }}</td>
                        <td>{{ $loan->remarks }}</td>
                     </tr>
                  </table>
               </div>

               <div class="tab-pane fade" id="guarantor">
                  <div class="card">
                     <div class="card-header d-flex align-items-center">
                        <span>{{ _lang("Guarantors") }}</span>
                        <a
                           class="btn btn-primary btn-xs ml-auto ajax-modal"
                           href="{{ route('guarantors.create')."?loan_id=".$loan->id }}" data-title="{{ _lang('Add Guarantor') }}"
                           ><i class="ti-plus"></i>
                        {{ _lang("Add New") }}</a>
                     </div>
                     <div class="card-body">
                        <div class="table-responsive">
                           <table id="guarantors_table" class="table table-bordered mt-2">
                              <thead>
                                 <tr>
                                    <th>S.No.</th>
                                    <th>{{ _lang('Name') }}</th>
                                    <th>{{ _lang('Father Name') }}</th>
                                    <th>Mobile</th>
                                    <th>{{ _lang('Amount') }}</th>
                                    <th class="text-center">{{ _lang('Action') }}</th>
                                 </tr>
                              </thead>
                              <tbody>
                                 @foreach($guarantors as $key => $guarantor)
                                 <tr data-id="row_{{ $guarantor->id }}">
                                    <td>{{ ($key+1) }}</td>
                                    <td class='loan_id'>{{ $guarantor->name }}</td>
                                    <td class='member_id'>{{ $guarantor->father_name }}</td>
                                    <td> {{ $guarantor->mobile }} </td>
                                    <td class='amount'>{{ decimalPlace($guarantor->amount, currency($loan->currency->name)) }}</td>
                                    
                                    <td class="text-center">
                                       <span class="dropdown">
                                       <button class="btn btn-primary dropdown-toggle btn-xs" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                       {{ _lang('Action') }}
                                       </button>
                                       <form action="{{ action('GuarantorController@destroy', $guarantor['id']) }}" method="post">
                                          {{ csrf_field() }}
                                          <input name="_method" type="hidden" value="DELETE">

                                          <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                             <a href="{{ action('GuarantorController@edit', $guarantor['id']) }}" data-title="{{ _lang('Update Guarantor') }}" class="dropdown-item dropdown-edit ajax-modal"><i class="ti-pencil-alt"></i>&nbsp;{{ _lang('Edit') }}</a>
                                             <button class="btn-remove dropdown-item" type="submit"><i class="ti-trash"></i>&nbsp;{{ _lang('Delete') }}</button>
                                          </div>
                                       </form>
                                       </span>
                                    </td>
                                 </tr>
                                 @endforeach
                                 <tr>
                                    <td colspan="4">{{ _lang('Grand Total') }}</td>
                                    <td colspan="2"><b>{{ decimalPlace($guarantors->sum('amount'), currency($loan->currency->name)) }}</b></td>
                                 </tr>
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>
               </div>


               <div class="tab-pane fade" id="collateral">
                  <div class="card">
                     <div class="card-header d-flex align-items-center">
                        <span>{{ _lang("All Collaterals") }}</span>
                        <a
                           class="btn btn-primary btn-xs ml-auto"
                           href="{{ route('loan_collaterals.create',['loan_id' => $loan->id]) }}"
                           ><i class="ti-plus"></i>
                        {{ _lang("New Collateral") }}</a
                           >
                     </div>
                     <div class="card-body">
                        <div class="table-responsive">
                           <table class="table table-bordered mt-2">
                              <thead>
                                 <tr>
                                    <th>{{ _lang("Name") }}</th>
                                    <th>{{ _lang("Collateral Type") }}</th>
                                    <th>{{ _lang("Serial Number") }}</th>
                                    <th>{{ _lang("Estimated Price") }}</th>
                                    <th class="text-center">{{ _lang("Action") }}</th>
                                 </tr>
                              </thead>
                              <tbody>
                                 @foreach($loancollaterals as $loancollateral)
                                 <tr data-id="row_{{ $loancollateral->id }}">
                                    <td class="name">{{ $loancollateral->name }}</td>
                                    <td class="collateral_type">
                                       {{ $loancollateral->collateral_type }}
                                    </td>
                                    <td class="serial_number">
                                       {{ $loancollateral->serial_number }}
                                    </td>
                                    <td class="estimated_price">
                                       {{ decimalPlace($loancollateral->estimated_price, currency($loan->currency->name)) }}
                                    </td>
                                    <td class="text-center">
                                       <div class="dropdown">
                                          <button
                                             class="btn btn-primary dropdown-toggle btn-xs"
                                             type="button"
                                             id="dropdownMenuButton"
                                             data-toggle="dropdown"
                                             aria-haspopup="true"
                                             aria-expanded="false"
                                             >
                                          {{ _lang("Action") }}
                                          </button>
                                          <form
                                             action="{{
                                             action(
                                             'LoanCollateralController@destroy',
                                             $loancollateral['id']
                                             )
                                             }}"
                                             method="post"
                                             >
                                             {{ csrf_field() }}
                                             <input
                                                name="_method"
                                                type="hidden"
                                                value="DELETE"
                                                />
                                             <div
                                                class="dropdown-menu"
                                                aria-labelledby="dropdownMenuButton"
                                                >
                                                <a
                                                   href="{{
                                                   action(
                                                   'LoanCollateralController@edit',
                                                   $loancollateral['id']
                                                   )
                                                   }}"
                                                   class="
                                                   dropdown-item dropdown-edit dropdown-edit
                                                   "
                                                   ><i class="ti-pencil-alt"></i>
                                                {{ _lang("Edit") }}</a
                                                   >
                                                <a
                                                   href="{{
                                                   action(
                                                   'LoanCollateralController@show',
                                                   $loancollateral['id']
                                                   )
                                                   }}"
                                                   class="
                                                   dropdown-item dropdown-view dropdown-view
                                                   "
                                                   ><i class="ti-eye"></i>
                                                {{ _lang("View") }}</a
                                                   >
                                                <button
                                                   class="btn-remove dropdown-item"
                                                   type="submit"
                                                   >
                                                <i class="ti-trash"></i>
                                                {{ _lang("Delete") }}
                                                </button>
                                             </div>
                                          </form>
                                       </div>
                                    </td>
                                 </tr>
                                 @endforeach
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>
               </div>

               <div class="tab-pane fade mt-4 border px-3" id="schedule">
                  <div class="report-header">
                     <h4>{{ get_option('company_name') }}</h4>
                     <h5>{{ _lang('Repayments Schedule') }}</h5>
                     <p>{{ $loan->borrower->name }}, {{ _lang('Loan ID').': '.$loan->loan_id }}</p>
                  </div>
                  <table class="table table-bordered report-table">
                     <thead>
                        <tr>
                           <th>S.No.</th>
                           <th>{{ _lang("Date") }}</th>
                           <th class="text-right">{{ _lang("Amount to Pay") }}</th>
                           <th class="text-right">{{ _lang("Late Penalty") }}</th>
                           <th class="text-right">{{ _lang("Principal Amount") }}</th>
                           <th class="text-right">{{ _lang("Interest") }}</th>
                           <th class="text-right">{{ _lang("Balance") }}</th>
                           <th class="text-center">{{ _lang("Status") }}</th>
                        </tr>
                     </thead>
                     <tbody>
                        @foreach($repayments as $key => $repayment)
                        <tr>
                           <td>{{ ($key + 1) }}</td>
                           <td>{{ $repayment->repayment_date }}</td>
                           <td class="text-right">
                              {{ decimalPlace($repayment['amount_to_pay'], currency($loan->currency->name)) }}
                           </td>
                           <td class="text-right">
                              {{ decimalPlace($repayment['penalty'], currency($loan->currency->name)) }}
                           </td>
                           <td class="text-right">
                              {{ decimalPlace($repayment['principal_amount'], currency($loan->currency->name)) }}
                           </td>
                           <td class="text-right">
                              {{ decimalPlace($repayment['interest'], currency($loan->currency->name)) }}
                           </td>
                           <td class="text-right">
                              {{ decimalPlace($repayment['balance'], currency($loan->currency->name)) }}
                           </td>
                           <td class="text-center">
                              @if($repayment['status'] == 0 && date('Y-m-d') > $repayment->getRawOriginal('repayment_date'))
                                    {!! xss_clean(show_status(_lang('Due'),'danger')) !!}
                              @elseif($repayment['status'] == 0 && date('Y-m-d') <= $repayment->getRawOriginal('repayment_date'))
                                    {!! xss_clean(show_status(_lang('Unpaid'),'warning')) !!}
                              @else
                                    {!! xss_clean(show_status(_lang('Paid'),'success')) !!}
                              @endif
                           </td>
                        </tr>
                        @endforeach
                     </tbody>
                  </table>
               </div>

               <div class="tab-pane fade mt-4" id="repayments">
                  <div class="report-header">
                     <h4>{{ get_option('company_name') }}</h4>
                     <h5>{{ _lang('Loan Payments') }}</h5>
                     <p>{{ $loan->borrower->name }}, {{ _lang('Loan ID').': '.$loan->loan_id }}</p>
                  </div>
                  <table class="table table-bordered report-table" id="repayments-table">
                     <thead>
                        <tr>
                           <th>S.No.</th>
                           <th>{{ _lang("Date") }}</th>
                           <th class="text-right">{{ _lang("Principal Amount") }}</th>
                           <th class="text-right">{{ _lang("Interest") }}</th>
                           <th class="text-right">{{ _lang("Late Penalty") }}</th>
                           <th class="text-right">{{ _lang("Total Amount") }}</th>
                        </tr>
                     </thead>
                     <tbody>
                        @foreach($payments as $key => $payment)
                        <tr>
                           <td> {{ ($key+1) }} </td>
                           <td>{{ $payment->paid_at }}</td>
                           <td class="text-right">
                              {{ decimalPlace($payment['repayment_amount'] - $payment['interest'], currency($loan->currency->name)) }}
                           </td>
                           <td class="text-right">
                              {{ decimalPlace($payment['interest'], currency($loan->currency->name)) }}
                           </td>
                           <td class="text-right">
                              {{ decimalPlace($payment['late_penalties'], currency($loan->currency->name)) }}
                           </td>
                           <td class="text-right">
                              {{ decimalPlace($payment['total_amount'], currency($loan->currency->name)) }}
                           </td>
                        </tr>
                        @endforeach
                     </tbody>
                  </table>
               </div>

               <div class="tab-pane fade" id="documents">
                  <div class="card">
                     <div class="card-header d-flex align-items-center">
                        <span>{{ _lang("Documents") }}</span>
                        <a
                           class="btn btn-primary btn-xs ml-auto ajax-modal"
                           href="{{ route('loan_documents.create', $loan->id)}}" data-title="{{ _lang('Add New') }}"
                           ><i class="ti-plus"></i>
                        {{ _lang("Add New") }}</a>
                     </div>
                     <div class="card-body">
                        <div class="table-responsive">
                           <table id="loan_documents_table" class="table table-bordered mt-2">
                              <thead>
                                 <tr>
                                    <th>S.No.</th>
                                    <th>{{ _lang('Name') }}</th>
                                    <th>{{ _lang('Document') }}</th>
                                    <th class="text-center">{{ _lang('Action') }}</th>
                                 </tr>
                              </thead>
                              <tbody>
                                 @foreach($documents as $key => $document)
                                 <tr data-id="row_{{ $document->id }}">
                                    <td>{{ ($key+1) }}</td>
                                    <td class=''>{{ $document->name }}</td>
                                    <td class=''>
                                       <a target="_blank" href="{{ asset('public/uploads/documents/'.$document->document) }}">{{ $document->document }}</a>
                                    </td>
                                    <td class="text-center">
                                       <span class="dropdown">
                                          <button class="btn btn-primary dropdown-toggle btn-xs" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                          {{ _lang('Action') }}
                                          </button>
                                          <form action="{{ action('LoanDocumentController@destroy', $document['id']) }}" method="post">
                                           {{ csrf_field() }}
                                           <input name="_method" type="hidden" value="DELETE">
                
                                           <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                              <a href="{{ action('LoanDocumentController@edit', $document['id']) }}" data-title="{{ _lang('Update Document') }}" class="dropdown-item dropdown-edit ajax-modal"><i class="ti-pencil-alt"></i>&nbsp;{{ _lang('Edit') }}</a>
                                              <button class="btn-remove dropdown-item" type="submit"><i class="ti-trash"></i>&nbsp;{{ _lang('Delete') }}</button>
                                           </div>
                                          </form>
                                        </span>
                                    </td>
                                 </tr>
                                 @endforeach
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>
               </div>

            </div>
         </div>
      </div>
   </div>
</div>

<div class="modal fade" id="foreCloseModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
   <div class="modal-dialog" role="document">
     <div class="modal-content">
       <div class="modal-header">
         <h5 class="modal-title" id="exampleModalLabel">Loan Fore Close</h5>
         <button type="button" class="close" data-dismiss="modal" aria-label="Close">
           <span aria-hidden="true">&times;</span>
         </button>
       </div>
       <div class="modal-body">
            
            <form id="formForeClose" name="formForeClose" action="{{route('loans.fore_close', $loan)}}" method="POST">
               @csrf
               <div class="row">
                  <div class="col-md-12">
                     <div class="form-group">
                        <label class="control-label">{{ _lang('Fore Close Amount') }}</label>
                        <input type="text" class="form-control" name="foreclose_amount" value="{{ old('foreclose_amount') }}" required>
                     </div>
                  </div>
               </div>
            </form>
       </div>
       <div class="modal-footer">
         <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
         <button type="submit" form="formForeClose" class="btn btn-primary">Save changes</button>
       </div>
     </div>
   </div>
 </div>
@endsection

@section('js-script')
<script>
   (function($) {
       "use strict";

   	$('.nav-tabs a').on('shown.bs.tab', function(event){
   		var tab = $(event.target).attr("href");
   		var url = "{{ route('loans.show',$loan->id) }}";
   	    history.pushState({}, null, url + "?tab=" + tab.substring(1));
   	});

   	@if(isset($_GET['tab']))
   	   $('.nav-tabs a[href="#{{ $_GET['tab'] }}"]').tab('show');
   	@endif

   })(jQuery);
</script>

<script>
	// Function to print the table
	function printTable() {
		var table = document.getElementById("table_loan_details");
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