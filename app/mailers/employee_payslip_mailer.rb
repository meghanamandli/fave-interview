class EmployeePayslipMailer < ApplicationMailer
  def send_email(name, income, monthly_income_tax, net_monthly_income)
  	    @name = name
  	    @income = income
  	    @monthly_income_tax = monthly_income_tax
  	    @net_monthly_income = net_monthly_income
        mail(to: "mandli.meghana555@gmail.com", subject: 'Payslip created')
  end
end