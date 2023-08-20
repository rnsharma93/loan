<form method="post" class="ajax-submit" autocomplete="off" action="{{ route('guarantors.store') }}" enctype="multipart/form-data">
	{{ csrf_field() }}
	<input type="hidden" name="loan_id" value="{{ $loan_id }}">
	<div class="row px-2">
	    <div class="col-md-12">
			<div class="form-group">
				<label class="control-label">{{ _lang('Name') }}</label>						
				<input type="text" class="form-control" name="name" value="{{ old('name') }}" required>
			</div>
		</div>

		<div class="col-md-12">
			<div class="form-group">
				<label class="control-label">{{ _lang('Father Name') }}</label>						
				<input type="text" class="form-control" name="father_name" value="{{ old('father_name') }}" required>
			</div>
		</div>

		<div class="col-md-12">
			<div class="form-group">
				<label class="control-label">{{ _lang('Mobile No.') }}</label>						
				<input type="text" class="form-control float-field" name="mobile" value="{{ old('mobile') }}" required>
			</div>
		</div>

		<div class="col-md-12">
			<div class="form-group">
				<label class="control-label">{{ _lang('Amount') }}</label>						
				<input type="text" class="form-control float-field" name="amount" value="{{ old('amount') }}">
			</div>
		</div>

		<div class="col-md-12">
		    <div class="form-group">
			    <button type="submit" class="btn btn-primary"><i class="ti-check-box"></i>&nbsp;{{ _lang('Submit') }}</button>
		    </div>
		</div>
	</div>
</form>
