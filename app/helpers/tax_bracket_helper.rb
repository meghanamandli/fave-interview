module TaxBracketHelper

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
end