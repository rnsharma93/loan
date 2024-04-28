<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class UpdateColumnsToGuarantorsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('guarantors', function (Blueprint $table) {
            $table->dropForeign('member_id');
            $table->dropForeign('savings_account_id');
            $table->dropColumn('member_id');
            $table->dropColumn('savings_account_id');
            $table->string('name')->nullable()->after('loan_id');
            $table->string('father_name')->nullable()->after('name');
            $table->string('mobile')->nullable()->after('father_name');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('loans', function (Blueprint $table) {
            //
        });
    }
}
