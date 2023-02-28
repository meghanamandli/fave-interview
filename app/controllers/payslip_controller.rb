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
      print value[:id]
    @tax = @tax + ((value[:end] - value[:start]) * value[:fee]/100.00)
    else
     @tax = @tax + ((@income - value[:start]) * value[:fee]/100.00)
    end
    end
    get_formatted_value(@tax, name, income)
  end


  def get_formatted_value(tax, name, income)
  	@monthly_income_tax = @tax/12
  	@net_monthly_income = @income/12 - @tax/12
  	if params.present?
    payslip_data = {"employee_name" => name, "gross_monthly_income" => @income/12, "monthly_income_tax" => @monthly_income_tax, "net_monthly_income" => @net_monthly_income}
    render :json => payslip_data
  	else
  	payslip_data = {"Monthly Payslip for" => name, "Gross Monthly Income:" => @income/12, "Monthly Income Tax:" => @monthly_income_tax, "Net Monthly Income:" => @net_monthly_income}
  	return :json => payslip_data
  	end
  end
end