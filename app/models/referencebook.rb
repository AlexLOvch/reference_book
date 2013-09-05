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

class Referencebook < ActiveRecord::Base
  attr_accessible :name
  validates_presence_of :name
  validates_uniqueness_of :name
 
  has_many :attribs, dependent: :destroy
  has_many :storages, through: :attribs


  def record(record_no)
    Storage.records(self,record_no,nil)
  end  

  def records
    Storage.records(self)
  end  


  #              attrib_id => value
  #input: nil or {1        => 20.0  ,2=>'13.05.2004'}
  def add_record(values=nil)
              #new empty record
    values||= self.attribs.inject({}){|hsh,atr| hsh.merge({atr.id =>''})}
    return unless values.is_a?(Hash)    
    if Storage.record=values.merge({record_no:  self.record_count+1})
      self.record_count+=1
      save
    end  
  end  

  #input '10.0' or ['10.0','12.03.2013'....]          
  def find_records(values)
     values=[values] unless values.is_a?(Array)    
    Storage.records(self,nil,values)
  end  

end