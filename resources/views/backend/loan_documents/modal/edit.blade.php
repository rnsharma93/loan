<form method="post" class="ajax-screen-submit" autocomplete="off" action="{{ action('LoanDocumentController@update', $id) }}" enctype="multipart/form-data">
	{{ csrf_field()}}
	<input name="_method" type="hidden" value="PATCH">
	<div class="row px-2">					
		<input type="hidden" name="loan_id" value="{{ $loanDocument->loan_id }}">

		<div class="col-md-12">
			<div class="form-group">
				<label class="control-label">{{ _lang('Document Name') }}</label>						
				<input type="text" class="form-control" name="name" value="{{ $loanDocument->name }}" required>
			</div>
		</div>

		<div class="col-md-12">
			<div class="form-group">
				<label class="control-label">{{ _lang('Document') }}</label>						
				<input type="file" class="form-control dropify" name="document" data-default-file="{{ asset('public/uploads/documents/'.$loanDocument->document) }}">
			</div>
		</div>
	
		<div class="form-group">
		    <div class="col-md-12">
			    <button type="submit" class="btn btn-primary"><i class="ti-check-box"></i>&nbsp;{{ _lang('Update') }}</button>
		    </div>
		</div>
	</div>
</form>

