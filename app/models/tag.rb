class Tag < ApplicationRecord
  has_many:tagmaps, dependent: :destroy
  has_many:posts, through: :tagmaps

  def self.mapped(n=30)
    where(id:
     Tagmap.group(:tag_id).order('count(post_id) desc').limit(n).pluck(:tag_id)
    )
  end
end