class Public::HomesController < ApplicationController
  def top
    @posts = Post.order('id DESC').limit(4)
    @tag_lists=Tag.find(Tagmap.group(:tag_id).order('count(post_id) desc').limit(30).pluck(:tag_id))
  end

  def about
  end
end