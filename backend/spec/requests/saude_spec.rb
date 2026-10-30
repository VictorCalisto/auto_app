require "rails_helper"

RSpec.describe "Saúde da API", type: :request do
  it "confirma que a aplicação está disponível" do
    get "/up"

    expect(response).to have_http_status(:ok)
  end

  it "retorna não encontrado para uma rota inexistente" do
    get "/rota-inexistente"

    expect(response).to have_http_status(:not_found)
  end
end
