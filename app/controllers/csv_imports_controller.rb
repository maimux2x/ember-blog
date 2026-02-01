class CSVImportsController < ApplicationController
  before_action :verify_token, only: %i[create]

  def index
    @imports = CSVImport.order(:created_at).page(params[:page])
  end

  def show
    @import = CSVImport.find(params[:id])
  end

  def create
    import = CSVImport.create!(csv_import_params)

    CSVImportJob.perform_later import

    render json: { id: import.id }, status: :created
  end

  private
  def csv_import_params
    params.expect(csv_import: [ :file ])
  end
end
