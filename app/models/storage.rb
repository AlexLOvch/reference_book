# encoding: utf-8
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
      errors.add("Ошибка в аттрибуте #{attrib.name}!"," Неверный формат данных.")    
    end
  end  


  def self.delete_record(referencebook_id,record_no)
    destroy_all({ :attrib_id => [Referencebook.find(referencebook_id).attribs.map(&:id)], :record_no => record_no })
  end  



  def self.record_exist?(referencebook,record_no)
    where({ :attrib_id => [referencebook.attribs.map(&:id)], :record_no => record_no }).count>0
  end    


  #output [{:record_no=>1, :attribs=>[{:storage_id=>1, :attrib_id=>1, :data=>10.0}, {:storage_id=>2, :attrib_id=>2, :data=>Sun, 11 Sep 2011}]}, {:record_no=>2, ....]
  def self.records(referencebook,record_no=nil,find_values=nil)
    all_attrib_ids=referencebook.attribs.map(&:id)
    
    where_hash={ :attrib_id => all_attrib_ids}
    where_hash.merge!({:data=>find_values}) if find_values
    where_hash.merge!({:record_no=>record_no}) if record_no
    where(where_hash).order(:record_no).includes(:attrib).group_by{|r|r.record_no}.map do |n,r| 
      attr_arr = r.map{|atr| {storage_id:  atr.id, attrib_id: atr.attrib.id, data: atr.data} }
      # if any? new attribs without data - return storage_id:  nil
      if all_attrib_ids.size>attr_arr.size
         attribs_without_data=all_attrib_ids.reject{ |attrib_id| attr_arr.any?{|attr_hash| attrib_id==attr_hash[:attrib_id]} }
         non_existent_records=attribs_without_data.map{|atr_id| {storage_id:  nil, attrib_id: atr_id, data: ''} } if attribs_without_data.any?
         attr_arr = attr_arr + non_existent_records if non_existent_records.any?
      end  

      if attr_arr.any?
        if find_values
          records(referencebook,n).first
        else  
          {record_no: n, attribs: attr_arr} 
        end  
      end
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



  def self.typecast(value,type)
    return value if value.nil? || value.is_a?(type.constantize) || value.empty?
    
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
