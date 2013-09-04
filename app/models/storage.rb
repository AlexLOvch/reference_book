# == Schema Information
#
# Table name: storages
#
#  id         :integer          not null, primary key
#  attrib_id  :integer          not null
#  record_no  :integer          not null
#  data       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Storage < ActiveRecord::Base
  attr_accessible :attrib_id, :record_no, :data
  belongs_to :attrib
  validates :attrib_id, :record_no, presence: true
  validate :value_typecast
  
  def data
    value=read_attribute(:data)
    Storage.typecast(value,attrib.data_type)
  end    

  def value_typecast
    unless Storage.typecast(data,attrib.data_type)
      errors.add(:data, "Typecast error")
    end
  end  

  #output {:record_no=>1, :attribs=>[[{:storage_id=>1, :attrib_id=>1, :data=>10.0}], [{:storage_id=>2, :attrib_id=>2, :data=>Sun, 11 Sep 2011}]]}
  def self.record(referencebook,record_no)
    rec=where({ :attrib_id => [referencebook.attribs.map(&:id)], :record_no => record_no }).includes(:attrib).map{|atr| [storage_id:  atr.id, attrib_id: atr.attrib.id, data: atr.data]}
    {record_no: record_no}.merge(attribs: rec) if rec.any?
  end  

  def self.record_exist?(referencebook,record_no)
    where({ :attrib_id => [referencebook.attribs.map(&:id)], :record_no => record_no }).count>0
  end    


  #output [{:record_no=>1, :attribs=>[[{:storage_id=>1, :attrib_id=>1, :data=>10.0}], [{:storage_id=>2, :attrib_id=>2, :data=>Sun, 11 Sep 2011}]]}, {:record_no=>2, ....]
  def self.records(referencebook)
    where({ :attrib_id => [referencebook.attribs.map(&:id)]}).order(:record_no).includes(:attrib).group_by{|r|r.record_no}.map do |n,r| 
      attr_arr = r.map{|atr| [storage_id:  atr.id, attrib_id: atr.attrib.id, data: atr.data]}
      {record_no: n, attribs: attr_arr} if attr_arr.any?
    end  
  end  


  #input: {record_no: record_no, attrib_id: data, attrib_id: data,...}
  def self.record=(args)
    return if args.nil?
    return unless args.is_a?(Hash)
    record_no=args.delete(:record_no)
    return if record_no.nil?

    args.each do |id,v|
      unless value = self.where({ :attrib_id => id, :record_no => record_no }).first
        value = Storage.create({record_no: record_no,attrib_id: id, data: v})
      else
        value.update_attributes(:data=>v)
      end  
    end

  end


  def self.find_records_by_values(referencebook,values)
    where({ :attrib_id => [referencebook.attribs.map(&:id)], :data=>values}).order(:record_no).includes(:attrib).group_by{|r|r.record_no}.map do |n,r| 
      attr_arr = r.map{|atr| [storage_id:  atr.id, attrib_id: atr.attrib.id, data: atr.data]}
      {record_no: n, attribs: attr_arr} if attr_arr.any?
    end
  end  



  def self.typecast(value,type)
    return value if value.is_a?(type.constantize)
    
    begin
      value=case type
        when 'Integer'
          Integer(value)
        when 'Float'
          Float(value)
        when 'Date'
          Date.parse(value)
        when 'DateTime'
          DateTime.parse(value)
        when 'Time'
          Time.parse(value)
      end
    rescue  
      nil
    end  
  end  



end
