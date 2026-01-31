require "csv"

class CSVImportJob < ApplicationJob
  queue_as :default

  def perform(import)
    import(import)
  end

  private

  def import(import)
    import.processing!

    posts  = import.file.download.force_encoding("UTF-8")
    errors = []

    CSV.parse(posts, headers: true).each.with_index(2) do |post, i|
      ActiveRecord::Base.transaction do
        post = Post.create(
          published_at: post["published_at"],
          title:        post["title"],
          body:         post["body"],
          tag_names:    post["tag_names"]&.split(",") || []
        )

        post.errors.full_messages.each do |message|
          errors << { line: i, message: }
        end
      end
    end

    if errors.empty?
      import.completed!
    else
      import.failed!

      import.update!(messages: errors)
    end
  end
end
