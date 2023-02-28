class EmployeePayslip < ActiveRecord::Base
 validates :name, presence: true
 validates :annual_salary, presence: true
 validates :monthly_income_tax, presence: true
end