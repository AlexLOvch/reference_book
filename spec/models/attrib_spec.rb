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

require 'spec_helper'

describe Attrib do
  pending "add some examples to (or delete) #{__FILE__}"
end
