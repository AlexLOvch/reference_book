# == Schema Information
#
# Table name: attribs
#
#  id               :integer          not null, primary key
#  name             :string(255)      not null
#  data_type        :string(255)      default("String"), not null
#  referencebook_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Attrib < ActiveRecord::Base
  attr_accessible :name, :referencebook_id, :data_type
  validates_uniqueness_of :name, :scope => :referencebook_id
  validates_inclusion_of :data_type, in: DATA_TYPES
  
  belongs_to :referencebook

  has_many :storages, dependent: :destroy

end
