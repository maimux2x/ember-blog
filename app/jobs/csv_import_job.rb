class CSVImportJob < ApplicationJob
  queue_as :default

  def perform(import)
    #TODO
  end
end
