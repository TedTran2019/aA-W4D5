# == Schema Information
#
# Table name: goals
#
#  id         :bigint           not null, primary key
#  completed  :boolean          default(FALSE), not null
#  details    :text
#  private    :boolean          default(FALSE), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer          not null
#
# Indexes
#
#  index_goals_on_owner_id  (owner_id)
#

class Goal < ApplicationRecord
	validates :owner, :title, presence: true
	validates :title, length: { minimum: 6 }

	belongs_to :owner,
	class_name: :User

	has_many :comments,
	as: :commentable,
	dependent: :destroy
end
