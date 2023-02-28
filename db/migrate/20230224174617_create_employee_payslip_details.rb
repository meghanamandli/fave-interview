class CreateEmployeePayslipDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_payslips do |t|
      t.string :name
      t.integer :annual_salary
      t.integer :monthly_income_tax
      t.timestamps
    end
  end
end
