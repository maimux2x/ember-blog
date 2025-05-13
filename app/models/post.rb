class Post < ApplicationRecord
  has_many_attached :images
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true
  validates :body, presence: true
  validates :images, content_type: [ "image/png", "image/jpeg" ]

  before_save :set_images
  after_commit :purge_unattached_blobs

  def tag_names
    taggings.sort_by(&:position).map { it.tag.name }
  end

  def tag_names=(names)
    self.taggings = names.map.with_index { |name, i|
      tag = Tag.find_or_create_by!(name:)
      Tagging.new(tag:, position: i)
    }
  end

  private

  def set_images
    signed_ids = []

    Commonmarker.parse(body).walk do |node|
      case node.type
      when :link, :image
        if %r{/rails/active_storage/blobs/(?:redirect/|proxy/)?(?<signed_id>\S+)/} =~ node.url
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
