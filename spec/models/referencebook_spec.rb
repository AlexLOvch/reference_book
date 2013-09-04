# == Schema Information
#
# Table name: referencebooks
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  record_count :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Referencebook do
  pending "add some examples to (or delete) #{__FILE__}"
end
