class PledgeSerializer < ActiveModel::Serializer
  attributes :id, :amount, :user_name

  def user_name
    object.user.full_name.titleize if object.user
  end

end
