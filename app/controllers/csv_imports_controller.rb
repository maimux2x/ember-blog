class CSVImportsController < ApplicationController
  before_action :verify_token, only: %i[create]

  def create
    import = CSVImport.new
    import.file.attach(csv_import_params[:file])
    import.save!

    CSVImportJob.perform_later import
  end

  private
  def csv_import_params
    params.expect(csv_import: [ :file ])
  end
end
