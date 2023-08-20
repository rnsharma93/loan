<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

use App\Models\LoanDocument;

class LoanDocumentController extends Controller
{
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
    public function create($id, Request $request) {
        if (!$request->ajax()) {
            return back();
        } else {
            return view('backend.loan_documents.modal.create', compact('id'));
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request) {
        $validator = Validator::make($request->all(), [
            'loan_id' => 'required',
            'name'      => 'required',
            'document'  => 'required|mimes:png,jpg,jpeg,pdf|max:10000',
        ]);

        if ($validator->fails()) {
            if ($request->ajax()) {
                return response()->json(['result' => 'error', 'message' => $validator->errors()->all()]);
            } else {
                return redirect()->route('loan_documents.create')
                    ->withErrors($validator)
                    ->withInput();
            }
        }

        $document = '';
        if ($request->hasfile('document')) {
            $file     = $request->file('document');
            $document = time() . uniqid() . '-'. $file->getClientOriginalName();
            $file->move(public_path() . "/uploads/documents/", $document);
        }

        $loanDocument            = new LoanDocument();
        $loanDocument->loan_id = $request->input('loan_id');
        $loanDocument->name      = $request->input('name');
        $loanDocument->document  = $document;

        $loanDocument->save();

        //Prefix Output
        $loanDocument->document  = '<a target="_blank" href="'.asset('public/uploads/documents/'.$loanDocument->document) .'">'. $loanDocument->document .'</a>';

        if (!$request->ajax()) {
            return redirect()->route('loan_documents.create')->with('success', _lang('Saved Successfully'));
        } else {
            return response()->json(['result' => 'success', 'action' => 'store', 'message' => _lang('Saved Successfully'), 'data' => $loanDocument, 'table' => '#loan_documents_table']);
        }

    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit(Request $request, $id) {
        $loanDocument = LoanDocument::find($id);
        if (!$request->ajax()) {
            return back();
        } else {
            return view('backend.loan_documents.modal.edit', compact('loanDocument', 'id'));
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
        $validator = Validator::make($request->all(), [
            'loan_id' => 'required',
            'name'      => 'required',
            'document'  => 'nullable|mimes:png,jpg,jpeg,pdf|max:10000',
        ]);

        if ($validator->fails()) {
            if ($request->ajax()) {
                return response()->json(['result' => 'error', 'message' => $validator->errors()->all()]);
            } else {
                return redirect()->route('loan_documents.edit', $id)
                    ->withErrors($validator)
                    ->withInput();
            }
        }

        if ($request->hasfile('document')) {
            $file     = $request->file('document');
            $document = time() . uniqid() . '-'. $file->getClientOriginalName();
            $file->move(public_path() . "/uploads/documents/", $document);
        }

        $loanDocument            = LoanDocument::find($id);
        $loanDocument->loan_id = $request->input('loan_id');
        $loanDocument->name      = $request->input('name');
        if ($request->hasfile('document')) {
            $loanDocument->document = $document;
        }

        $loanDocument->save();

        //Prefix Output
        $loanDocument->document  = '<a target="_blank" href="'.asset('public/uploads/documents/'.$loanDocument->document) .'">'. $loanDocument->document .'</a>';

        if (!$request->ajax()) {
            return back()->with('success', _lang('Updated Successfully'));
        } else {
            return response()->json(['result' => 'success', 'action' => 'update', 'message' => _lang('Updated Successfully'), 'data' => $loanDocument, 'table' => '#loan_documents_table']);
        }

    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id) {
        $document = LoanDocument::find($id);
        unlink(public_path('uploads/documents/'.$document->document));
        $document->delete();
        return back()->with('success', _lang('Deleted Successfully'));
    }
}
