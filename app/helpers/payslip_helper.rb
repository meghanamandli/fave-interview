module PayslipHelper

  def get_tax_information
  tax_bracket = {
  0..20000 => { id: 1, fee:0, start: 0, end: 20000 },
  20001..40000 => { id: 2, fee:10, start: 20000 , end: 40000 },
  40001..80000 => { id: 3, fee:20 , start: 40000 , end: 80000},
  80001..180000=> { id: 4, fee:30 , start: 80000 ,end: 180000},
  180001.. => { id: 5, fee:40 , start: 180000 , end: ""}
  }
  end


  def update_employee_details(employee_name, income, monthly_income_tax)
  	@employee_payslip = EmployeePayslip.new
  	@employee_payslip.name = employee_name
  	@employee_payslip.annual_salary = income.to_f
  	@employee_payslip.monthly_income_tax = monthly_income_tax
  	@employee_payslip.save
  end

  def form_employee_params(employee_name, income, monthly_income_tax)
    @params = {name: employee_name, annual_salary: income, monthly_income_tax: monthly_income_tax}
    create_employee_payslip(params)
  end

  def create_employee_payslip(params)
    @employee_payslip = EmployeePayslip.new(employee_params)
  end

  def get_salary_data(employee_payslip)
    {
      time_stamp: employee_payslip.created_at,
      employee_name: employee_payslip.name,
      annual_salary: employee_payslip.annual_salary.to_f,
      monthly_income_tax: employee_payslip.monthly_income_tax.to_f
    }
  end

  def employee_params(params)
    params.require(:employee_payslip).permit(:name, :annual_salary, :monthly_income)
  end

  def generate_csv(payslip_values)
    binding.pry
    require 'csv'
    file = "#{Rails.root}/public/product_data.csv"
    CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
      payslip_values.each do |payslip| 
      writer << [payslip[:employee_name], payslip[:annual_salary], payslip[:monthly_income_tax]]
    end
  end
  end
end