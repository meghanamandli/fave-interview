class PayslipController < ApplicationController

  skip_before_action :verify_authenticity_token
  include PayslipHelper


  def get_payslip_information
  	@name = params[:name]
  	@income = params[:income].to_i
  	generate_monthly_payslip(@name, @income)
  	view_context.update_employee_details(@name, @income, @monthly_income_tax, @net_monthly_income)
  end

  def generate_monthly_payslip(name, income)
    @income = income
    @tax_bracket = view_context.get_tax_information
    @available_range = @tax_bracket.select {|income| income === @income}
    @id = @available_range.first[1][:id]
    @bracket = @tax_bracket.first(@id).to_h
    @tax = 0
    @bracket.each_pair do |key,value|
    if value[:id] != @id
    @tax = @tax + ((value[:end] - value[:start]) * value[:fee]/100.00)
    else
     @tax = @tax + ((@income - value[:start]) * value[:fee]/100.00)
    end
    end
    get_formatted_value(@tax, name, income)
  end


  def get_formatted_value(tax, name, income)
  	@monthly_income_tax = @tax.to_f/12.00
  	@monthly_income = @income.to_f/12.00
  	@net_monthly_income = @monthly_income - @monthly_income_tax
  	if params.present?
    payslip_data = {"employee_name" => name, "gross_monthly_income" => @monthly_income, "monthly_income_tax" => @monthly_income_tax, "net_monthly_income" => @net_monthly_income}
    render :json => payslip_data
  	else
  	payslip_data = {"Monthly Payslip for" => name, "Gross Monthly Income:" => @imonthly_income, "Monthly Income Tax:" => @monthly_income_tax, "Net Monthly Income:" => @net_monthly_income}
  	return :json => payslip_data
  	end
  end


  def show_payslip_information
  	if params[:name].present?
  		@employee_payslip = EmployeePayslip.where(name: params[:name])
  		@salary_computations = []
  		@employee_payslip.each do |payslip|
  		@salary_computations.append(get_salary_data(payslip))
  		end
  		render :json => @salary_computations
  	end
  end

  def get_salary_data(employee_payslip)
  	{
      time_stamp: employee_payslip.created_at,
      employee_name: employee_payslip.name,
      annual_salary: employee_payslip.annual_salary.to_f,
      monthly_income_tax: employee_payslip.monthly_income_tax.to_f
    }
  end
end