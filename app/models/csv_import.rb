class CSVImport < ApplicationRecord
  has_one_attached :file

  enum :status, {
    waiting:    0,
    processing: 1,
    completed:  2,
    failed:     99
  }

  def in_progress?
    status.in?(%w[
      waiting
      processing
    ])
  end
end
