<?php

namespace App\Http\Controllers;

use App\Models\Guarantor;
use App\Models\Loan;
use App\Models\SavingsAccount;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class GuarantorController extends Controller {

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct() {
        date_default_timezone_set(get_option('timezone', 'Asia/Kolkata'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request) {
        if (!$request->ajax()) {
            return back();
        } else {
            $loan_id = $request->get('loan_id');
            return view('backend.guarantor.modal.create', compact('loan_id'));
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request) {
        $loan = Loan::find($request->loan_id);

        $validator = Validator::make($request->all(), [
            'name'            => 'required',
            'father_name' => 'required',
            'mobile'          => 'required|numeric',
            'amount'             => 'required|numeric',
        ]);

        if ($validator->fails()) {
            if ($request->ajax()) {
                return response()->json(['result' => 'error', 'message' => $validator->errors()->all()]);
            } else {
                return redirect()->route('guarantors.create')
                    ->withErrors($validator)
                    ->withInput();
            }
        }

        $guarantor                     = new Guarantor();
        $guarantor->loan_id            = $request->input('loan_id');
        $guarantor->name               = $request->input('name');
        $guarantor->mobile             = $request->input('mobile');
        $guarantor->father_name        = $request->input('father_name');
        $guarantor->amount             = $request->input('amount');

        $guarantor->save();

        if (!$request->ajax()) {
            return redirect()->route('guarantors.create')->with('success', _lang('Saved Successfully'));
        } else {
            return response()->json(['result' => 'success', 'action' => 'store', 'message' => _lang('Saved Successfully'), 'data' => $guarantor, 'table' => '#guarantors_table']);
        }

    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit(Request $request, $id) {
        $guarantor = Guarantor::find($id);
        if (!$request->ajax()) {
            return back();
        } else {
            return view('backend.guarantor.modal.edit', compact('guarantor', 'id'));
        }
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id) {
        $loan = Loan::find($request->loan_id);

        $validator = Validator::make($request->all(), [
            'name'            => 'required',
            'father_name'          => 'required',
            'mobile' => 'required|numeric',
            'amount'             => 'required|numeric',
        ]);

        if ($validator->fails()) {
            if ($request->ajax()) {
                return response()->json(['result' => 'error', 'message' => $validator->errors()->all()]);
            } else {
                return redirect()->route('guarantors.edit', $id)
                    ->withErrors($validator)
                    ->withInput();
            }
        }

        $guarantor      = Guarantor::find($id);
        $guarantor->name               = $request->input('name');
        $guarantor->mobile             = $request->input('mobile');
        $guarantor->father_name        = $request->input('father_name');
        $guarantor->amount             = $request->input('amount');

        $guarantor->save();

        if (!$request->ajax()) {
            return redirect()->route('guarantors.index')->with('success', _lang('Updated Successfully'));
        } else {
            return response()->json(['result' => 'success', 'action' => 'update', 'message' => _lang('Updated Successfully'), 'data' => $guarantor, 'table' => '#guarantors_table']);
        }

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id) {
        $guarantor = Guarantor::find($id);
        $guarantor->delete();
        return back()->with('success', _lang('Deleted Successfully'));
    }
}