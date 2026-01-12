class CSVImportsController < ApplicationController
  def create
    import = CSVImport.create!(params.expect(:file))

    CSVImportJob.perform_later import
  end
end
