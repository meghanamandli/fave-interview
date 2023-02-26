require 'spec_helper'

RSpec.describe PayslipController, type: :controller do
  describe 'POST #get_payslip_information' do
    it 'returns http success' do

    post '/payslip', params: {
          name: 'leon',
          income: '70000'
      }
    end
    expect(response.status).to eq(200)
  end

  describe 'GET #show_payslip_information' do
    it 'returns http success' do

    get '/payslip_details'
    expect(response).to have_http_status(:success)
    expect(response.status).to eq(200)
    end
  end
end
