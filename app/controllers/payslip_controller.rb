class PayslipController < ApplicationController

  skip_before_action :verify_authenticity_token
  include PayslipHelper
  require 'csv'


  def create_payslip
    if params[:name].present? && params[:income].present?
  	  @name = params[:name]
  	  @income = params[:income].to_i
      perform_payslip_operation
    else
      render :json => {error: "Please enter name and income"}
    end
  end

  def show_payslip
  	if params[:name].present?
  		@employee_payslip = EmployeePayslip.where(name: params[:name])
      show_pay_information
  	else
      render :json => {error: "Please enter name"}
    end
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
    payslip_data = {"employee_name" => name, "gross_monthly_income" => @monthly_income.to_f.round(2), "monthly_income_tax" => @monthly_income_tax.to_f.round(2), "net_monthly_income" => @net_monthly_income.to_f.round(2)}
    render :json => payslip_data
    else
    payslip_data = {"Monthly Payslip for" => name, "Gross Monthly Income:" => @imonthly_income, "Monthly Income Tax:" => @monthly_income_tax, "Net Monthly Income:" => @net_monthly_income}
    return :json => payslip_data
    end
  end

  private

  def perform_payslip_operation
    generate_monthly_payslip(@name, @income)
    view_context.update_employee_details(@name, @income, @monthly_income_tax)
    binding.pry
    EmployeePayslipMailer.send_email(@name, @income, @monthly_income_tax, @net_monthly_income).deliver_now
  end

  def show_pay_information
    @salary_computations = []
    @employee_payslip.each do |payslip|
      @salary_computations.append(view_context.get_salary_data(payslip))
    end
    binding.pry
    view_context.generate_csv(@salary_computations)
    render :json => @salary_computations
  end
end