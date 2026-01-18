require "csv"

class CSVImportJob < ApplicationJob
  queue_as :default

  def perform(import)
    insert_posts(import.file)
  end

  private

  def insert_posts(csv)
    posts  = csv.download.force_encoding("UTF-8")
    errors = []

    CSV.parse(posts, headers: true).each do |post|
      ActiveRecord::Base.transaction do
        Post.create!(
          published_at: post["published_at"],
          title:        post["title"],
          body:         post["body"],
          tag_names:    post["tag_names"]&.split(",") || []
        )
      end
    rescue ActiveRecord::RecordInvalid => e
      # TODO: インポート履歴の実装時に見直す
      errors << { message: e.message }
    end
  end
end
