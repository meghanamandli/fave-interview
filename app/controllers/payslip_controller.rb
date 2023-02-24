class PayslipController < ApplicationController

  skip_before_action :verify_authenticity_token
  include TaxBracketHelper

  def get_payslip_information
  	@name = params[:name]
  	@income = params[:income].to_i
  	generate_monthly_payslip(@name, @income)
  end

  def generate_monthly_payslip(name, income)
  	binding.pry
    @income = income
    @tax_bracket = view_context.get_tax_information
    binding.pry
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
  	if params.present?
    payslip_data = {"employee_name" => name, "gross_monthly_income" => @income/12, "monthly_income_tax" => @tax/12, "net_monthly_income" => (@income/12 - @tax/12) }
    render :json => payslip_data
  	else
  	payslip_data = {"Monthly Payslip for" => name, "Gross Monthly Income:" => @income/12, "Monthly Income Tax:" => @tax/12, "Net Monthly Income:" => (@income/12 - @tax/12) }
  	return :json => payslip_data
  	end
  end
end