class Photo < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  belongs_to :user
  has_and_belongs_to_many :likers, class_name: 'User', join_table: :likes

  def liked_by?(user)
    # 1. likers - relationship has_and_belongs_to_many
    # 2. exists? checks if there is a record with user
    # 3. id of the user that we need to check
    likers.exists?(user.id)
  end

  def toggle_liked_by(user)
    if liked_by?(user)
      likers.destroy(user)
    else
      likers << user
    end
  end
end
