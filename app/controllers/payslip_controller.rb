class PayslipController < ApplicationController
  
  include TaxBracketHelper

  def generate_monthly_payslip(income, name)
    @income = income
    @tax_bracket = TaxBracketHelper.get_tax_information
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
  	payslip_data = {"Monthly Payslip for" => name, "Gross Monthly Income:" => @income/12, "Monthly Income Tax:" => @tax/12, "Net Monthly Income:" => (@income/12 - @tax/12) }
    return :json => payslip_data
  end
end