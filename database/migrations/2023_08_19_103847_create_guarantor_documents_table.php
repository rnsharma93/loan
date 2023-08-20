<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateGuarantorDocumentsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('guarantor_documents', function (Blueprint $table) {
            $table->id();
            $table->bigInteger('guarantor_id')->unsigned();
            $table->bigInteger('loan_id')->unsigned();
            $table->string('name');
            $table->string('document');
            $table->timestamps();

            $table->foreign('guarantor_id')->references('id')->on('guarantors')->onDelete('cascade');
            $table->foreign('loan_id')->references('id')->on('loans')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('guarantor_documents');
    }
}
