require 'rails_helper'

RSpec.describe "Payslips", type: :request do
  context 'with valid parameters' do
      before do
         post '/payslip', params: {
          name: 'leon',
          income: '70000'
      }
      end
      expect(response.status).to eq(200)
  end   

  context 'with invalid parameters' do
      before do
         post '/payslip', params: {
          name: '',
          income: ''
      }
      end

      it 'returns a unprocessable entity status' do
        expect(response.status).to eq(422)
      end
  end            
end
