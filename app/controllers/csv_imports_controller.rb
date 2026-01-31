class CSVImportsController < ApplicationController
  before_action :verify_token, only: %i[create]

  def create
    import = CSVImport.create!(csv_import_params)

    CSVImportJob.perform_later import

    head :ok
  end

  private
  def csv_import_params
    params.expect(csv_import: [ :file ])
  end
end
