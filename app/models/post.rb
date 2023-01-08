class Post < ApplicationRecord
  belongs_to :user
  belongs_to :genre
  has_many :post_comments, dependent: :destroy
  has_many:favorites, dependent: :destroy
  has_many:tagmaps, dependent: :destroy
  has_many:tags, through: :tagmaps
  #ジャンルを複数設定したい場合は中間テーブルを作る
  has_one_attached :image
  has_many_attached :post_images

  validates:title, presence:true#タイトルは必須

  def get_photo(width, height)
    unless post_images.attached?
      file_path=Rails.root.join('app/assets/images/no_image.jpg')
      post_images.attach(io: File.open(file_path),filename: 'default-image.jpg',content_type: 'image/jpeg')
    end
    post_images[0].variant(resize_to_limit:[width,height]).processed
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  #あいまい検索
  def self.search(keyword)
    where("title LIKE? OR body LIKE?", "%#{keyword}%","#{keyword}%")
  end

  def save_posts(tags)
    current_tags=self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - tags
    new_tags = tags - current_tags
    # Destroy
    old_tags.each do |old_name|
     self.tags.delete Tag.find_by(tag_name:old_name)
    end
    # Create
    new_tags.each do |new_name|
     post_tag=Tag.find_or_create_by(tag_name:new_name)
     self.tags << post_tag
    end
  end

enum post_status:{
    publish:0,
    unpublish:1,
    draft:2
  }

end