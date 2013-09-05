# encoding: utf-8
ActiveAdmin.register Referencebook do
  config.batch_actions = false
  config.sort_order = "id_asc"
  collection_action :delete_record
  collection_action :new_record
  collection_action :update_record_attribute, :method => :put

  menu :priority => 1
  filter :name

  index do
    column (:name){|item|link_to item.name, admin_referencebook_path(item.id) }
    default_actions
  end    



  form do |f|
    f.inputs "Справочник" do
      f.input :name, :required => true
    end
    f.buttons
  end   

  show :title=>proc{"Справочник #{resource.name}"} do
    panel "Аттрибуты" do
      table_for(referencebook.attribs) do |t|
          t.column(:name) 
          t.column(:data_type) 
          t.column "" do |item|
            links = ''.html_safe
            links += link_to icon(:pen_alt_fill),  "#{edit_admin_attrib_path(item.id)}?referencebook_id=#{referencebook.id}&redirect_after=/admin/referencebooks/#{referencebook.id}",  :alt=>I18n.t('active_admin.edit'), :title=>I18n.t('active_admin.edit'), :style=>'font-size:16px'
            links += link_to icon(:x), "#{admin_attrib_path(item.id)}?redirect_after=/admin/referencebooks/#{referencebook.id}", :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link", :style=>'font-size:16px;margin-left:10px', :alt =>  I18n.t('active_admin.delete'), :title => I18n.t('active_admin.delete')
            links
          end
      end
      
      div :class=>"action_items" do
       span :class=>"action_item" do 
         link_to icon(:plus_alt),  "#{new_admin_attrib_path}?referencebook_id=#{referencebook.id}&redirect_after=/admin/referencebooks/#{referencebook.id}", :style=>'font-size:24px',:alt=>'Добавить аттрибут',:title=>'Добавить аттрибут' 
       end
      end  


    end

    panel "Данные" do
      table do
        tr do 
          referencebook.attribs.each_with_index do |attrib,i|
            th attrib.name
          end  
        end
        referencebook.records.each_with_index do |record,i|
          tr do 
            record[:attribs].each_with_index do |attrib,j|
              #attrib[:data]
              td  do
                object=attrib[:storage_id] ? Storage.find(attrib[:storage_id]) : Storage.new({:attrib_id=>attrib[:attrib_id],:record_no=>attrib[:record_no],:data=>''})

                cntn=''.html_safe
                cntn+=best_in_place(object, :data, :type => :input,:path=>"/admin/referencebooks/update_record_attribute?storage_id=#{attrib[:storage_id]}&attrib_id=#{attrib[:attrib_id]}&record_no=#{record[:record_no]}",:activator=>"#holder_#{i}_#{j}")
                cntn+=link_to icon(:pen_alt_fill),'#', :alt =>  'Изменить', :title => 'Изменить',:style=>'font-size:11px;',:id=>"holder_#{i}_#{j}"
              end  
            end 
            td do
              links = ''.html_safe
              links += link_to icon(:x), "/admin/referencebooks/delete_record?record_no=#{record[:record_no]}&referencebook_id=#{referencebook.id}", :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link", :style=>'font-size:16px;margin-left:10px', :alt =>  'Удалить', :title => 'Удалить'
            end 
          end  
        end
      end

      div :class=>"action_items" do
       span :class=>"action_item" do 
         link_to icon(:plus_alt),  "/admin/referencebooks/new_record?referencebook_id=#{referencebook.id}", :style=>'font-size:24px',:alt=>'Добавить значения',:title=>'Добавить значения' 
       end
      end  


    end

  end    






controller do
  def delete_record
      Storage.delete_record(params[:referencebook_id],params[:record_no])
      redirect_to '/admin/referencebooks/'+params[:referencebook_id]
  end

  def new_record
      Referencebook.find(params[:referencebook_id]).add_record
      redirect_to '/admin/referencebooks/'+params[:referencebook_id]
  end


  def update_record_attribute
    if params[:storage_id].present? 
      rec=Storage.find(params[:storage_id])
      rec.update_attributes(params[:storage])
    else  
      rec=Storage.new({:attrib_id=>params[:attrib_id],:record_no=>params[:record_no]}.merge(params[:storage]))
      rec.save 
    end  

    respond_to do |format|
      format.json { respond_with_bip(rec) }
    end
  end


end




end