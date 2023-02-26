module PayslipHelper

  def get_tax_information
  @tax_bracket = {
  0..20000 => { id: 1, fee:0, start: 0, end: 20000 },
  20001..40000 => { id: 2, fee:10, start: 20000 , end: 40000 },
  40001..80000 => { id: 3, fee:20 , start: 40000 , end: 80000},
  80001..180000=> { id: 4, fee:30 , start: 80000 ,end: 180000},
  180001.. => { id: 5, fee:40 , start: 180000 , end: ""}
  }
  return @tax_bracket
  end


  def update_employee_details(employee_name, income, monthly_income_tax, net_monthly_income)
  	@employee_payslip = EmployeePayslip.new
  	@employee_payslip.name = employee_name
  	@employee_payslip.annual_salary = income.to_f
  	@employee_payslip.monthly_income_tax = monthly_income_tax
  	@employee_payslip.save
  end
end