class Post < ApplicationRecord
  has_many_attached :images

  validates :title, presence: true
  validates :body, presence: true
  validates :images, content_type: [ "image/png", "image/jpeg" ]

  before_save :set_images
  after_commit :purge_unattached_blobs

  private

  def set_images
    signed_ids = []

    Commonmarker.parse(body).walk do |node|
      case node.type
      when :link, :image
        if %r{\Ahttp://localhost:3000/rails/active_storage/blobs/(?:redirect/|proxy/)?(?<signed_id>\S+)/} =~ node.url
          signed_ids << signed_id
        end
      end
    end

    self.images = signed_ids
  end

  def purge_unattached_blobs
    ActiveStorage::Blob.unattached.each(&:purge)
  end
end
