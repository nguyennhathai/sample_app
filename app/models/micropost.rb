class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze

  belongs_to :user

  scope :recent_posts, ->{order created_at: :desc}
  scope :new_feed, ->(following_ids){where user_id: following_ids}

  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_maximum}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("microposts.message_validate_content")},
    size: {less_than: Settings.image_size.megabytes,
           message: I18n.t("microposts.message_size_content")}

  def display_image
    image.variant resize_to_limit: [Settings.resize_to_limit, Settings.resize_to_limit]
  end
end
